
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321317809182
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _workday_interface_utils;

function san_pjs_linked_workday_actual_res_reader() {
	var v_attributes = new vector(\"SAN_UA_RDPM_RES_EMPL_NUM\");
	var wd_actual_obj=this;
	var wd_actualname=wd_actual_obj.NAME;
	var v_values = new vector(wd_actualname);
	
	var ka = new Keyattribute(plc.resource,v_attributes,v_values);
	if (ka instanceof KeyAttribute){
		with(ka.fromObject()){
			for (var res in plc.resource) {
				return true;
			}
		}
	}
}

function san_pjs_create_dynamic_attribute_workday_actual_resource(){
    try{
        var slot = new objectAttribute(plc.__USER_TABLE_SAN_RDPM_UT_ACTUALS_WORKDAY,\"SAN_RDPM_DA_B_ACTUALS_IN_RDPM\",\"BOOLEAN\");
        slot.Comment = \"Actuals in RDPM (dynatt)\";
        slot.Reader = san_pjs_linked_workday_actual_res_reader;
        slot.Modifier = undefined;
        slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
    catch(error e){
        plw.writetolog(\"Could not create slot due to error: \" + e);
	}
}

function san_pjs_linked_workday_open_res_reader() {
	var v_attributes = new vector(\"SAN_RDPM_RES_S_WORK_DAY_REF\");
	var wd_open_obj=this;
	var wd_open_name=wd_open_obj.NAME;
	var v_values = new vector(wd_open_name);
	
	var ka = new Keyattribute(plc.resource,v_attributes,v_values);
	if (ka instanceof KeyAttribute){
		with(ka.fromObject()){
			for (var res in plc.resource) {
				return true;
			}
		}
	}
}

function san_pjs_create_dynamic_attribute_workday_open_resource(){
    try{
        var slot = new objectAttribute(plc.__USER_TABLE_SAN_RDPM_UT_OPEN_POSITION_WORKDAY,\"SAN_RDPM_DA_B_OPEN_POSITION_IN_RDPM\",\"BOOLEAN\");
        slot.Comment = \"Open position in RDPM (dynatt)\";
        slot.Reader = san_pjs_linked_workday_open_res_reader;
        slot.Modifier = undefined;
        slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
    catch(error e){
        plw.writetolog(\"Could not create slot due to error: \" + e);
	}
}

san_pjs_create_dynamic_attribute_workday_actual_resource();
san_pjs_create_dynamic_attribute_workday_open_resource();"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 321315206382
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20231123000000
 :_US_AA_S_OWNER "E0434229"
)