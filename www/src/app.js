let cy;
const dbSelector = document.getElementById('dbSelector');
const tableSelector = document.getElementById('tableSelector');
let clickedNode;
let clickedNodeFamily = [];
let state = 0;
const toggleEl = document.getElementById('toggle');

// ******* API functions

async function retrieveDbFromSession(){
    query = 'http://localhost:3000/api/databaseSelected'
    console.log(query);
    const response = await fetch(query);
    const data = await response.json();
    return data;
}

async function fetchDatabases(){ // list the available databases on the server
    query = 'http://localhost:3000/api/database'
    console.log(query);
    const response = await fetch(query);
    const data = await response.json();
    return data;
}

async function fetchData(db){ // retrieve full nodes + edges of the db
    const query = 'http://localhost:3000/api/graph-data?db=' + db;
    console.log(query);
	const response = await fetch(query);
	const data = await response.json();
	return data;
}

async function fetchTabledef(db){ // retrieve the tabledefs of the db
	query = 'http://localhost:3000/api/graph-data/tabledef?db=' + db;
	console.log(query);
	const response = await fetch(query);
	const data = await response.json();
	return data;
}

async function fetchNodeForInfo(db,id){ // retrieve a single node to display informations
    const query = 'http://localhost:3000/api/graph-data/node?db='+db+'&id='+id;
    console.log(query);
	const response = await fetch(query);
	const data = await response.json();
	var attributes = data.node[0].ATTRIBUTES.split('|');
	var values = data.node[0].DATA.split('|');
	var title = data.node[0].TYPE;

    const oldDiv = document.getElementById('infos');
    if (oldDiv) oldDiv.remove();
	const oldTitle = document.getElementById('title');
	if (oldTitle) oldTitle.remove();

	const newTitle = document.createElement('div');
	newTitle.textContent = title;
	newTitle.id = 'title';
	// document.getElementById('node-info').appendChild(newTitle);
	document.getElementById('rightPane').appendChild(newTitle);

    const newDiv = document.createElement('div');
    newDiv.id = 'infos';

    for (let i = 0; i < attributes.length; i++) {
        const key = document.createElement('div');
        key.textContent = attributes[i];
		key.classList.add(`kv-${attributes[i]}`.replace(':','')); // <- dynamic class
		
        const value = document.createElement('div');
        value.textContent = values[i];
		value.classList.add(`kv-${attributes[i]}`.replace(':',''));
		
		if (attributes[i] === ':NAME' || attributes[i] === ':OBJECT-NUMBER') {
            key.classList.add('highlight-yellow');
            value.classList.add('highlight-yellow');
        }
        newDiv.appendChild(key);
        newDiv.appendChild(value);
    }
	
    // Add the new div in the parent node-info
    // document.getElementById('node-info').appendChild(newDiv);
    document.getElementById('rightPane').appendChild(newDiv);
}

// ******* UI functions

// right panel
const pane = document.getElementById('rightPane');
const resizer = document.getElementById('resizer');

function togglePane() {
	const pane = document.getElementById('rightPane');
	const button = document.getElementById('toggleBtn');
	pane.classList.toggle('closed');
	// button.classList.toggle('closed');
	if (pane.classList.contains('closed')) {
		button.innerHTML = '⮜';
	} else {
		button.innerHTML = '⮞';
	}
}
resizer.addEventListener('mousedown', (e) => {
  e.preventDefault();
  document.addEventListener('mousemove', resizePane);
  document.addEventListener('mouseup', stopResize);
});

function resizePane(e) {
  const newWidth = window.innerWidth - e.clientX;
  if (newWidth > 150 && newWidth < 600) {
    pane.style.width = newWidth + 'px';
    // document.querySelector('.container').style.marginRight = newWidth + 'px';
  }
}
function stopResize() {
  document.removeEventListener('mousemove', resizePane);
  document.removeEventListener('mouseup', stopResize);
}

// toggle color targets/sources
function colorNodesOnClick(){
	if (cy && clickedNode) {
		// clean styles
		cy.nodes().forEach(n => {n.style({'background-color': '#666'});});
		cy.edges().forEach(e => {e.style('line-color', objectGraphStyle[1].style['line-color']);});

		// color clicked node
		clickedNode.style(graphProperties['objectGraph'].highlightNodeStyle);

		// color the targets/sources
		if (toggleEl.classList[1] == 'state-0' || toggleEl.classList[1] == 'state-1' || toggleEl.classList[1] == 'state-3') var incomingNodes = clickedNode.incomers('edge').sources();
		if (toggleEl.classList[1] == 'state-2' || toggleEl.classList[1] == 'state-1' || toggleEl.classList[1] == 'state-3') var outgoingNodes = clickedNode.outgoers('edge').targets();
		if (incomingNodes) {
			clickedNode.incomers('edge').forEach(edge => {edge.style({'line-color': '#ff9999'});});
			incomingNodes.forEach(node => {
				if (node != clickedNode) node.style('background-color', '#ff9999');
			});
		}
		if (outgoingNodes) {
			clickedNode.outgoers('edge').forEach(edge => {edge.style({'line-color': '#33ccff'});});
			outgoingNodes.forEach(node => {
				if (node != clickedNode) node.style('background-color', '#33ccff');
			});
		}
	}
}

function updateToggleLabel() {
  toggleEl.classList.remove('state-0', 'state-1', 'state-2', 'state-3');
  toggleEl.classList.add(`state-${state}`);
  const labels = ['Incomers', 'Both', 'Outgoers', 'Both'];
  toggleEl.textContent = labels[state];
  colorNodesOnClick();
}

// page INIT
document.addEventListener('DOMContentLoaded', function() {
	// database picklist - init
    fetchDatabases().then(data => {
        data.databases.forEach(item => {
            const option = document.createElement('option');
            option.value = item;
            option.textContent = item;
            dbSelector.appendChild(option);
        });
    });
	dbSelector.addEventListener('change', (event) => {
		const selectedValue = event.target.value;
		fetchTabledef(selectedValue);
	});

	// toggle color target/sources of the clicked node - init
	toggleEl.addEventListener('click', () => {
		state = (state + 1) % 4;
		updateToggleLabel();
	});

	// draw first graph
	retrieveDbFromSession()
	.then(data => {if (data.selectedDb) dbSelector.value = data.selectedDb;})
	.then(data => {
		if (dbSelector.value != "" && cy == undefined) fetchTabledef(dbSelector.value).then(data => {buildGraph(data,'classGraph');});
		updateToggleLabel();
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
					fetchTabledef(dbSelector.value).then(data => {buildGraph(data,'classGraph');});
				}
			}
		}
	});
	
	document.getElementById('run').addEventListener('click', () => {
		fetchTabledef(dbSelector.value).then(data => {
			data.nodes.forEach(item => {
				const option = document.createElement('option');
				option.value = item.ID;
				option.textContent = item.ID + " (" + item.OBJECTS + ")";
				tableSelector.appendChild(option);
			});
		}).then(() => fetchData(dbSelector.value)).then(data => buildGraph(data, 'objectGraph'));
	});
});

function buildGraphData(data, graphType){
	let nodes = {}
	let edges = {}
	if (graphType == 'classGraph') {
		nodes = data.nodes.map(node => {
			return {
				group: 'nodes', data: {"id": node.ID, "label": node.ID}
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
				group: 'nodes', data: {id: node.id, name: node.name, label: node.id+"\n"+node.type.replace(/^[^:]*:/,'').replace(':','')}
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
	const [nodes, edges] = buildGraphData(data, graphType);
	const myLayout = graphProperties[graphType].layout;
	const myStyle = graphProperties[graphType].style;
	const myOnClick = graphProperties[graphType].onClick;
		
	cy = cytoscape({
		container: document.getElementById('cy'), // container to render in
		elements: {nodes: nodes, edges: edges},
		style: myStyle,
		layout: myLayout
	});

	cy.on('click', 'node', myOnClick);
	
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
const objectGraphStyle = [
	{
		selector: 'node',
		style: {
			'background-color': '#666',
			'label': 'data(name)',
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
];
const classGraphStyle = [
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
];
const graphProperties = {
	'classGraph' : {
		layout: {name: 'circle', padding: 100},
		style: classGraphStyle,
		nodeStyle: classGraphStyle[0].style,
		highlightNodeStyle: {
			'background-color': '#d2268c',
			'width': 50,
			'height': 50
		},
		edgeStyle: classGraphStyle[1].style,
		onClick:  function(evt) {
			clickedNode = evt.target;
			colorNodesOnClick();
		}
	},
	'objectGraph': {
		layout: breadthfirstLayout,
		style: objectGraphStyle,
		nodeStyle: objectGraphStyle[0].style,
		highlightNodeStyle: {
			'background-color': '#d2268c',
			'width': 50,
			'height': 50
		},
		edgeStyle: objectGraphStyle[1].style,
		highlightEdgeStyle: {},
		onClick:  function(evt) {
			clickedNode = evt.target;
			colorNodesOnClick();
			fetchNodeForInfo(dbSelector.value,clickedNode.id());
		}
	}
}