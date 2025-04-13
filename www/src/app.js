/*
document.addEventListener('DOMContentLoaded', function() {
    fetch('http://localhost:3000/api/graph-data')
        .then(response => {
            if (!response.ok) throw new Error('Network response was not ok ' + response.statusText);
            return;
		})
        .then(data => {
            const container = document.getElementById('sigma-container');
            // const graph = new graphology.Graph();
            const graph = new graphology.MultiGraph();
            // Add nodes and edges to the graph
            data._nodes.forEach(node => {
				graph.addNode(node.id, {label: node.id, class: node.label, x: node.x, y: node.y});graph.addNode(node.id, {label: node.id, class: node.label, x: node.x, y: node.y});
			});
			data._edges.forEach(edge => {
				graph.addEdge(edge.left, edge.right, edge);
			});

			settings = {
                    defaultNodeColor: '#ec5148',
                    defaultEdgeType: 'curve', // Utilisez des courbes pour les liens
                    defaultEdgeColor: '#ccc',
			};
            // const renderer = new Sigma(graph, container, {defaultEdgeType: 'curvedArrow', enableEdgeEvents: true});
            const renderer = new window.Sigma(graph, container);

            renderer.on('clickNode', event => {
                const nodeId = event.node;
                const nodeData = graph.getNodeAttributes(nodeId);
                document.getElementById('node-info').innerText = `Node info: ${JSON.stringify(nodeData, null, 2)}`;
            });
			
			renderer.on('enterEdge', ({ edge }) => {
				hoveredEdge = edge;
				renderer.refresh();
			});
			renderer.on('leaverEdge', ({ edge }) => {
				hoveredEdge = null;
				renderer.refresh();
			});
            renderer.on('clickEdge', event => {
                const edgeId = event.edge;
                const edgeData = graph.getEdgeAttributes(edgeId);
                document.getElementById('node-info').innerText = `Edge info: ${JSON.stringify(edgeData, null, 2)}`;
            });
        })
        .catch(error => console.error('Error fetching graph data:', error));
});
*/
async function fetchData(a){
	const response = await fetch('http://localhost:3000/api/graph-data');
	const data = await response.json();
	return data;
}

async function genGraph(data){
	var cy = cytoscape({
		container: document.getElementById('cy'), // container to render in
	// graph.addNode(node.id, {label: node.id, class: node.label, x: node.x, y: node.y});
	
	// elemets: {
		// nodes: [
	
	  elements: [ // list of graph elements to start with
		{ // node a
		  data: { id: 'a' }
		},
		{ // node b
		  data: { id: 'b' }
		},
		{ // edge ab
		  data: { id: 'ab', source: 'a', target: 'b' }
		}
	  ],

	  style: [ // the stylesheet for the graph
		{
		  selector: 'node',
		  style: {
			'background-color': '#666',
			'label': 'data(id)'
		  }
		},

		{
		  selector: 'edge',
		  style: {
			'width': 3,
			'line-color': '#ccc',
			'target-arrow-color': '#ccc',
			'target-arrow-shape': 'triangle',
			'curve-style': 'bezier'
		  }
		}
	  ],

	  layout: {
		name: 'grid',
		rows: 1
	  }

	});
}
document.addEventListener('DOMContentLoaded', function() {
	fetchData().then(data => {
		// console.log(data._nodes);
		// console.log(data._edges);
		var cy = cytoscape({
			container: document.getElementById('cy'), // container to render in

			elements: {
				nodes: data._nodes,
				edges: data._edges
			},

			style: [
				{
					selector: 'node',
					style: {
						'background-color': '#666',
						'label': 'data(id)'
					}
				},
				{
					selector: 'edge',
					style: {
					'width': 3,
					'line-color': '#ccc',
					'target-arrow-color': '#ccc',
					'target-arrow-shape': 'triangle',
					'curve-style': 'bezier'
					}
				}
			],

			// layout: {
				// name: 'grid',
				// rows: 1
			// }
		});
	});
});