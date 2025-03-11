
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321319295482
 :DATASET 118081000141
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_RDPM_JS2_AUTO_LINK_CREA_GCI_TASKS
//
//  AUTHOR  : Emilie GARCES
//
//  Creation : 2024/01/23 EG
//  Script contaitning the functions to create links between GCI Assay Tasks and Sample sets at lab (PC-7042)
//
//***************************************************************************/

namespace _rdpm_recreate_links_release_date;

function _rdpm_recreate_links_release_date(o_gcirelease, o_link_template)
{
	var P_Act_Type = o_link_template.SAN_RDPM_UA_S_PA_WBS_TYPE;
	var S_Act_Type = o_link_template.SAN_RDPM_UA_S_SA_WBS_TYPE;
	var link_type = o_link_template.SAN_RDPM_UA_S_LINK_TYPE;
	var lag = o_link_template.SAN_RDPM_UA_DU_LAG_TIME;
	var smooth = o_link_template.SAN_RDPM_UA_B_SMOOTH_LINK;
	var modification_type = o_link_template.SAN_RDPM_UA_S_MODIFICATION_TYPE;
	var v_PAct = new vector();
	var v_SAct = new vector();
	
	with(o_gcirelease.fromObject()){
		for (var o_act in plc.work_structure){
			if (o_act.WBS_TYPE==P_Act_Type){
				// Remove existing links
				for (var o_link in o_act.get(\"PLINKS\") where o_link.getinternalvalue(#TYPE#).tostring()==link_type && o_link.PA.WBS_TYPE==S_Act_Type){
					o_link.delete();
				}					
				v_PAct.push(o_act);					
			}
			else{
				if (o_act.WBS_TYPE==S_Act_Type){v_SAct.push(o_act);}
			}
			if(o_act.WBS_TYPE.printattribute() in ['Release date']){o_act.set('EXTND','Hammock');}
		}
	}
	
	// Create links
	if (modification_type==\"Create / Update\"){
		for (var PAct in v_PAct){
			for (var SAct in v_SAct){
				var new_link = new plc.constraint(
				TYPE : link_type,
				PA : PAct,
				SUCC_ACTIVITY : SAct,
				CAL : \"5x7\",
				PLA : \"\",
				LAG :lag,
				_SYN_AA_B_SMOOTHLINK : smooth,
				FILE : PAct.FILE);
			}
		}
	}
}

function _rdpm_auto_link_gci_assay_release_date_tasks(){
	var v_selection = context.GEN_ACT_FILTER.split(',');
	var o_gcirelease = plc.work_structure.get(v_selection[0]);

	if (context.GEN_ACT_FILTER==''){
		plw.alert('A WBS filter needs to be selected first');
	}
	else if (v_selection.length==1 && o_gcirelease instanceof plc.work_structure && o_gcirelease.SAN_RDPM_UA_B_GCI_INF_AVAIL==true){
		var b_contains_gci_assay_task = false;
		with(o_gcirelease.fromObject()){
			for (var o_act in plc.work_structure){
				if(o_act.WBS_TYPE.printattribute() in ['V_ASSAY','V_ASSAY_EXT']){b_contains_gci_assay_task = true;}
			}
		}
		if(o_gcirelease.SAN_RDPM_UA_ACT_B_PRJL==false && b_contains_gci_assay_task){
			for (var o_link_template in plc.__USER_TABLE_SAN_RDPM_UT_AUTO_LINKS){
				_rdpm_recreate_links_release_date(o_gcirelease, o_link_template);
			}
			plw.alert('Links successfully created');
		}
		else{
			plw.alert('Link between GCI Assay Tasks and Release date cannot be performed');
		}
	}
	else{
		plw.alert('The WBS filter have to be filled with one V_S_GCI-LAB only');
	}
}
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 0
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20240131000000
 :_US_AA_S_OWNER "E0434229"
)