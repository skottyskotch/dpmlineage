function displayInfoObject(data){
	var attributes = data.node[0].ATTRIBUTES.split('|');
	var values = data.node[0].DATA.split('|');
	var title = data.node[0].TYPE;
	
	const panel = document.getElementById('rightPanel');
	
    const oldInfo = document.getElementById('info');
    if (oldInfo) oldInfo.remove();
	
	// container of object info
	const newInfo = document.createElement('div');
	newInfo.id = 'info';
	panel.appendChild(newInfo);

	// object title section
	const newTitle = document.createElement('div');
	newInfo.appendChild(newTitle);
	newTitle.textContent = data.node[0].TYPE;
	newTitle.id = 'title';

    const newDiv = document.createElement('div');
    newDiv.id = 'infos';
	newDiv.className = 'infodata';

    for (let i = 0; i < attributes.length; i++) {
        const key = document.createElement('div');
        key.textContent = attributes[i];
		// key.classList.add(`kv-${attributes[i]}`.replace(':','')); // <- dynamic class
		
        const value = document.createElement('div');
        value.textContent = values[i];
		// value.classList.add(`kv-${attributes[i]}`.replace(':',''));
		
		if (attributes[i] === ':NAME' || attributes[i] === ':OBJECT-NUMBER') {
            key.classList.add('highlight-yellow');
            value.classList.add('highlight-yellow');
        }
        newDiv.appendChild(key);
        newDiv.appendChild(value);
    }

    document.getElementById('rightPanel').appendChild(newDiv);
}

function displayInfoTable(data){
	const panel = document.getElementById('rightPanel');
	
    const oldInfo = document.getElementById('info');
    if (oldInfo) oldInfo.remove();
	
	// container of object info
	const newInfo = document.createElement('div');
	panel.appendChild(newInfo);
	newInfo.id = 'info';

	// object title section
	const newTitle = document.createElement('div');
	newInfo.appendChild(newTitle);
	newTitle.className = 'title';
	const number_of_connections = data.edges.reduce((total, item) => total + item.number_of_edges, 0);
	const title = clickedNode.data('id') + '\n' + clickedNode.data('objects') + ' objects\n' + number_of_connections + ' connections';
	newTitle.style.whiteSpace = 'pre-line';
	newTitle.textContent = title;
	newTitle.innerHTML = newTitle.textContent.replace(/\n/g, '<br>');
	
	// "used by" section
	const sectionTitle1 = document.createElement('div');
	newInfo.appendChild(sectionTitle1);
	sectionTitle1.className = 'title';
	sectionTitle1.textContent = "Used by";
	
	const infoDiv1 = document.createElement('div');
	infoDiv1.className = 'infoSection';
	sectionTitle1.appendChild(infoDiv1);
	
	console.log(data);
    data.edges.forEach(edge =>{
		console.log(edge);
		if (edge.SOURCE != clickedNode.data('id') || [edge.SOURCE, edge.TARGET].filter( x => x === clickedNode.data('id')).length == 2) {
			const value = document.createElement('div');
			value.textContent = edge.number_of_edges;
			const key = document.createElement('div');
			key.textContent = edge.SOURCE;
			infoDiv1.appendChild(value);
			infoDiv1.appendChild(key);
		};
	});
	
	// "uses:" section
	const sectionTitle2 = document.createElement('div');
	newInfo.appendChild(sectionTitle2);
	sectionTitle2.className = 'title';
	sectionTitle2.textContent = "Uses";
	
	const infoDiv2 = document.createElement('div');
	infoDiv2.className = 'infoSection';
	sectionTitle2.appendChild(infoDiv2);
	
    data.edges.forEach(edge =>{
		if (edge.TARGET != clickedNode.data('id') || [edge.SOURCE, edge.TARGET].filter( x => x === clickedNode.data('id')).length == 2) {
			const value = document.createElement('div');
			value.textContent = edge.number_of_edges;
			const key = document.createElement('div');
			key.textContent = edge.TARGET;
			infoDiv2.appendChild(value);
			infoDiv2.appendChild(key);
		};
	});
}

// coloration mode for links targets/sources
function colorNodesOnClick(){
	if (cy && clickedNode) {
		// clean styles
		cy.nodes().forEach(n => {n.style(graphProperties.defaultNodeStyle);});
		cy.edges().forEach(e => {e.style(graphProperties.defaultEdgeStyle);});

		// color clicked node
		clickedNode.style(graphProperties.highlightedNodeStyle);

		// color the targets/sources
		if (highlightMode.classList.value == 'state-0' || highlightMode.classList.value == 'state-1') var incomingNodes = clickedNode.incomers('edge').sources();
		if (highlightMode.classList.value == 'state-2' || highlightMode.classList.value == 'state-1' ) var outgoingNodes = clickedNode.outgoers('edge').targets();
		if (incomingNodes) {
			clickedNode.incomers('edge').forEach(edge => {edge.style(graphProperties.highlightedEdgeIncomerStyle);});
			incomingNodes.forEach(node => {
				if (node != clickedNode) node.style(graphProperties.highlightedNodeIncomerStyle);
			});
		}
		if (outgoingNodes) {
			clickedNode.outgoers('edge').forEach(edge => {edge.style(graphProperties.highlightedEdgeOutgoerStyle);});
			outgoingNodes.forEach(node => {
				if (node != clickedNode) node.style(graphProperties.highlightedNodeOutgoerStyle);
			});
		}
	}
}

function colorButtons(){
	if (clickedNode) {
		document.getElementById("Isolate").style.backgroundColor = "#007BFF";
		document.getElementById("Expand").style.backgroundColor = "#007BFF";
	}
	else {
		document.getElementById("Isolate").style.backgroundColor = "#ccc";
		document.getElementById("Expand").style.backgroundColor = "#ccc";
	}
}

// toggle color target/sources of the clicked node - init
slider.oninput = function() {
	updateToggleLabel(this.value);
};

const breadthfirstLayout = {
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
};

const graphProperties = {
	'tableDef': {
		graphLayout: {name: 'circle', padding: 100}
	},
	'object': {
		nodeObject: {
		},
		edgeObject: {
		},
		graphLayout: breadthfirstLayout,
	},
	'hybrid': {
		edgeHybrid: {
		}
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
	defaultNodeStyle: {
		'background-color': '#666',
		'width': '30',
		'height': '30'
	},
	highlightedNodeStyle: {
		'background-color': '#d2268c',
		'width': 50,
		'height': 50
	},
	highlightedNodeIncomerStyle: {
		'background-color': '#ffcc00'
	},
	highlightedNodeOutgoerStyle: {
		'background-color': '#66ccff'
	},
	defaultEdgeStyle: {
		'width': 3,
		'line-color': '#ccc',
		'target-arrow-color': '#ccc'
	},
	highlightedEdgeIncomerStyle: {
		'line-color': '#ffcc00',
		'target-arrow-color': '#ffcc00'
	},
	highlightedEdgeOutgoerStyle: {
		'line-color': '#66ccff',
		'target-arrow-color': '#66ccff'
	},
	onClickEdge:  function(evt) {
		clickedNode = evt.target;
		colorNodesOnClick();
		colorButtons();
	},
	onClickNode:  function(evt) {
		clickedNode = evt.target;
		colorNodesOnClick();
		colorButtons();
		if (clickedNode.data('class') == 'object') fetchData('graph-data/node', 'db', dbSelector.value, 'id', clickedNode.id()).then(data => {displayInfoObject(data)});
		else if (clickedNode.data('class') == 'table') fetchData('graph-data/tabledef', 'db', dbSelector.value, 'id', clickedNode.id()).then(data => {displayInfoTable(data)});
	}
}
document.getElementById('Isolate').addEventListener('click', () => {
		if (clickedNode != undefined) {
			if (clickedNode.data('class') == 'table') {
				fetchData('graph-data/tabledef', 'db', dbSelector.value, 'id', clickedNode.data('name'))
				.then(data => buildGraphData(data, 'classGraph'))
				.then(data => buildGraph(data));
			}
			else if (clickedNode.data('class') == 'object') {
				clickedNodeExpansion += 1;
				fetchData('graph-data/nodeIsolation', 'db', dbSelector.value, 'table', clickedNode.data('id'));
			}
		}
	});

	document.getElementById('Expand').addEventListener('click', () => {
		if (clickedNode.data('class') == 'table') {
			fetchData('graph-data/node', 'db', dbSelector.value, 'table', clickedNode.data('id'))
			.then(data => expandNode(data, clickedNode))
			.then(data => addElementGraph(data));
		}
	});
	
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
				cy.elements().remove();
				if (dbSelector.value != "") {
					fetchData('graph-data/tabledef', 'db', dbSelector.value)
					.then(data => buildGraphData(data))
					.then(data => buildGraph(data));
				}
			}
		}
	});

function createNodes(data, sClass){
	const nodes = data.nodes.map(node => return graphProperties[sClass].node;});
	return nodes;
}

function buildGraphData(data, graphType){
	let nodes = {}
	let edges = {}
	if (graphType == 'classGraph') {
		console.log('classGraph');
		nodes = data.nodes.map(node => {
			return {
				group: 'nodes', data: {"id": node.ID, name: node.ID, label: node.ID.replace(/^[^:]*:/,'').replace(/:$/,'')+'\n'+node.OBJECTS, objects: node.OBJECTS, class: 'table'}
			};
		});
		edges = data.edges.map(edge => {
			return {
				group: 'edges', data: {id: edge.SOURCE + '_' + edge.TARGET, source: edge.SOURCE, target: edge.TARGET, label: edge.number_of_edges}
			}
		});
	}
	else if (graphType == 'objectGraph'){
		nodes = data.nodes.map(node => {
			var sType = node.type.replace(/^[^:]*/,'');
			return {
				group: 'nodes', data: {id: node.id, name: node.name, label: node.id+"\n"+node.type.replace(/^[^:]*:/,'').replace(':',''), type: node.type, class: 'object'}
			};
		});
		edges = data.edges.map(edge => {
			var foundby = ' (name)';
			if (edge.byname == 'FALSE') foundby = ' (ONB)';
			return {
				group: 'edges', data: {id: edge.source + '_' + edge.target, source: edge.source, source_type: edge.source_type, target: edge.target, target_type: edge.target_type, inattr: edge.inattr, label: edge.inattr.substring(1) + foundby}
			}
		});
	}
	return [nodes, edges];
}

function expandNode(data, clickedNode){
	console.log('expandNode("'+clickedNode.data('name')+'")');
	const [newNodes, edges] = buildGraphData(data, 'objectGraph');
	// clickedNode.hide();
	clickedNode.remove();
	// create a group for the tableDef
	const groupId = clickedNode.data('id');
		cy.add({
		data: {
			id: groupId,
			class: 'group',
			label: clickedNode.data('type')
		},
		position: clickedNode.position(), // au centre initialement
		// selectable: false,
		grabbable: true // <- pour qu’on puisse le déplacer à la souris
	});
	// move the new nodes
	newNodes.forEach(n => {
		n.data['parent'] = groupId;
	});
	if (cy) cy.add(newNodes);
	let newEdges = [];
	edges.forEach(e => {
		if (cy.getElementById(e.data.source).nonempty() && cy.getElementById(e.data.target).nonempty()) newEdges.push(e);
		else {
			let source = undefined;
			let target = undefined;
			let cancel = false;
			let elt = {
				group: 'edges', 
				data: {
					id: e.data.source + '_' + e.data.target, 
					source: e.data.source, 
					source_type: e.data.source_type, 
					target: e.data.target, 
					target_type: e.data.target_type, 
					inattr: e.data.inattr, 
					label: e.data.inattr.substring(1) + foundby
				}
			}
			if (cy.getElementById(e.source).empty()) {
				if (cy.getElementById(e.data.source_type).nonempty()) {
					elt.data.source = e.data.source_type;
					elt.data.id = elt.data.source + '_' + elt.data.target;
				}
				else cancel = true;
			}
			if (cy.getElementById(e.data.target).empty()) {
				if (cy.getElementById(e.data.target_type).nonempty()) {
					elt.data.target = e.data.target_type;
					elt.data.id = elt.data.source + '_' + elt.data.target;
				}
				else cancel = true;
			}
			if (!cancel) {
				var foundby = ' (name)';
				if (e.data.byname == 'FALSE') foundby = ' (ONB)';
				newEdges.push(elt);
			}
		}
	});
	if (cy) cy.add(newEdges);
}

function addElementGraph(data){
	const addedElements = cy.nodes('[parent =  "' + clickedNode.data('id') + '"]');
	layoutGroupAround(clickedNode, addedElements);
}

function layoutGroupAround(clickedNode, addedNodes) {
  // 3. Placer les nœuds autour du parent (cercle)
  const center = clickedNode.position();
  const radius = 150;
  const angleStep = (2 * Math.PI) / addedNodes.length;

  addedNodes.forEach((node, i) => {
    const angle = i * angleStep;
    const x = center.x + radius * Math.cos(angle);
    const y = center.y + radius * Math.sin(angle);
    node.position({ x, y });
  });

  // 4. Style (optionnel) du groupe parent
  cy.style()
    .selector('node')
    .style({
      'background-color': '#999',
      'label': 'data(id)'
    })
    .selector(':parent')
    .style({
      'background-opacity': 0.1,
      'border-width': 1,
      'border-color': '#aaa',
      'shape': 'roundrectangle',
      'padding': '30px',
      'label': '', // invisible
      'z-index': 0
    })
    .update();

  // 5. Centrer la vue
  cy.animate({
    fit: {
      eles: cy.collection([clickedNode, ...addedNodes]),
      padding: 100
    },
    duration: 500
  });
}

function buildGraph(data) {
	console.log('buildgraph');
	const [nodes, edges] = data;
	cy = cytoscape({
		container: document.getElementById('cy'),
		elements: {nodes: nodes, edges: edges},
		style: graphProperties.style,
		layout: graphProperties.classGraphLayout
	});

	cy.on('click', 'node', graphProperties.onClickNode);
}

function initNode(nodeData){
	const nodeStruct = {
		group: 'nodes',
		data: {
			"id": nodeData.ID,
			name: nodeData.ID,
			label: nodeData.ID.replace(/^[^:]*:/,'').replace(/:$/,'')+'\n'+nodeData.OBJECTS,
			objects: nodeData.OBJECTS,
			class: 'tableDef'
		}
	}
	return nodeStruct;
}

function initEdge(edgeData){
	var edgeStruct = {
		group: 'edges',
		data: {
			id: edgeData.SOURCE + '_' + edgeData.TARGET,
			source: edgeData.SOURCE,
			target: edgeData.TARGET,
			label: edgeData.number_of_edges,
			class: 'tableDef'
		}
	}
	return edgeStruct;
}

// server

const session = require('express-session');
app.use(session({
  secret: 'whatsthesecret?',
  resave: false,
  saveUninitialized: true,
  cookie: { secure: false }
}));

app.get('/admin', (req, res) => {
	const selection = req.session.selection || 'Aucune sélection';
	res.send(`
		<p>Vous avez choisi : ${selection}</p>
		<a href="/">Retour à l'accueil</a>
	`);
});

app.get('/api/databaseSelected', (req, res) => {
	const selectedDb = req.session.selection;
	res.json({selectedDb});
});