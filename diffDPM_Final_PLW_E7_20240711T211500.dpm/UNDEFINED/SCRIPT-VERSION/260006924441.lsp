
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260006924441
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_SYNC_RULE_FUNCTIONS
// 
//  AUTHOR  : I. GUEROUI
//
//  Revision 0.2 2020/05/12 IGU
//  Modification de san_rdpm_js_sync_tech_rule => La synchro rule s'applique quel que soit le driving mode
//
//  Revision 0.1 2020/04/30 IGU
//  Création du script regroupant toutes les fonctions utilisées dans les synchronization rules
//
//***************************************************************************/

namespace san_rdpm_sync_func;

/**
	Function used in SAN_RDPM_SR_TECH_PHARMA
*/
function san_rdpm_js_sync_tech_rule(s_tsk){
	var o_tsk = (s_tsk instanceof plc.Task)? s_tsk : plc.Task.get(s_tsk);
	
	if (o_tsk instanceof plc.Task){
		if (o_tsk.get('SAN_RDPM_UA_ACT_B_OPL_DRIVING')){
			var o_synchroTsk = o_tsk.get('SYNCHRONIZE_WITH');
			
			if (o_synchroTsk instanceof plc.Task){o_tsk.set('FNL',o_synchroTsk.get('EXPECTED_FINISH'));}
			else {plw.writetolog('[ERROR] [san_rdpm_js_sync_tech_rule] - the source (synchronized with) activity :'+o_synchroTsk+' is not a task');}
		}
		else {o_tsk.set('FNL',-1);}
	} 
	else {plw.writetolog('[ERROR] [san_rdpm_js_sync_tech_rule] - bad argument :'+o_tsk+' is not a task');}
}

/**
	Function used in SAN_RDPM_SR_DEFAULT_PHARMA
*/
function san_rdpm_js_sync_default_rule(s_act){
	var o_act = (s_act instanceof plc.work_structure)? s_act : plc.work_structure.get(s_act);
	
	if (o_act instanceof plc.work_structure){
		var o_synchroAct = o_act.get('SYNCHRONIZE_WITH');
		
		if (o_synchroAct instanceof plc.work_structure){o_act.set('PF',o_synchroAct.get('PF'));}
		else {plw.writetolog('[ERROR] [san_rdpm_js_sync_default_rule] - the source (synchronized with) activity :'+o_synchroAct+' is not an activity');}
	} 
	else {plw.writetolog('[ERROR] [san_rdpm_js_sync_default_rule] - bad argument :'+o_act+' is not an activity');}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260006921741
 :VERSION 0
 :_US_AA_D_CREATION_DATE 20200929000000
 :_US_AA_S_OWNER "E0448344"
)