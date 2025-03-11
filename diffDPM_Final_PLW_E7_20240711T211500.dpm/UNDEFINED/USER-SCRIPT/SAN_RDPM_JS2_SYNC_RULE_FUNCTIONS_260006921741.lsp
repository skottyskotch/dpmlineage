
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 260006921741
 :NAME "SAN_RDPM_JS2_SYNC_RULE_FUNCTIONS"
 :COMMENT "RDPM Synchronization rules functions"
 :ACTIVE T
 :DATASET 118081000141
 :EVAL-ON-LOAD T
 :LOAD-ORDER 0
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_SYNC_RULE_FUNCTIONS
// 
//  AUTHOR  : I. GUEROUI
//
//  Revision 0.4 2020/10/31 LFA
//  Rename functions to use more generic name
//  Replace plc.task by plc.workstructure in san_rdpm_js_sync_fnl_pf
//  Remove condition on SAN_RDPM_UA_ACT_B_OPL_DRIVING san_rdpm_js_sync_fnl_pf (Control done in SAN_RDPM_SR_FNL_PF)
//
//  Revision 0.3 2020/09/29 IGU
//  Modification du namespace
//
//  Revision 0.2 2020/05/12 IGU
//  Modification de san_rdpm_js_sync_tech_rule => La synchro rule s'applique quel que soit le driving mode
//
//  Revision 0.1 2020/04/30 IGU
//  Création du script regroupant toutes les fonctions utilisées dans les synchronization rules
//
//***************************************************************************/

namespace _san_rdpm_sync_func;

/**
	Function used in SAN_RDPM_SR_FNL_PF
*/
function san_rdpm_js_sync_fnl_pf(s_act){
	var o_act = (s_act instanceof plc.workstructure)? s_act : plc.work_structure.get(s_act);
	
	if (o_act instanceof plc.workstructure){
		var o_synchroAct = o_act.get('SYNCHRONIZE_WITH');
		
		if (o_synchroAct instanceof plc.workstructure){o_act.set('FNL',o_synchroAct.get('EXPECTED_FINISH'));}
		else {plw.writetolog('[ERROR] [san_rdpm_js_sync_fnl_pf] - the source (synchronized with) activity :'+o_synchroAct+' is not an activity');}
	} 
	else {plw.writetolog('[ERROR] [san_rdpm_js_sync_fnl_pf] - bad argument :'+o_act+' is not an activity');}
}

/**
	Function used in SAN_RDPM_SR_PF
*/
function san_rdpm_js_sync_pf(s_act){
	var o_act = (s_act instanceof plc.work_structure)? s_act : plc.work_structure.get(s_act);
	
	if (o_act instanceof plc.work_structure){
		var o_synchroAct = o_act.get('SYNCHRONIZE_WITH');
		
		if (o_synchroAct instanceof plc.work_structure){o_act.set('PF',o_synchroAct.get('PF'));}
		else {plw.writetolog('[ERROR] [san_rdpm_js_sync_pf] - the source (synchronized with) activity :'+o_synchroAct+' is not an activity');}
	} 
	else {plw.writetolog('[ERROR] [san_rdpm_js_sync_pf] - bad argument :'+o_act+' is not an activity');}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 2
 :_US_AA_B_BATCH_SCRIPT "0"
 :_US_AA_D_CREATION_DATE 20200929000000
 :_US_AA_S_OWNER "intranet"
)