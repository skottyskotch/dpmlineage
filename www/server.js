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
app.get('/api/graph-data', (req, res) => {
	db.serialize(() => {
		db.all("SELECT ID, TYPE from nodes limit 500", (err, nodes) => {
			if (err) {
				res.status(400).json({"error": err.message});
				return;
			}
			db.all("with cte as (select * from nodes limit 500) select a.Id, SOURCE, TARGET, INATTRIBUTE from edges a join cte b on a.source = b.id join cte c on a.target = c.id;", (err, edges) => {
				if (err) {
					res.status(400).json({"error": err.message});
					return;
				}
				const _nodes = nodes.map(node => ({id: node.ID, type: node.TYPE}))
				const _edges = edges.map(edge => ({id: edge.Id, source: edge.SOURCE, target: edge.TARGET, inattr: edge.INATTRIBUTE}))
				res.json({_nodes,_edges});
			});
		});
	});
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
