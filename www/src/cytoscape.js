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
			if (edge.byname == 'FALSE') foundby = ' (ONB)';
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
	// cy.on('click', 'node', graphProperties.onClickNode);
}

function centerOnNode(nodeId) {
	const node = cy.getElementById(nodeId);
	if (node.length > 0) {
		cy.center(node); 
	}
}