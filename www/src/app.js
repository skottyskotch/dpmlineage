async function fetchData(){
	const response = await fetch('http://localhost:3000/api/graph-data');
	const data = await response.json();
	return data;
}

async function fetchNode(id){
	const response = await fetch('http://localhost:3000/api/graph-data/node?ID='+id);
	const data = await response.json();
	var attributes = data.node[0].ATTRIBUTES.split('|');
	var values = data.node[0].VALUES.split('|');
	var title = data.node[0].TYPE;

    const oldDiv = document.getElementById('infos');
    if (oldDiv) oldDiv.remove();
	const oldTitle = document.getElementById('title');
	if (oldTitle) oldTitle.remove();

	const newTitle = document.createElement('div');
	newTitle.textContent = title;
	newTitle.id = 'title';
	document.getElementById('node-info').appendChild(newTitle);

    const newDiv = document.createElement('div');
    newDiv.id = 'infos';

    for (let i = 0; i < attributes.length; i++) {
        const key = document.createElement('div');
        key.textContent = attributes[i];
		key.classList.add(`kv-${attributes[i]}`.replace(':','')); // <- dynamic class
		
        const value = document.createElement('div');
        value.textContent = values[i];
		value.classList.add(`kv-${attributes[i]}`.replace(':',''));
		
		if (attributes[i] === ':NAME') {
            key.classList.add('highlight-green');
            value.classList.add('highlight-green');
        }
		if (attributes[i] === ':OBJECT-NUMBER') {
            key.classList.add('highlight-blue');
            value.classList.add('highlight-blue');
        }
        newDiv.appendChild(key);
        newDiv.appendChild(value);
    }
	
    // Add the new div in the parent node-info
    document.getElementById('node-info').appendChild(newDiv);
}

document.addEventListener('DOMContentLoaded', function() {
	fetchData().then(data => {
		const nodes = data._nodes.map(node => {
			var sType = node.type.replace(/^[^:]*/,'');
			return {
				group: 'nodes', data: {id: node.id, label: node.id+"\n"+node.type.replace(/^[^:]*:/,'').replace(':','')}
			};
		});
		const edges = data._edges.map(edge => {
			var foundby = '(name)';
			if (edge.byname == 'FALSE') foundby = '(ONB)';
			return {
				group: 'edges', data: {id: edge.id, source: edge.source, target: edge.target, inattr: edge.inattr, label: edge.inattr.substring(1) + ' ' + foundby}
			}
		});
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
						'background-color': '#666',
						'label': 'data(label)',
						'text-wrap': 'wrap'
					}
				},
				{
					selector: 'edge',
					style: {
						'width': 3,
						'label': 'data(label)',
						'edge-text-rotation': 'autorotate',
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

		cy.on('tap', 'node', function(evt){
			const clickedNode = evt.target;
			cy.nodes().forEach(n => {
				n.style({
					'background-color': '#666',
					'width': 30,
					'height': 30
				});
			});
			clickedNode.style({
				'background-color': 'red',
				'width': 50,
				'height': 50
			});
			const incomingNodes = clickedNode.incomers('edge').sources();
			lastSelectedNode = clickedNode;
			incomingNodes.forEach(node => {
				node.style('background-color', '#ff9999');
			});
			fetchNode(this.id());
		});
		
		// to finish
		cy.on('mousedown', 'edge', function(evt) {
			const edge = evt.target;
			const inattr = edge.data('inattr').replace(':','');
			document.querySelectorAll(`.kv-${inattr}`).forEach(el => {
				el.classList.add('highlight-yellow');
			});
		});

		cy.on('mouseup', function(evt) {
			document.querySelectorAll(`[class*="kv-"]`).forEach(el => {
				el.classList.remove('highlight-yellow');
			});
		});
	});
});
