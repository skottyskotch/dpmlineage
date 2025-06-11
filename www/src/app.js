let cy;
const dbSelector = document.getElementById('dbSelector');
const tableSelector = document.getElementById('tableSelector');

async function retrieveDbFromSession(){
    query = 'http://localhost:3000/api/databaseSelected'
    console.log(query);
    const response = await fetch(query);
    const data = await response.json();
    return data;
}

async function fetchDatabases(){
    query = 'http://localhost:3000/api/database'
    console.log(query);
    const response = await fetch(query);
    const data = await response.json();
    return data;
}

async function fetchData(db){
    const query = 'http://localhost:3000/api/graph-data?db=' + db;
    console.log(query);
	const response = await fetch(query);
	const data = await response.json();
	return data;
}

async function fecthTabledef(db){
	query = 'http://localhost:3000/api/graph-data/tabledef?db=' + db;
	console.log(query);
	const response = await fetch(query);
	const data = await response.json();
	return data;
}

async function fetchNode(db,id){
    const query = 'http://localhost:3000/api/graph-data/node?db='+db+'&id='+id;
    console.log(query);
	const response = await fetch(query);
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
	dbSelector.addEventListener('change', (event) => {
		const selectedValue = event.target.value;
		fecthTabledef(selectedValue);
	});
    fetchDatabases().then(data => {
        data.databases.forEach(item => {
            const option = document.createElement('option');
            option.value = item;
            option.textContent = item;
            dbSelector.appendChild(option);
        });
    });
	retrieveDbFromSession()
	.then(data => {if (data.selectedDb) dbSelector.value = data.selectedDb;})
	.then(data => {
		if (dbSelector.value != "") fetchData(dbSelector.value).then(data => {
			if (cy == undefined) buildGraph(data);
		});
	})
	
	document.addEventListener('keydown', (event) => {
		if (cy) {
			const key = event.key;

			if (key === '1') {
				console.log('Layout : fcose');
				cy.layout({
					name: 'fcose',
					animate: false,
					padding: 20,
					nodeRepulsion: 100000,
					idealEdgeLength: 250,
					gravity: 0.01
				}).run();
			}

			if (key === '2') {
				console.log('Layout : breadthfirst');
				cy.layout({
					name: 'breadthfirst',
					fit: true, // whether to fit the viewport to the graph
					directed: false, // whether the tree is directed downwards (or edges can point in any direction if false)
					padding: 150, // padding on fit
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
				}).run();
			}
			
			if (key == '4') {
				// cy.elements().remove();
				fecthTabledef(dbSelector.value).then(data => {
					const newNodes = data.nodes.map(node => {
						return {
							group: 'nodes', data: {"id": node.ID, "label": node.ID}
						};
					});
					const newEdges = data.edges.map(edge => {
						// console.log(edge);
						return {
							group: 'edges', data: {id: edge.SOURCE + '_' + edge.TARGET, source: edge.SOURCE, target: edge.TARGET, label: edge.number_of_edges}
						}
					});
					cy = cytoscape({
						container: document.getElementById('cy'), // container to render in
						elements: {
							nodes: newNodes
							,
							edges: newEdges
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
						],

						layout: {
							name: 'circle',
							padding: 100
						}
					});
				});
			}
		}
	});
	document.getElementById('run').addEventListener('click', () => {
		fecthTabledef(dbSelector.value).then(data => {
			data.nodes.forEach(item => {
				const option = document.createElement('option');
				option.value = item.ID;
				option.textContent = item.ID + " (" + item.OBJECTS + ")";
				tableSelector.appendChild(option);
			});
		}).then(() => fetchData(dbSelector.value)).then(data => buildGraph(data));
	});
});

function buildGraph(data) {
	const nodes = data.nodes.map(node => {
		var sType = node.type.replace(/^[^:]*/,'');
		return {
			group: 'nodes', data: {id: node.id, label: node.id+"\n"+node.type.replace(/^[^:]*:/,'').replace(':','')}
		};
	});
	const edges = data.edges.map(edge => {
		var foundby = ' (name)';
		if (edge.byname == 'FALSE') foundby = ' (ONB)';
		return {
			group: 'edges', data: {id: edge.source + '_' + edge.target, source: edge.source, target: edge.target, inattr: edge.inattr, label: edge.inattr.substring(1) + foundby}
		}
	});
	cy = cytoscape({
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
		],
		
		layout: {
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

	cy.on('click', 'node', function(evt){
		const clickedNode = evt.target;
		cy.nodes().forEach(n => {
			n.style({
				'background-color': '#666',
				'width': 30,
				'height': 30
			});
		});
		clickedNode.style({
			'background-color': '#d2268c',
			'width': 50,
			'height': 50
		});
		// const incomingNodes = clickedNode.incomers('edge').sources();
		const incomingNodes = clickedNode.outgoers('edge').targets();
		lastSelectedNode = clickedNode;
		incomingNodes.forEach(node => {
			node.style('background-color', '#ff9999');
		});
		fetchNode(dbSelector.value,this.id());
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
}


let state = 0;
const toggleEl = document.getElementById('toggle');

function updateToggleLabel() {
  toggleEl.classList.remove('state-0', 'state-1', 'state-2');
  toggleEl.classList.add(`state-${state}`);
  
  const labels = ['Incomers', 'Outgoers', 'Reset'];
  toggleEl.textContent = labels[state];
}

toggleEl.addEventListener('click', () => {
  state = (state + 1) % 3;
  updateToggleLabel();

  if (selectedNode) {
    cy.elements().removeClass('highlighted');
    if (state === 0) {
      selectedNode.incomers().addClass('highlighted');
    } else if (state === 1) {
      selectedNode.outgoers().addClass('highlighted');
    }
    // state 2 = reset, no highlighting
  }
});

updateToggleLabel(); // init