
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 336984096041
 :NAME "SAN_RDPM_JS2_DYN_ATTRIBUTES_02"
 :COMMENT "RDPM Dynamic attributes 02 PC-6558 spin-off"
 :ACTIVE T
 :DATASET 118081000141
 :EVAL-ON-LOAD T
 :LOAD-ORDER 0
 :SCRIPT-CODE "// PC-6958 Spin-off from SAN_RDPM_JS2_DYN_ATTRIBUTES
// --> RPP Dynamic attributes
// --> Development Strategy Dynamic attributes
// --> TAs Metrics Dynamic attributes

namespace _san_rdpm_dyn_attribute;

///////////////////////////////////////////////////////////////////////////////////////
//********************************RPP Dynamic attributes******************************//
///////////////////////////////////////////////////////////////////////////////////////

function san_rpp_slot_reader(slot_act_type,date_slot) {
	var vAct = this;
	var wbs_type;
	var wbs_type_filter;
	var result = undefined;
	var vec_wbs_type;
	var filter_vec = new vector();
	if (vAct instanceof plc.workstructure)
	{
		wbs_type= vAct.WBS_TYPE;
		if (wbs_type instanceof plc.WBS_TYPE && wbs_type.SAN_RDPM_UA_B_RPP_ACT  && wbs_type.get(slot_act_type)!=\"\")
		{
			wbs_type_filter=wbs_type.get(slot_act_type);
			if (wbs_type_filter==wbs_type)
			{
				result=vAct.get(date_slot);
			}
			else
			{
				//Create a vector of activity types
				vec_wbs_type=wbs_type_filter.parselist();
				// Create filter
				for (var at in vec_wbs_type)
				{
					filter_vec.push(plc.wbs_type.get(at));
				}
				filter_vec.push(vAct);
				var filter = plw.objectset(filter_vec);
				with(filter.fromobject()){		
					for(var Act in plc.work_structure order by [['INVERSE','PF']])
					{
						result = Act.get(date_slot);
					}					
				}
			}
		}
	}
	return result;
}

function san_create_rpp_dynamic_attributes(s_da_name,s_da_desc,slot_act_type,date_slot){
	var slot = new objectAttribute(plc.workstructure,s_da_name,\"END-DATE\");
	slot.Comment = s_da_desc;
	slot.Reader = san_rpp_slot_reader.closure(slot_act_type,date_slot);
	slot.Locker = true;
	slot.hiddenInIntranetServer = false;
	slot.connecting = false;
}

san_create_rpp_dynamic_attributes(\"SAN_RDPM_DA_ACT_PLANNED_SUBMISSION\",\"Planned Submission\",\"SAN_RDPM_UA_S_SUBMISSION_WBS_TYPE\",\"PF\");
san_create_rpp_dynamic_attributes(\"SAN_RDPM_DA_ACT_ACTUAL_SUBMISSION\",\"Actual Submission\",\"SAN_RDPM_UA_S_SUBMISSION_WBS_TYPE\",\"AF\");
san_create_rpp_dynamic_attributes(\"SAN_RDPM_DA_ACT_YEARLY_BASELINE_SUBMISSION\",\"Yearly Baseline Submission\",\"SAN_RDPM_UA_S_SUBMISSION_WBS_TYPE\",\"FD_YEARLY_VACCINES\");
san_create_rpp_dynamic_attributes(\"SAN_RDPM_DA_ACT_PLANNED_DISPATCH\",\"Planned Dispatch\",\"SAN_RDPM_UA_S_DISPATCH_WBS_TYPE\",\"PF\");
san_create_rpp_dynamic_attributes(\"SAN_RDPM_DA_ACT_ACTUAL_DISPATCH\",\"Actual Dispatch\",\"SAN_RDPM_UA_S_DISPATCH_WBS_TYPE\",\"AF\");
san_create_rpp_dynamic_attributes(\"SAN_RDPM_DA_ACT_YEARLY_BASELINE_DISPATCH\",\"Yearly Baseline Dispatch\",\"SAN_RDPM_UA_S_DISPATCH_WBS_TYPE\",\"FD_YEARLY_VACCINES\");
san_create_rpp_dynamic_attributes(\"SAN_RDPM_DA_ACT_PLANNED_APPROVAL\",\"Planned Approval\",\"SAN_RDPM_UA_S_APPROVAL_WBS_TYPE\",\"PF\");
san_create_rpp_dynamic_attributes(\"SAN_RDPM_DA_ACT_ACTUAL_APPROVAL\",\"Actual Approval\",\"SAN_RDPM_UA_S_APPROVAL_WBS_TYPE\",\"AF\");
san_create_rpp_dynamic_attributes(\"SAN_RDPM_DA_ACT_YEARLY_BASELINE_APPROVAL\",\"Yearly Baseline Approval\",\"SAN_RDPM_UA_S_APPROVAL_WBS_TYPE\",\"FD_YEARLY_VACCINES\");
// PC-6307
san_create_rpp_dynamic_attributes(\"SAN_RDPM_DA_ACT_MEETING_DATE\",\"Planned Meeting\",\"SAN_RDPM_UA_S_MEETING_WBS_TYPE\",\"PF\");
san_create_rpp_dynamic_attributes(\"SAN_RDPM_DA_ACT_ACTUAL_MEETING\",\"Actual Meeting\",\"SAN_RDPM_UA_S_MEETING_WBS_TYPE\",\"AF\");

///////////////////////////////////////////////////////////////////////////////////////
//********************************Development Strategy Dynamic attributes******************************//
///////////////////////////////////////////////////////////////////////////////////////

function san_slot_reader_development_strategy() {
	var result=\"\";
	var act=this;
	var dev_strat_act=act.SAN_RDPM_UA_S_DEV_STRATEGY;
	if (dev_strat_act!=\"\") {
		return dev_strat_act;
	}
	else {
		var level=act.LEVEL;
		var curr_level_act=act;
		while (level>1) {
			curr_level_act=curr_level_act.WBS_ELEMENT;
			// get parent value
			var parent_val=curr_level_act.SAN_RDPM_UA_S_DEV_STRATEGY;
			if (parent_val!=\"\")  {
				result=parent_val;
				return result;
			}
			level=level-1;
		}
	}
	return result;
}

function san_slot_modifier_development_strategy(value) {
	var act=this;
	act.SAN_RDPM_UA_S_DEV_STRATEGY=value;
}

function san_rdpm_create_slot_dev_strategy(){
	try{
		var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_S_DEV_STRATEGY\",plc.__USER_TABLE_SAN_RDPM_UT_MOLECULE_TYPE);
		slot.Comment = \"Development Strategy\";
		slot.Reader = san_slot_reader_development_strategy;
		slot.Modifier = san_slot_modifier_development_strategy;
		slot.Locker = false;
		slot.hiddenInIntranetServer = false;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

san_rdpm_create_slot_dev_strategy();

///////////////////////////////////////////////////////////////////////////////////////
//********************************TAs Metrics Dynamic attributes******************************//
///////////////////////////////////////////////////////////////////////////////////////

function san_slot_reader(res,skill) {
	var result=false;
	var plh=this;
	var act=plh.ACTIVITY;
	var skill_obj=plc.resourceskill.get(skill);
	var fin_task_type=plc.wbs_type.get(\"Financial Task\");
	var res_obj=plc.resource.get(res);
	
	if (res_obj!=undefined && skill_obj!=undefined && act.WBS_TYPE==fin_task_type) {
		var plh_vect=new vector();
		for (var plh_grpm in act.ALLOCATED_RESOURCES where plh_grpm.RES==res_obj && plh_grpm.PRIMARY_SKILL==skill_obj && plh_grpm.TYPE==\"MANUAL\" order by [['INVERSE','FD'],['INVERSE','ONB']]) {
			plh_vect.push(plh_grpm);
		}
		if (plh_vect.length>0) {
			var found_plh=plh_vect[0];
			if (plh==found_plh) result=true;
		}
	}
	else {
		return result;
	}
	return result;
}

// GRPM PM Research
function san_grpm_pm_slot_reader() {
	return san_slot_reader(\"GRPM\",\"PM\");
}

function san_rdpm_create_slot_grpm_pm(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_GRPM_PM\",\"BOOLEAN\");
		slot.Comment = \"Flag for last GRPM PM\";
		slot.Reader = san_grpm_pm_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

// PH BLG Research
function san_ph_blg_slot_reader() {
	return san_slot_reader(\"PH\",\"BLG\");
}

function san_rdpm_create_slot_ph_blg(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_PH_BLG\",\"BOOLEAN\");
		slot.Comment = \"Flag for last PH BLG\";
		slot.Reader = san_ph_blg_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

// PONC BLG Research
function san_ponc_blg_slot_reader() {
	return san_slot_reader(\"PONC\",\"BLG\");
}

function san_rdpm_create_slot_ponc_blg(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_PONC_BLG\",\"BOOLEAN\");
		slot.Comment = \"Flag for last PONC BLG\";
		slot.Reader = san_ponc_blg_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

// Development Owner ONC
function san_dev_onc_sci_slot_reader() {
	return san_slot_reader(\"BG10-ONC\",\"SCI\");
}

function san_rdpm_create_slot_dev_onc_sci(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_DEV_ONC_SCI\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BG10-ONC SCI\";
		slot.Reader = san_dev_onc_sci_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

function san_dev_onc_crd_slot_reader() {
	return san_slot_reader(\"BG10-ONC\",\"CRD\");
}

function san_rdpm_create_slot_dev_onc_crd(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_DEV_ONC_CRD\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BG10-ONC CRD\";
		slot.Reader = san_dev_onc_crd_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

function san_dev_onc_scs_slot_reader() {
	return san_slot_reader(\"BG10-ONC\",\"SCS\");
}

function san_rdpm_create_slot_dev_onc_scs(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_DEV_ONC_SCS\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BG10-ONC SCS\";
		slot.Reader = san_dev_onc_scs_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

function san_dev_onc_ph_slot_reader() {
	return san_slot_reader(\"BG10-ONC\",\"PH\");
}

function san_rdpm_create_slot_dev_onc_ph(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_DEV_ONC_PH\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BG10-ONC PH\";
		slot.Reader = san_dev_onc_ph_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

// Development Owner IIDF
function san_dev_iidf_crd_slot_reader() {
	return san_slot_reader(\"BE10-IIDF\",\"CRD\");
}

function san_rdpm_create_slot_dev_iidf_crd(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_DEV_IIDF_CRD\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BE10-IIDF CRD\";
		slot.Reader = san_dev_iidf_crd_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

function san_dev_iidf_scs_slot_reader() {
	return san_slot_reader(\"BE10-IIDF\",\"SCS\");
}

function san_rdpm_create_slot_dev_iidf_scs(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_DEV_IIDF_SCS\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BE10-IIDF SCS\";
		slot.Reader = san_dev_iidf_scs_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

function san_dev_iidf_ph_slot_reader() {
	return san_slot_reader(\"BE10-IIDF\",\"PH\");
}

function san_rdpm_create_slot_dev_iidf_ph(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_DEV_IIDF_PH\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BE10-IIDF PH\";
		slot.Reader = san_dev_iidf_ph_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

// Development Owner MSNO
function san_dev_msno_crd_slot_reader() {
	return san_slot_reader(\"BF10-MSNO\",\"CRD\");
}

function san_rdpm_create_slot_dev_msno_crd(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_DEV_MSNO_CRD\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BF10-MSNO CRD\";
		slot.Reader = san_dev_msno_crd_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

function san_dev_msno_scs_slot_reader() {
	return san_slot_reader(\"BF10-MSNO\",\"SCS\");
}

function san_rdpm_create_slot_dev_msno_scs(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_DEV_MSNO_SCS\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BF10-MSNO SCS\";
		slot.Reader = san_dev_msno_scs_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

function san_dev_msno_ph_slot_reader() {
	return san_slot_reader(\"BF10-MSNO\",\"PH\");
}

function san_rdpm_create_slot_dev_msno_ph(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_DEV_MSNO_PH\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BF10-MSNO PH\";
		slot.Reader = san_dev_msno_ph_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

// Development Owner RBD
function san_dev_rbd_crd_slot_reader() {
	return san_slot_reader(\"BI10-RBD\",\"CRD\");
}

function san_rdpm_create_slot_dev_rbd_crd(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_DEV_RBD_CRD\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BI10-RBD CRD\";
		slot.Reader = san_dev_rbd_crd_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

function san_dev_rbd_scs_slot_reader() {
	return san_slot_reader(\"BI10-RBD\",\"SCS\");
}

function san_rdpm_create_slot_dev_rbd_scs(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_DEV_RBD_SCS\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BI10-RBD SCS\";
		slot.Reader = san_dev_rbd_scs_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

function san_dev_rbd_ph_slot_reader() {
	return san_slot_reader(\"BI10-RBD\",\"PH\");
}

function san_rdpm_create_slot_dev_rbd_ph(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_DEV_RBD_PH\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BI10-RBD PH\";
		slot.Reader = san_dev_rbd_ph_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

// Development Owner DIAB
function san_dev_diab_crd_slot_reader() {
	return san_slot_reader(\"BJ20-DIAB\",\"CRD\");
}

function san_rdpm_create_slot_dev_diab_crd(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_DEV_DIAB_CRD\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BJ20-DIAB CRD\";
		slot.Reader = san_dev_diab_crd_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

function san_dev_diab_scs_slot_reader() {
	return san_slot_reader(\"BJ20-DIAB\",\"SCS\");
}

function san_rdpm_create_slot_dev_diab_scs(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_DEV_DIAB_SCS\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BJ20-DIAB SCS\";
		slot.Reader = san_dev_diab_scs_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

function san_dev_diab_ph_slot_reader() {
	return san_slot_reader(\"BJ20-DIAB\",\"PH\");
}

function san_rdpm_create_slot_dev_diab_ph(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_DEV_DIAB_PH\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BJ20-DIAB PH\";
		slot.Reader = san_dev_diab_ph_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

function san_dev_gpman_ppm_slot_reader() {
	return san_slot_reader(\"BP11-GPMAN\",\"PPM\");
}

function san_rdpm_create_slot_dev_gpman_ppm(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_DEV_GPMAN_PPM\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BP11-GPMAN PPM\";
		slot.Reader = san_dev_gpman_ppm_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

function san_dev_gpman_pm_slot_reader() {
	return san_slot_reader(\"BP11-GPMAN\",\"PM\");
}

function san_rdpm_create_slot_dev_gpman_pm(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_DEV_GPMAN_PM\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BP11-GPMAN PM\";
		slot.Reader = san_dev_gpman_pm_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}


//Creation of TAs Dynamic attributes
san_rdpm_create_slot_grpm_pm();
san_rdpm_create_slot_ph_blg();
san_rdpm_create_slot_ponc_blg();
san_rdpm_create_slot_dev_gpman_ppm();
san_rdpm_create_slot_dev_gpman_pm();
san_rdpm_create_slot_dev_onc_sci();
san_rdpm_create_slot_dev_onc_crd();
san_rdpm_create_slot_dev_onc_scs();
san_rdpm_create_slot_dev_onc_ph();
san_rdpm_create_slot_dev_iidf_crd();
san_rdpm_create_slot_dev_iidf_scs();
san_rdpm_create_slot_dev_iidf_ph();
san_rdpm_create_slot_dev_msno_crd();
san_rdpm_create_slot_dev_msno_scs();
san_rdpm_create_slot_dev_msno_ph();
san_rdpm_create_slot_dev_rbd_crd();
san_rdpm_create_slot_dev_rbd_scs();
san_rdpm_create_slot_dev_rbd_ph();
san_rdpm_create_slot_dev_diab_crd();
san_rdpm_create_slot_dev_diab_scs();
san_rdpm_create_slot_dev_diab_ph();

// SKILL below will be BLG or RPH new function
function san_slot_reader_last_value_cluster(skill) {
	var result=false;
	var plh=this;
	//retrieve cluster on project
	var prj=plh.PROJECT;
	
	// retrive cluster code (relation to OBS element)
	var prj_cluster_code_obs_obj=prj.SAN_RDPM_UA_CLUSTER_CODE;
	if (prj_cluster_code_obs_obj!=undefined && prj_cluster_code_obs_obj InstanceOf plc.obs_node) {
		var linked_res_to_cluster=undefined;
		// retrieve generic resource from cluster (must be unique)
		var res_vect=new vector();
		with (prj_cluster_code_obs_obj.fromobject()) {
			for (var res in plc.resource where res._INF_AA_B_GENERIC_RES) {
				res_vect.push(res);
			}
		}
		if (res_vect.length==1) linked_res_to_cluster=res_vect[0];
		
		if (linked_res_to_cluster!=undefined) {
			var act=plh.ACTIVITY;
			var skill_obj=plc.resourceskill.get(skill);
			var fin_task_type=plc.wbs_type.get(\"Financial Task\");
			//var res_obj=plc.resource.get(res);
			
			if (linked_res_to_cluster!=undefined && skill_obj!=undefined && act.WBS_TYPE==fin_task_type) {
				var plh_vect=new vector();
				for (var plh_cluster in act.ALLOCATED_RESOURCES where plh_cluster.RES==linked_res_to_cluster && plh_cluster.PRIMARY_SKILL==skill_obj && plh_cluster.TYPE==\"MANUAL\" order by [['INVERSE','FD'],['INVERSE','ONB']]) {
					plh_vect.push(plh_cluster);
				}
				if (plh_vect.length>0) {
				plw.writetolog(\"plh_vect: \"+plh_vect);
					var found_plh=plh_vect[0];
					if (plh==found_plh) {
						return true;
					}
				}
			}
		}
	}
	return result;
}

function san_slot_reader_last_value_cluster_BLG() {
	return san_slot_reader_last_value_cluster(\"BLG\");
}

function san_slot_reader_last_value_cluster_RPH() {
	return san_slot_reader_last_value_cluster(\"RPH\");
}

function san_rdpm_create_slot_blg_cluster(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_BLG_CLUSTER\",\"BOOLEAN\");
		slot.Comment = \"Flag for last BLG cluster\";
		slot.Reader = san_slot_reader_last_value_cluster_BLG;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

function san_rdpm_create_slot_rph_cluster(){
	try{
		var slot = new objectAttribute(plc.task_alloc,\"SAN_RDPM_DA_LAST_RPH_CLUSTER\",\"BOOLEAN\");
		slot.Comment = \"Flag for last RPH cluster\";
		slot.Reader = san_slot_reader_last_value_cluster_RPH;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

// create the dynamic attribute for blg
san_rdpm_create_slot_blg_cluster();
// create the dynamic attribute for rph
san_rdpm_create_slot_rph_cluster();"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 72
 :_US_AA_B_BATCH_SCRIPT "0"
 :_US_AA_D_CREATION_DATE 20230803000000
 :_US_AA_S_OWNER "intranet"
)