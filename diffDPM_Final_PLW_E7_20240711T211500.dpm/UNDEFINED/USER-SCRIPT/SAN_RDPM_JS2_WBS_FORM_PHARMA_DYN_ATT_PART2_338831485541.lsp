
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 338831485541
 :NAME "SAN_RDPM_JS2_WBS_FORM_PHARMA_DYN_ATT_PART2"
 :COMMENT "WBS Form Pharma Dynamic Attributes part 2"
 :ACTIVE T
 :DATASET 118081000141
 :EVAL-ON-LOAD T
 :LOAD-ORDER 2
 :SCRIPT-CODE "namespace _wbs_form;

// Need to create a new user script SAN_RDPM_JS2_WBS_FORM_PHARMA_DYN_ATT_PART2
// because code was too long to be added to SAN_RDPM_JS2_WBS_FORM_PHARMA_DYN_ATT
//
// EPA GSE 16-NOV-23
// #### PC-7067 / PC-7131 : create a dyn attribute on STUDY / Country WBS element to enter directly IPM Leader value

// need to create a function to read wbs form value FROM AN ACTIVITY
// strongly inspired from san_wbs_form_parent_slot_reader
function san_wbs_form_slot_reader_from_activity(act_obj,role_onb,field,default_val,empty_val) {
	var result=default_val;
	var role_obj=plc._RM_REVIEW_PT_ROLE.get(role_onb);
	
	if (act_obj InstanceOf plc.workstructure && role_obj.SAN_UA_RDPM_B_DISPLAYED_WBS_FORM_PHARMA)
    {
        var act_onb=act_obj.ONB.tostring(\"####\");
        var entered_value=san_pjs_get_upper_level_value(act_onb,role_onb,field);
        if (entered_value!=undefined && entered_value!=false) result=entered_value;
	}
    else
    {
        result=empty_val;
	}
    return result;
	
}

// need to create a function to modifiy wbs form value FROM AN ACTIVITY
// strongly inspired from san_wbs_form_slot_modifier_leader
function san_wbs_form_slot_modifier_from_activity(act_obj,nvalue,role_onb,field,default_val) {
	var role_obj=plc._RM_REVIEW_PT_ROLE.get(role_onb);
	if (act_obj InstanceOf plc.workstructure && role_obj.SAN_UA_RDPM_B_DISPLAYED_WBS_FORM_PHARMA)
	{
		var act_onb=act_obj.ONB.tostring(\"####\");
		var result=default_val;
		var result=san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,nvalue);
		// Set leader site as ND --> Value will be resource value
		// PC-6431 Remove the part to initialise a value for Leader site on Leader modification
		// san_pjs_set_wbs_form_data_value(act_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_LEADER_SITE\",\"ND\");
		// Update leader on tasks
    	san_pjs_rdpm_update_activity_leader(act_onb,role_onb,field,nvalue);
		
		return result;
	}
}

// ###############     Dyn amic attribute SAN_DA_S_IPM_LEADER to be able to enter CSC-IPM leader value directly from the STUDY / country wbs element
// manage necessary function for the dynamic attribute SAN_DA_S_IPM_LEADER

function san_wbs_form_ipm_leader_slot_reader() {
	var country_study=this;
	var wbs_type_study=plc.WBS_TYPE.get(\"STUDY\");
	
	var result=\"\";
	
	var csc_ipm_role=plc._RM_REVIEW_PT_ROLE.get(\"CSC-IPM\");
	var csc_ipm_role_onb=csc_ipm_role.ONB;
	
	if (country_study InstanceOf plc.network && country_study.SAN_RDPM_UA_ACT_COUNT!=\"\" && country_study.SAN_RDPM_UA_ACT_COUNT InstanceOf plc.__USER_TABLE_SAN_RWE_UT_COUNTRY && country_study.WBS_TYPE==wbs_type_study) {		
		result=san_wbs_form_slot_reader_from_activity(country_study,csc_ipm_role_onb,\"USER_ATTRIBUTE_SAN_UA_S_LEADER\",\"\",\"\");	
	}
	return result;
}

function san_wbs_form_ipm_leader_slot_modifier(value) {
	var country_study=this;	
	var wbs_type_study=plc.WBS_TYPE.get(\"STUDY\");
	
	var result=\"\";
	
	var csc_ipm_role=plc._RM_REVIEW_PT_ROLE.get(\"CSC-IPM\");
	var csc_ipm_role_onb=csc_ipm_role.ONB;
	
	if (country_study InstanceOf plc.network && country_study.SAN_RDPM_UA_ACT_COUNT!=\"\" && country_study.SAN_RDPM_UA_ACT_COUNT InstanceOf plc.__USER_TABLE_SAN_RWE_UT_COUNTRY && country_study.WBS_TYPE==wbs_type_study) {
		result=san_wbs_form_slot_modifier_from_activity(country_study,value,csc_ipm_role_onb,\"USER_ATTRIBUTE_SAN_UA_S_LEADER\",\"\");
	}
	return result;
}

function san_wbs_form_ipm_leader_slot_locker() {
	var result=true;
	var country_study=this.object;	
	var wbs_type_study=plc.WBS_TYPE.get(\"STUDY\");
	if (country_study InstanceOf plc.network && country_study.SAN_RDPM_UA_ACT_COUNT!=\"\" && country_study.SAN_RDPM_UA_ACT_COUNT InstanceOf plc.__USER_TABLE_SAN_RWE_UT_COUNTRY && country_study.WBS_TYPE==wbs_type_study) {
		result=false;
	}
	return result;
}

function san_pjs_create_dynamic_attribute_ipm_leader_on_study_country(){
    try{
        var slot = new objectAttribute(plc.workstructure,\"SAN_DA_S_IPM_LEADER\",plc.resource);
        slot.Comment = \"CSC-IPM Leader\";
        slot.Reader = san_wbs_form_ipm_leader_slot_reader;
        slot.Modifier = san_wbs_form_ipm_leader_slot_modifier;
        slot.Locker = san_wbs_form_ipm_leader_slot_locker;
        slot.hiddenInIntranetServer = false;
		slot.connecting = false;
	}
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_ipm_leader_on_study_country();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create dynamic attribute SAN_DA_S_IPM_LEADER\");
    plw.writeln(e);
}
// END OF PC-7067 / PC-7131"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 1
 :_US_AA_B_BATCH_SCRIPT "0"
 :_US_AA_D_CREATION_DATE 20231116000000
 :_US_AA_S_OWNER "I0260387"
)