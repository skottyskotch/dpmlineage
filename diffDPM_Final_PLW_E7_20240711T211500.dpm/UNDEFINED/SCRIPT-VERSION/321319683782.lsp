
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321319683782
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _san_pivotal;

// Dynamic relation from a MAJM/Mid Term Objective to its pivotals
function san_js_listPredecessors(oAct, vLeftActivities, depth){
	depth++;
	if (depth > 999) return vLeftActivities;
	if (oAct.plinks != undefined) {
		for (var oPlink in oAct.PLINKS where (oPlink.getInternalValue(\"TYPE\") == #FINISH-START# || oPlink.getInternalValue(\"TYPE\") == #START-START# || oPlink.getInternalValue(\"TYPE\") == #START-FINISH# || oPlink.getInternalValue(\"TYPE\") == #FINISH-FINISH#) && oPlink.PA.SAN_RDPM_UF_B_EQUA_FILTER==true && oPlink.left instanceof plc.task) {
		//for (var oPlink in oAct.PLINKS where oPlink.left instanceof plc.task) {
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
					if ((oLeftLeftLink.getInternalValue(\"TYPE\") == #FINISH-START# || oLeftLeftLink.getInternalValue(\"TYPE\") == #START-START# || oLeftLeftLink.getInternalValue(\"TYPE\") == #START-FINISH# || oLeftLeftLink.getInternalValue(\"TYPE\") == #FINISH-FINISH#) && oLeftLeftLink.left.synchronize_with instanceof plc.task) vSynchros.push(oLeftLeftLink.left.synchronize_with);
					// if (oLeftLeftLink.left.synchronize_with instanceof plc.task) vSynchros.push(oLeftLeftLink.left.synchronize_with);
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

namespace _san_pivotal_batch;
_san_pivotal.san_js_flagPivotalBatch();"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 321319034382
 :VERSION 2
 :_US_AA_D_CREATION_DATE 20240207000000
 :_US_AA_S_OWNER "E0434229"
)