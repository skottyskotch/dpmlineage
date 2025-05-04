const express = require('express');
const path = require('path');
const sqlite3 = require('sqlite3').verbose();
const app = express();
const port = 3000;

// Serve static files from the 'public' directory
app.use(express.static(path.join(__dirname, 'public')));
app.use('/src', express.static(path.join(__dirname, 'src')));

// Connect to SQLite database
const db = new sqlite3.Database('../output/DPM_OUT_SAN_graph.db');

// API endpoint to fetch graph data
var sSampleQueryNodes = "SELECT ID, TYPE from nodes limit 500";
var sSampleQueryEdges = "with cte as (select * from nodes limit 500) select SOURCE, TARGET, INATTRIBUTE, BYNAME from edges a join cte b on a.source = b.id join cte c on a.target = c.id;";
var sQueryNodes = "with recursive subgraph(id, depth) as (select id, 0 from nodes where type = '#%TEMP-TABLE:_SC_PT_REPORTING:'	union all select edges.source, subgraph.depth + 1 from edges join subgraph on edges.target = subgraph.id where subgraph.depth < 2)select ID, TYPE from nodes where id in (select id from subgraph);";
var sQueryEdges = "with recursive subgraph(id, depth) as (select id, 0 from nodes where type = '#%TEMP-TABLE:_SC_PT_REPORTING:' union all select edges.source, subgraph.depth + 1 from edges join subgraph on edges.target = subgraph.id where subgraph.depth < 2),cte_node as (select ID from nodes where id in (select id from subgraph))select SOURCE, TARGET, INATTRIBUTE, BYNAME from edges where source in (select * from cte_node) and target in (select * from cte_node);";
var sQueryTabledefNodes = "select ID from TABLEDEF;";
// var sQueryTabledefEdges = "select distinct d.id as SOURCE, e.id as TARGET, count(*) as number_of_edges from edges a join nodes b on a.source =b.id join nodes c on a.target = c.id join tabledef d on b.type = d.id join tabledef e on c.type = e.id group by d.id, e.id order by count(*) desc;";
var sQueryTabledefEdges = "with cte as (select distinct d.id as source, e.id as target , count(*) as number_of_edges  from edges a join nodes b on a.source =b.id join nodes c on a.target = c.id join tabledef d on b.type = d.id join tabledef e on c.type = e.id group by d.id, e.id), sumcte as (select cte.source, sum(number_of_edges) as number_of_connections from cte group by source) select cte.source as SOURCE, cte.target as TARGET, cte.number_of_edges as number_of_edges, sumcte.number_of_connections from cte left join sumcte on cte.source = sumcte.source order by number_of_connections desc;";
app.get('/api/graph-data', (req, res) => {
	db.serialize(() => {
		db.all(sQueryNodes, (err, nodes) => {
			if (err) {
				res.status(400).json({"error": err.message});
				return;
			}
			db.all(sQueryEdges, (err, edges) => {
				if (err) {
					res.status(400).json({"error": err.message});
					return;
				}
				const _nodes = nodes.map(node => ({id: node.ID, type: node.TYPE}))
				const _edges = edges.map(edge => ({id: edge.Id, source: edge.SOURCE, target: edge.TARGET, inattr: edge.INATTRIBUTE, byname: edge.byname}))
				res.json({_nodes,_edges});
			});
		});
	});
});

app.get('/api/graph-data/node', (req,res) => {
	var sQuery = "SELECT ATTRIBUTES, \"DATA\", TYPE from nodes where ID = " + req.query.ID + ";";
	db.all(sQuery, (err, node) => {
		if (err) {
			if (err.message = "SQLITE_ERROR: no such column: undefined") err.message += ". Valid request is like /api/graph-data/node?ID=...";
			res.status(400).json({"error": err.message});
			return;
		}
		res.json({node});
	});
});

app.get('/api/graph-data/tabledef', (req,res) => {
	db.serialize(() => {
		db.all(sQueryTabledefNodes, (err, nodes) => {
			if (err) {
				res.status(400).json({"error nodes": err.message});
				return;
			}
			db.all(sQueryTabledefEdges, (err, edges) => {
				if (err) {
					res.status(400).json({"error edges": err.message});
					return;
				}
				const _nodes = nodes.map(node => ({id: node.ID}))
				const _edges = edges.map(edge => ({id: edge.Id, source: edge.SOURCE, target: edge.TARGET}))
				// const _edges = edges.map(edge => ({source: edge.SOURCE, target: edge.TARGET}))
				res.json({nodes, edges});
			});
		});
	});
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});