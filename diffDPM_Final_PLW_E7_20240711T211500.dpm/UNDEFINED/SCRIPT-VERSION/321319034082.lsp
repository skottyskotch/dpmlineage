
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321319034082
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _san_pivotal;

// Dynamic relation from a MAJM/Mid Term Objective to its pivotals
function san_js_listPredecessors(oAct, vLeftActivities, depth){
	depth++;
	if (oAct.plinks != undefined) {
		for (var oPlink in oAct.PLINKS where oPlink.getInternalValue(\"TYPE\") == #FINISH-START# && oPlink.left instanceof plc.task) {
			vLeftActivities.push(oPlink.left);
			san_js_listPredecessors(oPlink.left, vLeftActivities, depth);
		}
	}
	return vLeftActivities;
}

function san_js_majmPivotalActivitiesMapMethod(f){
	var oAct = this;
	var vPivotalActivities = [];
	if (oAct.SAN_RDPM_UA_KMS_ACT.matchregexp(\"MAJM|Mid Term Objective\")) {
		var vSynchros = [];
		for (var oLeftLink in oAct.plinks){
			if (oLeftLink.getInternalValue(\"TYPE\") == #FINISH-START# && oLeftLink.left.synchronize_with instanceof plc.task) vSynchros.push(oLeftLink.left.synchronize_with);
			else if (oLeftLink.getInternalValue(\"TYPE\") == #START-START# && oLeftLink.left.plinks != undefined) {
				for (var oLeftLeftLink in oLeftLink.left.plinks){
					if (oLeftLeftLink.getInternalValue(\"TYPE\") == #FINISH-START# && oLeftLeftLink.left.synchronize_with instanceof plc.task) vSynchros.push(oLeftLeftLink.left.synchronize_with);
				}		
			}
		}
		vPivotalActivities += vSynchros;
		for (var oSyncAct in vSynchros){
			vPivotalActivities += san_js_listPredecessors(oSyncAct, [], 0);
		}
	}
	for (var oAct in vPivotalActivities){
		f.call(oAct);
	}
}

var oDynRel = undefined;
if (plc.work_structure.getslotbyID(\"SAN_DR_ACT_PIVOTAL\") == undefined) {
	oDynRel = new objectrelation(plc.work_structure,\"SAN_DR_ACT_PIVOTAL\");
	oDynRel.comment = \"Pivotal tasks\";
	oDynRel.mapmethod = san_js_majmPivotalActivitiesMapMethod;
	oDynRel.connectedtoclass = plc.work_structure;
}

// Dynamic attributes
// list of pivotal on a MAJM/Mid Term Objective
method san_js_isPivotalListReader on plc.work_structure(){
	var oAct = this;
	var sResult = \"\";
	if (oAct.SAN_DR_ACT_PIVOTAL != undefined) {
		var vNames = oAct.SAN_DR_ACT_PIVOTAL.mapc(function() {return this.name;});
		sResult = vNames.join(\",\");
	}
	return sResult;
}

var oSlot = undefined;
if (plc.work_structure.getslotbyID(\"SAN_DA_S_ACT_PIVOTAL_LIST\") == undefined){
	oSlot = new Objectattribute(plc.work_structure,\"SAN_DA_S_ACT_PIVOTAL_LIST\",\"string\");
	oSlot.reader = function () {return this.san_js_isPivotalListReader();};
	oSlot.hiddeninintranetserver = false;
	oSlot.Comment = \"Pivotals\";
}

// boolean Is a pivotal? - true if the activity is somwhere mentionned in the pivotal activity list of a MAJM act in the same project
// May cause performance issue.
cached function san_js_pivotalList(oPrj){
	var vPivotal = [];
	with (oPrj.fromobject()){
		for (var oTask in plc.workstructure where oTask.SAN_RDPM_UA_KMS_ACT.matchregexp(\"MAJM|Mid Term Objective\")){
			if (oTask.SAN_DR_ACT_PIVOTAL != undefined && oTask.SAN_DR_ACT_PIVOTAL.length > 0) for (var each in oTask.SAN_DR_ACT_PIVOTAL) vPivotal.push(each);
		}
	}
	return vPivotal.removeduplicates();
}

method san_js_isPivotalReader on plc.work_structure(){
	var oAct = this;
	if (san_js_pivotalList(oAct.project).position(oAct) != undefined) return true;
	else return false;
}

var oSlot = undefined;
if (plc.work_structure.getslotbyID(\"SAN_DA_B_ACT_IS_PIVOTAL\") == undefined){
	oSlot = new Objectattribute(plc.work_structure,\"SAN_DA_B_ACT_IS_PIVOTAL\",\"BOOLEAN\");
	oSlot.reader = function () {return this.san_js_isPivotalReader();};
	oSlot.hiddeninintranetserver = false;
	oSlot.Comment = \"Is pivotal?\";
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 321318674282
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20240124000000
 :_US_AA_S_OWNER "E0434229"
)