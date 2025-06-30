let clickedNode = null;

function graphData(data) {
	const sClass = data.class;
	const nodes = data.nodes.map(node => {
		let nodeStruct;
		if (sClass == "tableDef"){
			nodeStruct = {
				"id": node.ID, 
				name: node.ID,
				label: node.ID.replace(/^[^:]*:/,'').replace(/:$/,'')+'\n'+node.OBJECTS,
				objects: node.OBJECTS,
				class: sClass
			}
		}
		else {
			let sLabel = node.id+"\n"+node.type.replace(/^[^:]*:/,'').replace(':','');
			if (node.name != "") sLabel = node.name+"\n"+node.type.replace(/^[^:]*:/,'').replace(':','');
			nodeStruct = {
				id: node.id,
				name: node.name,
				label: sLabel,
				type: node.type,
				class: sClass
			}
		}
		return {
			group: 'nodes',
			data: nodeStruct
		}
	});
	const edges = data.edges.map(edge => {
		let edgeStruct;
		if (sClass == "tableDef"){
			edgeStruct = {
				id: edge.SOURCE + '_' + edge.TARGET, 
				source: edge.SOURCE, 
				target: edge.TARGET, 
				label: edge.number_of_edges
			}
		}
		else {
			let foundby = ' (name)';
			if (edge.byname == 'False') foundby = ' (ONB)';
			edgeStruct = {
				id: edge.source + '_' + edge.target,
				source: edge.source,
				source_type: edge.source_type,
				target: edge.target,
				target_type: edge.target_type,
				inattr: edge.inattr,
				label: edge.inattr.substring(1) + foundby
			}
		}
		return {
			group: 'edges',
			data: edgeStruct
		}
	});
	const style= [
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
	const layout = {name: 'circle'};
	return [nodes, edges, style, layout];
}

function buildGraph(data) {
	const [nodes, edges, style, layout] = data;
	cy = cytoscape({
		container: document.getElementById('cy'),
		elements: {nodes: nodes, edges: edges},
		style: style,
		layout: layout
	});
	if (tableSelected != null) activeCenterButton(tableSelected);
	if (objectSelected != null) activeCenterButton(objectSelected);
	cy.on('click', 'node', onClickNode);
	cy.on('mousedown', 'edge', function(event) {
		const edge = event.target;
	});

	cy.on('mouseup', 'edge', function(event) {
		// console.log('down'); // À définir
	});
}

function addGraph(data){
	if (cy) {
		const [nodes, edges, style, layout] = data;
		let addedNodes =  cy.add({nodes: nodes, edges: edges, style: style});
		// addedNodes.style({'display': 'none'});
	}
}

function centerOnNode(nodeId) {
	const node = cy.getElementById(nodeId);
	if (node.length > 0) {
		cy.center(node); 
	}
}

function onClickNode(evt) {
	clickedNode = evt.target;
	colorNodesOnClick();
	
	// activate the Isolate button
	$('#Isolate').addClass('active').prop('disabled', false);
	$('#Mark').addClass('active').prop('disabled', false);
	
	// activate the Discover button if there are any to discover
	fetchData('graph-data/nodes', 'db', dbSelector.value, 'id', clickedNode.id())
	.then(data => {
		if (data.nodes.some(node => cy.getElementById(node.id).empty())) { // if some in database aren't in the graph
			$('#Discover').addClass('active').prop('disabled', false);
		};
	});

	if (clickedNode.neighborhood('node').data([':hidden']).length > 0) { // if some are in the graph but hidden
		$('#Discover').addClass('active').prop('disabled', false);
	}
	
	if (clickedNode.data('class') == 'tableDef'){
		fetchData('graph-data/tabledef', 'db', dbSelector.value, 'id', clickedNode.id())
		.then(data => {displayInfoTable(data)});
	}
	else if (clickedNode.data('class') == 'object') {
		fetchData('graph-data/node', 'db', dbSelector.value, 'id', clickedNode.id())
		.then(data => {displayInfoObject(data)});
	}
}

function colorNodesOnClick() {
	if (cy && clickedNode) {
		// clean styles
		cy.nodes().forEach(n => {
			n.style({
				'background-color': '#666',
				'width': '30',
				'height': '30'
			});
		});
		cy.edges().forEach(e => {e.style({
			'width': 3,
			'line-color': '#ccc',
			'target-arrow-color': '#ccc'
			});
		});

		// color clicked node
		clickedNode.style({
			'background-color': '#d2268c',
			'width': 50,
			'height': 50
		});

		// color the targets/sources
		if ($('#slider2Message').hasClass('state-0') || $('#slider2Message').hasClass('state-1')) {
			var incomingNodes = clickedNode.incomers('edge').sources();
			clickedNode.incomers('edge').forEach(edge => {edge.style({
					'line-color': '#ffcc00',
					'target-arrow-color': '#ffcc00'
				})
			});
			incomingNodes.forEach(node => {
				if (node != clickedNode) node.style({
					'background-color': '#ffcc00'
				});
			});
		}
		if ($('#slider2Message').hasClass('state-2') || $('#slider2Message').hasClass('state-1')) {
			var outgoingNodes = clickedNode.outgoers('edge').targets();
			clickedNode.outgoers('edge').forEach(edge => {edge.style({
					'line-color': '#66ccff',
					'target-arrow-color': '#66ccff'
				});
			});
			outgoingNodes.forEach(node => {
				if (node != clickedNode) node.style({
					'background-color': '#66ccff'
				});
			});
		}
	}
}

function displayInfoTable(){
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
	const number_of_incomers = clickedNode.incomers('edge').reduce((total, item) => total + Number(item.data('label')), 0);
	const number_of_outgoers = clickedNode.outgoers('edge').reduce((total, item) => total + Number(item.data('label')), 0);
	const number_of_connections = number_of_incomers + number_of_outgoers;
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
	
	clickedNode.incomers('edge').forEach(edge =>{
		if (edge.data('source') != clickedNode.data('id') || [edge.data('source'), edge.data('target')].filter( x => x === clickedNode.data('id')).length == 2) {
			const value = document.createElement('div');
			value.textContent = edge.data('label');
			const key = document.createElement('div');
			key.textContent = edge.data('source');
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
	
	clickedNode.outgoers('edge').forEach(edge =>{
		if (edge.data('target') != clickedNode.data('id') || [edge.data('source'), edge.data('target')].filter( x => x === clickedNode.data('id')).length == 2) {
			const value = document.createElement('div');
			value.textContent = edge.data('label');
			const key = document.createElement('div');
			key.textContent = edge.data('target');
			infoDiv2.appendChild(value);
			infoDiv2.appendChild(key);
		};
	});
}

function displayInfoObject(data){
	// var attributes = data.nodes[0].attributes.split('|');
	var attributes = data.nodes[0].attributes.split(String.fromCharCode(23));
	// var values = data.nodes[0].data.split('|');
	var values = data.nodes[0].data.split(String.fromCharCode(23));
	
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
	newTitle.className = 'title';
	let title = data.nodes[0].name+'\n'+data.nodes[0].type+'\n'+data.edges[0].count+' connections';
	if (data.nodes[0].name == '') title = data.nodes[0].id+'\n'+data.nodes[0].type+'\n'+data.edges[0].count+' connections';
	newTitle.style.whiteSpace = 'pre-line';
	newTitle.textContent = title;
	newTitle.id = 'title';
	newTitle.innerHTML = newTitle.textContent.replace(/\n/g, '<br>');

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

    newInfo.appendChild(newDiv);
}