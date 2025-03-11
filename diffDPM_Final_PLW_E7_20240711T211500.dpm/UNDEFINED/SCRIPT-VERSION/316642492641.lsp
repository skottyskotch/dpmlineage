
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 316642492641
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _wbs_form;

// ###############   WBS Form toolbox ####################
// PC-4292 - Fix san_pjs_rdpm_update_activity_leader - When leader was empty, values were emptied on all children activities - 20210727 - LFA
// PC-4306/PC-4165 (Problem with WBS Form Data in Version) - 20210730 - LFA
// PC-4051 - update of san_pjs_get_wbs_form_data_value and san_pjs_set_wbs_form_data_value to add  \"# Sample(s)\", \"# Lot(s)\" and \"# Test(s)\" fields in the hashtable  - AHI
// PC-2397 - update of san_rdpm_update_ph to extend sourcing and Provider Init to Vaccines projects

function san_pjs_get_wbs_form_value_on_object(act_id,role_id,field,type) {
   
    var result;
    if (type==\"STRING\") result=\"\";
    if (type==\"NUMBER\") result=1;
	if (type==\"BOOLEAN\") result=FALSE;
   
    var act_obj=plc.work_structure.get(act_id);
    var act_onb=undefined;
    if (!act_obj.internal) act_onb=act_obj.ONB.tostring();
   
    var role_obj=plc._RM_REVIEW_PT_ROLE.get(role_id);
    var role_onb=undefined;
    if (role_obj!=undefined && !role_obj.internal) {
        role_onb=role_obj.ONB;
    }
	
      if (act_onb!=undefined && role_onb!=undefined) result=san_pjs_get_upper_level_value(act_onb,role_onb,field);
   
    if (result InstanceOf plc._INF_PT_CBS2 || result InstanceOf plc.resource || result InstanceOf plc._RM_REVIEW_PT_LOCATIONS ||  result InstanceOf plc._INF_PT_CBS3) result=result.printattribute();
   
    if (result==undefined) {
        if (type==\"STRING\") result=\"\";
		if (field==\"USER_ATTRIBUTE_SAN_UA_S_SOURCING\") result=\"INT\";
		if (field==\"USER_ATTRIBUTE_SAN_UA_S_LEADER_SITE\") result=\"ND\";
        if (type==\"NUMBER\") result=1;
		if (type==\"BOOLEAN\") result=FALSE;
    }
   
    return result;
}

function san_pjs_get_upper_level_value(act_onb,role_onb,field) {
	var ThisLevelValue=undefined;
    //if (field==\"USER_ATTRIBUTE_SAN_UA_N_COMPLEXITY_FACTOR\") ThisLevelValue=1;
	//if (field==\"USER_ATTRIBUTE_SAN_UA_B_EXCLUDED_RES\") ThisLevelValue=FALSE;
	var onb_number=act_onb.parsenumber();
    var act_obj=plc.work_structure.get(onb_number);
	
	if (act_obj!=\"\" && act_obj!=undefined && act_obj!=false && act_obj.internal==false)
	{
		// Level activity
		if(act_obj.level==1)
		{
			ThisLevelValue=san_pjs_get_wbs_form_data_value(act_onb,role_onb,field);
		}
		else
		{
			var act_parent_obj=act_obj.WBS_ELEMENT;

			var act_parent_obj_onb=\"\";
			if (act_parent_obj!=\"\" && act_parent_obj!=undefined && act_parent_obj!=false && act_parent_obj.internal==false) {
				act_parent_obj_onb=act_parent_obj.ONB.tostring();
									   
				ThisLevelValue=san_pjs_get_wbs_form_data_value(act_onb,role_onb,field);
				//plw.alert(\"Value : \" +ThisLevelValue);
				//plw.alert(\"ThisLevelValue: \"+ThisLevelValue);
				if (ThisLevelValue!=undefined) {
					return ThisLevelValue;
				}
				else {
					//plw.alert(\"On va chercher sur le parent: \"+ThisLevelValue);
					if (act_parent_obj_onb!=undefined) {
						return san_pjs_get_upper_level_value(act_parent_obj_onb,role_onb,field);
					}
				}
			}
		}
	}

    //plw.alert(\"Cas où on n'a rien trouvé\");
    return ThisLevelValue;
}

function san_pjs_get_wbs_form_data_object(act_onb,role_onb) {
    var result=undefined;
	act_onb=act_onb.parsenumber();
    var act_obj=plc.work_structure.get(act_onb);
    var role_obj=plc._RM_REVIEW_PT_ROLE.get(role_onb);
    var count=0;
   
   // PC-4166 : check file of activity and wbs form data 
    for (var wbs_form_data in act_obj.get(\"USER_ATTRIBUTE_INVERSE_SAN_UA_WBS_FORM_DATA_ACTIVITY.__USER_TABLE_SAN_RDPM_UT_WBS_FORM_DATA\") where (wbs_form_data.file._PM_NF_B_IS_A_VERSION==false || wbs_form_data.file==act_obj.file)) {
        if (wbs_form_data.SAN_UA_WBS_FORM_DATA_ROLE==role_obj) {
            result=wbs_form_data;
            count++;
        }
    }
    if (count==1) return result;
}

function san_pjs_get_wbs_form_data_value(act_onb,role_onb,field) {
	
	var vHash = new hashtable(\"STRING\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_S_LEADER\",\"__USER_ATTRIBUTE_SAN_UA_B_LEADER_OVERWRITE\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_S_LEADER_SITE\",\"__USER_ATTRIBUTE_SAN_UA_B_LEADER_SITE_OVERWRITE\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_S_SOURCING\",\"__USER_ATTRIBUTE_SAN_UA_B_SOURCING_OVERWRITE\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_S_PROVIDER\",\"__USER_ATTRIBUTE_SAN_UA_B_PROVIDER_OVERWRITE\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_S_TEAM\",\"__USER_ATTRIBUTE_SAN_UA_B_TEAM_OVERWRITE\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_B_EXCLUDED_RES\",\"__USER_ATTRIBUTE_SAN_UA_B_EXCLUDED_RES_OVERWRITE\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_N_COMPLEXITY_FACTOR\",\"__USER_ATTRIBUTE_SAN_UA_B_COMPLEXITY_FACTOR_OVERWRITE\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_N_NUM_SAMPLE\",\"__USER_ATTRIBUTE_SAN_UA_B_NUM_SAMPLE_OVERWRITE\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_N_NUM_LOT\",\"__USER_ATTRIBUTE_SAN_UA_B_NUM_LOT_OVERWRITE\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_N_NUM_TEST\",\"__USER_ATTRIBUTE_SAN_UA_B_NUM_TEST_OVERWRITE\");


	var field_overwrite =vHash.get(field);
	
	
    var ThisValue=undefined;
	var Value_Overwrite=false;
	var leader_value;
	var leader_overwrite=false;
    var result=undefined;
    var wbs_form_data_obj=san_pjs_get_wbs_form_data_object(act_onb,role_onb);
    //plw.alert(\"in san_pjs_get_wbs_form_data_value ; wbs_form_data_obj = \"+wbs_form_data_obj);
    if (wbs_form_data_obj!=undefined && wbs_form_data_obj!=false) {
		
		// Case Site
		if (field==\"USER_ATTRIBUTE_SAN_UA_S_LEADER_SITE\")
		{
			leader_value=wbs_form_data_obj.get(\"USER_ATTRIBUTE_SAN_UA_S_LEADER\");
			leader_overwrite=wbs_form_data_obj.get(\"__USER_ATTRIBUTE_SAN_UA_B_LEADER_OVERWRITE\");
			if (leader_overwrite && leader_value instanceof plc.resource)
			{
				result=leader_value._RM_REVIEW_RA_LOCATION;
			}
			else
			{
				ThisValue=wbs_form_data_obj.get(field);
				Value_Overwrite=wbs_form_data_obj.get(field_overwrite);
				if (Value_Overwrite)
				{
					result=ThisValue;
				}
			}
		}
		else
		{
			ThisValue=wbs_form_data_obj.get(field);
			Value_Overwrite=wbs_form_data_obj.get(field_overwrite);
			if (Value_Overwrite)
			{
				result=ThisValue;
			}
		}
    }
    return result;
}

function san_pjs_get_parent_wbs_form_data_value(act_onb,role_onb,field) {
	var act_onb_number=act_onb.parsenumber();
	var act_parent=plc.work_structure.get(act_onb_number);
	var act_parent_onb=act_parent.ONB.tostring();
	var result=san_pjs_get_wbs_form_data_value(act_onb,role_onb,field);
	return result;	
}

function san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,fvalue) {

	var vHash = new hashtable(\"STRING\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_S_LEADER\",\"USER_ATTRIBUTE_SAN_UA_B_LEADER_OVERWRITE\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_S_LEADER_SITE\",\"USER_ATTRIBUTE_SAN_UA_B_LEADER_SITE_OVERWRITE\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_S_SOURCING\",\"USER_ATTRIBUTE_SAN_UA_B_SOURCING_OVERWRITE\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_S_PROVIDER\",\"USER_ATTRIBUTE_SAN_UA_B_PROVIDER_OVERWRITE\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_S_TEAM\",\"USER_ATTRIBUTE_SAN_UA_B_TEAM_OVERWRITE\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_B_EXCLUDED_RES\",\"USER_ATTRIBUTE_SAN_UA_B_EXCLUDED_RES_OVERWRITE\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_N_COMPLEXITY_FACTOR\",\"USER_ATTRIBUTE_SAN_UA_B_COMPLEXITY_FACTOR_OVERWRITE\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_N_NUM_SAMPLE\",\"USER_ATTRIBUTE_SAN_UA_B_NUM_SAMPLE_OVERWRITE\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_N_NUM_LOT\",\"USER_ATTRIBUTE_SAN_UA_B_NUM_LOT_OVERWRITE\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_N_NUM_TEST\",\"USER_ATTRIBUTE_SAN_UA_B_NUM_TEST_OVERWRITE\");
	
	var field_overwrite =vHash.get(field);
	
    var act_onb_string=act_onb;
    var act_onb_number=act_onb.parsenumber();
    var expected_id=act_onb_string+\"_\"+role_onb;
    var act_rel=plc.work_structure.get(act_onb_number);
	if (act_rel!=undefined && act_rel!=false && act_rel.internal==false)
	{
		var act_file=act_rel.get(\"FILE\");
		var role_rel=plc._RM_REVIEW_PT_ROLE.get(role_onb);
	   
		//var wbs_form_data_obj=plc.__USER_TABLE_SAN_RDPM_UT_WBS_FORM_DATA.get(expected_id);
		var wbs_form_data_obj=san_pjs_get_wbs_form_data_object(act_onb,role_onb);
		//plw.alert(\"in san_pjs_set_wbs_form_data_value ; wbs_form_data_obj = \"+wbs_form_data_obj);
				
		if (act_rel.level==1)
		{
			if (fvalue!=undefined) {
				if (wbs_form_data_obj==undefined || wbs_form_data_obj==false) {
					wbs_form_data_obj=new plc.__USER_TABLE_SAN_RDPM_UT_WBS_FORM_DATA
									(NAME: expected_id,
									FILE: act_file,
									SAN_UA_WBS_FORM_DATA_ACTIVITY: act_rel,
									SAN_UA_WBS_FORM_DATA_ROLE: role_rel);
				}
				wbs_form_data_obj.set(field,fvalue);
				wbs_form_data_obj.set(field_overwrite,true);
			}	
		}
		else
		{
			// Check the value at parent level
			var act_parent=act_rel.WBS_ELEMENT;
			if(act_parent!=undefined && act_parent!=false && act_parent.internal==false)
			{
				var act_parent_onb=act_parent.ONB.tostring();
				var parent_value = san_pjs_get_upper_level_value(act_parent_onb,role_onb,field);

				if (fvalue==parent_value)
				{
					if (wbs_form_data_obj!=undefined && wbs_form_data_obj!=false) {
						wbs_form_data_obj.set(field,fvalue);
						wbs_form_data_obj.set(field_overwrite,false);
					}
				}
				else
				{	
					if (fvalue!=undefined) {
						if (wbs_form_data_obj==undefined || wbs_form_data_obj==false) {
							wbs_form_data_obj=new plc.__USER_TABLE_SAN_RDPM_UT_WBS_FORM_DATA
											(NAME: expected_id,
											FILE: act_file,
											SAN_UA_WBS_FORM_DATA_ACTIVITY: act_rel,
											SAN_UA_WBS_FORM_DATA_ROLE: role_rel);
						}
						wbs_form_data_obj.set(field,fvalue);
						wbs_form_data_obj.set(field_overwrite,true);
					}	
				}
			   
				// cleaning       
				if (wbs_form_data_obj.SAN_UA_B_WBS_FORM_OVERWRITE==false) {
					plw.writetolog(\"Deleting empty entry WBS Form data \"+wbs_form_data_obj);
					wbs_form_data_obj.delete();	   
				}
			}
		}
	}
}

// Function to update leader on activity
function san_pjs_rdpm_update_activity_leader(act_onb,role_onb,field,nvalue)
{
	var act_onb_number = act_onb.parsenumber();
	var act_obj=plc.work_structure.get(act_onb_number);	
	var key=\"\";
	var act_type_onb=\"\";
	var obs_onb=\"\";
	var wbs_form_map_obj=\"\";
	
	with(act_obj.fromObject())
	{
		for (var vAct in plc.work_structure where vAct.AF==undefined)
		{
			act_type_onb = vAct.WBS_TYPE.ONB.tostring();
			obs_onb = vAct.OBS_ELEMENT.ONB.tostring();
			key = role_onb + \"_\" + act_type_onb + \"_\" + obs_onb;
			wbs_form_map_obj=plc.__USER_TABLE_SAN_RDPM_UR_WBS_FORM_MAP_LEADER.get(key);
			
			if (wbs_form_map_obj!=undefined && wbs_form_map_obj!=false){
					
				if (san_pjs_leader_defined_by_act(act_obj,vAct,Role_ONB,\"SAN_UA_B_LEADER_OVERWRITE\"))
				{
					if (nvalue==\"\")
					{
						vAct.SAN_RDPM_UA_S_PHARMA_LEADER=\"\";
						vAct._RM_REVIEW_RA_LOCATION=\"ND\";
					}
					else
					{
						var site = nvalue._RM_REVIEW_RA_LOCATION;
						if (site.printattribute()==\"\") site=\"ND\";
						vAct.SAN_RDPM_UA_S_PHARMA_LEADER=nvalue.name;
						vAct._RM_REVIEW_RA_LOCATION=site;
					}
				}				
			}
		}
	}
}

// Function to update leader site on activity
function san_pjs_rdpm_update_activity_leader_site(role_onb,field,nvalue)
{
	var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
	var act_onb_number = act_onb.parsenumber();
	var act_obj=plc.work_structure.get(act_onb_number);
	var key=\"\";
	var act_type_onb=\"\";
	var obs_onb=\"\";
	var wbs_form_map_obj=\"\";
	
	with(act_obj.fromObject())
	{
		for (var vAct in plc.work_structure where vAct.AF==undefined)
		{
			act_type_onb = vAct.WBS_TYPE.ONB.tostring();
			obs_onb = vAct.OBS_ELEMENT.ONB.tostring();
			key = role_onb + \"_\" + act_type_onb + \"_\" + obs_onb;
			wbs_form_map_obj=plc.__USER_TABLE_SAN_RDPM_UR_WBS_FORM_MAP_LEADER.get(key);
			
			if (wbs_form_map_obj!=undefined && wbs_form_map_obj!=false){
					
				if (san_pjs_leader_defined_by_act(act_obj,vAct,Role_ONB,\"SAN_UA_B_LEADER_SITE_OVERWRITE\"))
				{
					vAct._RM_REVIEW_RA_LOCATION=nvalue;	
				}				
			}
		}
	}
}

// Check if the activity define leader / site on lower activities
function san_pjs_leader_defined_by_act(Defined_Act,Act,Role_ONB,field_overwrite)
{
	var result = false;
	var act_parent;
	var act_onb = Act.ONB.tostring();
	var expected_id=act_onb+\"_\"+Role_ONB;
    var wbs_form_data_obj=plc.__USER_TABLE_SAN_RDPM_UT_WBS_FORM_DATA.get(expected_id);
	
	if (Act==Defined_Act) 
	{
		return true;
	}
	else
	{
		if (wbs_form_data_obj!=undefined && wbs_form_data_obj!=false && wbs_form_data_obj.get(field_overwrite)==true)
		{
			return false;	
		}
		else
		{
			act_parent=Act.WBS_ELEMENT;
				if (act_parent!=undefined && act_parent!=false && act_parent.internal==false)  return san_pjs_leader_defined_by_act(Defined_Act,act_parent,Role_ONB,field_overwrite);
		}
	}
	return result;
}

// Update Leader and Sites on activities from toolbar
function san_rdpm_wbs_form_update_leader_and_site()
{
	var CurrentProject = plw.CurrentPageObject();
	// Launch on selection
	var selection= false;
	 for( var vAct_selection in #TOOL-BAR::SELECTION-ATOM# ){
		selection= true;
		with(vAct_selection.fromObject())
		{
			
			for (var vAct in plc.workstructure where vAct.AF==undefined && vAct.SAN_UA_RDPM_S_WBS_FORM_LEADER_ROLE!=\"\")
			{
				vAct.SAN_RDPM_UA_S_PHARMA_LEADER=vAct.SAN_UA_RDPM_S_WBS_FORM_LEADER;
				vAct._RM_REVIEW_RA_LOCATION=vAct.SAN_UA_RDPM_S_WBS_FORM_LEADER_SITE;
			}
		}
	 }
	// Launch on full project
	if(selection==false && plw.Question(\"Do you want to launch recomputation of leader and site on all project?\"))
	{
		with(CurrentProject.fromObject())
		{
			for (var vAct in plc.workstructure where vAct.AF==undefined && vAct.SAN_UA_RDPM_S_WBS_FORM_LEADER_ROLE!=\"\")
			{
				vAct.SAN_RDPM_UA_S_PHARMA_LEADER=vAct.SAN_UA_RDPM_S_WBS_FORM_LEADER;
				vAct._RM_REVIEW_RA_LOCATION=vAct.SAN_UA_RDPM_S_WBS_FORM_LEADER_SITE;
			}
		}
	}
}

// Object = this.editor
function san_rdpm_update_ph(object)
{
	if (object.file.SAN_RD_IS_RND_PROJECT)
	{
		object.setsensitive(\"RESOURCE\");
		object.setsensitive(\"_RM_REVIEW_RA_LOCATION\");
		var role=object._RM_REVIEW_RA_ROLE;
		var activity=object.ACTIVITY;
		if (role instanceof plc._RM_REVIEW_PT_ROLE)
		{
			// Set default values
			object._INF_RA_CBS3=\"\";
			object._RM_REVIEW_RA_LOCATION=\"ND\";
			object._INF_RA_CBS2=\"INT\";
			// Set activity values
			if (object.ACTIVITY._RM_REVIEW_RA_LOCATION instanceof plc._RM_REVIEW_PT_LOCATIONS && object.ACTIVITY._RM_REVIEW_RA_LOCATION.internal==false) object._RM_REVIEW_RA_LOCATION=object.ACTIVITY._RM_REVIEW_RA_LOCATION;
			if (object.ACTIVITY.SAN_RDPM_UA_ACT_SOURCING instanceof plc._INF_PT_CBS2 && object.ACTIVITY.SAN_RDPM_UA_ACT_SOURCING.internal==false) object._INF_RA_CBS2=object.ACTIVITY.SAN_RDPM_UA_ACT_SOURCING;
			if (object.ACTIVITY.SAN_RDPM_UA_ACT_PROVIDER instanceof plc._INF_PT_CBS3 && object.ACTIVITY.SAN_RDPM_UA_ACT_PROVIDER.internal==false) object._INF_RA_CBS3=object.ACTIVITY.SAN_RDPM_UA_ACT_PROVIDER;
			// Set role value
			if (activity instanceof plc.workstructure && role.SAN_UA_RDPM_B_DISPLAYED_WBS_FORM_PHARMA)
			{
				object._INF_RA_CBS3=plw.san_pjs_get_wbs_form_string_value_on_object(activity.printattribute(),role.printattribute(),\"USER_ATTRIBUTE_SAN_UA_S_PROVIDER\");
				object._INF_RA_CBS2=plw.san_pjs_get_wbs_form_string_value_on_object(activity.printattribute(),role.printattribute(),\"USER_ATTRIBUTE_SAN_UA_S_SOURCING\");
				if (object.file.SAN_RDPM_B_RND_PHARMA_PROJECT) {object._RM_REVIEW_RA_LOCATION=plw.san_pjs_get_wbs_form_string_value_on_object(activity.printattribute(),role.printattribute(),\"USER_ATTRIBUTE_SAN_UA_S_LEADER_SITE\");}
			}
			else
			{
				if (role._RM_REVIEW_RA_LOCATION instanceof plc._RM_REVIEW_PT_LOCATIONS && role._RM_REVIEW_RA_LOCATION.internal==false)
					object._RM_REVIEW_RA_LOCATION=role._RM_REVIEW_RA_LOCATION;
			}
		}
	}
}

// Function to fix problem with the copy of the WBS Form data in versions
function san_rdpm_restore_wbs_form_data_in_version(version)
{
	var hash_version = new hashtable(\"STRING\");
	var hash_activity =  new hashtable(\"STRING\");
	var key_act;
	var version_act;
	var file;
	// Loop on WBS Form data for which the activity is not is the same file as the WBS Form data object
	for (var wbs_form_data in plc.__USER_TABLE_SAN_RDPM_UT_WBS_FORM_DATA where wbs_form_data.FILE._PM_NF_B_IS_A_VERSION && (version==\"\" || wbs_form_data.file.printattribute()==version) && wbs_form_data.SAN_UA_WBS_FORM_DATA_ACTIVITY!=\"\" && wbs_form_data.SAN_UA_WBS_FORM_DATA_ACTIVITY.FILE!=wbs_form_data.file)
	{
		file = wbs_form_data.file;
		// If the activity of the version have not been entered in the hashtable, we add it
		if (hash_version.get(file.NAME)==undefined)
		{
			with(file.fromObject())
			{
				for (var vAct in plc.workstructure)
				{
					hash_activity.set(file.NAME+\"_\"+vAct.ORIGIN_ACTIVITY.printattribute(),VAct);
				}
			}
			hash_version.set(file.NAME,\"1\");
		}
		// Calculate the key to retrieve the activity in the hashtable --> Return the activity of the version
		key_act =  file.NAME+\"_\"+wbs_form_data.SAN_UA_WBS_FORM_DATA_ACTIVITY.printattribute();
		version_act = hash_activity.get(key_act);
		// Update the activity to have the activity of the version
		if (version_act instanceof plc.workstructure)
		{
			with (plw.no_locking){
				wbs_form_data.SAN_UA_WBS_FORM_DATA_ACTIVITY=version_act;
			}
		}
	}
	
	if (version!=\"\")
	{
	    plw.alert(\"WBS Form data has been restored for project version \" + version +\".\");
	}

}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260006820574
 :VERSION 43
 :_US_AA_D_CREATION_DATE 20210923000000
 :_US_AA_S_OWNER "E0476882"
)