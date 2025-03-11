
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 321318674282
 :NAME "SAN_RDPM_JS2_PIVOTAL_ACTIVITIES"
 :COMMENT "Script for Pivotal activities identification"
 :ACTIVE T
 :DATASET 118081000141
 :EVAL-ON-LOAD T
 :LOAD-ORDER 0
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_RDPM_JS2_PIVOTAL_ACTIVITIES
//
//  AUTHOR  : Emilie GARCES
//
//  Creation : 2024/01/23 EG
//  Script contaitning the functions to identify pivotal activities (PC-7042)
//
//***************************************************************************/

namespace _san_pivotal;

// Dynamic relation from a MAJM/Mid Term Objective to its pivotals
function san_js_listPredecessors(oAct, vLeftActivities, depth){
	depth++;
	if (depth > 999) return vLeftActivities;
	if (oAct.plinks != undefined) {
		for (var oPlink in oAct.PLINKS where oPlink.PA.SAN_RDPM_UF_B_PIVOTAL_SCRIPT_FILTER==true && oPlink.left instanceof plc.task) {
			if (oPlink.left in vLeftActivities) 
			//{
			//    plw.alert (oPlink.left);
			    return vLeftActivities;
			//}
			vLeftActivities.push(oPlink.left);
			san_js_listPredecessors(oPlink.left, vLeftActivities, depth);
		}
	}
	return vLeftActivities;
}


function san_js_listSynchros(oAct, vSynchros, vLeft, depth){
	depth++;
	if (depth > 999) return vSynchros;
	if (oAct.plinks != undefined) {
		for (var oPlink in oAct.PLINKS where oPlink.left instanceof plc.task){
			if (oPlink.left in vLeft) return vSynchros;
			vLeft.push(oPlink.left);
			if (oPlink.left.synchronize_with instanceof plc.task) vSynchros.push(oPlink.left.synchronize_with);
			san_js_listSynchros(oPlink.left,vSynchros,vLeft,depth);			
		}
	}
	return vSynchros;
}

function san_js_majmPivotalActivitiesMapMethod(f){
    var oAct = this;
    var vPivotalActivities = [];
    if (oAct.SAN_RDPM_UA_KMS_ACT.matchregexp(\"MAJM|Mid Term Objective\") || oAct.WBS_TYPE.printattribute() in ['First Approval']) {
        var vSynchros = [];
        var vLeft = [];
        if (oAct.synchronize_with instanceof plc.task) vSynchros.push(oAct.synchronize_with);
        for (var oLeftLink in oAct.plinks where oLeftLink.getInternalValue(\"TYPE\") == #FINISH-START#){
            if (oLeftLink.left.synchronize_with instanceof plc.task) vSynchros.push(oLeftLink.left.synchronize_with);
            if (oLeftLink.left.plinks != undefined){
                vLeft.push(oLeftLink.left);
                san_js_listPredecessors(oLeftLink.left, vLeft, 0);
            }
        }
        for (var oLeftLink in oAct.plinks where oLeftLink.getInternalValue(\"TYPE\") == #START-START# && oLeftLink.left.plinks != undefined) {
            for (var oLeftLeftLink in oLeftLink.left.plinks){
                if (oLeftLeftLink.left.synchronize_with instanceof plc.task) vSynchros.push(oLeftLeftLink.left.synchronize_with);
                if (oLeftLink.left.plinks != undefined){
                    vLeft.push(oLeftLeftLink.left);
                    san_js_listPredecessors(oLeftLeftLink.left, vLeft, 0);
                }
            }
        }
        for (var oAct in vLeft) {
            if (oAct.synchronize_with instanceof plc.task) vSynchros.push(oAct.synchronize_with);
        }
        vPivotalActivities = vSynchros;
        for (var oSyncAct in vSynchros){
            vPivotalActivities += san_js_listPredecessors(oSyncAct, [], 0);
        }
        vPivotalActivities = vPivotalActivities.removeduplicates();
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

// based on a new boolean attribute (here) SAN_RDPM_UA_B_PIVOTAL_ACT
// vPrj is the list of projects from dataset class Pasteur and above
// function used by batch
function san_js_flagPivotalBatch(){
	var oProjectTypeParent = plc.project_type.Get(\"Continuum.RDPM.Pasteur\");
	var vPrj = [];
	with(oProjectTypeParent.fromobject()){
		for (var oProjectType in plc.project_type) {
			if (oProjectType.projects != undefined) vPrj += oProjectType.projects.parsevector();
		}
	}
	var vPivotalAct = [];
	with (plw.monitoring(title: \"Identify pivotal activities\", steps: vPrj.length)){
		for (var oPrj in vPrj){
			with (oPrj.fromobject()){
				for (var oAct in plc.workstructure) {
					if (oAct.SAN_RDPM_UA_B_ACT_IS_PIVOTAL == true) with (plw.no_alerts, plw.no_locking) oAct.SAN_RDPM_UA_B_ACT_IS_PIVOTAL = false; // reset the boolean for all activity
					if (oAct.SAN_DR_ACT_PIVOTAL != undefined && oAct.SAN_DR_ACT_PIVOTAL.length > 0) {
						vPivotalAct += oAct.SAN_DR_ACT_PIVOTAL.parsevector(); 						// keep the activities to tag (post treatment)
					}
				}
			}
			\"identify pivotal activities\".monitor(vPrj.length,1,2);
		}
	}
	vPivotalAct = vPivotalAct.removeduplicates();
	// tag all identified activities
	with(plw.monitoring(title: \"Tag pivotal activities\", steps:vPivotalAct.length)){
		for (var oAct in vPivotalAct){
			with (plw.no_alerts, plw.no_locking) oAct.SAN_RDPM_UA_B_ACT_IS_PIVOTAL = true;
			\"Tag pivotal activities\".monitor(vPivotalAct.length,1,2);
		}
	}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 9
 :_US_AA_B_BATCH_SCRIPT "0"
 :_US_AA_D_CREATION_DATE 20240112000000
 :_US_AA_S_OWNER "E0434229"
)