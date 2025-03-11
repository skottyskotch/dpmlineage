
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260006909574
 :DATASET 118081000141
 :SCRIPT-CODE "// filtre popup task et wbs element

/*  Script V1 to be implemented in ProWeb (level 2)
    function san_pjs_get_wbs_form_string_value_on_object(act_id,role_id,field) {
    var type=\"STRING\";
    var result=\"\";
    result=callV2(\"_wbs_form\",\"san_pjs_get_wbs_form_value_on_object\",act_id,role_id,field,type);
    return result;
    }
    san_pjs_get_wbs_form_string_value_on_object.exportfunction(new vector(\"STRING\",\"STRING\",\"STRING\"),\"STRING\",\"\");
   
   
    function san_pjs_get_wbs_form_number_value_on_object(act_id,role_id,field) {
    var type=\"NUMBER\";
    var result=1;
    result=callV2(\"_wbs_form\",\"san_pjs_get_wbs_form_value_on_object\",act_id,role_id,field,type);
    return result;
    }
    san_pjs_get_wbs_form_number_value_on_object.exportfunction(new vector(\"STRING\",\"STRING\",\"STRING\"),\"NUMBER\",\"\");
   
    function san_pjs_get_wbs_form_boolean_value_on_object(act_id,role_id,field) {
    var type=\"NUMBER\";
    var result=1;
    result=callV2(\"_wbs_form\",\"san_pjs_get_wbs_form_value_on_object\",act_id,role_id,field,type);
    return result;
    }
    san_pjs_get_wbs_form_boolean_value_on_object.exportfunction(new vector(\"STRING\",\"STRING\",\"STRING\"),\"BOOLEAN\",\"\");
*/

// ##############################################################################################################################################

namespace _wbs_form;

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

function san_pjs_get_upper_level_value(act_onb,role_onb,field,field_overwrite) {
    var ThisLevelValue=undefined;
    //plw.alert(\"Calling san_pjs_get_upper_level_value with args: \");
   
    //plw.alert(act_onb);
    //plw.alert(role_onb);
    //plw.alert(field);
    var act_onb=act_onb.parsenumber();
    var act_obj=plc.work_structure.get(act_onb);
    //plw.alert(\"act_obj: \"+act_obj);
    var act_parent_obj=act_obj.WBS_ELEMENT;
    //plw.alert(\"act_parent_obj internal: \"+act_parent_obj.internal);
    //plw.alert(\"act_parent_obj: \"+act_parent_obj);
    var act_parent_obj_onb=undefined;
    if (act_parent_obj.internal==false) {
        act_parent_obj_onb=act_parent_obj.ONB.tostring();
    }
       
    ThisLevelValue=san_pjs_get_wbs_form_data_value(act_onb,role_onb,field,field_overwrite);
    //plw.alert(\"ThisLevelValue: \"+ThisLevelValue);
    if (ThisLevelValue!=undefined) {
        return ThisLevelValue;
    }
    else {
        //plw.alert(\"On va chercher sur le parent: \"+ThisLevelValue);
        if (act_parent_obj_onb!=undefined) {
            return san_pjs_get_upper_level_value(act_parent_obj_onb,role_onb,field,field_overwrite);
        }
    }

    //plw.alert(\"Cas où on n'a rien trouvé\");
    return ThisLevelValue;
}

function san_pjs_get_wbs_form_data_object(act_onb,role_onb) {
    /*var act_onb_string=math.round(act_onb);
    act_onb_string=act_onb_string.tostring();*/
    var act_onb_string=act_onb;
   
    var expected_id=act_onb_string+\"_\"+role_onb;
    plw.alert(\"Expected id : \" + expected_id);
    //plw.alert(\"in san_pjs_get_wbs_form_data_object ; expected_id = \"+expected_id);
    var wbs_form_data_obj=plc.__USER_TABLE_SAN_RDPM_UT_WBS_FORM_DATA.get(expected_id);
    return wbs_form_data_obj;
}

function san_pjs_get_wbs_form_data_value(act_onb,role_onb,field,field_overwrite) {
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

function san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,field_overwrite,fvalue) {
   /* var act_onb_string=math.round(act_onb);
    act_onb_string=act_onb_string.tostring();*/
    var act_onb_string=act_onb;
    var act_onb_number=act_onb.parsenumber();
    var expected_id=act_onb_string+\"_\"+role_onb;
    plw.alert(\"expected_id: \"+expected_id);
    /*var act_rel=plc.work_structure.get(act_onb_number);
    var act_file=act_rel.get(\"FILE\");
    var role_rel=plc._RM_REVIEW_PT_ROLE.get(role_onb);
   
    //var wbs_form_data_obj=plc.__USER_TABLE_SAN_RDPM_UT_WBS_FORM_DATA.get(expected_id);
    var wbs_form_data_obj=san_pjs_get_wbs_form_data_object(act_onb,role_onb);
    //plw.alert(\"in san_pjs_set_wbs_form_data_value ; wbs_form_data_obj = \"+wbs_form_data_obj);
	
	// Check the value at parent level
	var act_parent=act_rel.WBS_ELEMENT;
	var act_parent_onb=act_parent.ONB.tostring();
	var parent_value = san_pjs_get_upper_level_value(act_parent_onb,role_onb,field,field_overwrite);
	
	if (fvalue==parent_value)
	{
		if (wbs_form_data_obj!=undefined && wbs_form_data_obj!=false) {
			wbs_form_data_obj.set(field_overwrite,false);
		}
	}
	else
	{	
		if (fvalue!=undefined) {
			if (wbs_form_data_obj==undefined || wbs_form_data_obj==false) {
				wbs_form_data_obj=new plc.__USER_TABLE_SAN_RDPM_UT_WBS_FORM_DATA(NAME: expected_id,
					FILE: act_file,
					SAN_UA_WBS_FORM_DATA_ACTIVITY: act_rel,
				SAN_UA_WBS_FORM_DATA_ROLE: role_rel);
			}
			wbs_form_data_obj.set(field,fvalue);
			wbs_form_data_obj.set(field_overwrite,true);
		}	
	}
   
    // cleaning
    /*if (wbs_form_data_obj!=undefined && wbs_form_data_obj!=false) {
       /* var complexity_factor_value=wbs_form_data_obj.SAN_UA_N_COMPLEXITY_FACTOR;
		complexity_factor_value=math.round(complexity_factor_value);
        //plw.alert(\"complexity_factor_value: \"+complexity_factor_value);
        var leader_value=wbs_form_data_obj.SAN_UA_S_LEADER;
        //plw.alert(\"leader_value: \"+leader_value);
        var sourcing_value=wbs_form_data_obj.SAN_UA_S_SOURCING_OBJ;
        //plw.alert(\"sourcing_value: \"+sourcing_value);
       
        if (wbs_form_data_obj.SAN_UA_B_WBS_FORM_OVERWRITE==false) {
            plw.writetolog(\"Deleting empty entry WBS Form data \"+wbs_form_data_obj);
            wbs_form_data_obj.delete();
           
        }
    }*/
   
}

// ###############   Complexity factor input ####################

function san_wbs_form_complexity_factor_slot_reader() {
    var result=1;
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    var entered_value=san_pjs_get_wbs_form_data_value(act_onb,role_onb,\"__USER_ATTRIBUTE_SAN_UA_N_COMPLEXITY_FACTOR\",\"__USER_ATTRIBUTE_SAN_UA_B_COMPLEXITY_FACTOR_OVERWRITE\");
    //var entered_value=san_pjs_get_upper_level_value(act_onb,role_onb,\"__USER_ATTRIBUTE_SAN_UA_N_COMPLEXITY_FACTOR\");
    if (entered_value!=undefined && entered_value!=false && entered_value!=1) result=entered_value;
    return result;
}

function san_wbs_form_complexity_factor_slot_modifier(nvalue) {
    var field=\"USER_ATTRIBUTE_SAN_UA_N_COMPLEXITY_FACTOR\";
	var field_overwrite=\"USER_ATTRIBUTE_SAN_UA_B_COMPLEXITY_FACTOR_OVERWRITE\";
    if (nvalue==\"\" || nvalue==undefined) nvalue=1;
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    plw.alert(act_onb);
    var result=\"\";
    var result=san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,field_overwrite,nvalue);
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
        //slot.Initializer = san_wbs_form_complexity_factor_slot_reader;
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

// ###############   Complexity factor conso ####################

function san_wbs_form_complexity_factor_conso_slot_reader() {
    var result=1;
    if (this.IS_A_LEAF) {
        var role_onb=this.ONB;
        var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
        //plw.alert(role_onb);
        //plw.alert(act_onb);
        //var entered_value=san_pjs_get_wbs_form_data_value(act_onb,role_onb,\"__USER_ATTRIBUTE_SAN_UA_N_COMPLEXITY_FACTOR\");
        var entered_value=san_pjs_get_upper_level_value(act_onb,role_onb,\"__USER_ATTRIBUTE_SAN_UA_N_COMPLEXITY_FACTOR\",\"__USER_ATTRIBUTE_SAN_UA_N_COMPLEXITY_FACTOR_OVERWRITE\");
        if (entered_value!=undefined && entered_value!=false) result=entered_value;
    }
    return result;
}

function san_wbs_form_complexity_factor_conso_slot_locker() {
    return true;
}

function san_pjs_create_dynamic_attribute_complexity_factor_conso(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_COMPLEXITY_FACTOR_CONSO\",\"NUMBER\");
        slot.Comment = \"Complexity factor (conso)\";
        slot.Reader = san_wbs_form_complexity_factor_conso_slot_reader;
        //slot.Modifier = san_wbs_form_complexity_factor_conso_slot_modifier;
        slot.Locker = san_wbs_form_complexity_factor_conso_slot_locker;
        //slot.Initializer = san_wbs_form_complexity_factor_slot_reader;
        slot.hiddenInIntranetServer = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_complexity_factor_conso();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_COMPLEXITY_FACTOR_CONSO\");
    plw.writeln(e);
}

// ###############   Leader ####################

function san_wbs_form_leader_slot_reader() {
    var result=\"\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    var entered_value=san_pjs_get_wbs_form_data_value(act_onb,role_onb,\"__USER_ATTRIBUTE_SAN_UA_S_LEADER\",\"__USER_ATTRIBUTE_SAN_UA_B_LEADER_OVERWRITE\");
    if (entered_value!=undefined && entered_value!=false) result=entered_value;
    return result;
}

function san_wbs_form_leader_slot_modifier(nvalue) {
    var result=undefined;
    var field=\"USER_ATTRIBUTE_SAN_UA_S_LEADER\";
	var field_overwrite=\"USER_ATTRIBUTE_SAN_UA_B_LEADER_OVERWRITE\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    var act_obj=plc.work_structure.get(act_onb);
    if (act_obj!=undefined && !act_obj.internal) {
        result=san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,field_overwrite,nvalue);
        with(act_obj.fromobject()) {
            for (var act_child in plc.work_structure) {
            var act_child_onb=act_child.ONB;
            var act_child_leader=san_pjs_get_wbs_form_data_value(act_child_onb,role_onb,field,field_overwrite);
            //plw.alert(\"act_child_leader: \"+act_child_leader);
                if (act_child_leader==undefined || act_child==act_obj) {
                if (nvalue!=\"\") {
                    act_child.SAN_RDPM_UA_S_PHARMA_LEADER=nvalue;
                }
                else {
                    act_child.SAN_RDPM_UA_S_PHARMA_LEADER=san_pjs_get_upper_level_value(act_onb,role_onb,\"__USER_ATTRIBUTE_SAN_UA_S_LEADER\",\"__USER_ATTRIBUTE_SAN_UA_S_LEADER_OVERWRITE\");
                }
                }
            }
        }
    }
    return result;
}

function san_wbs_form_leader_slot_locker() {
    var lock=!(this.IS_A_LEAF);
    return lock;
}

function san_pjs_create_dynamic_attribute_leader(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_LEADER\",plc.Resource);
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

// ###############   Leader conso ####################

function san_wbs_form_leader_conso_slot_reader() {
    var result=\"\";
    if (this.IS_A_LEAF) {
        var role_onb=this.ONB;
        var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
        var entered_value=san_pjs_get_upper_level_value(act_onb,role_onb,\"__USER_ATTRIBUTE_SAN_UA_S_LEADER\",\"__USER_ATTRIBUTE_SAN_UA_S_LEADER_OVERWRITE\");
        if (entered_value!=undefined && entered_value!=false) result=entered_value;
    }
    return result;
}

function san_wbs_form_leader_conso_slot_locker() {
    return true;
}

function san_pjs_create_dynamic_attribute_leader_conso(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_LEADER_CONSO\",plc.Resource);
        slot.Comment = \"Leader (conso)\";
        slot.Reader = san_wbs_form_leader_conso_slot_reader;
        slot.Locker = san_wbs_form_leader_conso_slot_locker;
        slot.hiddenInIntranetServer = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_leader_conso();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_PROJECT_LEADER_CONSO\");
    plw.writeln(e);
}

// ###############   Sourcing ####################

function san_wbs_form_sourcing_slot_reader() {
    var result=\"\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    var entered_value=san_pjs_get_wbs_form_data_value(act_onb,role_onb,\"__USER_ATTRIBUTE_SAN_UA_S_SOURCING_OBJ\",\"__USER_ATTRIBUTE_SAN_UA_B_SOURCING_OVERWRITE\");
    if (entered_value!=undefined && entered_value!=false) result=entered_value;
    return result;
}

function san_wbs_form_sourcing_slot_modifier(nvalue) {
    //plw.alert(\"san_wbs_form_sourcing_slot_modifier\");
    var field=\"USER_ATTRIBUTE_SAN_UA_S_SOURCING_OBJ\";
	var field_overwrite=\"USER_ATTRIBUTE_SAN_UA_B_SOURCING_OVERWRITE\";
    var role_onb=this.ONB;
    //plw.alert(\"role_onb: \"+role_onb);
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    //plw.alert(\"act_onb: \"+act_onb);
    var result=san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,field_overwrite,nvalue);
    //plw.alert(\"result: \"+result);
    return result;
}

function san_wbs_form_sourcing_slot_locker() {
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

// ###############   Sourcing conso ####################

function san_wbs_form_sourcing_conso_slot_reader() {
    var result=\"\";
    var role_onb=this.ONB;
    var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    var entered_value=san_pjs_get_upper_level_value(act_onb,role_onb,\"__USER_ATTRIBUTE_SAN_UA_S_SOURCING_OBJ\",\"__USER_ATTRIBUTE_SAN_UA_B_SOURCING_OVERWRITE\");
    if (entered_value!=undefined && entered_value!=false) result=entered_value;
    return result;
}

function san_wbs_form_sourcing_conso_slot_locker() {
    return true;
}

function san_pjs_create_dynamic_attribute_sourcing_conso(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_SOURCING_CONSO\",plc.__USER_TABLE_SAN_RDPM_UT_SOURCING);
        slot.Comment = \"Sourcing (conso)\";
        slot.Reader = san_wbs_form_sourcing_conso_slot_reader;
        slot.Locker = san_wbs_form_sourcing_conso_slot_locker;
        slot.hiddenInIntranetServer = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_sourcing_conso();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_PROJECT_SOURCING_CONSO\");
    plw.writeln(e);
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260006820574
 :VERSION 5
 :_US_AA_D_CREATION_DATE 20200928000000
 :_US_AA_S_OWNER "E0296878"
)