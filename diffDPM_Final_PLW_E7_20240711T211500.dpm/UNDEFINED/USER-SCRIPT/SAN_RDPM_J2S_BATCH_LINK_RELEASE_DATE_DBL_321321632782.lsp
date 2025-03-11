
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 321321632782
 :NAME "SAN_RDPM_J2S_BATCH_LINK_RELEASE_DATE_DBL"
 :COMMENT "Script generated for batch which link Release date and V_S_DBL milestones"
 :ACTIVE T
 :DATASET 118081000141
 :LOAD-ORDER 0
 :SCRIPT-CODE "//
//  PLWSCRIPT : Script embeded in the batch SAN_RDPM_BA_RELEASE_DATE_DBL_LINK_CREATION
//
//  AUTHOR  : Emilie GARCES
//
//  Creation : 2024/05/14 EG
//  Script contaitning the functions to create links between Release date milestone and V_S_DBL (PC-7412)
// 
//***************************************************************************/


namespace _rdpm_recreate_links_release_date_dbl_batch;

function _rdpm_recreate_links_release_date_DBL (o_release_date, o_link_template)
{
	var P_Act_Type = o_link_template.SAN_RDPM_UA_S_PA_WBS_TYPE;
	var S_Act_Type = o_link_template.SAN_RDPM_UA_S_SA_WBS_TYPE;
	var link_type = o_link_template.SAN_RDPM_UA_S_LINK_TYPE;
	var lag = o_link_template.SAN_RDPM_UA_DU_LAG_TIME;
	var smooth = o_link_template.SAN_RDPM_UA_B_SMOOTH_LINK;
	var modification_type = o_link_template.SAN_RDPM_UA_S_MODIFICATION_TYPE;
	var v_PAct = new vector();
	var v_SAct = new vector();
	var v_list = new vector();

	with(o_release_date.fromObject()){
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
			if(o_act.WBS_TYPE.printattribute() in ['Release date']){o_act.set('EXTND','Extendible');}
		}
	}
	
	// Create links
	if (modification_type==\"Create / Update\"){
        for (var SAct in v_SAct where SAct.SAN_RDPM_UA_ACT_CGI_RN_F !=\"\"){
			var v_list = SAct.SAN_RDPM_UA_ACT_CGI_RN_F.split(\",\");
			for (var PAct in v_PAct where PAct.SAN_RDPM_UA_ACT_CGI_RN_F !=\"\" && PAct.SAN_RDPM_UA_ACT_CGI_RN_F in v_list){
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


function _rdpm_auto_link_release_date_DBL_batch(){
	
	var oProjectTypeParent = plc.project_type.Get(\"Continuum.RDPM.Pasteur\");
	var vPrj = [];
	with(oProjectTypeParent.fromobject()){
		for (var oProjectType in plc.project_type) {
			if (oProjectType.projects != undefined) vPrj += oProjectType.projects.parsevector();
		}
	}
	

	with (plw.monitoring(title: \"Identify Release date milestones for links creation\", steps: vPrj.length)){
		for (var oPrj in vPrj){
			with (oPrj.fromobject()){
				for (var o_release_date in plc.workstructure) {
					if 	(o_release_date instanceof plc.work_structure && o_release_date.SAN_RDPM_UA_B_IS_THERE_V_S_DBL_RELEASE_DATE==true){
							var b_contains_release_date_task = false;
							with(o_release_date.fromObject()){
							for (var o_act in plc.work_structure){
							if(o_act.WBS_TYPE.printattribute() in ['Release date','V_S_DBL']){b_contains_release_date_task = true;}
							}
							}
							if(o_release_date.SAN_RDPM_UA_ACT_B_PRJL==false && b_contains_release_date_task){
								for (var o_link_template in plc.__USER_TABLE_SAN_RDPM_UT_AUTO_LINKS){
								_rdpm_recreate_links_release_date_DBL(o_release_date, o_link_template);
								}
							plw.alert('Links successfully created');
							}
						else{
						plw.alert('Link between Release date and V_S_DBL cannot be performed');
						}
					}
				}
			}		
		}
	}	
}

_rdpm_recreate_links_release_date_dbl_batch._rdpm_auto_link_release_date_DBL_batch();"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 2
 :_US_AA_B_BATCH_SCRIPT "1"
 :_US_AA_D_CREATION_DATE 20240514000000
 :_US_AA_S_OWNER "E0434229"
)