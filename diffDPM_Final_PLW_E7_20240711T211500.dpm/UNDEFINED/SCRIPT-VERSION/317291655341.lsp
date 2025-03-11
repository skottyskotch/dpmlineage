
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 317291655341
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _san_lib;
// Modification : 11/05/2021 : SAK - PC 3539
// retrieve standard code and define san function PC-2836
function san_js2_get_library_selection_obj() {
	if (context.selected_activity_list instanceOf Vector && context.selected_activity_list.length>0) {
		return context.selected_activity_list[0];
	}
	return false;
}

function san_js2_insert_library() {
	plw.writeln(\"Start san_js2_insert_library..;\");
	plw.writeln(\"--- START OF LIBRARY INSERTION ---\");
	var v_selection = plw.selection_vector();
	var b_plSelected = false;
	var b_indication_selected=false;
	var b_no_selection_done=false;
	
	// E7 compliance replace get_library_selection_obj by san_js2_get_library_selection_obj
	//var o_actSelection = plw.get_library_selection_obj();
	var o_actSelection = san_js2_get_library_selection_obj();
	// PC-2802: allow indication insertion for versions, do not allow inside a project/vserion which is already an indication
	var TargetPrjVersionNb=o_actSelection.PROJECT.VERSION_NUMBER;
	var TargetPrjIsIndication=o_actSelection.PROJECT.SAN_RDPM_UA_PRJ_RND_IND;
	
	context.SAN_UA_RDPM_ACT_S_BB_ID = o_actSelection.SAN_UA_RDPM_ACT_S_BUILD_BLOCK_ID;
	
	if (v_selection.length==0) {
		plw.alert(\"Please make a selection of activities to insert.\");
		b_no_selection_done=true;
	}
	// PC-2978 : Able to insert Indication in Project
	// Case of no selection in the lib, the v_selection is always on the target activity
	if (v_selection.length==1) {
		var act_select=v_selection[0];
		if (act_select InstanceOf plc.work_structure && act_select.PROJECT._INF_NF_B_IS_TEMPLATE==false) {
		plw.alert(\"Please make a selection of activities to insert.\");
		b_no_selection_done=true;
		}
	}
	
	// PC-2666/PC-2802: indication insertion is forbidden via library insertion
	// PC-2802: allow indication insertion for versions
	for (var act in v_selection) {
		if (act.SAN_RDPM_UA_B_IS_AN_INDICATION && (TargetPrjVersionNb==0 || TargetPrjIsIndication)) {
			if (TargetPrjVersionNb==0) plw.alert(\"You cannot insert indication with library insertion. Please modify your selection.\");
			if (TargetPrjIsIndication) plw.alert(\"You cannot insert indication into an indication version. Please modify your selection.\");
			b_indication_selected=true;
		}
	}
	
	if (b_indication_selected==false && b_no_selection_done==false) {
		//pc-2416 HRA old condition context.CallBooleanFormula(\"NOT USER_IN_GROUP($CURRENT_USER,\\\"P_ADM,R_PM\\\")\")
		if (context.SAN_RDPM_UA_UG_PL_ACCESS==false && o_actSelection.project._INF_NF_B_IS_TEMPLATE==false){
			if (v_selection.length == 0){
				for (var o_act in plc.work_structure where o_act.CallBooleanFormula(\"LIBRARY_FILTER AND _WT_NF_B_GENERIC_LIBRARY_FILTER\")) {
					if (o_act.get(\"SAN_RDPM_UA_ACT_B_PRJL\")) {
						b_plSelected = true;
						break;
					}
				}
			}
			else {
				for (var o_actSelected in v_selection where o_actSelected.CallBooleanFormula(\"LIBRARY_FILTER AND _WT_NF_B_GENERIC_LIBRARY_FILTER\") && b_plSelected == false) {
					with(o_actSelected.fromobject()){
						for (var o_act in plc.work_structure where o_act.get(\"SAN_RDPM_UA_ACT_B_PRJL\")) {
							b_plSelected = true;
							break;
						}
					}
				}
			}
		}
		
		
		var answer = undefined;
		
		if (b_plSelected) {
		answer = plw.question(\"There is PL activities in your selection. Do you want to proceed without inserting the PL activities?\");
		if (answer==true) {
			// E7 compliance replace insertandcopylinkfromlibrary by library_InsertSelectedActivitiesAndLinks
			context.library_InsertSelectedActivitiesAndLinks();
		}
		}
		else {
			// E7 compliance replace insertandcopylinkfromlibrary by library_InsertSelectedActivitiesAndLinks
			context.library_InsertSelectedActivitiesAndLinks();
		}
		
		plw.writeln(\"... Library inserted. Start managing synchonrizations...\");
		
		with(o_actSelection.fromobject()){
			for (var o_actSyncTarget in plc.work_structure where o_actSyncTarget._PM_AA_N_LIBRARY_ACT_ONB!=0){
				var o_actTemplate = plc.work_structure.get(o_actSyncTarget._PM_AA_N_LIBRARY_ACT_ONB);
				var v_actSyncSource=undefined;
				if (o_actTemplate!=undefined) {
					v_actSyncSource= (o_actTemplate.get(\"SYNCHRONIZED_ACTIVITIES\") instanceof String) ? o_actTemplate.get(\"SYNCHRONIZED_ACTIVITIES\").split(\",\") : o_actTemplate.get(\"SYNCHRONIZED_ACTIVITIES\");
				}
				
				for (var s_actSyncSource in v_actSyncSource){
					var o_actSyncSource = (s_actSyncSource instanceof String) ? plc.work_structure.get(s_actSyncSource) : s_actSyncSource;
					
					if(o_actSyncSource.PROJECT.SAN_RDPM_UA_PRJ_S_ROOT_PROJECT==o_actSyncTarget.PROJECT.SAN_RDPM_UA_PRJ_S_ROOT_PROJECT){
						o_actSyncSource.SYNCHRONIZE_WITH = o_actSyncTarget.printattribute();
						for (var o_syncRule in plc.synchronization_rule order by [['INVERSE','PRIORITY']]){
							if (o_actSyncSource.callbooleanformula(o_syncRule.FILTER)) {
								o_actSyncSource.LAST_SYNC_RULE=o_syncRule.printattribute();
								break;
							}
						}
					}
				}
			}
			
			for (var o_actSyncSource in plc.work_structure where o_actSyncSource.SYNCHRONIZE_WITH instanceof plc.work_structure){
				if (o_actSyncSource.SYNCHRONIZE_WITH.PROJECT.SAN_RDPM_UA_PRJ_S_ROOT_PROJECT!=o_actSyncSource.PROJECT.SAN_RDPM_UA_PRJ_S_ROOT_PROJECT && o_actSyncSource.SYNCHRONIZE_WITH.PROJECT._INF_NF_B_IS_TEMPLATE){
					// PC-2558 - LFA - Recreate external links inside the building block
					if (o_actSyncSource.WBS_TYPE.SAN_UA_RDPM_B_AUTO_SYNC_LINK_BB)
					{
						var act_target=\"\";
						var nb_act=0;
						var sync_act_type = o_actSyncSource.SYNCHRONIZE_WITH.WBS_TYPE;
						var building_block = plc.workstructure.get(o_actSyncSource.SAN_UA_RDPM_ACT_S_BUILD_BLOCK_ID);
						if (building_block instanceof plc.workstructure && sync_act_type instanceof plc.WBS_TYPE)
						{
							// Search of activities from Building Block and sync activity type
							var result=\"\";
							
							var list = [];
							list.push(sync_act_type);
							list.push(building_block);
							var filter = plw.objectset(list);
							
							with(filter.fromobject()){
								for (var vAct_bb in plc.workstructure where vAct_bb!=o_actSyncSource){
									act_target=vAct_bb;
									nb_act++;
								}
							}
						}	
						// We did not find or find more than one activity with the matching activity type
						if (nb_act>1 || nb_act==0)
						{
							plw.alert(\"The \\\"Synchronize with\\\" activity for \\\"\"+o_actSyncSource.NAME+\"\\\" was not found. Field emptied!\");
							o_actSyncSource.SYNCHRONIZE_WITH = \"\";
					    }
						else
						{
						    o_actSyncSource.SYNCHRONIZE_WITH=act_target;
							for (var o_syncRule in plc.SYNCHRONIZATION_RULE order by [[\"INVERSE\",\"PRIORITY\"]]){
								if (o_actSyncSource.callbooleanformula(o_syncRule.FILTER)) {o_actSyncSource.LAST_SYNC_RULE=o_syncRule.printattribute();break;}
							}
						}
					}
					else
					{					
						plw.alert(\"The \\\"Synchronize with\\\" activity for \\\"\"+o_actSyncSource.NAME+\"\\\" was not found. Field emptied!\");
						o_actSyncSource.SYNCHRONIZE_WITH = \"\";
					}
				}
			}
		}
		
		plw.writeln(\"... Synchonrizations managed!\");
		plw.writeln(\"\");
		plw.writeln(\"--- END OF LIBRARY INSERTION ---\");
		return true;
		//this.editor.delete();
	}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 282701597541
 :VERSION 15
 :_US_AA_D_CREATION_DATE 20211207000000
 :_US_AA_S_OWNER "E0046087"
)