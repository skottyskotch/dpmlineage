
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260010403574
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _wbs_form;

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
	var result=\"\";
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
	san_pjs_rdpm_update_activity_leader_site(act_onb,role_onb,field,nvalue);
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
 :USER-SCRIPT 260009651974
 :VERSION 2
 :_US_AA_D_CREATION_DATE 20201002000000
 :_US_AA_S_OWNER "E0296878"
)