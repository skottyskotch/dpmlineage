
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 260007785073
 :NAME "SAN_RDPM_JS2_WORKSPACE"
 :COMMENT "Functions used for workspace functionalities"
 :ACTIVE T
 :DATASET 118081000141
 :EVAL-ON-LOAD T
 :LOAD-ORDER 0
 :SCRIPT-CODE "//
// 
//  PLWSCRIPT : SAN_RDPM_JS2_WORKSPACE
// 
//  AUTHOR  : S. AKAAYOUS
//
//
//  Creation : 2020/07/08 SAK
//  Script used for PC 408 : Project activities accessible via the \"By workspace\" style 
//
//  Modif : 2020/09/30 IGU
//  Transformation of the script to V2 to be used as a user script
//
//  Modif : 2022/02/24 IGU
//  Syntax fixes & cleaning of useless comments
//
//***************************************************************************/

namespace _san_rdpm_pm;


function sun_rdpm_func_get_activity_from_selected_obs(vObs){
	var vActVect = new vector();
	var Alloc_Act;
	var result;
	var s_title = '% of progress ';
	var n_sum = 0;
	
	for (var vObj in vObs.get(\"OBS_CHILDREN\")) {n_sum++;}
	
	
	with(plw.monitoring (title: s_title, steps: n_sum)){
		// Inverse relations --> Returns Activity, Resources and OBS linked to the OBS
		for (var vObj in vObs.get('OBS_CHILDREN')){
			if (vObj instanceof plc.work_structure){
				// Check if the project of the Activity is in the list of project
				if (vObj.PROJECT.CallBooleanFormula('OPEN AND LIST_FIND(STATE,\\\"Active\\\") AND IF OPX2_CONTEXT._FF_AA_S_LIST_NAME <> \\\"\\\" then evaluate_filter(OPX2_CONTEXT._FF_DA_S_PORTFOLIO_CONTEXT_FILTER) ELSE true FI')){
					// Add the activity to vector
					vActVect.push(vObj);	
				}
			}		
			else if (vObj instanceof plc.resource){
				// Get allocations of the resource
				for (var vALLOC in vObj.get('ALLOCATIONS')){
					// Get the activity of the allocation
					Alloc_Act=vALLOC.ACTIVITY;
					
					// Check if the project of the Activity is in the list of project
					if (Alloc_Act.PROJECT.CallBooleanFormula('OPEN AND STATE IN (\\\"Active\\\") AND IF OPX2_CONTEXT._FF_AA_S_LIST_NAME <> \\\"\\\" then evaluate_filter(OPX2_CONTEXT._FF_DA_S_PORTFOLIO_CONTEXT_FILTER) ELSE true FI')){
						// Add the activity to vector
							vActVect.push(Alloc_Act);
					}
				}
			}			
			s_title.monitor(n_sum);
		}
	}
	
	result = vActVect.removeduplicates();
	return result;
}

// Function to init and open the virtual dataset
function san_rdpm_func_goto_virtualdataset_on_selected_activities_workspace(vActVect){
	if(vActVect!= undefined && vActVect instanceOf vector){
		if(vActVect.length>0){
			var vDataSet = new plc.virtual_dataset();
			vDataSet.selected_activities = vActVect;
			// We set a comment on tha dataset to identify Workspace (allow to display specific features on \"Workspaces\")
			vDataSet.comment = 'WorkSpace';

			if(vDataSet instanceOf plc.virtual_dataset){
				plw._inf_open_project(THIS : vDataSet);
			}
		} else {
			plw.alert('No data to display, please change your selection criteria');
		}
	}
}

// san_rdpm_fun_goto_virtualdataset_on_selected_obs : fonction called in the link L1
function san_rdpm_fun_goto_virtualdataset_on_selected_obs(vOBS){
	context.SAN_RDPM_CT_NTP_WORK_OBS = '';
	var v_virtualdataset_objects = sun_rdpm_func_get_activity_from_selected_obs(vOBS);
	
	san_rdpm_func_goto_virtualdataset_on_selected_activities_workspace(v_virtualdataset_objects);
	context.SAN_RDPM_CT_NTP_WORK_OBS = vOBS.printattribute();
	
}

function san_rdpm_func_goto_virtualdataset_on_multiple_obs(){
	//reset of obs to display
	context.SAN_RDPM_CT_NTP_WORK_OBS = '';
	// E7 compliancy, replace _InfGetSelectedObjectOnClass by selection_filterWithClass
	var SelectedElements = plw.selection_filterWithClass('opxRESPONSIBILITY');
	if(SelectedElements != undefined && SelectedElements instanceOf vector){
		//list of OBS concerned
		var v_obsid = '';
		//List of object to include in the virtualdataset
		var v_virtualdataset_objects = new vector();

		for (var o_obs_element in SelectedElements){
			//adding activities to the vector of element for the virtualdataset
			v_virtualdataset_objects = v_virtualdataset_objects+sun_rdpm_func_get_activity_from_selected_obs(o_obs_element);
			
			v_obsid = (v_obsid!='') ? v_obsid+',' : '';	
			v_obsid = v_obsid+o_obs_element.printattribute();
		}
		
		san_rdpm_func_goto_virtualdataset_on_selected_activities_workspace(v_virtualdataset_objects);
		context.SAN_RDPM_CT_NTP_WORK_OBS=v_obsid;
	}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 2
 :_US_AA_B_BATCH_SCRIPT "0"
 :_US_AA_D_CREATION_DATE 20200930000000
 :_US_AA_S_OWNER "intranet"
)