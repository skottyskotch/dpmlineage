let databaseSelected = null;
let tableSelected = null;
let objectSelected = null;
let cy;

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

// Toolbar functions
function initSelectorButtons(eltId = null) {
	if (eltId == null) $('.selectorButton').removeClass('active').prop('disabled', true);
	else $(eltId).removeClass('active').prop('disabled', true);
}

function emptySelector(eltId){
	const elt = document.getElementById(eltId);
	while (elt.firstChild) {
		elt.removeChild(elt.firstChild);
	}
}

function activeCenterButton(eltId){
	if (cy) {
		if (cy.getElementById(objectSelected).length > 0) $('#centerObject').addClass('active').prop('disabled', false);
		else $('#centerObject').removeClass('active').prop('disabled', true);
		if (cy.getElementById(tableSelected).length > 0) $('#centerTable').addClass('active').prop('disabled', false);
		else $('#centerTable').removeClass('active').prop('disabled', true);
	}
}

function linkHighlighterSelectorUpdate() {
	const value = $(this).val();
	highlightModeMessage.classList.remove('state-0', 'state-1', 'state-2');
	highlightModeMessage.classList.add(`state-${value}`);
	const labels = ['Incomers', 'In/Out', 'Outgoers'];
	highlightModeMessage.textContent = labels[value];
	colorNodesOnClick();
}

// Right panel functions
function resizePanel(e) {
	const newWidth = window.innerWidth - e.clientX;
	if (newWidth > 150 && newWidth < 600) {
		rightPanel.style.width = newWidth + 'px';
	}
}

function stopResize() {
	document.removeEventListener('mousemove', resizePanel);
	document.removeEventListener('mouseup', stopResize);
}

function isolateNode() {
	if (clickedNode){
		let connectedElts = clickedNode.neighborhood();
		let visibleElts = connectedElts.add(clickedNode);
		cy.elements().not(visibleElts).hide();
		visibleElts.show();
	}
}

function showThenLayout(elt, layoutOptions) {
	let connectedElts = clickedNode.neighborhood();
	let visibleElts = connectedElts.add(clickedNode);
	visibleElts.show();
	visibleElts.layout(layoutOptions).run({name: 'circle', animate: true});
	console.log('show');
}

function discoverNode() {
	if (clickedNode){
		fetchData('graph-data/node', 'db', dbSelector.value, 'id', clickedNode.id())
		.then(data => graphData(data))
		.then(data => addGraph(data))
		.then(() => showThenLayout(clickedNode, {name: 'circle', animate: true}))
		.then(() => colorNodesOnClick);
	}
}

$(document).ready(function() {
	// init selectors
    $('#dbSelector').select2({
      placeholder: 'Select a database',
      allowClear: true
    })
	
    $('#tableSelector').select2({
      placeholder: 'Select a table',
      allowClear: true
    })
	
    $('#objectSelector').select2({
      placeholder: 'Select an object',
      allowClear: true
    });
	
	$('#dbSelector').on('change', function() {
		databaseSelected = $(this).val();
		emptySelector('tableSelector');
		tableSelected = null;
		emptySelector('objectSelector');
		objectSelected = null;
		if (databaseSelected == null) {
			initSelectorButtons();
		}
		else{
			fetchData('graph-data/tabledef', 'db', databaseSelected)
			.then(data => {
				data.nodes.forEach(item => {
					const tableDef = document.createElement('option');
					tableDef.value = item.ID;
					tableDef.textContent = item.ID.replace(/^[^:]*:/,'').replace(/:$/,'');
					document.getElementById('tableSelector').appendChild(tableDef);
				});
				$('#tableSelector').val(null);
			});
			$('#runDB').addClass('active').prop('disabled', false);
		}
	});

	$('#tableSelector').on('change', function() {
		tableSelected = $(this).val();
		emptySelector('objectSelector');
		objectSelected = null;
		if (tableSelected == null) {
			initSelectorButtons('#runTable');
			initSelectorButtons('#centerTable');
		}
		else{
			fetchData('graph-data/node', 'db', databaseSelected, 'table', tableSelected)
			.then(data => {
				data.nodes.forEach(item => {
					const object = document.createElement('option');
					object.value = item.id;
					object.textContent = item.id.replace(/^[^:]*:/,'').replace(/:$/,'') + " - " + item.name;
					document.getElementById('objectSelector').appendChild(object);
				});
				$('#objectSelector').val(null);
			});
			$('#runTable').addClass('active').prop('disabled', false);
			activeCenterButton(tableSelected);
		}
	});

	$('#objectSelector').on('change', function() {
		objectSelected = $(this).val();
		if (objectSelected == null) {
			initSelectorButtons('#runObject');
			initSelectorButtons('#centerObject');
		}
		else{
			$('#runObject').addClass('active').prop('disabled', false);
			activeCenterButton(objectSelected);
		}
	});

	$('#runDB').click(function() {
		if (cy) cy.elements().remove();
		if (databaseSelected != "") {
			fetchData('graph-data/tabledef', 'db', databaseSelected)
			.then(data => graphData(data))
			.then(data => buildGraph(data));
		}
	});
	
	$('#runTable').click(function() {
		if (cy) cy.elements().remove();
		if (databaseSelected != "" && tableSelected != "") {
			fetchData('graph-data/node', 'db', databaseSelected, 'table', tableSelected)
			.then(data => graphData(data))
			.then(data => buildGraph(data));
		}
		$('#centerTable').addClass('active').prop('disabled', false);
	});
	
	$('#centerTable').click(function() {
		if (cy) {
			centerOnNode(tableSelected);
		}
	});
	
	$('#runObject').click(function() {
		if (cy) cy.elements().remove();
		if (databaseSelected != "" && objectSelected != "") {
			fetchData('graph-data/node', 'db', databaseSelected, 'id', objectSelected)
			.then(data => graphData(data))
			.then(data => buildGraph(data));
		}
		$('#centerObject').addClass('active').prop('disabled', false);
	});
	
	$('#centerObject').click(function() {
		if (cy) {
			centerOnNode(objectSelected);
		}
	});
	
	$('#slider').on('input', linkHighlighterSelectorUpdate);

	// init right panel
	$('#toggleBtn').click(function() {
		rightPanel.classList.toggle('collapsed');
		if (rightPanel.classList.contains('collapsed')) toggleBtn.innerHTML = '⮜';
		else toggleBtn.innerHTML = '⮞';
	});
	
	$('#resizer').on('mousedown', function(e) {
		e.preventDefault();
		document.addEventListener('mousemove', resizePanel);
		document.addEventListener('mouseup', stopResize);
	});

	$('#Isolate').click(isolateNode);
	
	$('#Discover').click(discoverNode);

	// init the available databases
	fetchData('database')
	.then(data => {
        data.databases.forEach(item => {
            const option = document.createElement('option');
            option.value = item;
            option.textContent = item;
            dbSelector.appendChild(option);
        })
    });
});