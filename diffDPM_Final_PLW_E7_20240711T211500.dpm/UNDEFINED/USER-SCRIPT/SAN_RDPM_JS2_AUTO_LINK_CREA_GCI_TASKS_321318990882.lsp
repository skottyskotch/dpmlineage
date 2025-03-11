
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 321318990882
 :NAME "SAN_RDPM_JS2_AUTO_LINK_CREA_GCI_TASKS"
 :COMMENT "Script containing the functions to create links between GCI Assay tasks and samples"
 :ACTIVE T
 :DATASET 118081000141
 :EVAL-ON-LOAD T
 :LOAD-ORDER 0
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_RDPM_JS2_AUTO_LINK_CREA_GCI_TASKS
//
//  AUTHOR  : Emilie GARCES
//
//  Creation : 2024/01/23 EG
//  Script contaitning the functions to create links between Sample sets at lab, GCI Assay Tasks and Release date milestone (PC-7175)
//
//***************************************************************************/

namespace _rdpm_recreate_links_gci;

function _rdpm_recreate_links_gci(o_gcilab, o_link_template)
{
	var P_Act_Type = o_link_template.SAN_RDPM_UA_S_PA_WBS_TYPE;
	var S_Act_Type = o_link_template.SAN_RDPM_UA_S_SA_WBS_TYPE;
	var link_type = o_link_template.SAN_RDPM_UA_S_LINK_TYPE;
	var lag = o_link_template.SAN_RDPM_UA_DU_LAG_TIME;
	var smooth = o_link_template.SAN_RDPM_UA_B_SMOOTH_LINK;
	var modification_type = o_link_template.SAN_RDPM_UA_S_MODIFICATION_TYPE;
	var v_PAct = new vector();
	var v_SAct = new vector();
	
	with(o_gcilab.fromObject()){
		for (var o_act in plc.work_structure){
			if (o_act.WBS_TYPE==P_Act_Type){
				// Remove existing links
				for (var o_link in o_act.get(\"SLINKS\") where o_link.SAN_RDPM_UA_LK_GCI_MANUAL_LINK==false && o_link.getinternalvalue(#TYPE#).tostring()==link_type && o_link.SUCC_ACTIVITY.WBS_TYPE==S_Act_Type){
					o_link.delete();
				}
				for (var o_link in o_act.get(\"PLINKS\") where o_link.SAN_RDPM_UA_LK_GCI_MANUAL_LINK==false && o_link.getinternalvalue(#TYPE#).tostring()==link_type && o_link.PA.WBS_TYPE==S_Act_Type){
					o_link.delete();
				}					
				v_PAct.push(o_act);					
			}
			else{
				if (o_act.WBS_TYPE==S_Act_Type){v_SAct.push(o_act);}
			}
			if(o_act.WBS_TYPE.printattribute() in ['V_ASSAY','V_ASSAY_EXT']){o_act.set('EXTND','Extendible');}
		}
	}
	
	// Create links
	if (modification_type==\"Create / Update\"){
		for (var PAct in v_PAct where PAct.SAN_RDPM_UA_ACT_CGI_RN_F !=\"\"){
			for (var SAct in v_SAct where SAct.SAN_RDPM_UA_ACT_CGI_RN_F !=\"\" && PAct.SAN_RDPM_UA_ACT_CGI_RN_F==SAct.SAN_RDPM_UA_ACT_CGI_RN_F){
				var new_link = new plc.constraint(
				TYPE : link_type,
				PA : PAct,
				SUCC_ACTIVITY : SAct,
				CAL : \"5x7\",
				PLA : \"\",
				_SYN_AA_B_SMOOTHLINK : smooth,
				FILE : PAct.FILE);
			}
		}
	}
}

function _rdpm_auto_link_gci_assay_gci_lab_tasks(){
	var v_selection = context.GEN_ACT_FILTER.split(',');
	var o_gcilab = plc.work_structure.get(v_selection[0]);

	if (context.GEN_ACT_FILTER==''){
		plw.alert('A WBS filter needs to be selected first');
	}
	else if (v_selection.length==1 && o_gcilab instanceof plc.work_structure && o_gcilab.SAN_RDPM_UA_B_IS_THERE_V_S_GCI_LAB==true){
		var b_contains_gci_assay_task = false;
		with(o_gcilab.fromObject()){
			for (var o_act in plc.work_structure){
				if(o_act.WBS_TYPE.printattribute() in ['V_S_SAMP-E','V_SAMP-S']){b_contains_gci_assay_task = true;}
			}
		}
		if(o_gcilab.SAN_RDPM_UA_ACT_B_PRJL==false && b_contains_gci_assay_task){
			for (var o_link_template in plc.__USER_TABLE_SAN_RDPM_UT_AUTO_LINKS){
				_rdpm_recreate_links_gci(o_gcilab, o_link_template);
			}
			plw.alert('Links successfully created');
		}
		else{
			plw.alert('Link between GCI Assay Tasks and samples cannot be performed');
		}
	}
	else{
		plw.alert('The WBS filter have to be filled with one study only');
	}
}



function _rdpm_auto_link_gci_assay_gci_lab_tasks_batch(){
	
	var oProjectTypeParent = plc.project_type.Get(\"Continuum.RDPM.Pasteur\");
	var vPrj = [];
	with(oProjectTypeParent.fromobject()){
		for (var oProjectType in plc.project_type) {
			if (oProjectType.projects != undefined) vPrj += oProjectType.projects.parsevector();
		}
	}
	

	with (plw.monitoring(title: \"Identify GCI tasks for links creation\", steps: vPrj.length)){
		for (var oPrj in vPrj){
			with (oPrj.fromobject()){
				for (var o_gcilab in plc.workstructure) {
					if 	(o_gcilab instanceof plc.work_structure && o_gcilab.SAN_RDPM_UA_B_IS_THERE_V_S_GCI_LAB==true){
							var b_contains_gci_assay_task = false;
							with(o_gcilab.fromObject()){
							for (var o_act in plc.work_structure){
							if(o_act.WBS_TYPE.printattribute() in ['V_S_SAMP-E','V_SAMP-S','V_ASSAY','V_ASSAY_EXT','Release date']){b_contains_gci_assay_task = true;}
							}
							}
							if(o_gcilab.SAN_RDPM_UA_ACT_B_PRJL==false && b_contains_gci_assay_task){
								for (var o_link_template in plc.__USER_TABLE_SAN_RDPM_UT_AUTO_LINKS){
								_rdpm_recreate_links_gci(o_gcilab, o_link_template);
								}
							plw.alert('Links successfully created');
							}
						else{
						plw.alert('Link between GCI Assay Tasks and samples cannot be performed');
						}
					}
				}
			}		
		}
	}	
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 10
 :_US_AA_B_BATCH_SCRIPT "0"
 :_US_AA_D_CREATION_DATE 20240123000000
 :_US_AA_S_OWNER "E0434229"
)