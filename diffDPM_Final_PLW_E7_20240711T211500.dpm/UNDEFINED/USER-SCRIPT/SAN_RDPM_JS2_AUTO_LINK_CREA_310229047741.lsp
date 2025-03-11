
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 310229047741
 :NAME "SAN_RDPM_JS2_AUTO_LINK_CREA"
 :COMMENT "Script contaitning the functions to create links between cohorts and countries"
 :ACTIVE T
 :DATASET 118081000141
 :EVAL-ON-LOAD T
 :LOAD-ORDER 0
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_RDPM_JS2_AUTO_LINK_CREA
//
//  AUTHOR  : Islam GUEROUI
//
//  Modification : 2021/11/05 IGU
//  Use WBS Filter instead of activity selection and modification of the error popup message (PC-4304)
//
//  Creation : 2021/06/23 IGU
//  Script contaitning the functions to create links between cohorts and countries (PC-3918)
//
//***************************************************************************/

namespace _rdpm_recreate_links;

function _rdpm_recreate_links(o_study, o_link_template)
{
	var P_Act_Type = o_link_template.SAN_RDPM_UA_S_PA_WBS_TYPE;
	var S_Act_Type = o_link_template.SAN_RDPM_UA_S_SA_WBS_TYPE;
	var link_type = o_link_template.SAN_RDPM_UA_S_LINK_TYPE;
	var lag = o_link_template.SAN_RDPM_UA_DU_LAG_TIME;
	var smooth = o_link_template.SAN_RDPM_UA_B_SMOOTH_LINK;
	var modification_type = o_link_template.SAN_RDPM_UA_S_MODIFICATION_TYPE;
	var v_PAct = new vector();
	var v_SAct = new vector();
	
	with(o_study.fromObject()){
		for (var o_act in plc.work_structure){
			if (o_act.WBS_TYPE==P_Act_Type){
				// Remove existing links
				for (var o_link in o_act.get(\"SLINKS\") where o_link.getinternalvalue(#TYPE#).tostring()==link_type && o_link.SUCC_ACTIVITY.WBS_TYPE==S_Act_Type){
					o_link.delete();
				}
				for (var o_link in o_act.get(\"PLINKS\") where o_link.getinternalvalue(#TYPE#).tostring()==link_type && o_link.PA.WBS_TYPE==S_Act_Type){
					o_link.delete();
				}					
				v_PAct.push(o_act);					
			}
			else{
				if (o_act.WBS_TYPE==S_Act_Type){v_SAct.push(o_act);}
			}
			if(o_act.WBS_TYPE.printattribute() in ['Recruitment','Treatment','FUP/Extension']){o_act.set('EXTND','Hammock');}
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

function _rdpm_auto_link_cohort_country(){
	var v_selection = context.GEN_ACT_FILTER.split(',');
	var o_study = plc.work_structure.get(v_selection[0]);

	if (context.GEN_ACT_FILTER==''){
		plw.alert('A WBS filter needs to be selected first');
	}
	else if (v_selection.length==1 && o_study instanceof plc.work_structure && o_study.SAN_UA_RDPM_B_IS_A_STUDY==true){
		var b_contains_cohort = false;
		var b_contains_country = false;
		with(o_study.fromObject()){
			for (var o_act in plc.work_structure){
				if(o_act.WBS_TYPE.printattribute()=='COHORT'){b_contains_cohort = true;}
				if(o_act.WBS_TYPE.printattribute()=='STUDY'){b_contains_country = true;}
				if(b_contains_cohort && b_contains_country) {break;}
			}
		}
		if(o_study.SAN_RDPM_UA_ACT_B_PRJL==false && b_contains_cohort && b_contains_country){
			for (var o_link_template in plc.__USER_TABLE_SAN_RDPM_UT_AUTO_LINKS){
				_rdpm_recreate_links(o_study, o_link_template);
			}
			plw.alert('Links successfully created');
		}
		else{
			plw.alert('Link between countries and cohorts cannot be performed');
		}
	}
	else{
		plw.alert('The WBS filter have to be filled with one study only');
	}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 5
 :_US_AA_B_BATCH_SCRIPT "0"
 :_US_AA_D_CREATION_DATE 20210625000000
 :_US_AA_S_OWNER "intranet"
)