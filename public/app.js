document.addEventListener('DOMContentLoaded', function() {

    // Fetch data from your backend API
    fetch('http://localhost:3000/api/graph-data')
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok ' + response.statusText);
            }
            return response.json();
        })
        .then(data => {
            const container = document.getElementById('sigma-container');
            const graph = new graphology.Graph();
            // Add nodes and edges to the graph
            data._nodes.forEach(node => {
				graph.addNode(node.id, {label: node.id, class: node.label, x: node.x, y: node.y, size: 10, color: "blue" });
			});
            // data.edges.forEach(edge => {graph.addEdge(edge.source, edge.target, edge);});
// graph.addNode("1", { label: "Node 1", x: 0, y: 0, size: 10, color: "blue" }); 
// graph.addNode("2", { label: "Node 2", x: 1, y: 1, size: 20}); 
// graph.addNode("2", { label: "Node 2", x: 1, y: 1, size: 20, color: "red" }); 
// graph.addEdge("1", "2", { size: 5, color: "purple" }); 

            const renderer = new window.Sigma(graph, container);

            renderer.on('clickNode', event => {
                const nodeId = event.node;
                const nodeData = graph.getNodeAttributes(nodeId);
                document.getElementById('node-info').innerText = `Informations sur le nœud : ${JSON.stringify(nodeData, null, 2)}`;
            });
        });
        // .catch(error => console.error('Error fetching graph data:', error));
});
      // const graph = new graphology.Graph();
// graph.addNode("1", { label: "Node 1", x: 0, y: 0, size: 10, color: "blue" }); 
// graph.addNode("2", { label: "Node 2", x: 1, y: 1, size: 20}); 
// graph.addNode("2", { label: "Node 2", x: 1, y: 1, size: 20, color: "red" }); 
// graph.addEdge("1", "2", { size: 5, color: "purple" }); 
// const sigmaInstance = new Sigma(graph, document.getElementById("sigma-container")); 
