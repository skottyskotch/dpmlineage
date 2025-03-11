
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321183416441
 :DATASET 118081000141
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
//***************************************************************************/

namespace _san_rdpm_pm;

/*
_LinksActivateLink(\"143484646372\"); var vOBS=this.object; san_rdpm_fun_goto_virtualdataset_on_selected_obs(vOBS);
*/

function sun_rdpm_func_get_activity_from_selected_obs(vObs) // sp_get_activity_set_from_selected_portfolio_and_obs
{
	var vActVect = new vector();
	var Alloc_Act;
	var result;
//	var L1_Act;
//	var L1_Act_Vect = New vector();
	var s_title = '% of progress ';
	var n_sum = 0;
	
	for (var vObj in vObs.get(\"OBS_CHILDREN\")) {n_sum++;}
	
	
	with(plw.monitoring (title: s_title, steps: n_sum))
	{
		// Inverse relations --> Returns Activity, Resources and OBS linked to the OBS
		for (var vObj in vObs.get('OBS_CHILDREN'))
		{
			if (vObj instanceof plc.work_structure)
			{
				// Check if the project of the Activity is in the list of project
				//if (vObj.PROJECT.SP_NF_B_WKSP_PROJ_FILTER)
				if (vObj.PROJECT.CallBooleanFormula('OPEN AND LIST_FIND(STATE,\\\"Active\\\") AND IF OPX2_CONTEXT._FF_AA_S_LIST_NAME <> \\\"\\\" then evaluate_filter(OPX2_CONTEXT._FF_DA_S_PORTFOLIO_CONTEXT_FILTER) ELSE true FI'))
				{
					// Add the activity to vector
					vActVect.push(vObj);	

					// Add level 1 activity
					/*var L1_Act = \"OpxActivity\".get(vObj.PROJECT.NAME);
					if (L1_Act instanceof OpxActivity)
					{
						L1_Act_Vect.push(L1_Act.ONB);
					}*/
				}
			}		
			else if (vObj instanceof plc.resource)
			{
				// Get allocations of the resource
				for (var vALLOC in vObj.get('ALLOCATIONS'))
				{
					// Get the activity of the allocation
					Alloc_Act=vALLOC.ACTIVITY;
					
					// Check if the project of the Activity is in the list of project
					//if (Alloc_Act.PROJECT.SP_NF_B_WKSP_PROJ_FILTER)
					if (Alloc_Act.PROJECT.CallBooleanFormula('OPEN AND STATE IN (\\\"Active\\\") AND IF OPX2_CONTEXT._FF_AA_S_LIST_NAME <> \\\"\\\" then evaluate_filter(OPX2_CONTEXT._FF_DA_S_PORTFOLIO_CONTEXT_FILTER) ELSE true FI'))
					{
						// Add the activity to vector
						//if (Alloc_Act.LEVEL>1)
						//{
							vActVect.push(Alloc_Act);
							// Add level 1 activity
							/*var L1_Act = \"OpxActivity\".get(Alloc_Act.PROJECT.NAME);
							if (L1_Act instanceof OpxActivity)
							{
								L1_Act_Vect.push(L1_Act.ONB);
							}*/							
						//}
						//else
						//{
							//L1_Act_Vect.push(Alloc_Act.ONB);
						//}
					}
				}
			}			
			s_title.monitor(n_sum);
		}
	}
	
	// Store level 1 activities in a context field
	//L1_Act_Vect=L1_Act_Vect.removeduplicates();
	//context.SP_AA_S_OC_WS_L1_ACT=L1_Act_Vect.join(\",\");
	
	result = vActVect.removeduplicates();
	//alert(\"List of act: \"+result);
	return result;
}

// Function to init and open the virtual dataset
function san_rdpm_func_goto_virtualdataset_on_selected_activities_workspace(vActVect)
{
	if(vActVect!= undefined && vActVect instanceOf vector)
	{
		if(vActVect.length>0)
		{
			var vDataSet = new plc.virtual_dataset();
			vDataSet.selectedActivities = vActVect;
			// We set a comment on tha dataset to identify Workspace (allow to display specific features on \"Workspaces\")
			vDataSet.comment = 'WorkSpace';

			if(vDataSet instanceOf plc.virtual_dataset)
			{
				var CurrentModuleId = plw.GetCurrentModule(\"\");
				var openingfunction = plc._gui_pt_modules.get(CurrentModuleId)._GUI_AA_S_OPEN_FUNCTION;
				'_GuiAddOrOpenClass'.call(vDataSet, Openingfunction, false);
				vDataSet._inf_open_project();
			}
		} else {
			plw.alert('No data to display, please change your selection criteria');
		}
	}
}

// san_rdpm_fun_goto_virtualdataset_on_selected_obs : fonction called in the link L1
function san_rdpm_fun_goto_virtualdataset_on_selected_obs(vOBS)
{
	//alert(\"vOBS: \"+vOBS);
	//var vOBS = this.object;
	
	//reset of obs to display for the lock hiding activities in workspaces.
	//context.SP_AA_S_CTX_OBS_LIST=\"\";
	context.SAN_RDPM_CT_NTP_WORK_OBS = '';
	
	//sp_apply_clinical_filter_on_obs_selection(vOBS);
	var v_virtualdataset_objects = sun_rdpm_func_get_activity_from_selected_obs(vOBS);
 	//listing all department concerned to add BVA summary data
	/*for (var o_res_dept in \"opxResource\" where o_res_dept.LEVEL==3 && o_res_dept.callBooleanFormula(\"BELONGS(\\\"RESPONSIBILITY\\\",\\\"\"+vOBS.printattribute()+\"\\\")\"))
	{
		//adding BVA summary data to the vector of element for the virtualdataset
		for (var o_BVA_SUM in o_res_dept.get(\"r.SP_RA_S_BVA_SUM_DEPT.SP_PT_BVA_SUMMARY\"))
		{
			if (o_BVA_SUM.FILE.STATE==\"Active\")
			{
				v_virtualdataset_objects.push(o_BVA_SUM);
			}
		}
	}*/
	
	san_rdpm_func_goto_virtualdataset_on_selected_activities_workspace(v_virtualdataset_objects);
	//setting the obs to display for the lock hiding activities.
	//context.SP_AA_S_CTX_OBS_LIST=vOBS.printattribute();
	context.SAN_RDPM_CT_NTP_WORK_OBS = vOBS.printattribute();//context.SP_AA_S_CTX_OBS_LIST
	
}

function san_rdpm_func_goto_virtualdataset_on_multiple_obs()
{
	//reset of obs to display
	//context.SP_AA_S_CTX_OBS_LIST=\"\";
	context.SAN_RDPM_CT_NTP_WORK_OBS = '';
	// E7 compliancy, replace _InfGetSelectedObjectOnClass by selection_filterWithClass
	var SelectedElements = plw.selection_filterWithClass('opxRESPONSIBILITY');
	if(SelectedElements != undefined && SelectedElements instanceOf vector)
	{
		//list of OBS concerned
		var v_obsid = '';
		//List of object to include in the virtualdataset
		var v_virtualdataset_objects = new vector();

		for (var o_obs_element in SelectedElements)
		{
			//listing all department concerned to add BVA summary data
			/*for (var o_res_dept in \"opxResource\" where o_res_dept.LEVEL==3 && o_res_dept.callBooleanFormula(\"BELONGS(\\\"RESPONSIBILITY\\\",\\\"\"+o_obs_element.printattribute()+\"\\\")\"))
			{
				//adding BVA summary data to the vector of element for the virtualdataset
				for (var o_BVA_SUM in o_res_dept.get(\"r.SP_RA_S_BVA_SUM_DEPT.SP_PT_BVA_SUMMARY\"))
				{
					if (o_BVA_SUM.FILE.STATE==\"Active\")
					{
						v_virtualdataset_objects.push(o_BVA_SUM);
					}
				}
			}*/
			//adding activities to the vector of element for the virtualdataset
			v_virtualdataset_objects = v_virtualdataset_objects+sun_rdpm_func_get_activity_from_selected_obs(o_obs_element);
			
			v_obsid = (v_obsid!='') ? v_obsid+',' : '';	
			v_obsid = v_obsid+o_obs_element.printattribute();
		}
		
		san_rdpm_func_goto_virtualdataset_on_selected_activities_workspace(v_virtualdataset_objects);
		// alert(v_virtualdataset_objects);
		//setting the obs to display for the lock hiding activities.
		//context.SP_AA_S_CTX_OBS_LIST=v_obsid;
		context.SAN_RDPM_CT_NTP_WORK_OBS=v_obsid;
	}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260007785073
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20220224000000
 :_US_AA_S_OWNER "E0448344"
)