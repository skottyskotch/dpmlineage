let cy;
const dbSelector = document.getElementById('dbSelector');
const tableSelector = document.getElementById('tableSelector');
let clickedNode;
let clickedNodeFamily = [];
let state = 0;
const highlightMode = document.getElementById('highlightMode');

// ******* UI functions

// right panel
const panel = document.getElementById('rightPane');
function togglePane() {
	const button = document.getElementById('toggleBtn');
	panel.classList.toggle('collapsed');
	if (panel.classList.contains('collapsed')) {
		button.innerHTML = '⮜';
	} else {
		button.innerHTML = '⮞';
	}
}
const resizer = document.getElementById('resizer');
resizer.addEventListener('mousedown', (e) => {
  e.preventDefault();
  document.addEventListener('mousemove', resizePanel);
  document.addEventListener('mouseup', stopResize);
});
function resizePanel(e) {
  const newWidth = window.innerWidth - e.clientX;
  if (newWidth > 150 && newWidth < 600) {
    panel.style.width = newWidth + 'px';
    // document.querySelector('.container').style.marginRight = newWidth + 'px';
  }
}
function stopResize() {
  document.removeEventListener('mousemove', resizePanel);
  document.removeEventListener('mouseup', stopResize);
}
function displayInfoObject(data){
	var attributes = data.node[0].ATTRIBUTES.split('|');
	var values = data.node[0].DATA.split('|');
	var title = data.node[0].TYPE;
	
	const panel = document.getElementById('rightPane');
	
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

    document.getElementById('rightPane').appendChild(newDiv);
}

function displayInfoTable(data){
	const panel = document.getElementById('rightPane');
	
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
	sectionTitle1.textContent = "Used by:";
	
	const infoDiv1 = document.createElement('div');
	infoDiv1.className = 'infoSection';
	sectionTitle1.appendChild(infoDiv1);
	
    data.edges.forEach(edge =>{
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

// database selection menu
dbSelector.addEventListener('change', (event) => {
	const selectedValue = event.target.value;
	fetchData('graph-data/tabledef', 'db', selectedValue).then(data => {buildGraph(data,'classGraph');});
});

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
			clickedNode.incomers('edge').forEach(edge => {edge.style(graphProperties.highlightedEdgeStyle);});
			incomingNodes.forEach(node => {
				if (node != clickedNode) node.style('background-color', '#ff9999');
			});
		}
		if (outgoingNodes) {
			clickedNode.outgoers('edge').forEach(edge => {edge.style({'line-color': '#33ccff', 'target-arrow-color': '#33ccff'});});
			outgoingNodes.forEach(node => {
				if (node != clickedNode) node.style('background-color', '#33ccff');
			});
		}
	}
}
function updateToggleLabel(value) {
	highlightMode.classList.remove('state-0', 'state-1', 'state-2');
	highlightMode.classList.add(`state-${value}`);
	const labels = ['Incomers', 'Both', 'Outgoers'];
	highlightMode.textContent = labels[value];
	colorNodesOnClick();
}

// toggle color target/sources of the clicked node - init
slider.oninput = function() {
	updateToggleLabel(this.value);
};

// ******* API function
async function fetchData(endpoint, ...args){
	let sParams = '';
	if (args.length > 0 && args.length % 2 == 0) {
		const params = [];
		for (let i = 0; i < args.length; i += 2) {
			const key = args[i];
			const value = args[i+1];
			params.push(`${encodeURIComponent(key)}=${encodeURIComponent(value)}`);
		}
		sParams = '?'+params.join('&');
	}
	const query = 'http://localhost:3000/api/' + endpoint + sParams;
    console.log(query);
    const response = await fetch(query);
    const data = await response.json();
    return data;
}

// page INIT
document.addEventListener('DOMContentLoaded', function() {
	// database picklist - init
    fetchData('database').then(data => {
        data.databases.forEach(item => {
            const option = document.createElement('option');
            option.value = item;
            option.textContent = item;
            dbSelector.appendChild(option);
        });
    });

	// draw first graph
	fetchData('databaseSelected')
	.then(data => {if (data.selectedDb) dbSelector.value = data.selectedDb;})
	.then(data => {
		if (dbSelector.value != "" && cy == undefined) fetchData('graph-data/tabledef', 'db', dbSelector.value).then(data => {buildGraph(data,'classGraph');});
		updateToggleLabel(slider.value);
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
				cy.elements().remove();
				if (dbSelector.value != "") {
					fetchData('graph-data/tabledef', 'db', dbSelector.value).then(data => {buildGraph(data,'classGraph');});
				}
			}
		}
	});
	
	document.getElementById('Isolate').addEventListener('click', () => {
		if (clickedNode.data('class') == 'table');
		fetchData('graph-data/tabledef', 'db', dbSelector.value, 'id', clickedNode.data('name'))
		.then(data => buildGraph(data, 'classGraph'));			
	});

	document.getElementById('run').addEventListener('click', () => {
		fetchData('graph-data/tabledef', 'db', dbSelector.value).then(data => {
			data.nodes.forEach(item => {
				const option = document.createElement('option');
				option.value = item.ID;
				option.textContent = item.ID + " (" + item.OBJECTS + ")";
				tableSelector.appendChild(option);
			});
		}).then(() => fetchData('graph-data', 'db', dbSelector.value)).then(data => buildGraph(data, 'objectGraph'));
	});
});

function buildGraphData(data, graphType){
	let nodes = {}
	let edges = {}
	if (graphType == 'classGraph') {
		nodes = data.nodes.map(node => {
			return {
				group: 'nodes', data: {"id": node.ID, name: node.ID, label: node.ID, objects: node.OBJECTS, class: 'table'}
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
				group: 'nodes', data: {id: node.id, name: node.name, label: node.id+"\n"+node.type.replace(/^[^:]*:/,'').replace(':',''), class: 'object'}
			};
		});
		edges = data.edges.map(edge => {
			var foundby = ' (name)';
			if (edge.byname == 'FALSE') foundby = ' (ONB)';
			return {
				group: 'edges', data: {id: edge.source + '_' + edge.target, source: edge.source, target: edge.target, inattr: edge.inattr, label: edge.inattr.substring(1) + foundby}
			}
		});
	}
	return [nodes, edges];
}

function buildGraph(data, graphType) {
	console.log('buildgraph("'+graphType+'")');
	const [nodes, edges] = buildGraphData(data, graphType);
	cy = cytoscape({
		container: document.getElementById('cy'), // container to render in
		elements: {nodes: nodes, edges: edges},
		style: graphProperties.style,
		layout: graphProperties.classGraphLayout
	});

	cy.on('click', 'node', graphProperties.onClickNode);
	
	// to finish
	cy.on('mousedown', 'edge', function(evt) {
		if (graphType != 'classGraph'){
			const edge = evt.target;
			const inattr = edge.data('inattr').replace(':','');
			document.querySelectorAll(`.kv-${inattr}`).forEach(el => {
				el.classList.add('highlight-yellow');
			});
		}
	});

	cy.on('mouseup', function(evt) {
		if (graphType != 'classGraph'){
			document.querySelectorAll(`[class*="kv-"]`).forEach(el => {
				el.classList.remove('highlight-yellow');
			});
		}
	});
}

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
	classGraphLayout: {name: 'circle', padding: 100},
	objectGraphLayout: breadthfirstLayout,
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
	defaultEdgeStyle: {
		'width': 3,
		'line-color': '#ccc',
		'target-arrow-color': '#ccc'
	},
	highlightedEdgeStyle: {
		'line-color': '#ff9999',
		'target-arrow-color': '#ff9999'
	},
	onClickEdge:  function(evt) {
		clickedNode = evt.target;
		colorNodesOnClick();},
	onClickNode:  function(evt) {
		clickedNode = evt.target;
		colorNodesOnClick();
		if (clickedNode.data('class') == 'object') fetchData('graph-data/node', 'db', dbSelector.value, 'id', clickedNode.id()).then(data => {displayInfoObject(data)});
		else if (clickedNode.data('class') == 'table') fetchData('graph-data/tabledef', 'db', dbSelector.value, 'id', clickedNode.id()).then(data => {displayInfoTable(data)});}
}