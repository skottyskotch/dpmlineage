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

// Toolbar selectors - init
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
					object.textContent = item.id.replace(/^[^:]*:/,'').replace(/:$/,'');
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

    fetchData('database')
	.then(data => {
        data.databases.forEach(item => {
            const option = document.createElement('option');
            option.value = item;
            option.textContent = item;
            dbSelector.appendChild(option);
        })
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
});