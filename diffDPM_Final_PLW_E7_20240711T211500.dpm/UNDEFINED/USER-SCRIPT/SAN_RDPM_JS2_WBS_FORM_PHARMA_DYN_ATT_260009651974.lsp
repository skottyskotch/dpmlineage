
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 260009651974
 :NAME "SAN_RDPM_JS2_WBS_FORM_PHARMA_DYN_ATT"
 :COMMENT "WBS Form Pharma Dynamic Attributes"
 :ACTIVE T
 :DATASET 118081000141
 :EVAL-ON-LOAD T
 :LOAD-ORDER 1
 :SCRIPT-CODE "//////
//// WST 26 10 2022: PC-6431 update of san_wbs_form_slot_wbsf_data_modifier and san_wbs_form_slot_modifier_leader: remove default value for leader site as ND when modify Leader
//// HRA 19 01 2021: update of san_wbs_form_provider_slot_modifier and san_wbs_form_sourcing_slot_modifier: remove provider or sourcing value control
//// AHI 05 08 2021: Creation of functions for DA \"# Sample(s)\", \"# Lot(s)\" and \"# Test(s)\"
//// LFA 21 10 2021 : Creation of SAN_RDPM_DA_B_WBS_FORM_DATA_DUPLICATED to identify the duplicates in WBS Form data table - PC-4818
//// AHI 28 10 2021: remove comment on lockers for sample, lots, tests
//// ABO 28 02 2022: Addition of the management of the user attributes on WBS Form data by using the existing functions (to manage overwrite fields and the automatic deletion for instance) - PC-832


namespace _wbs_form;

// Reader (Generic)
function san_wbs_form_slot_reader(role_onb,field,default_val,empty_val) {
	var result=default_val;
	if (this.SAN_UA_RDPM_B_DISPLAYED_WBS_FORM_PHARMA)
    {
        var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
        var entered_value=san_pjs_get_upper_level_value(act_onb,role_onb,field);
        if (entered_value!=undefined && entered_value!=false) result=entered_value;
    }
    else
    {
        result=empty_val;
    }
    return result;
}

// Reader parent (Generic)
function san_wbs_form_parent_slot_reader(role_onb,field,default_val,empty_val) {
    var result=default_val;
    if (this.SAN_UA_RDPM_B_DISPLAYED_WBS_FORM_PHARMA)
    {
        var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    	var act_onb_number=act_onb.parsenumber();
    	var act=plc.work_structure.get(act_onb_number);
    	if (act!=undefined && act!=false && act.internal==false)
    	{
    		var act_parent=act.WBS_ELEMENT;
    		if (act_parent!=undefined && act_parent!=false && act_parent.internal==false)
    		{
    			var act_parent_onb=act_parent.ONB.tostring();
    			var entered_value=san_pjs_get_upper_level_value(act_parent_onb,role_onb,field);
    			if (entered_value!=undefined && entered_value!=false) result=entered_value;
    		}
    	}
    }
    else
    {
        result=empty_val;
    }
    return result;
}

// Modifier (Generic)
function san_wbs_form_slot_modifier(nvalue,role_onb,field,default_val) {
	if (this.SAN_UA_RDPM_B_DISPLAYED_WBS_FORM_PHARMA){
		if (nvalue==\"\" || nvalue==undefined) nvalue=default_val;
		var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
		var result=san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,nvalue);
		return result;
	}
}

// Modifier (Leader = Generic + Update Site + Update leader on activities)
function san_wbs_form_slot_modifier_leader(nvalue,role_onb,field,default_val) {
	if (this.SAN_UA_RDPM_B_DISPLAYED_WBS_FORM_PHARMA)
	{
		var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
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



// Locker (Generic)
function san_wbs_form_slot_locker()
{
	var result = true;
	if (this.SAN_UA_RDPM_B_DISPLAYED_WBS_FORM_PHARMA)
    {
		var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    	var act_onb_number=act_onb.parsenumber();
    	var act=plc.work_structure.get(act_onb_number);
    	if (act!=undefined && act!=false && act.internal==false && act.project.WRITABLE)
    	{
			result = false;
		}
	}
	return result;
}

// ###############  Sourcing ####################

function san_wbs_form_sourcing_slot_reader() {
	return san_wbs_form_slot_reader(this.ONB,\"USER_ATTRIBUTE_SAN_UA_S_SOURCING\",\"INT\",\"\");
}

function san_wbs_form_sourcing_slot_modifier(nvalue) {
	if (this.SAN_UA_RDPM_B_DISPLAYED_WBS_FORM_PHARMA){
		var field=\"USER_ATTRIBUTE_SAN_UA_S_SOURCING\";
		var role_onb=this.ONB;
		var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
		var result=\"\";
		if (nvalue!=\"\")
		{
			var provider = san_pjs_get_wbs_form_data_value(act_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_PROVIDER\");

			result=san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,nvalue);
		}
		return result;	
	}
}

function san_wbs_form_sourcing_slot_locker(){
    return san_wbs_form_slot_locker();
}

function san_pjs_create_dynamic_attribute_sourcing(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_SOURCING\",plc._INF_PT_CBS2);
        slot.Comment = \"Sourcing\";
        slot.Reader = san_wbs_form_sourcing_slot_reader;
        slot.Modifier = san_wbs_form_sourcing_slot_modifier;
        slot.Locker = san_wbs_form_sourcing_slot_locker;
        slot.hiddenInIntranetServer = false;
		slot.connecting = false;
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
    return san_wbs_form_parent_slot_reader(this.ONB,\"USER_ATTRIBUTE_SAN_UA_S_SOURCING\",\"INT\",\"\");
}

function san_wbs_form_sourcing_parent_slot_locker() {
    return true;
}

function san_pjs_create_dynamic_attribute_sourcing_parent(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_SOURCING_PARENT\",plc._INF_PT_CBS2);
        slot.Comment = \"Sourcing (Parent)\";
        slot.Reader = san_wbs_form_sourcing_parent_slot_reader;
        slot.Locker = san_wbs_form_sourcing_parent_slot_locker;
        slot.hiddenInIntranetServer = false;
		slot.connecting = false;
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
	return san_wbs_form_slot_reader(this.ONB,\"USER_ATTRIBUTE_SAN_UA_S_PROVIDER\",\"\",\"\");
}

function san_wbs_form_provider_slot_modifier(nvalue) {
	if (this.SAN_UA_RDPM_B_DISPLAYED_WBS_FORM_PHARMA)
	{
		var field=\"USER_ATTRIBUTE_SAN_UA_S_PROVIDER\";
		var role_onb=this.ONB;
		var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
		var result=\"\";
		
		var Sourcing = san_pjs_get_wbs_form_data_value(act_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_SOURCING\");
		
		result=san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,nvalue);
		
		return result;
	}
}

function san_wbs_form_provider_slot_locker(){
    return san_wbs_form_slot_locker();
}

function san_pjs_create_dynamic_attribute_provider(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_PROVIDER\",plc._INF_PT_CBS3);
        slot.Comment = \"Provider\";
        slot.Reader = san_wbs_form_provider_slot_reader;
        slot.Modifier = san_wbs_form_provider_slot_modifier;
        slot.Locker = san_wbs_form_provider_slot_locker;
        slot.hiddenInIntranetServer = false;
		slot.connecting = false;
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
	 return san_wbs_form_parent_slot_reader(this.ONB,\"USER_ATTRIBUTE_SAN_UA_S_PROVIDER\",\"\",\"\");
}

function san_wbs_form_provider_parent_slot_locker() {
    return true;
}

function san_pjs_create_dynamic_attribute_provider_parent(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_PROVIDER_PARENT\",plc._INF_PT_CBS3);
        slot.Comment = \"Provider (Parent)\";
        slot.Reader = san_wbs_form_provider_parent_slot_reader;
        slot.Locker = san_wbs_form_provider_parent_slot_locker;
        slot.hiddenInIntranetServer = false;
		slot.connecting = false;
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
	return san_wbs_form_slot_reader(this.ONB,\"USER_ATTRIBUTE_SAN_UA_S_TEAM\",\"\",\"\");
}

function san_wbs_form_team_slot_modifier(nvalue) {
    return san_wbs_form_slot_modifier(nvalue,this.ONB,\"USER_ATTRIBUTE_SAN_UA_S_TEAM\",\"\");
}

function san_wbs_form_team_slot_locker(){
    return san_wbs_form_slot_locker();
}

function san_pjs_create_dynamic_attribute_team(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_TEAM\",plc.Resource);
        slot.Comment = \"Team\";
        slot.Reader = san_wbs_form_team_slot_reader;
        slot.Modifier = san_wbs_form_team_slot_modifier;
        slot.Locker = san_wbs_form_team_slot_locker;
        slot.hiddenInIntranetServer = false;
		slot.connecting = false;
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
    return san_wbs_form_parent_slot_reader(this.ONB,\"USER_ATTRIBUTE_SAN_UA_S_TEAM\",\"\",\"\");
}

function san_wbs_form_team_parent_slot_locker() {
    return true;
}

function san_pjs_create_dynamic_attribute_team_parent(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_TEAM_PARENT\",plc.Resource);
        slot.Comment = \"Team (Parent)\";
        slot.Reader = san_wbs_form_team_parent_slot_reader;
        slot.Locker = san_wbs_form_team_parent_slot_locker;
        slot.hiddenInIntranetServer = false;
		slot.connecting = false;
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
	return san_wbs_form_slot_reader(this.ONB,\"USER_ATTRIBUTE_SAN_UA_B_EXCLUDED_RES\",false,false);
}

function san_wbs_form_excluded_res_slot_modifier(nvalue) {
    return san_wbs_form_slot_modifier(nvalue,this.ONB,\"USER_ATTRIBUTE_SAN_UA_B_EXCLUDED_RES\",false);
}

function san_wbs_form_excluded_res_slot_locker(){
    return san_wbs_form_slot_locker();
}

function san_pjs_create_dynamic_attribute_excluded_res(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_EXCLUDED_RES\",\"BOOLEAN\");
        slot.Comment = \"Excluded Resources\";
        slot.Reader = san_wbs_form_excluded_res_slot_reader;
        slot.Modifier = san_wbs_form_excluded_res_slot_modifier;
        slot.Locker = san_wbs_form_excluded_res_slot_locker;
        slot.hiddenInIntranetServer = false;
		slot.connecting = false;
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
    return san_wbs_form_parent_slot_reader(this.ONB,\"USER_ATTRIBUTE_SAN_UA_B_EXCLUDED_RES\",false,false);
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
		slot.connecting = false;
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
}

// ###############   Complexity factor input ####################

function san_wbs_form_complexity_factor_slot_reader() {
		return san_wbs_form_slot_reader(this.ONB,\"USER_ATTRIBUTE_SAN_UA_N_COMPLEXITY_FACTOR\",1,0);
}

function san_wbs_form_complexity_factor_slot_modifier(nvalue) {
	return san_wbs_form_slot_modifier(nvalue,this.ONB,\"USER_ATTRIBUTE_SAN_UA_N_COMPLEXITY_FACTOR\",1);
}

function san_wbs_form_complexity_factor_slot_locker() {
    return san_wbs_form_slot_locker();
}

function san_pjs_create_dynamic_attribute_complexity_factor(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_COMPLEXITY_FACTOR\",\"NUMBER\");
        slot.Comment = \"Complexity factor\";
        slot.Reader = san_wbs_form_complexity_factor_slot_reader;
        slot.Modifier = san_wbs_form_complexity_factor_slot_modifier;
        slot.Locker = san_wbs_form_complexity_factor_slot_locker;
        slot.hiddenInIntranetServer = false;
		slot.connecting = false;
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
	return san_wbs_form_parent_slot_reader(this.ONB,\"USER_ATTRIBUTE_SAN_UA_N_COMPLEXITY_FACTOR\",1,0);
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
		slot.connecting = false;
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
		return san_wbs_form_slot_reader(this.ONB,\"USER_ATTRIBUTE_SAN_UA_S_LEADER\",\"\",\"\");
}

function san_wbs_form_leader_slot_modifier(nvalue) {
    return san_wbs_form_slot_modifier_leader(nvalue,this.ONB,\"USER_ATTRIBUTE_SAN_UA_S_LEADER\",\"\");
}

function san_wbs_form_leader_slot_locker() {
    return san_wbs_form_slot_locker();
}

function san_pjs_create_dynamic_attribute_leader(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_LEADER\",plc.resource);
        slot.Comment = \"Leader\";
        slot.Reader = san_wbs_form_leader_slot_reader;
        slot.Modifier = san_wbs_form_leader_slot_modifier;
        slot.Locker = san_wbs_form_leader_slot_locker;
        slot.hiddenInIntranetServer = false;
		slot.connecting = false;
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
    return san_wbs_form_parent_slot_reader(this.ONB,\"USER_ATTRIBUTE_SAN_UA_S_LEADER\",\"\",\"\");
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
		slot.connecting = false;
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
	return san_wbs_form_slot_reader(this.ONB,\"USER_ATTRIBUTE_SAN_UA_S_LEADER_SITE\",\"ND\",\"\");
}

function san_wbs_form_leader_site_slot_modifier(nvalue) {
	if (this.SAN_UA_RDPM_B_DISPLAYED_WBS_FORM_PHARMA){
		var field=\"USER_ATTRIBUTE_SAN_UA_S_LEADER_SITE\";
		var role_onb=this.ONB;
		var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
		var result=\"\";
		var result=san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,nvalue);
		san_pjs_rdpm_update_activity_leader_site(role_onb,field,nvalue);
		return result;
	}
}

function san_wbs_form_leader_site_slot_locker() {
	var lock =san_wbs_form_slot_locker();
	
	if (lock==false)
	{
		var leader_site=\"\";
		var role_onb=this.ONB;
		var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
		
		var leader=san_pjs_get_upper_level_value(act_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_LEADER\");
		if (leader!=\"\" && leader!=undefined && leader!=false && leader.internal==false)
		{
			lock=true;
		}
	}
    return lock;
}

function san_pjs_create_dynamic_attribute_leader_site(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_LEADER_SITE\",plc._RM_REVIEW_PT_LOCATIONS);
        slot.Comment = \"Site of the leader\";
        slot.Reader = san_wbs_form_leader_site_slot_reader;
        slot.Modifier = san_wbs_form_leader_site_slot_modifier;
        slot.Locker = san_wbs_form_leader_site_slot_locker;
        slot.hiddenInIntranetServer = false;
		slot.connecting = false;
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
    if (this.SAN_UA_RDPM_B_DISPLAYED_WBS_FORM_PHARMA ){
        var result=\"ND\";
    	var leader_site=\"\";
        var role_onb=this.ONB;
        var act_onb=context.SAN_UA_TMP_CURRENT_ACT_WBS_FORM_ONB;
    	var act_onb_number=act_onb.parsenumber();
    	var act=plc.work_structure.get(act_onb_number);
    	if (act!=undefined && act!=false && act.internal==false)
    	{
    		var act_parent=act.WBS_ELEMENT;
    		if (act_parent!=undefined && act_parent!=false && act_parent.internal==false)
    		{
    			var act_parent_onb=act_parent.ONB.tostring();
    			
    			var leader=san_pjs_get_upper_level_value(act_parent_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_LEADER\");
    			if (leader instanceof plc.resource)
    			{
    				leader_site=leader._RM_REVIEW_RA_LOCATION;
    				if (leader_site!=undefined && leader_site!=false && leader_site.internal==false)
    				{
    					result=leader_site;
    				}
    			}
    			
    			if (result!=\"\")
    			{
    				var entered_value=san_pjs_get_upper_level_value(act_parent_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_LEADER_SITE\");
    				if (entered_value!=undefined && entered_value!=false) result=entered_value;
    			}
    		}
    	}
    	else
    	{
    	    result=\"\";
    	}
    
        return result;
    }
}

function san_wbs_form_leader_site_parent_slot_locker() {
    return true;
}

function san_pjs_create_dynamic_attribute_leader_site_parent(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_LEADER_SITE_PARENT\",plc._RM_REVIEW_PT_LOCATIONS);
        slot.Comment = \"Site of the leader (Parent)\";
        slot.Reader = san_wbs_form_leader_site_parent_slot_reader;
        slot.Locker = san_wbs_form_leader_site_parent_slot_locker;
        slot.hiddenInIntranetServer = false;
		slot.connecting = false;
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


// ###############   # Lot(s) input ####################

function san_wbs_form_num_lot_slot_reader() {
		return san_wbs_form_slot_reader(this.ONB,\"USER_ATTRIBUTE_SAN_UA_N_NUM_LOT\",1,0);
}

function san_wbs_form_num_lot_slot_modifier(nvalue) {
	return san_wbs_form_slot_modifier(nvalue,this.ONB,\"USER_ATTRIBUTE_SAN_UA_N_NUM_LOT\",1);
}

function san_wbs_form_num_lot_slot_locker() {
    return san_wbs_form_slot_locker();
}

function san_pjs_create_dynamic_attribute_num_lot(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_N_NUM_LOT\",\"NUMBER\");
        slot.Comment = \"# Lot(s)\";
        slot.Reader = san_wbs_form_num_lot_slot_reader;
        slot.Modifier = san_wbs_form_num_lot_slot_modifier;
        slot.Locker = san_wbs_form_num_lot_slot_locker;
        slot.hiddenInIntranetServer = false;
		slot.connecting = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_num_lot();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_N_NUM_LOT\");
    plw.writeln(e);
}

// ###############   # Test(s) input ####################

function san_wbs_form_num_test_slot_reader() {
		return san_wbs_form_slot_reader(this.ONB,\"USER_ATTRIBUTE_SAN_UA_N_NUM_TEST\",1,0);
}

function san_wbs_form_num_test_slot_modifier(nvalue) {
	return san_wbs_form_slot_modifier(nvalue,this.ONB,\"USER_ATTRIBUTE_SAN_UA_N_NUM_TEST\",1);
}

function san_wbs_form_num_test_slot_locker() {
    return san_wbs_form_slot_locker();
}

function san_pjs_create_dynamic_attribute_num_test(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_N_NUM_TEST\",\"NUMBER\");
        slot.Comment = \"# Test(s)\";
        slot.Reader = san_wbs_form_num_test_slot_reader;
        slot.Modifier = san_wbs_form_num_test_slot_modifier;
        slot.Locker = san_wbs_form_num_test_slot_locker;
        slot.hiddenInIntranetServer = false;
		slot.connecting = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_num_test();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_N_NUM_TEST\");
    plw.writeln(e);
}

// ###############   # Sample(s) input ####################

function san_wbs_form_num_sample_slot_reader() {
		return san_wbs_form_slot_reader(this.ONB,\"USER_ATTRIBUTE_SAN_UA_N_NUM_SAMPLE\",1,0);
}

function san_wbs_form_num_sample_slot_modifier(nvalue) {
	return san_wbs_form_slot_modifier(nvalue,this.ONB,\"USER_ATTRIBUTE_SAN_UA_N_NUM_SAMPLE\",1);
}

function san_wbs_form_num_sample_slot_locker() {
    return san_wbs_form_slot_locker();
}

function san_pjs_create_dynamic_attribute_num_sample(){
    try{
        var slot = new objectAttribute(plc._RM_REVIEW_PT_ROLE,\"SAN_DA_N_NUM_SAMPLE\",\"NUMBER\");
        slot.Comment = \"# Sample(s)\";
        slot.Reader = san_wbs_form_num_sample_slot_reader;
        slot.Modifier = san_wbs_form_num_sample_slot_modifier;
        slot.Locker = san_wbs_form_num_sample_slot_locker;
        slot.hiddenInIntranetServer = false;
		slot.connecting = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_num_sample();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create SAN_DA_N_NUM_SAMPLE\");
    plw.writeln(e);
}

// ###############  Dynamic attribute to identify duplicates in WBS Form Data table  ####################

function wbs_form_data_duplicate_reader()
{
	var activity = this.SAN_UA_WBS_FORM_DATA_ACTIVITY;
	var role = this.SAN_UA_WBS_FORM_DATA_ROLE;
	var file = this.FILE;
	var onb=this.ONB;
	var duplicate=false;
	
	if (activity!=\"\" && role!=\"\")
	{
		for (var wbs_form_data in activity.get(\"USER_ATTRIBUTE_INVERSE_SAN_UA_WBS_FORM_DATA_ACTIVITY.__USER_TABLE_SAN_RDPM_UT_WBS_FORM_DATA\") where wbs_form_data.SAN_UA_WBS_FORM_DATA_ROLE==role order by ['ONB']) {
			if (onb>wbs_form_data.ONB) {
				duplicate=true;
				break;			
			}		
		}
	}
	return duplicate;
}

var slot = new objectAttribute(plc.__USER_TABLE_SAN_RDPM_UT_WBS_FORM_DATA,\"SAN_RDPM_DA_B_WBS_FORM_DATA_DUPLICATED\",\"BOOLEAN\");
slot.Comment = \"Duplicated WBS Form Data?\";
slot.Reader = wbs_form_data_duplicate_reader;
slot.Locker = function () {return true;};
slot.hiddenInIntranetServer = false;
slot.connecting = false;




// Reader (Generic for WBS form data)
function san_wbs_form_slot_wbsf_data_reader(field,default_val,empty_val) {
	var result=default_val;
	var role_onb=this.SAN_UA_WBS_FORM_DATA_ROLE_ONB;
	var act_onb=this.SAN_UA_WBS_FORM_DATA_ACTIVITY_ONB.tostring(\"####\");
	var entered_value=san_pjs_get_upper_level_value(act_onb,role_onb,field);
	if (entered_value!=undefined && entered_value!=false) result=entered_value;
	return result;
}

// Modifier (Generic for WBS form data)
function san_wbs_form_slot_wbsf_data_modifier(nvalue,field,default_val) {
	if (nvalue==\"\" || nvalue==undefined) nvalue=default_val;
	var role_onb=this.SAN_UA_WBS_FORM_DATA_ROLE_ONB;
	var act_onb=this.SAN_UA_WBS_FORM_DATA_ACTIVITY_ONB.tostring(\"####\");
	var result=san_pjs_set_wbs_form_data_value(act_onb,role_onb,field,nvalue);
	if (field==\"USER_ATTRIBUTE_SAN_UA_S_LEADER\")
	{
		// Set leader site as ND --> Value will be resource value
		// PC-6431 Remove the part to initialise a value for Leader site on Leader modification
		// san_pjs_set_wbs_form_data_value(act_onb,role_onb,\"USER_ATTRIBUTE_SAN_UA_S_LEADER_SITE\",\"ND\");
		// Update leader on tasks
    	san_pjs_rdpm_update_activity_leader(act_onb,role_onb,field,nvalue);
	}
	return result;
}

// Locker (Generic for WBS form data)
function san_wbs_form_slot_wbsf_data_locker(field)
{
	var result = true;
	var act_onb_number=this.SAN_UA_WBS_FORM_DATA_ACTIVITY_ONB;
	var role_onb=this.SAN_UA_WBS_FORM_DATA_ROLE_ONB;
	var act=plc.work_structure.get(math.round(act_onb_number));
	if (act!=undefined && act!=false && act.internal==false && act.project.WRITABLE)
	{
		result = false;
	}
	if (field==\"USER_ATTRIBUTE_SAN_UA_S_LEADER_SITE\" && result==false)
	{
		var leader=san_pjs_get_upper_level_value(\"PRINT_NUMBER\".callmacro(act_onb_number,\"####\"),role_onb,\"USER_ATTRIBUTE_SAN_UA_S_LEADER\");
		if (leader!=\"\" && leader!=undefined && leader!=false && leader.internal==false)
		{
			result=true;
		}
	}
	return result;
}

// ###############  Dynamic attribute in WBS Form Data table  ####################
function san_pjs_create_dynamic_attribute_wbs_form_data()
{
	var vHash=new hashtable(\"STRING\");
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_S_LEADER\",['','','Leader',plc.resource.name]);
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_S_LEADER_SITE\",['ND','','Leader Site',plc._RM_REVIEW_PT_LOCATIONS.name]);
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_S_SOURCING\",['INT','','Sourcing',plc._INF_PT_CBS2.name]);
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_S_PROVIDER\",['','','Provider',plc._INF_PT_CBS3.name]);
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_S_TEAM\",['','','Team',plc.Resource.name]);
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_B_EXCLUDED_RES\",[false,false,'Excluded resource','BOOLEAN']);
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_N_COMPLEXITY_FACTOR\",[1,0,'Complexity factor','NUMBER']);
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_N_NUM_SAMPLE\",[1,0,'# Sample(s)','NUMBER']);
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_N_NUM_LOT\",[1,0,'# Lot(s)','NUMBER']);
	vHash.set(\"USER_ATTRIBUTE_SAN_UA_N_NUM_TEST\",[1,0,'# Test(s)','NUMBER']);
	
	for (var vSlotField in vHash)
	{
		var vVect=vHash.get(vSlotField);
		var vDynName=vSlotField.replaceregexp(\"USER_ATTRIBUTE_\",\"\");
		vDynName=vDynName.replaceregexp(\"_UA_\",\"_DA_\");
		var slot = new objectAttribute(plc.__USER_TABLE_SAN_RDPM_UT_WBS_FORM_DATA,vDynName,vVect[3]);
		slot.Comment = vVect[2];
		slot.Reader = san_wbs_form_slot_wbsf_data_reader.closure(vSlotField,vVect[0],vVect[1]);
		slot.Modifier = san_wbs_form_slot_wbsf_data_modifier.closure(vSlotField,vVect[0]);
		slot.Locker = san_wbs_form_slot_wbsf_data_locker.closure(vSlotField);
		slot.hiddenInIntranetServer = false;
		slot.connecting = false;
	}
}
try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_wbs_form_data();
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create dynamic attributes on WBS Form data\");
    plw.writeln(e);
}

"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 35
 :_US_AA_B_BATCH_SCRIPT "0"
 :_US_AA_D_CREATION_DATE 20201001000000
 :_US_AA_S_OWNER "intranet"
)