
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260009653074
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
   
    var act_obj=plc.work_structure.get(act_id);
    plw.writeln(\"act_obj: \"+act_obj);
    var act_onb=undefined;
    if (!act_obj.internal) act_onb=act_obj.ONB;
    plw.writeln(\"act_onb: \"+act_onb);
   
    var role_obj=plc._RM_REVIEW_PT_ROLE.get(role_id);
    plw.writeln(\"role_obj: \"+role_obj);
    var role_onb=undefined;
    if (role_obj!=undefined && !role_obj.internal) {
        role_onb=role_obj.ONB;
    }
    plw.writeln(\"role_onb: \"+role_onb);
	
      if (act_onb!=undefined && role_onb!=undefined) result=san_pjs_get_upper_level_value(act_onb,role_onb,field);
   
    plw.writeln(\"result: \"+result);
    if (result InstanceOf plc.__USER_TABLE_SAN_RDPM_UT_SOURCING) result=result.printattribute();
   
    if (result==undefined) {
        if (type==\"STRING\") result=\"\";
        if (type==\"NUMBER\") result=1;
    }
   
    return result;
}

function san_pjs_get_upper_level_value(act_onb,role_onb,field) {
    var ThisLevelValue=undefined;

	var onb_number=act_onb.parsenumber();
    var act_obj=plc.work_structure.get(onb_number);

    var act_parent_obj=act_obj.WBS_ELEMENT;

    var act_parent_obj_onb=undefined;
    if (act_parent_obj.internal==false) {
        act_parent_obj_onb=act_parent_obj.ONB.tostring();
    }
       
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
    var act_file=act_rel.get(\"FILE\");
    var role_rel=plc._RM_REVIEW_PT_ROLE.get(role_onb);
   
    //var wbs_form_data_obj=plc.__USER_TABLE_SAN_RDPM_UT_WBS_FORM_DATA.get(expected_id);
    var wbs_form_data_obj=san_pjs_get_wbs_form_data_object(act_onb,role_onb);
    //plw.alert(\"in san_pjs_set_wbs_form_data_value ; wbs_form_data_obj = \"+wbs_form_data_obj);
	
	// Check the value at parent level
	var act_parent=act_rel.WBS_ELEMENT;
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
	var act_leader_cur=\"\";
	var cur_act_onb=\"\";
	var child_act_onb=\"\";
	
	with(act_obj.fromObject())
	{
		for (var vAct in plc.work_structure)
		{
			act_type_onb = vAct.WBS_TYPE.ONB.tostring();
			cur_act_onb=vAct.ONB.tostring();
			obs_onb = vAct.OBS_ELEMENT.ONB.tostring();
			key = role_onb + \"_\" + act_type_onb + \"_\" + obs_onb;
			wbs_form_map_obj=plc.__USER_TABLE_SAN_RDPM_UR_WBS_FORM_MAP_LEADER.get(key);
			
			if (wbs_form_map_obj!=undefined && wbs_form_map_obj!=false){
				
				child_act_onb = vAct.ONB.tostring();
				var act_leader=san_pjs_rdpm_update_activity_leader_act(child_act_onb,role_onb);
				plw.alert(\"act_leader : \"+act_leader);
				plw.alert(\"act_obj : \"+act_obj);
				
				if (act_leader==act_obj)
				{
					vAct.SAN_RDPM_UA_S_PHARMA_LEADER=nvalue.name;
					vAct._RM_REVIEW_RA_LOCATION=site;	
				}				
			}
		}
	}
}

function san_pjs_rdpm_update_activity_leader_act(act_onb,role_onb)
{
	var act_onb_number = act_onb.parsenumber();
	var act_obj=plc.work_structure.get(act_onb_number);
	plw.alert(\"act_obj : \"+act_obj.name);
	var result=act_obj;
	var act_parent;
	var act_parent_onb=\"\";

	// Search for a WBS Form Data linked to the activity
	var expected_id=act_onb+\"_\"+role_onb;
    var wbs_form_data_obj=plc.__USER_TABLE_SAN_RDPM_UT_WBS_FORM_DATA.get(expected_id);
	plw.alert(wbs_form_data_obj);
	if (wbs_form_data_obj!=undefined && wbs_form_data_obj!=false)
	{
		// Check if a value is defined for leader
		if (wbs_form_data_obj.SAN_UA_B_LEADER_OVERWRITE)
		{
			result = act_obj;
			plw.alert(\"1\");
			plw.alert(\"wbs_form_data_obj.SAN_UA_B_LEADER_OVERWRITE : \"+result);
		}
		// No value defined for leader
		else
		{
			plw.alert(\"2\");
			act_parent=act_obj.WBS_ELEMENT;
			if (act_parent!=undefined && act_parent!=false){
				act_parent_onb=act_parent.ONB.tostring();
				san_pjs_rdpm_update_activity_leader_act(act_parent_onb,role_onb);
			}
		}
	}
	// No WBS Form Data linked to the activity
	else
	{
		plw.alert(\"3\");
		act_parent=act_obj.WBS_ELEMENT;
		if (act_parent!=undefined && act_parent!=false){
			act_parent_onb=act_parent.ONB.tostring();
			san_pjs_rdpm_update_activity_leader_act(act_parent_onb,role_onb);
		}
	}
	
	plw.alert(\"san_pjs_rdpm_update_activity_leader_act -> result : \"+result);
	return result;	
}

// ###############   Complexity factor input ####################

function san_wbs_form_complexity_factor_slot_reader() {
	var result=1;
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    var entered_value=san_pjs_get_upper_level_value(act_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_N_COMPLEXITY_FACTOR\");
    if (entered_value!=undefined && entered_value!=false) result=entered_value;

    return result;
}

function san_wbs_form_complexity_factor_slot_modifier(nvalue) {
    var field=\"USER_ATTRIBUTE_SAN_UA_N_COMPLEXITY_FACTOR\";
    if (nvalue==\"\" || nvalue==undefined) nvalue=1;
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    var result=\"\";
    var result=san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,nvalue);
    return result;
}

function san_wbs_form_complexity_factor_slot_locker() {
    var lock=!(this.IS_A_LEAF);
    return lock;
}

function san_pjs_create_dynamic_attribute_complexity_factor(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_COMPLEXITY_FACTOR\",\"NUMBER\");
        slot.Comment = \"Complexity factor\";
        slot.Reader = san_wbs_form_complexity_factor_slot_reader;
        slot.Modifier = san_wbs_form_complexity_factor_slot_modifier;
        slot.Locker = san_wbs_form_complexity_factor_slot_locker;
        slot.hiddenInIntranetServer = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_complexity_factor();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_COMPLEXITY_FACTOR\");
    plw.writeln(e);
}


// ###############   Complexity factor Parent ####################
function san_wbs_form_complexity_factor_parent_slot_reader() {
    var result=1;
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
	var act_onb_number=act_onb.parsenumber();
	var act=plc.work_structure.get(act_onb_number);
	var act_parent=act.WBS_ELEMENT;
	var act_parent_onb=act_parent.ONB.tostring();
	var entered_value=san_pjs_get_upper_level_value(act_parent_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_N_COMPLEXITY_FACTOR\");
    if (entered_value!=undefined && entered_value!=false) result=entered_value;

    return result;
}

function san_wbs_form_complexity_factor_parent_slot_locker() {
    return true;
}

function san_pjs_create_dynamic_attribute_complexity_factor_parent(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_COMPLEXITY_FACTOR_PARENT\",\"NUMBER\");
        slot.Comment = \"Complexity factor (Parent)\";
        slot.Reader = san_wbs_form_complexity_factor_parent_slot_reader;
        slot.Locker = san_wbs_form_complexity_factor_parent_slot_locker;
        slot.hiddenInIntranetServer = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_complexity_factor_parent();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_COMPLEXITY_FACTOR_PARENT\");
    plw.writeln(e);
}



// ###############  Leader ####################

function san_wbs_form_leader_slot_reader() {
	var result=1;
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    var entered_value=san_pjs_get_upper_level_value(act_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_LEADER\");
    if (entered_value!=undefined && entered_value!=false) result=entered_value;

    return result;
}

function san_wbs_form_leader_slot_modifier(nvalue) {
    var field=\"USER_ATTRIBUTE_SAN_UA_S_LEADER\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    var result=\"\";
    var result=san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,nvalue);
	san_pjs_rdpm_update_activity_leader(act_onb,role_onb,field,nvalue);
    return result;
}

function san_wbs_form_leader_slot_locker() {
    var lock=!(this.IS_A_LEAF);
    return lock;
}

function san_pjs_create_dynamic_attribute_leader(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_LEADER\",plc.resource);
        slot.Comment = \"Leader\";
        slot.Reader = san_wbs_form_leader_slot_reader;
        slot.Modifier = san_wbs_form_leader_slot_modifier;
        slot.Locker = san_wbs_form_leader_slot_locker;
        slot.hiddenInIntranetServer = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_leader();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_LEADER\");
    plw.writeln(e);
}


// ###############  Leader Parent ####################
function san_wbs_form_leader_parent_slot_reader() {
    var result=\"\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
	var act_onb_number=act_onb.parsenumber();
	var act=plc.work_structure.get(act_onb_number);
	var act_parent=act.WBS_ELEMENT;
	var act_parent_onb=act_parent.ONB.tostring();
	var entered_value=san_pjs_get_upper_level_value(act_parent_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_LEADER\");
    if (entered_value!=undefined && entered_value!=false) result=entered_value;

    return result;
}

function san_wbs_form_leader_parent_slot_locker() {
    return true;
}

function san_pjs_create_dynamic_attribute_leader_parent(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_LEADER_PARENT\",plc.resource);
        slot.Comment = \"Leader (Parent)\";
        slot.Reader = san_wbs_form_leader_parent_slot_reader;
        slot.Locker = san_wbs_form_leader_parent_slot_locker;
        slot.hiddenInIntranetServer = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_leader_parent();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_LEADER_PARENT\");
    plw.writeln(e);
}

// ###############  Leader Site ####################

function san_wbs_form_leader_site_slot_reader() {
	var result=\"ND\";
	var leader_site=\"\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
	
	var leader=san_pjs_get_upper_level_value(act_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_LEADER\");
	if (leader instanceof plc.resource)
	{
		leader_site=leader._RM_REVIEW_RA_LOCATION;
		if (leader_site instanceof plc._RM_REVIEW_PT_LOCATIONS && leader_site!=\"\")
		{
			result=leader_site;
		}
	}
	if (result!=\"\")
	{
		var entered_value=san_pjs_get_upper_level_value(act_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_LEADER_SITE\");
		if (entered_value!=undefined && entered_value!=false) result=entered_value;
	}

    return result;
}

function san_wbs_form_leader_site_slot_modifier(nvalue) {
    var field=\"USER_ATTRIBUTE_SAN_UA_S_LEADER_SITE\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    var result=\"\";
    var result=san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,nvalue);
    return result;
}

function san_wbs_form_leader_site_slot_locker() {
	var lock = false;
	
	var leader_site=\"\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
	
    var leader=san_pjs_get_parent_wbs_form_data_value(act_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_LEADER\");
	if (leader instanceof plc.resource)
	{
		leader_site=leader._RM_REVIEW_RA_LOCATION;
		if (leader_site!=undefined && leader_site!=false && leader_site.internal==false)
		{
			lock=true;
		}
	}
    return lock;
}

function san_pjs_create_dynamic_attribute_leader_site(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_LEADER_SITE\",plc._RM_REVIEW_PT_LOCATIONS);
        slot.Comment = \"Leader Site\";
        slot.Reader = san_wbs_form_leader_site_slot_reader;
        slot.Modifier = san_wbs_form_leader_site_slot_modifier;
        slot.Locker = san_wbs_form_leader_site_slot_locker;
        slot.hiddenInIntranetServer = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_leader_site();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_LEADER_SITE\");
    plw.writeln(e);
}


// ###############  Leader Site Parent ####################
function san_wbs_form_leader_site_parent_slot_reader() {
    var result=\"ND\";
	var leader_site=\"\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
	var act_onb_number=act_onb.parsenumber();
	var act=plc.work_structure.get(act_onb_number);
	var act_parent=act.WBS_ELEMENT;
	var act_parent_onb=act_parent.ONB.tostring();
	
	var leader=san_pjs_get_upper_level_value(act_parent_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_LEADER\");
	if (leader instanceof plc.resource)
	{
		leader_site=leader._RM_REVIEW_RA_LOCATION;
		if (leader_site instanceof plc._RM_REVIEW_PT_LOCATIONS && leader_site!=\"\")
		{
			result=leader_site;
		}
	}
	
	if (result!=\"\")
	{
		var entered_value=san_pjs_get_upper_level_value(act_parent_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_LEADER_SITE\");
		if (entered_value!=undefined && entered_value!=false) result=entered_value;
	}

    return result;
}

function san_wbs_form_leader_site_parent_slot_locker() {
    return true;
}

function san_pjs_create_dynamic_attribute_leader_site_parent(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_LEADER_SITE_PARENT\",plc._RM_REVIEW_PT_LOCATIONS);
        slot.Comment = \"Leader Site (Parent)\";
        slot.Reader = san_wbs_form_leader_site_parent_slot_reader;
        slot.Locker = san_wbs_form_leader_site_parent_slot_locker;
        slot.hiddenInIntranetServer = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_leader_site_parent();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_LEADER_SITE_PARENT\");
    plw.writeln(e);
}

// ###############  Sourcing ####################

function san_wbs_form_sourcing_slot_reader() {
	var result=\"INT\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
	 
    var entered_value=san_pjs_get_upper_level_value(act_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_SOURCING\");
    if (entered_value!=undefined && entered_value!=false) result=entered_value;

    return result;
}

function san_wbs_form_sourcing_slot_modifier(nvalue) {
    var field=\"USER_ATTRIBUTE_SAN_UA_S_SOURCING\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    var result=\"\";
	if (nvalue.printattribute()!=\"INT\")
	{
		var provider = san_pjs_get_wbs_form_data_value(act_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_PROVIDER\");
		if (provider!=undefined && provider!=false && provider!=\"\")
		{
			result=san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,nvalue);
		}
		else
		{
			plw.alert(\"Please enter a provider before changing sourcing.\");
		}
	}
	else
	{
		result=san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,nvalue);
	}

    return result;
}

function san_wbs_form_sourcing_slot_locker(){
    var lock=!(this.IS_A_LEAF);
    return lock;
}

function san_pjs_create_dynamic_attribute_sourcing(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_SOURCING\",plc.__USER_TABLE_SAN_RDPM_UT_SOURCING);
        slot.Comment = \"Sourcing\";
        slot.Reader = san_wbs_form_sourcing_slot_reader;
        slot.Modifier = san_wbs_form_sourcing_slot_modifier;
        slot.Locker = san_wbs_form_sourcing_slot_locker;
        slot.hiddenInIntranetServer = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_sourcing();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_SOURCING\");
    plw.writeln(e);
}


// ###############  Sourcing (Parent) ####################
function san_wbs_form_sourcing_parent_slot_reader() {
    var result=\"INT\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
	var act_onb_number=act_onb.parsenumber();
	var act=plc.work_structure.get(act_onb_number);
	var act_parent=act.WBS_ELEMENT;
	var act_parent_onb=act_parent.ONB.tostring();
	var entered_value=san_pjs_get_upper_level_value(act_parent_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_SOURCING\");
    if (entered_value!=undefined && entered_value!=false) result=entered_value;

    return result;
}

function san_wbs_form_sourcing_parent_slot_locker() {
    return true;
}

function san_pjs_create_dynamic_attribute_sourcing_parent(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_SOURCING_PARENT\",plc.__USER_TABLE_SAN_RDPM_UT_SOURCING);
        slot.Comment = \"Sourcing (Parent)\";
        slot.Reader = san_wbs_form_sourcing_parent_slot_reader;
        slot.Locker = san_wbs_form_sourcing_parent_slot_locker;
        slot.hiddenInIntranetServer = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_sourcing_parent();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_SOURCING_PARENT\");
    plw.writeln(e);
}

// ###############  Provider ####################

function san_wbs_form_provider_slot_reader() {
	var result=\"\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    var entered_value=san_pjs_get_upper_level_value(act_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_PROVIDER\");
    if (entered_value!=undefined && entered_value!=false) result=entered_value;

    return result;
}

function san_wbs_form_provider_slot_modifier(nvalue) {
    var field=\"USER_ATTRIBUTE_SAN_UA_S_PROVIDER\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    var result=\"\";
	
	var Sourcing = san_pjs_get_wbs_form_data_value(act_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_SOURCING\");
	
	if (Sourcing.printattribute()!=\"INT\" && nvalue==\"\")
	{
		plw.alert(\"Please change sourcing to INT before removing provider.\");
	}
	else
	{
		result=san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,nvalue);
	}
    return result;
}

function san_wbs_form_provider_slot_locker(){
    var lock=!(this.IS_A_LEAF);
    return lock;
}

function san_pjs_create_dynamic_attribute_provider(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_PROVIDER\",plc.__USER_TABLE_SAN_RDPM_UT_PARTNER);
        slot.Comment = \"Provider\";
        slot.Reader = san_wbs_form_provider_slot_reader;
        slot.Modifier = san_wbs_form_provider_slot_modifier;
        slot.Locker = san_wbs_form_provider_slot_locker;
        slot.hiddenInIntranetServer = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_provider();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_PROVIDER\");
    plw.writeln(e);
}


// ###############  Provider (Parent) ####################
function san_wbs_form_provider_parent_slot_reader() {
    var result=\"\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
	var act_onb_number=act_onb.parsenumber();
	var act=plc.work_structure.get(act_onb_number);
	var act_parent=act.WBS_ELEMENT;
	var act_parent_onb=act_parent.ONB.tostring();
	var entered_value=san_pjs_get_upper_level_value(act_parent_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_PROVIDER\");
    if (entered_value!=undefined && entered_value!=false) result=entered_value;

    return result;
}

function san_wbs_form_provider_parent_slot_locker() {
    return true;
}

function san_pjs_create_dynamic_attribute_provider_parent(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_PROVIDER_PARENT\",plc.__USER_TABLE_SAN_RDPM_UT_PARTNER);
        slot.Comment = \"Provider (Parent)\";
        slot.Reader = san_wbs_form_provider_parent_slot_reader;
        slot.Locker = san_wbs_form_provider_parent_slot_locker;
        slot.hiddenInIntranetServer = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_provider_parent();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_PROVIDER_PARENT\");
    plw.writeln(e);
}

// ###############  Team ####################

function san_wbs_form_team_slot_reader() {
	var result=\"\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    var entered_value=san_pjs_get_upper_level_value(act_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_TEAM\");
    if (entered_value!=undefined && entered_value!=false) result=entered_value;

    return result;
}

function san_wbs_form_team_slot_modifier(nvalue) {
    var field=\"USER_ATTRIBUTE_SAN_UA_S_TEAM\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    var result=\"\";
    var result=san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,nvalue);
    return result;
}

function san_wbs_form_team_slot_locker(){
    var lock=!(this.IS_A_LEAF);
    return lock;
}

function san_pjs_create_dynamic_attribute_team(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_TEAM\",plc._INF_PT_CBS2);
        slot.Comment = \"Team\";
        slot.Reader = san_wbs_form_team_slot_reader;
        slot.Modifier = san_wbs_form_team_slot_modifier;
        slot.Locker = san_wbs_form_team_slot_locker;
        slot.hiddenInIntranetServer = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_team();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_TEAM\");
    plw.writeln(e);
}


// ###############  Team (Parent) ####################
function san_wbs_form_team_parent_slot_reader() {
    var result=\"\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
	var act_onb_number=act_onb.parsenumber();
	var act=plc.work_structure.get(act_onb_number);
	var act_parent=act.WBS_ELEMENT;
	var act_parent_onb=act_parent.ONB.tostring();
	var entered_value=san_pjs_get_upper_level_value(act_parent_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_TEAM\");
    if (entered_value!=undefined && entered_value!=false) result=entered_value;

    return result;
}

function san_wbs_form_team_parent_slot_locker() {
    return true;
}

function san_pjs_create_dynamic_attribute_team_parent(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_TEAM_PARENT\",plc._INF_PT_CBS2);
        slot.Comment = \"Team (Parent)\";
        slot.Reader = san_wbs_form_team_parent_slot_reader;
        slot.Locker = san_wbs_form_team_parent_slot_locker;
        slot.hiddenInIntranetServer = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_team_parent();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_TEAM_PARENT\");
    plw.writeln(e);
}

// ###############  Excluded Resources ####################

function san_wbs_form_excluded_res_slot_reader() {
	var result=false;
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    var entered_value=san_pjs_get_upper_level_value(act_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_B_EXCLUDED_RES\");
    if (entered_value!=undefined && entered_value!=false) result=entered_value;

    return result;
}

function san_wbs_form_excluded_res_slot_modifier(nvalue) {
    var field=\"USER_ATTRIBUTE_SAN_UA_B_EXCLUDED_RES\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    var result=\"\";
    var result=san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,nvalue);
    return result;
}

function san_wbs_form_excluded_res_slot_locker(){
    var lock=!(this.IS_A_LEAF);
    return lock;
}

function san_pjs_create_dynamic_attribute_excluded_res(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_EXCLUDED_RES\",\"BOOLEAN\");
        slot.Comment = \"Excluded Resources\";
        slot.Reader = san_wbs_form_excluded_res_slot_reader;
        slot.Modifier = san_wbs_form_excluded_res_slot_modifier;
        slot.Locker = san_wbs_form_excluded_res_slot_locker;
        slot.hiddenInIntranetServer = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_excluded_res();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_EXCLUDED_RES\");
    plw.writeln(e);
}


// ###############  Excluded Resources (Parent) ####################
function san_wbs_form_excluded_res_parent_slot_reader() {
    var result=false;
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
	var act_onb_number=act_onb.parsenumber();
	var act=plc.work_structure.get(act_onb_number);
	var act_parent=act.WBS_ELEMENT;
	var act_parent_onb=act_parent.ONB.tostring();
	var entered_value=san_pjs_get_upper_level_value(act_parent_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_B_EXCLUDED_RES\");
    if (entered_value!=undefined && entered_value!=false) result=entered_value;

    return result;
}

function san_wbs_form_excluded_res_parent_slot_locker() {
    return true;
}

function san_pjs_create_dynamic_attribute_excluded_res_parent(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_EXCLUDED_RES_PARENT\",\"BOOLEAN\");
        slot.Comment = \"Excluded Resources (Parent)\";
        slot.Reader = san_wbs_form_excluded_res_parent_slot_reader;
        slot.Locker = san_wbs_form_excluded_res_parent_slot_locker;
        slot.hiddenInIntranetServer = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_excluded_res_parent();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_EXCLUDED_RES_PARENT\");
    plw.writeln(e);
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260006820574
 :VERSION 13
 :_US_AA_D_CREATION_DATE 20201001000000
 :_US_AA_S_OWNER "E0296878"
)