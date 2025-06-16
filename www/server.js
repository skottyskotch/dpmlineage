const express = require('express');
const session = require('express-session');
const path = require('path');
const sqlite3 = require('sqlite3').verbose();
const fs = require('fs');
const app = express();
const port = 3000;

app.use(express.urlencoded({ extended: true }));
app.use(session({
  secret: 'whatsthesecret?',
  resave: false,
  saveUninitialized: true,
  cookie: { secure: false }
}));

// Serve static files from the 'public' directory
app.use(express.static(path.join(__dirname, 'public')));
app.use('/src', express.static(path.join(__dirname, 'src')));

// useful db queries for apis
var depth = 1;
var tableDefFilter = "#%TEMP-TABLE:_SC_PT_REPORTING:";
var sSampleQueryNodes = "SELECT ID, TYPE from nodes limit 500";
var sSampleQueryEdges = "with cte as (select * from nodes limit 500) select SOURCE, TARGET, INATTRIBUTE, BYNAME from edges a join cte b on a.source = b.id join cte c on a.target = c.id;";
// var sQueryNodes = "with recursive subgraph(id, depth) as (select id, 0 from nodes where type = '{0}' union all select edges.source, subgraph.depth + 1 from edges join subgraph on edges.target = subgraph.id where subgraph.depth < {1})select ID, TYPE from nodes where id in (select id from subgraph);";
var sQueryNodes = "select ID, NAME, TYPE from nodes where type = '#%TEMP-TABLE:_SC_PT_REPORTING:';";
// var sQueryEdges = "with recursive subgraph(id, depth) as (select id, 0 from nodes where type = '{0}' union all select edges.source, subgraph.depth + 1 from edges join subgraph on edges.target = subgraph.id where subgraph.depth < {1}),cte_node as (select ID from nodes where id in (select id from subgraph))select SOURCE, TARGET, INATTRIBUTE, BYNAME from edges where source in (select * from cte_node) and target in (select * from cte_node);";
// TABLEDEF api:
// -- tablename | number of objects
// -- source table | target table | number of links
var sQueryEdges = "with cte as (select ID, TYPE from nodes where type = '{0}') select SOURCE, TARGET, INATTRIBUTE, BYNAME from edges where SOURCE in (select ID from cte) and TARGET in (select ID from cte);";
// no filter ("all tabledef")
const sQueryTabledefNodes = "select ID, OBJECTS from TABLEDEF;";
const sQueryTabledefEdges = "with cte as (select distinct d.id as source, e.id as target , count(*) as number_of_edges from edges a join nodes b on a.source =b.id join nodes c on a.target = c.id join tabledef d on b.type = d.id join tabledef e on c.type = e.id group by d.id, e.id), sumcte as (select cte.source, sum(number_of_edges) as number_of_connections from cte group by source) select cte.source as SOURCE, cte.target as TARGET, cte.number_of_edges as number_of_edges, sumcte.number_of_connections from cte left join sumcte on cte.source = sumcte.source order by number_of_connections desc;";
// filter on one tabledef and connected ("isolate tabledef")
var sQueryTableDefObjectNodes = "with tablelinks as (SELECT n1.type AS type1, n2.type AS type2 FROM edges l JOIN nodes n1 ON l.source = n1.id JOIN nodes n2 ON l.target = n2.id WHERE (n1.type = '{0}' OR n2.type = '{0}') GROUP BY n1.type, n2.type),tables as (select type1 as type from tablelinks union select type2 as type from tablelinks) select a.type as ID, b.OBJECTS from tables a left join tabledef b on a.type = b.id;"
var sQueryTableDefObjectEdges = "SELECT n1.type AS type1, n2.type AS type2, COUNT(*) AS number_of_links FROM edges l JOIN nodes n1 ON l.source = n1.id JOIN nodes n2 ON l.target = n2.id WHERE (n1.type = '{0}' OR n2.type = '{0}') GROUP BY n1.type, n2.type ORDER BY number_of_links DESC;"

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

app.get('/admin', (req, res) => {
	const selection = req.session.selection || 'Aucune sélection';
	res.send(`
		<p>Vous avez choisi : ${selection}</p>
		<a href="/">Retour à l'accueil</a>
	`);
});

// API endpoint for list available dbs
app.get('/api/database', (req, res) => {
    const databases = Object.keys(hDatabases);
    res.json({databases});
});

// API endpoint to fetch graph data
app.get('/api/graph-data', (req, res) => {
    if (req.query.db) {
		req.session.selection = req.query.db;
        if (hDatabases[req.query.db] != undefined) {
            var db = hDatabases[req.query.db];
            db.serialize(() => {
				const sQuery1 = format(sQueryNodes,tableDefFilter,depth);
                db.all(sQuery1, (err, _nodes) => {
                    if (err) {
                        res.status(400).json({"error": err.message});
                        return;
                    }
					const sQuery2 = format(sQueryEdges,tableDefFilter,depth);
                    db.all(sQuery2, (err, _edges) => {
                        if (err) {
                            res.status(400).json({"error": err.message});
                            return;
                        }
                        const nodes = _nodes.map(node => ({id: node.ID, name: node.NAME, type: node.TYPE}))
                        const edges = _edges.map(edge => ({id: edge.Id, source: edge.SOURCE, target: edge.TARGET, inattr: edge.INATTRIBUTE, byname: edge.byname}))
						const selectedDb = req.session.selection;
                        res.json({selectedDb,nodes,edges});
                    });
                });
            });
        }
        else{
            res.json({"error":"database " +req.query.db + " not found"});
        }
    }
    else {
        res.json({"error":"Please request a database /api/graph-data?db=databasename.db"});
    }
});

app.get('/api/graph-data/node', (req,res) => {
	if (req.query.db) {
		req.session.selection = req.query.db;
		if (hDatabases[req.query.db] != undefined) {
			let db = hDatabases[req.query.db];
			let sQuery = "SELECT ATTRIBUTES, DATA, TYPE from nodes where ID = " + req.query.id + ";";
			db.all(sQuery, (err, node) => {
				if (err) {
					if (err.message = "SQLITE_ERROR: no such column: undefined") err.message += ". Valid request is like /api/graph-data/node?db=databasename&ID=nodeid";
					res.status(400).json({"error": err.message});
					return;
				}
				const selectedDb = req.session.selection;
				res.json({selectedDb,node});
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
		req.session.selection = req.query.db;
		if (hDatabases[req.query.db] != undefined) {
			let db = hDatabases[req.query.db];
			let sQuery = "select ID, OBJECTS from TABLEDEF where ID = " + req.query.id + ";";
			db.all(sQuery, (err, node) => {
				if (err) {
					if (err.message = "SQLITE_ERROR: no such column: undefined") err.message += ". Valid request is like /api/graph-data/class?db=dbname&ID=...";
					res.status(400).json({"error": err.message});
					return;
				}
				const selectedDb = req.session.selection;
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

app.get('/api/graph-data/tabledef', (req,res) => {
	if (req.query.db) {
		let sQuery1 = sQueryTabledefNodes;
		let sQueryEdges = sQueryTabledefEdges;
		console.log(req.query);
		if (req.query.id) {
			sQueryNodes = format(sQueryTableDefObjectNodes, req.query.id);
			sQueryEdges = format(sQueryTableDefObjectEdges, req.query.id);
		}
		req.session.selection = req.query.db;
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
						// const _edges = edges.map(edge => ({source: edge.SOURCE, target: edge.TARGET}))
						res.json({nodes, edges});
					});
				});
			});
		}
	}
    else {
        res.json({"error":"Please request a database /api/graph-data/tabledef?db=databasename"});
    }
});

app.get('/api/databaseSelected', (req, res) => {
	const selectedDb = req.session.selection;
	res.json({selectedDb});
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
