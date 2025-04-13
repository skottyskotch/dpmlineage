const express = require('express');
const path = require('path');
const sqlite3 = require('sqlite3').verbose();
const app = express();
const port = 3000;

// Serve static files from the 'public' directory
app.use(express.static(path.join(__dirname, 'public')));

// Serve Sigma.js & graphology from node_modules
app.use('/sigma', express.static(path.join(__dirname, 'node_modules/sigma/dist')));
app.use('/graphology', express.static(path.join(__dirname, 'node_modules/graphology/dist')));

// Connect to SQLite database
const db = new sqlite3.Database('./output/DPM_OUT_SAN_graph.db');

// API endpoint to fetch graph data
app.get('/api/graph-data', (req, res) => {
    _nodes = [];
	_edges = [];
	db.all("SELECT ID, TYPE from nodes limit 10", (err, nodes) => {
    // db.all("SELECT ID, TYPE from nodes", (err, nodes) => {
		if (err) {
            res.status(400).json({"error": err.message});
            return;
        }
		_nodes = nodes.map(node => ({ id: node.ID, label: node.TYPE, x: Math.random(), y: Math.random(), size: 1 }));
	console.log(_nodes);
    });
		res.json({ _nodes, _edges });
    // db.all("with cte as (select * from nodes limit 100) select ID, SOURCE, TARGET from edges a join cte b on a.source = b.id join cte c on a.target = c.id;", (err, edges) => {
        // if (err) {
            // res.status(400).json({"error": err.message});
            // return;
        // }
		// const _edges = edges.map(edge => ({ left: edge.source, right: edge.right}));
    // });
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
