
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260010743274
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _wbs_form;

// ###############   WBS Form toolbox ####################

function san_pjs_get_wbs_form_value_on_object(act_id,role_id,field,type) {
    plw.writeln(\"arg1: \"+act_id);
    plw.writeln(\"arg2: \"+role_id);
    plw.writeln(\"arg3: \"+field);
    plw.writeln(\"arg4: \"+type);
   
    var result;
    if (type==\"STRING\") result=\"\";
    if (type==\"NUMBER\") result=1;
	if (type==\"BOOLEAN\") result=FALSE;
   
    var act_obj=plc.work_structure.get(act_id);
    plw.writeln(\"act_obj: \"+act_obj);
    var act_onb=undefined;
    if (!act_obj.internal) act_onb=act_obj.ONB.tostring();
    plw.writeln(\"act_onb: \"+act_onb);
   
    var role_obj=plc._RM_REVIEW_PT_ROLE.get(role_id);
    plw.writeln(\"role_obj: \"+role_obj);
    var role_onb=undefined;
    if (role_obj!=undefined && !role_obj.internal) {
        role_onb=role_obj.ONB.tostring();
    }
    plw.writeln(\"role_onb: \"+role_onb);
	
      if (act_onb!=undefined && role_onb!=undefined) result=san_pjs_get_upper_level_value(act_onb,role_onb,field);
   
    plw.writeln(\"result: \"+result);
    if (result InstanceOf plc.__USER_TABLE_SAN_RDPM_UT_SOURCING || result InstanceOf plc.resource || result InstanceOf plc._RM_REVIEW_PT_LOCATIONS || result InstanceOf plc.__USER_TABLE_SAN_RDPM_UT_PARTNER || result InstanceOf plc._INF_PT_CBS2) result=result.printattribute();
   
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

	// Level activity
	if (act_obj.level==1)
	{
		ThisLevelValue=san_pjs_get_wbs_form_data_value(act_onb,role_onb,field);
	}
	else
	{
		var act_parent_obj=act_obj.network;

		var act_parent_obj_onb=\"\";
		if (act_parent_obj!=undefined && act_parent_obj!=false && act_parent_obj.internal==false) {
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

    //plw.alert(\"Cas où on n'a rien trouvé\");
    return ThisLevelValue;
}

function san_pjs_get_wbs_form_data_object(act_onb,role_onb) {

    var act_onb_string=act_onb;
    var expected_id=act_onb_string+\"_\"+role_onb;
    //plw.alert(\"in san_pjs_get_wbs_form_data_object ; expected_id = \"+expected_id);
    var wbs_form_data_obj=plc.__USER_TABLE_SAN_RDPM_UT_WBS_FORM_DATA.get(expected_id);
    return wbs_form_data_obj;
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

	var field_overwrite =vHash.get(field);
	
	
    var ThisValue=undefined;
	var Value_Overwrite=false;
    var result=undefined;
    var wbs_form_data_obj=san_pjs_get_wbs_form_data_object(act_onb,role_onb);
    //plw.alert(\"in san_pjs_get_wbs_form_data_value ; wbs_form_data_obj = \"+wbs_form_data_obj);
    if (wbs_form_data_obj!=undefined && wbs_form_data_obj!=false) {
        ThisValue=wbs_form_data_obj.get(field);
		Value_Overwrite=wbs_form_data_obj.get(field_overwrite);
		if (Value_Overwrite)
		{
			result=ThisValue;
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
			var act_parent=act_rel.network;
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
	var site = nvalue._RM_REVIEW_RA_LOCATION;
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
					vAct.SAN_RDPM_UA_S_PHARMA_LEADER=nvalue.name;
					vAct._RM_REVIEW_RA_LOCATION=site;	
				}				
			}
		}
	}
}

// Function to update leader site on activity
function san_pjs_rdpm_update_activity_leader_site(act_onb,role_onb,field,nvalue)
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
			act_parent=Act.network;
				if (act_parent!=undefined && act_parent!=false && act_parent.internal==false)  return san_pjs_leader_defined_by_act(Defined_Act,act_parent,Role_ONB,field_overwrite);
		}
	}
	return result;
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260006820574
 :VERSION 21
 :_US_AA_D_CREATION_DATE 20201004000000
 :_US_AA_S_OWNER "E0296878"
)