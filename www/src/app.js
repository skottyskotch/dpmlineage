async function fetchData(){
	const response = await fetch('http://localhost:3000/api/graph-data');
	const data = await response.json();
	return data;
}

document.addEventListener('DOMContentLoaded', function() {
	fetchData().then(data => {
		const nodes = data._nodes.map(node => ({group: 'nodes', data: {id: node.id, label: node.id+"\n"+node.type}}))
		const edges = data._edges.map(edge => (
	{ group: 'edges', data: {id: edge.id, source: edge.source, target: edge.target, inattr: edge.inattr}}))
		var cy = cytoscape({
			container: document.getElementById('cy'), // container to render in

			elements: {
				nodes: nodes,
				edges: edges
			},

			style: [
				{
					selector: 'node',
					style: {
						'background-color': '#333',
						'label': 'data(label)',
						'text-wrap': 'wrap'
					}
				},
				{
					selector: 'edge',
					style: {
						'width': 3,
						'label': 'data(inattr)',
						'line-color': '#ccc',
						'target-arrow-color': '#ccc',
						'target-arrow-shape': 'triangle',
						'curve-style': 'bezier'
					}
				}
			]

			,layout: {
				name: 'breadthfirst',

				fit: true, // whether to fit the viewport to the graph
				directed: false, // whether the tree is directed downwards (or edges can point in any direction if false)
				padding: 30, // padding on fit
				circle: false, // put depths in concentric circles if true, put depths top down if false
				grid: false, // whether to create an even grid into which the DAG is placed (circle:false only)
				spacingFactor: 1.75, // positive spacing factor, larger => more space between nodes (N.B. n/a if causes overlap)
				boundingBox: undefined, // constrain layout bounds; { x1, y1, x2, y2 } or { x1, y1, w, h }
				avoidOverlap: true, // prevents node overlap, may overflow boundingBox if not enough space
				nodeDimensionsIncludeLabels: false, // Excludes the label when calculating node bounding boxes for the layout algorithm
				roots: undefined, // the roots of the trees
				depthSort: undefined, // a sorting function to order nodes at equal depth. e.g. function(a, b){ return a.data('weight') - b.data('weight') }
				animate: false, // whether to transition the node positions
				animationDuration: 500, // duration of animation in ms if enabled
				animationEasing: undefined, // easing of animation if enabled,
				animateFilter: function ( node, i ){ return true; }, // a function that determines whether the node should be animated.  All nodes animated by default on animate enabled.  Non-animated nodes are positioned immediately when the layout starts
				ready: undefined, // callback on layoutready
				stop: undefined, // callback on layoutstop
				transform: function (node, position ){ return position; } // transform a given node position. Useful for changing flow direction in discrete layouts
			}
		});
	});
});