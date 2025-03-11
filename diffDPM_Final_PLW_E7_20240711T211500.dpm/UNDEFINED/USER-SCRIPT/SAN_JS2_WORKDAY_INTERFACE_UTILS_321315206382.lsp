
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 321315206382
 :NAME "SAN_JS2_WORKDAY_INTERFACE_UTILS"
 :COMMENT "Resource Dynamic attributes"
 :ACTIVE T
 :DATASET 118081000141
 :EVAL-ON-LOAD T
 :LOAD-ORDER 0
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
    try {
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
    try {
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
san_pjs_create_dynamic_attribute_workday_open_resource();

// PC-6928

function san_pjs_open_service_managed_by_current_user_reader() {
	if (context.CallBooleanFormula(\"USER_IN_GROUP($CURRENT_USER,\\\"OR_FUNCT_ADM_PHARMA,OR_FUNCT_ADM_VACCINES,R_ITS_ADMIN\\\")\")) {
		return true;	
	}
	else {
		var pos=this;
		var boost_service=pos.SAN_RDPM_UA_OPEN_POSITION_BOOST_SERVICE_CODE;
		if (boost_service!=\"\") {
			var obs_code=boost_service.substring(0,6);
			if (obs_code!=\"\") {
				var obs_obj=plc.obs_node.get(obs_code);
				if (obs_obj!=undefined) {
					with(obs_obj.fromobject()) {
						for (var res in plc.resource where res._INF_AA_B_GENERIC_RES && res.OBS_ELEMENT==obs_obj) {
							return res._RM_NF_B_RES_IS_MANAGED;
						}
					}
				}
			}
		}
	}
}

function san_pjs_actuals_service_managed_by_current_user_reader() {
	if (context.CallBooleanFormula(\"USER_IN_GROUP($CURRENT_USER,\\\"OR_FUNCT_ADM_PHARMA,OR_FUNCT_ADM_VACCINES,R_ITS_ADMIN\\\")\")) {
		return true;	
	}
	else {
		var pos=this;
		var boost_service=pos.SAN_RDPM_UA_ACTUALS_BOOST_SERVICE_CODE;
		if (boost_service!=\"\") {
			var obs_code=boost_service.substring(0,6);
			if (obs_code!=\"\") {
				var obs_obj=plc.obs_node.get(obs_code);
				if (obs_obj!=undefined) {
					with(obs_obj.fromobject()) {
						for (var res in plc.resource where res._INF_AA_B_GENERIC_RES && res.OBS_ELEMENT==obs_obj) {
							return res._RM_NF_B_RES_IS_MANAGED;
						}
					}
				}
			}
		}
	}
}

function san_pjs_create_dynamic_attribute_service_managed_open_resource(){
	try {
		var slot = new objectAttribute(plc.__USER_TABLE_SAN_RDPM_UT_OPEN_POSITION_WORKDAY,\"SAN_RDPM_DA_B_MANAGED_SERVICE_OPEN\",\"BOOLEAN\");
		slot.Comment = \"Service managed by current user? (dynatt)\";
		slot.Reader = san_pjs_open_service_managed_by_current_user_reader;
		slot.Modifier = undefined;
		slot.hiddenInIntranetServer = true;
	slot.connecting = false;
	}
	catch(error e){
		plw.writetolog(\"Could not create slot due to error: \" + e);
	}
}

function san_pjs_create_dynamic_attribute_service_managed_actuals_resource(){
	try {
		var slot = new objectAttribute(plc.__USER_TABLE_SAN_RDPM_UT_ACTUALS_WORKDAY,\"SAN_RDPM_DA_B_MANAGED_SERVICE_ACTUALS\",\"BOOLEAN\");
		slot.Comment = \"Service managed by current user? (dynatt)\";
		slot.Reader = san_pjs_actuals_service_managed_by_current_user_reader;
		slot.Modifier = undefined;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writetolog(\"Could not create slot due to error: \" + e);
	}
}

san_pjs_create_dynamic_attribute_service_managed_open_resource();
san_pjs_create_dynamic_attribute_service_managed_actuals_resource();



function san_rdpm_map_resource_from_obs(f){
    var obs_obj=this;
    with(obs_obj.fromobject() ) {
        for (var res_obj in plc.resource) {
            f.call(res_obj);
        }
    }
}

function san_rdpm_dyn_rel_OBS_TO_RESOURCE(){
	var SAN_RDPM_REL_OBS_TO_RES = new ObjectRelation(plc.obs_node,\"SAN_RDPM_REL_OBS_TO_RES\");
	SAN_RDPM_REL_OBS_TO_RES.Mapmethod = san_rdpm_map_resource_from_obs;
	SAN_RDPM_REL_OBS_TO_RES.ConnectedToClass = plc.resource;
	SAN_RDPM_REL_OBS_TO_RES.Comment = \"Relation from OBS to linked resources\";
}

function san_pjs_create_dynamic_rel_OBS_TO_RESOURCE(){
	try{
		with(plw.no_locking){
			san_rdpm_dyn_rel_OBS_TO_RESOURCE();
		}
	}
	catch (error e){
		plw.writeToLog(\"Failed to create san_rdpm_dyn_rel_OBS_TO_RESOURCE\");
		plw.writeln(e);
	}
}

san_pjs_create_dynamic_rel_OBS_TO_RESOURCE();"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 2
 :_US_AA_B_BATCH_SCRIPT "0"
 :_US_AA_D_CREATION_DATE 20230706000000
 :_US_AA_S_OWNER "E0434229"
)