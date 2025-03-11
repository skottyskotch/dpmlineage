
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 282706523741
 :DATASET 118081000141
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_RDPM_JS2_DYN_ATTRIBUTES
//
//
//  Modification : 2020/01/12 IGU
//  Dynamic attributes to manage PRIME - RDPM fields governance added
//
//
//***************************************************************************/

namespace _san_rdpm_dyn_attribute;

// ################  PC-2783  ################

function san_get_long_absence_on_timecard_slot_reader() {
	var result=false;
	var timecard=this;
	var res=timecard.RESOURCE;
	var tc_start=timecard.START_DATE;
	var tc_end=timecard.END_DATE;
	
	if (res!=undefined) {
		with(res.fromobject()) {
			for (var avail in plc.avaibility where avail.TYPE==\"Absence\") {
				if (avail.sd<=tc_start && avail.fd>=tc_end) {
					return true;
				}
			}
		}
	}
	return result;
}

function san_create_exists_long_absence_on_timecard_dynamic_attribute(){
	try{
		var slot = new objectAttribute(plc.timecard,\"SAN_RDPM_DYN_ATT_B_TC_ABS\",\"BOOLEAN\");
		slot.Comment = \"[DynAtt TimeCard] Long absence?\";
		slot.Reader = san_get_long_absence_on_timecard_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot SAN_RDPM_DYN_ATT_B_TC_ABS due to error: \" + e);
	}
}

try{
	with(plw.no_locking){
		san_create_exists_long_absence_on_timecard_dynamic_attribute();
	}
}
catch (error e){
	plw.writeToLog(\"Failed to create SAN_RDPM_DYN_ATT_B_TC_ABS\");
	plw.writeln(e);
}

// ################  End PC-2783  ################

// dynamic attribute will be used to retrieve corresponding date and type on each Indication project

function san_next_milestone_prj_slot_reader() {
	var result=0;
	var prj=this;
	var wbs_ind=undefined;
	
	// retrieve top level activity
	var tlws = prj.getlistofrootws();
    if ( tlws instanceof list && 
		tlws.length > 0 && 
		tlws[0] instanceof plc.workstructure){
		wbs_ind = tlws[0];
	}
	
	if (wbs_ind.SAN_UA_B_ACT_IS_LEAD_INDICATION) {
		// WBS_TYPE are project objective type if its reporting milestone type is \"Project Objective\"
		var o_proj_obj = plc.__USER_TABLE_SAN_RDPM_UT_REPORT_MILE_TYPE.get(context.SAN_RDPM_CS_PROJECT_OBJECTIVE);
		for (var o_wbstype in o_proj_obj.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_AT_REPORT_MILE_TYPE\")) {
			with (o_wbstype.fromobject()) {
				for (var ms in plc.task where (ms.PROJECT==prj && ms.AF==undefined) order by [\"PS\"]) {
					return ms.onb;
				}
			}
		}
	}
	return result;
}

function san_next_milestone_create_prj_dynamic_attribute(){
	try{
		var slot = new objectAttribute(plc.project,\"SAN_RDPM_DA_PRJ_NEXT_MILESTONE_ONB\",\"NUMBER\");
		slot.Comment = \"[DynAtt project] Next milestone ONB\";
		slot.Reader = san_next_milestone_prj_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

try{
	with(plw.no_locking){
		san_next_milestone_create_prj_dynamic_attribute();
	}
}
catch (error e){
	plw.writeToLog(\"Failed to create SAN_RDPM_DA_PRJ_NEXT_MILESTONE_ONB\");
	plw.writeln(e);
}

// *********************   Planned start of milestones   *********************

function san_milestone_with_wbs_type_ps_slot_reader(o_wbstype) {
	var result=0;
	var prj=this;
	var wbs_ind=undefined;
	
	if (o_wbstype != undefined) {
		// retrieve top level activity
		var tlws = prj.getlistofrootws();
		if ( tlws instanceof list && 
			tlws.length > 0 && 
			tlws[0] instanceof plc.workstructure){
			wbs_ind = tlws[0];
		}
		
		if (wbs_ind.SAN_UA_B_ACT_IS_LEAD_INDICATION) {
			with (o_wbstype.fromobject()) {
				for (var ms in plc.task where (ms.PROJECT==prj) order by [\"PS\"]) {
					return ms.PS;
				}
			}
		}
	}
	return result;
}

function san_create_prj_ind_milestone_ps_dynamic_attribute(field_name,field_desc,wbs_type_arg){
	try{
		var slot = new objectAttribute(plc.project,field_name,\"DATE\");
		slot.Comment = \"[DynAtt project indication] \"+field_desc;
		slot.Reader = san_milestone_with_wbs_type_ps_slot_reader.closure(wbs_type_arg);
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot [\"+field_name+\"] due to error: \" + e);
	}
}

// *********************   Dynamic attributes to manage PRIME - RDPM fields governance   *********************

//Project dynamic attributes (PC-2572)
function san_prj_prime_gov_slot_reader(s_prj_slot,s_prj_code_slot) {
	var o_prj = this;
	if(o_prj.SAN_UA_RWE_PROJECT_CODE_PRIME instanceof plc.__USER_TABLE_SAN_RWE_UT_PROJECT_CODES && (o_prj.getinternalvalue('STATE').toString()=='ACTIVE' || o_prj._PM_NF_B_IS_A_VERSION==true)){
		return o_prj.SAN_UA_RWE_PROJECT_CODE_PRIME.get(s_prj_code_slot);
	}
	else{
		return o_prj.get(s_prj_slot);
	}
}

function san_prj_prime_gov_slot_modifier(newValue,s_prj_slot) {
	var o_prj = this;
	o_prj.set(s_prj_slot,newValue);
}

function san_prj_prime_gov_slot_locker() {
	var o_prj = this;
	if(o_prj.SAN_UA_RWE_PROJECT_CODE_PRIME instanceof plc.__USER_TABLE_SAN_RWE_UT_PROJECT_CODES && (o_prj.getinternalvalue('STATE').toString()=='ACTIVE' || o_prj._PM_NF_B_IS_A_VERSION==true)){
		return true;
	}
	else{
		return false;
	}
}

function san_create_prj_prime_gov_dynamic_attributes(s_prj_slot,s_prj_code_slot,s_da_name){
	var o_prj_slot = plc.ordo_project.getslot(s_prj_slot);
	var o_prj_slot_type = o_prj_slot.descriptor.type.name;
	
	try{
		var slot = new objectAttribute(plc.ordo_project,s_da_name,o_prj_slot_type);
		
		if (o_prj_slot_type.name.matchregexp('^\\.\\.\\.')){
			slot.setPlist(new symbol(\"LIST-CLASS\",\"KEYWORD\"), new symbol(o_prj_slot_type.name.replaceregexp('\\.\\.\\.',''),o_prj_slot_type.package));
		}

		slot.Comment = o_prj_slot.descriptor.comment;
		slot.Reader = san_prj_prime_gov_slot_reader.closure(s_prj_slot,s_prj_code_slot);
		slot.Modifier = san_prj_prime_gov_slot_modifier.closure(s_prj_slot);
		slot.Locker = san_prj_prime_gov_slot_locker;
		slot.hiddenInIntranetServer = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot [\"+s_da_name+\"] due to error: \" + e);
	}
}

//Study dynamic attributes (PC-2573)
function san_act_prime_gov_slot_reader(s_act_slot,s_study_code_slot,s_da_name) {
	var o_act = this;
	var o_root_prj = plc.ordo_project.get(o_act.PROJECT.get('SAN_RDPM_UA_PRJ_S_ROOT_PROJECT'));
	if(o_act.SAN_UA_RDPM_B_IS_A_STUDY && o_act.SAN_UA_ACT_STUDY_CODE instanceof plc.__USER_TABLE_SAN_RWE_PRIME_CODES && (o_root_prj.getinternalvalue('STATE').toString()=='ACTIVE' || o_root_prj._PM_NF_B_IS_A_VERSION==true)){
		return o_act.SAN_UA_ACT_STUDY_CODE.get(s_study_code_slot);
	}
	else if (o_act.SAN_UA_RDPM_B_IS_A_STUDY){
		return o_act.get(s_act_slot);
	}
	else{
		var o_study_act = plc.work_structure.get(o_act.SAN_UA_RDPM_ACT_S_STUDY_ID);
		if (o_study_act instanceof plc.work_structure) {return o_study_act.get(s_da_name);}
	}
}

function san_act_prime_gov_slot_modifier(newValue,s_act_slot) {
	var o_act = this;
	o_act.set(s_act_slot,newValue);
}

function san_act_prime_gov_slot_locker(s_act_slot) {
	var o_act = this;
	var o_root_prj = plc.ordo_project.get(o_act.PROJECT.get('SAN_RDPM_UA_PRJ_S_ROOT_PROJECT'));
	if(o_act.SAN_UA_RDPM_B_IS_A_STUDY==false){
		return true;
	}
	else if(o_act.SAN_UA_RDPM_B_IS_A_STUDY && o_act.SAN_UA_ACT_STUDY_CODE instanceof plc.__USER_TABLE_SAN_RWE_PRIME_CODES && (o_root_prj.getinternalvalue('STATE').toString()=='ACTIVE' || o_root_prj._PM_NF_B_IS_A_VERSION==true)){
		return true;
	}
	else{
		return false;
	}
}

function san_create_act_prime_gov_dynamic_attributes(s_act_slot,s_study_code_slot,s_da_name){
	var o_act_slot = plc.work_structure.getslot(s_act_slot);
	var o_act_slot_type = o_act_slot.descriptor.type.name;
	
	try{
		var slot = new objectAttribute(plc.work_structure,s_da_name,o_act_slot_type);
		
		if (o_act_slot_type.name.matchregexp('^\\.\\.\\.')){
			slot.setPlist(new symbol(\"LIST-CLASS\",\"KEYWORD\"), new symbol(o_act_slot_type.name.replaceregexp('\\.\\.\\.',''),o_act_slot_type.package));
		}

		slot.Comment = o_act_slot.descriptor.comment;
		slot.Reader = san_act_prime_gov_slot_reader.closure(s_act_slot,s_study_code_slot,s_da_name);
		slot.Modifier = san_act_prime_gov_slot_modifier.closure(s_act_slot);
		slot.Locker = san_act_prime_gov_slot_locker.closure(s_act_slot);
		slot.hiddenInIntranetServer = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot [\"+s_da_name+\"] due to error: \" + e);
	}
}


// retrieving different WBS_TYPE, and create associated dynamic attributes
// the dynamic attributes created are hidden, and used by user attributes on projects
var wbs_type_Proof_of_Concept=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_POC_LEAD_INDICATION);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PS_POC\",\"PS of Proof of concept on lead indication\",wbs_type_Proof_of_Concept);

var wbs_type_Pre_Candidate_Selection=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_PRECANDIDATE_LEAD_INDICATION);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PS_Pre_Candidate_Selection\",\"PS of Pre Candidate Selection on lead indication\",wbs_type_Pre_Candidate_Selection);

var wbs_type_Start_of_Screening=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_SCREENING_LEAD_INDICATION);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PS_Start_of_Screening\",\"PS of Start of Screening on lead indication\",wbs_type_Start_of_Screening);

var wbs_type_Submission=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_SUBMISSION_LEAD_INDICATION);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PS_Submission\",\"PS of Submission on lead indication\",wbs_type_Submission);

var wbs_type_First_Dose_in_GLP_TOX=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_1ST_DOSE_GLP_TOX_LEAD_INDICATION);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PS_First_Dose_in_GLP_TOX\",\"PS of First Dose in GLP TOX on lead indication\",wbs_type_First_Dose_in_GLP_TOX);

var wbs_type_Approval=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_APPROVAL);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PS_Approval\",\"PS of Approval on lead indication\",wbs_type_Approval);

var wbs_type_GNG_Filing=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_GNG_FILING_LEAD_INDICATION);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PS_GNG_Filing\",\"PS of GNG Filing on lead indication\",wbs_type_GNG_Filing);

var wbs_type_GNG_Ph2A=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_GNG_PH2A_LEAD_INDICATION);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PS_GNG_Ph2A\",\"PS of GNG Ph2A on lead indication\",wbs_type_GNG_Ph2A);

var wbs_type_GNG_Ph2B=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_GNG_PH2B_LEAD_INDICATION);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PS_GNG_Ph2B\",\"PS of GNG Ph2B on lead indication\",wbs_type_GNG_Ph2B);

var wbs_type_GNG_Ph02=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_GNG_PH2_LEAD_INDICATION);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PS_GNG_Ph02\",\"PS of GNG Ph02 on lead indication\",wbs_type_GNG_Ph02);

var wbs_type_GNG_Ph03=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_GNG_PH3_LEAD_INDICATION);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PS_GNG_Ph03\",\"PS of GNG Ph03 on lead indication\",wbs_type_GNG_Ph03);

var wbs_type_Target_Selection_M0=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_M0_LEAD_INDICATION);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PS_Target_Selection_M0\",\"PS of Target Selection M0 on lead indication\",wbs_type_Target_Selection_M0);

var wbs_type_Lead_Selection_M1=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_M1_LEAD_INDICATION);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PS_Lead_Selection_M1\",\"PS of Lead Selection M1 on lead indication\",wbs_type_Lead_Selection_M1);

var wbs_type_Start_Development_M2=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_M2_LEAD_INDICATION);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PS_Start_Development_M2\",\"PS of Start Development M2 on lead indication\",wbs_type_Start_Development_M2);

var wbs_type_Start_Ph01=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_PH1_LEAD_INDICATION);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PS_Start_Ph01\",\"PS of Start Ph01 on lead indication\",wbs_type_Start_Ph01);

var wbs_type_Start_Ph2A=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_PH2A_LEAD_INDICATION);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PS_Start_Ph2A\",\"PS of Start Ph2A on lead indication\",wbs_type_Start_Ph2A);

var wbs_type_Start_Ph2B=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_PH2B_LEAD_INDICATION);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PS_Start_Ph2B\",\"PS of Start Ph2B on lead indication\",wbs_type_Start_Ph2B);

var wbs_type_Start_Ph02=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_PH2_LEAD_INDICATION);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PSStart_Ph02\",\"PS of Start Ph02 on lead indication\",wbs_type_Start_Ph02);

var wbs_type_Start_Ph03=plc.WBS_TYPE.get(context.SAN_RDPM_CS_AT_PH3_LEAD_INDICATION);
san_create_prj_ind_milestone_ps_dynamic_attribute(\"SAN_RDPM_DA_PRJ_PS_Start_Ph03\",\"PS of Start Ph03 on lead indication\",wbs_type_Start_Ph03);

//Project dynamic attributes creation
san_create_prj_prime_gov_dynamic_attributes('SAN_RDPM_UA_PRJ_UA_CODEV_PARTNER','SAN_UA_PC_PARTNER','SAN_RDPM_DA_PRJ_UA_CODEV_PARTNER');
san_create_prj_prime_gov_dynamic_attributes('SAN_RDPM_UA_S_MOA','SAN_UA_PC_S_MECANISM_OF_ACTION','SAN_RDPM_DA_S_MOA');
san_create_prj_prime_gov_dynamic_attributes('SAN_RDPM_UA_MOLECULE_SUB_TYPE','SAN_UA_PC_S_MOLECULE_TYPE','SAN_RDPM_DA_MOLECULE_SUB_TYPE');
san_create_prj_prime_gov_dynamic_attributes('SAN_RDPM_UA_PROJECT_CATEGORY','SAN_UA_PC_PROJECT_CATEGORY','SAN_RDPM_DA_PROJECT_CATEGORY');

//Study dynamic attributes creation
san_create_act_prime_gov_dynamic_attributes('SAN_UA_ACT_STUDY_PHASE','SAN_UA_RWE_STUDY_PHASE','SAN_DA_ACT_STUDY_PHASE');
//san_create_act_prime_gov_dynamic_attributes('SAN_RDPM_UA_CLIN_INDICATION','SAN_UA_RWE_INDICATION','SAN_RDPM_DA_CLIN_INDICATION');
san_create_act_prime_gov_dynamic_attributes('SAN_RDPM_UA_ACT_THERAPEUTIC_AREA','SAN_UA_RWE_STUDY_TA','SAN_RDPM_DA_ACT_THERAPEUTIC_AREA');
san_create_act_prime_gov_dynamic_attributes('SAN_UA_ACT_STUDY_GROUP','SAN_UA_RWE_S_STUDY_GROUP','SAN_DA_ACT_STUDY_GROUP');
san_create_act_prime_gov_dynamic_attributes('SAN_RDPM_UA_S_PHARMA_EXT_CODE','SAN_UA_SC_S_EXTERNAL_STUDY_CODE','SAN_RDPM_DA_S_PHARMA_EXT_CODE');
san_create_act_prime_gov_dynamic_attributes('SAN_UA_ACT_B_IN_HUMAN','SAN_UA_SC_B_IN_HUMAN','SAN_DA_ACT_B_IN_HUMAN');
san_create_act_prime_gov_dynamic_attributes('SAN_UA_ACT_STUDY_PURPOSE','SAN_UA_SC_STUDY_PURPOSE','SAN_DA_ACT_STUDY_PURPOSE');"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 262044406270
 :VERSION 9
 :_US_AA_D_CREATION_DATE 20210113000000
 :_US_AA_S_OWNER "E0448344"
)