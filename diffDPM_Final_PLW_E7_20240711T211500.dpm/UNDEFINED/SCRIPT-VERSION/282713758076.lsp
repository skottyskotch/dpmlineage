
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 282713758076
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _san_lib;

function san_js2_insert_library() {
	plw.writeln(\"Start san_js2_insert_library..;\");
	plw.writeln(\"--- START OF LIBRARY INSERTION ---\");
	var v_selection = plw.selection_vector();
	var b_plSelected = false;
	var b_indication_selected=false;
	var b_no_selection_done=false;
	
	// PC-2329: Store the ID of the study to recreate links inside the study
	var o_actSelection = plw.get_library_selection_obj();
	
	context.SAN_UA_RDPM_ACT_S_BB_ID = o_actSelection.SAN_UA_RDPM_ACT_S_BUILD_BLOCK_ID;
	
   // PC-2666/PC-2802: indication insertion is forbidden via library insertion
	for (var act in v_selection) {
		if (act.SAN_RDPM_UA_B_IS_AN_INDICATION) {
			plw.alert(\"You cannot insert indication with library insertion. Please modify your selection.\");
			b_indication_selected=true;
		}
	}
	
	if (v_selection.length==0) {
		plw.alert(\"Please make a selection of activities to insert.\");
		b_no_selection_done=true;
	}
	
	if (b_indication_selected==false && b_no_selection_done==false) {
		//pc-2416 HRA old condition context.CallBooleanFormula(\"NOT USER_IN_GROUP($CURRENT_USER,\\\"P_ADM,R_PM\\\")\")
		if (context.SAN_RDPM_UA_UG_PL_ACCESS==false){
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
			context.InsertAndCopyLinkFromLibrary();
		}
		}
		else {
			context.InsertAndCopyLinkFromLibrary();
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
					plw.alert(\"The \\\"Synchronize with\\\" activity for \\\"\"+o_actSyncSource.NAME+\"\\\" was not found. Field emptied!\");
					o_actSyncSource.SYNCHRONIZE_WITH = \"\";
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
 :VERSION 4
 :_US_AA_D_CREATION_DATE 20210126000000
 :_US_AA_S_OWNER "E0455451"
)