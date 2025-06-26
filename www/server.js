const express = require('express');
const path = require('path');
const sqlite3 = require('sqlite3').verbose();
const fs = require('fs');
const app = express();
const port = 3000;

app.use(express.urlencoded({ extended: true }));
// Serve static files from the 'public' directory
app.use(express.static(path.join(__dirname, 'public')));
app.use('/src', express.static(path.join(__dirname, 'src')));

// useful db queries for apis
// var depth = 1;

// Objects api
const sNodesFull = "select ID, NAME, TYPE from nodes;";
const sEdgeFull = "with cte as (select ID from nodes) select SOURCE, TARGET, INATTRIBUTE, BYNAME from edges where SOURCE in (select ID from cte) or TARGET in (select ID from cte);";
const sOneNode = "select ID, NAME, TYPE, ATTRIBUTES, DATA from nodes where ID in ('{0}');";
const sOneNodeEdges = "select count(*) as count from edges where source = '{0}' or target = '{0}';";
// const sNodesFromOneTable = "select ID, NAME, TYPE, ATTRIBUTES, DATA from nodes where type in ('{0}');";
const sNodesFromOneTable = "select a.ID, a.NAME, a.TYPE, a.ATTRIBUTES, a.DATA, count(b.source) as nb_callers, count(c.target) as nb_called from nodes a left join edges b on b.source = a.ID left join edges c on c.target = a.ID where a.type in ('{0}') group by (a.id);";
const sEdgesFromOneTable = "with cte as (select ID from nodes where type in ('{0}'))select a.SOURCE, b.TYPE as SOURCE_TYPE, a.TARGET, c.TYPE as TARGET_TYPE, INATTRIBUTE, BYNAME from edges a left join nodes b on a.source = b.ID left join nodes c on a.target = c.ID where SOURCE in (select ID from cte) and TARGET in (select ID from cte);";
const sNodesFromOneNode = "with cte as (select a.SOURCE, a.TARGET from edges a left join nodes b on a.source = b.ID left join nodes c on a.target = c.ID where a.SOURCE = '{0}' or a.TARGET = '{0}') select ID, NAME, TYPE, ATTRIBUTES, DATA from nodes where ID = '{0}' or ID in (select SOURCE from cte) or ID in (select TARGET from cte);";
const sEdgesFromOneNode = "select a.SOURCE, b.TYPE as SOURCE_TYPE, a.TARGET, c.TYPE as TARGET_TYPE, INATTRIBUTE, BYNAME from edges a left join nodes b on a.source = b.ID left join nodes c on a.target = c.ID where a.SOURCE = '{0}' or a.TARGET = '{0}'";

// TABLEDEF api:
// -- tablename | number of objects
// -- source table | target table | number of links
// no filter ("all tabledef")
const sQueryTabledefNodes = "select ID, OBJECTS from TABLEDEF;";
const sQueryTabledefEdges = "with cte as (select distinct d.id as source, e.id as target , count(*) as number_of_edges from edges a join nodes b on a.source =b.id join nodes c on a.target = c.id join tabledef d on b.type = d.id join tabledef e on c.type = e.id group by d.id, e.id), sumcte as (select cte.source, sum(number_of_edges) as number_of_connections from cte group by source) select cte.source as SOURCE, cte.target as TARGET, cte.number_of_edges as number_of_edges, sumcte.number_of_connections from cte left join sumcte on cte.source = sumcte.source order by number_of_connections desc;";
// filter on one tabledef and connected ("isolate tabledef")
const sQueryTableDefObjectNodes = "with tablelinks as (SELECT n1.type AS SOURCE, n2.type AS TARGET FROM edges l JOIN nodes n1 ON l.source = n1.id JOIN nodes n2 ON l.target = n2.id WHERE (n1.type = '{0}' OR n2.type = '{0}') GROUP BY n1.type, n2.type),tables as (select SOURCE as type from tablelinks union select TARGET as type from tablelinks) select a.type as ID, b.OBJECTS from tables a left join tabledef b on a.type = b.id;"
const sQueryTableDefObjectEdges = "SELECT n1.type AS SOURCE, n2.type AS TARGET, COUNT(*) AS number_of_edges FROM edges l JOIN nodes n1 ON l.source = n1.id JOIN nodes n2 ON l.target = n2.id WHERE (n1.type = '{0}' OR n2.type = '{0}') GROUP BY n1.type, n2.type ORDER BY number_of_edges DESC;"
// info on click

const dbFolder = '../output/';
let hDatabases = {};
fs.readdirSync(dbFolder).forEach(dbFile => {
    if (dbFile.endsWith('.db')) {
        hDatabases[dbFile] = new sqlite3.Database(dbFolder + '/' + dbFile);
    }
});

function format(str, ...values) {
	return str.replace(/{(\d+)}/g, function(match, index) {
		return typeof values[index] !== 'undefined' ? values[index] : match;
	});
}

// API endpoint for list available dbs
app.get('/api/database', (req, res) => {
    const databases = Object.keys(hDatabases);
    res.json({databases});
});

// API endpoint for tables graph
app.get('/api/graph-data/tabledef', (req,res) => {
	if (req.query.db) {
		let sQueryNodes = sQueryTabledefNodes;
		let sQueryEdges = sQueryTabledefEdges;
		if (req.query.id){
			sQueryNodes = sQueryTabledefNodes;
			sQueryEdges = sQueryTabledefEdges;
		}
		if (hDatabases[req.query.db] != undefined) {
			let db = hDatabases[req.query.db];
			db.serialize(() => {
				db.all(sQueryNodes, (err, nodes) => {
					if (err) {
						res.status(400).json({"error nodes": err.message});
						return;
					}
					db.all(sQueryEdges, (err, edges) => {
						if (err) {
							res.status(400).json({"error edges": err.message});
							return;
						}
						const _nodes = nodes.map(node => ({id: node.ID, objects: nodes.OBJECTS}))
						const _edges = edges.map(edge => ({id: edge.Id, source: edge.SOURCE, target: edge.TARGET}))
						res.json({class:'tableDef', nodes, edges});
					});
				});
			});
		}
	}
    else {
        res.json({"error":"Please request a database /api/graph-data/tabledef?db=databasename"});
    }
});

app.get('/api/graph-data/node', (req,res) => {
	if (req.query.db && req.query.id) {
		let sQueryNodes = format(sOneNode, req.query.id);
		let sQueryEdges = format(sOneNodeEdges, req.query.id);
		if (hDatabases[req.query.db] != undefined) {
			let db = hDatabases[req.query.db];
			db.serialize(() => {
				db.all(sQueryNodes, (err, _nodes) => {
					if (err) {
						if (err.message = "SQLITE_ERROR: no such column: undefined") err.message += ". Valid request is like /api/graph-data/node?db=databasename&ID=nodeid";
						res.status(400).json({"error": err.message});
						return;
					}
					db.all(sQueryEdges, (err, number_of_edges) => {
						if (err) {
							res.status(400).json({"error edges": err.message});
							return;
						}
						const nodes = _nodes.map(node => ({id: node.ID, name: node.NAME, type: node.TYPE, attributes: node.ATTRIBUTES, data: node.DATA}));
						const edges = number_of_edges;
						res.json({class:'object',nodes, edges});
					});
				});
			});
		}
		else{
			res.json({"error":"database " +req.query.db + " not found"});
		}
    }
    else {
        res.json({"error":"Please request a database /api/graph-data?db=databasename.db&ID=nodeid"});
    }
});

app.get('/api/graph-data/nodes', (req,res) => {
	if (req.query.db) {
		let sQueryNodes =  sNodesFull;
		let sQueryEdges =  sEdgeFull;
		if (req.query.table) {
			sQueryNodes = format(sNodesFromOneTable, req.query.table);
			sQueryEdges = format(sEdgesFromOneTable, req.query.table);
		}
		else if (req.query.id) {
			sQueryNodes = format(sNodesFromOneNode, req.query.id);
			sQueryEdges = format(sEdgesFromOneNode, req.query.id);
		}
		if (hDatabases[req.query.db] != undefined) {
			let db = hDatabases[req.query.db];
			db.serialize(() => {
				db.all(sQueryNodes, (err, _nodes) => {
					if (err) {
						if (err.message = "SQLITE_ERROR: no such column: undefined") err.message += ". Valid request is like /api/graph-data/node?db=databasename&ID=nodeid";
						res.status(400).json({"error": err.message});
						return;
					}
					db.all(sQueryEdges, (err, _edges) => {
						if (err) {
							res.status(400).json({"error edges": err.message});
							return;
						}
						const nodes = _nodes.map(node => ({id: node.ID, name: node.NAME, type: node.TYPE, attributes: node.ATTRIBUTES, data: node.DATA, nb_called: node.nb_called, nb_callers: node.nb_callers}))
						const edges = _edges.map(edge => ({id: edge.Id, source: edge.SOURCE, source_type: edge.SOURCE_TYPE, target: edge.TARGET, target_type: edge.TARGET_TYPE, inattr: edge.INATTRIBUTE, byname: edge.BYNAME}))
						res.json({class:'object',nodes, edges});
					});
				});
			});
		}
        else{
            res.json({"error":"database " +req.query.db + " not found"});
        }
    }
    else {
        res.json({"error":"Please request a database /api/graph-data?db=databasename.db&ID=nodeid"});
    }
});

app.get('/api/graph-data/class', (req,res) => {
	if (req.query.db) {
		if (hDatabases[req.query.db] != undefined) {
			let db = hDatabases[req.query.db];
			let sQuery = "select ID, OBJECTS from TABLEDEF where ID = " + req.query.id + ";";
			db.all(sQuery, (err, node) => {
				if (err) {
					if (err.message = "SQLITE_ERROR: no such column: undefined") err.message += ". Valid request is like /api/graph-data/class?db=dbname&ID=...";
					res.status(400).json({"error": err.message});
					return;
				}
				res.json({selectedDb, node});
			});
		}
        else{
            res.json({"error":"database " +req.query.db + " not found"});
        }
    }
    else {
        res.json({"error":"Please request a database /api/graph-data?db=databasename.db&ID=nodeid"});
    }
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
