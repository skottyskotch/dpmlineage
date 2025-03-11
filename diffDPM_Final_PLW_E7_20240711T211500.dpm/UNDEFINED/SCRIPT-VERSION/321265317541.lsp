
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321265317541
 :DATASET 118081000141
 :SCRIPT-CODE "// dev
//  PLWSCRIPT : SAN_RDPM_JS2_DYN_ATTRIBUTES
//
//  Modification - GSE - 24/11/2022 : PC-6449 - Creation of Dynamic attribute for TAs metrics
//  Modification - GSE - 24/11/2022 : PC-6465 - Creation of Dynamic attribute for Development Strategy
//  Modification - WST - 13/10/2022 : PC-6307 - Modification style : need \"Planned Meeting\" and \"Actual Meeting\" columns
//  Modification - WST - 04/10/2022 : PC-4731 - Modification to harmonize behavior between pharma and vaccins for san_rdpm_team_member_from_project
//  Modification : 13-JAN-2022 LFA
//  Add control on start date and finish date of availibility on function san_get_long_absence_on_timecard_slot_reader
//  Modification : 2020/01/12 IGU
//  Dynamic attributes to manage PRIME - RDPM fields governance added
//  Modification : 29-JAN-2021 FLC
//  Merge with 'SAN_RDPM_JS2_DYN_REL_PROJ_OBJ_AND_TECH_MIL' to include Project objectives relations & attributes
//  Modification - SAK - 24/03/2021 : PC-3573 - PPM should receives an alert when delay at OL
//  Modification - ABE - 17/06/2021 : PC-452 - Creation of new dynamic attributes Study Sponsorship Type & Study Sponsorship Name
//  Modification - ABE - 28/07/2021 : PC-2960 & PC-3429 - Creation of new dynamic attributes Project role related to team member on Project, Activity, Planned Expenditure, Planned Hour and Actual Hour class. 
//  Modification - ABO - 14/09/2021 : PC-4515 - Creation of new dynamic attributes Root product code related to Activity class.       
//  Modification - LFA - 21/09/2021 : PC-4571 - Modification of function san_rdpm_team_member_from_project_parent and san_rdpm_team_member_from_project to avoid Global Map when calculating fields on indications
//  Modification - LFA - 09/12/2021 : PC-4236 - Creation of dynamic attribute \"All Root Products Codes\"
//  Modification - TGO - 15/12/2021 : PC-3008 - Creation of dynamic attribute \"MCQ score reached?\"
//  Modification - LFA - 14/02/2022 : PC-5675 - Creation of dynamic attributes for RPP Report
//  Modification - ABE - 14/02/2022 : PC-5547 - Modification of san_rdpm_team_member_from_project_parent && san_rdpm_team_member_from_project to take account a new management rule to propagate the project team if the project is pharma or vaccine.
//  Modification - TGO - 24/02/2022 : PC-5656 - Change behavior of dynamic attribute \"MCQ score reached?\"
//  Modification - ABO - 12/04/2022 : PC-515  - Creation of dynamic relation \"My Studies\".
//***************************************************************************/

namespace _san_rdpm_dyn_attribute;

// *********************  Timecard  *********************

// PC-2783 Dynamic attribute \"Long absence?\" on Timecard class
// Used to filter absent people from List timecard screen in the Timecard module
function san_get_long_absence_on_timecard_slot_reader() {
	var result=false;
	var timecard=this;
	var res=timecard.RESOURCE;
	var tc_start=timecard.START_DATE;
	var tc_end=timecard.END_DATE;
	
	if (res!=undefined) {
		with(res.fromobject()) {
			for (var avail in plc.avaibility where avail.TYPE==\"Absence\") {
				if ((avail.sd==undefined || avail.sd<=tc_start) && (avail.fd==undefined || avail.fd>=tc_end)) {
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

// *********************  Project Objectives  *********************

// Function used to list the planned Project Objectives for a given project. Used by the dynamic relation on Project Objectives (Workbox aggregator) and the dynamic attribute \"Next Milestone\" on Project class
function san_rdpm_js2_get_planned_project_objectives(o_project)
{   
	var v_vect_planned_po = new vector();
	
	// Get the list of Project Objectives Activity types
	var list = [];
	for (var o_wbstype in plc.wbs_type where o_wbstype.SAN_RDPM_UA_B_IS_PROJECT_OBJECTIVES) 
		{
			list.push(o_wbstype);
		}
	
	// Loop on Project related Project Objectives
	if(o_project instanceof plc.project)
	{
		list.push(o_project);
		var filter = plw.objectset(list);
		with(filter.fromobject()){
			for (var o_po in plc.task where o_po.AF==undefined order by [\"PS\"])
			{
				v_vect_planned_po.push(o_po);
			}
		}
	}  
	return v_vect_planned_po;
}

// Function used to list \"My active projects\". Used by the dynamic relation on Project Objectives (Workbox aggregator).
function san_rdpm_js2_get_my_active_projects()
{
	var v_vect_my_projects = new vector();
	var o_project_type = plc.project_type.get(\"Continuum.RDPM.Pharma\");
	with(o_project_type.fromobject()){
		for(var o_project in plc.project where o_project.is_active && (o_project.callbooleanformula(\"OWNER = $CURRENT_USER\") || o_project.SAN_RDPM_UA_B_PRJ_PO_NOTIF)){
			v_vect_my_projects.push(o_project);
		}
	}
	return v_vect_my_projects;
}

// Dynamic relation \"My Project Objectives\"
// Function to get all task that is project objetives and linked to the user: only for the project team users
function san_rdpm_my_project_objectives(f)
{
	var v_my_active_projects = san_rdpm_js2_get_my_active_projects();
	var v_my_planned_project_objectives = new vector();
	if(v_my_active_projects.length>0)
	{
		for(var o_project in v_my_active_projects)
		{
			var v_planned_project_objectives = san_rdpm_js2_get_planned_project_objectives(o_project);
			if(v_planned_project_objectives.length>0)
			{
				for(var o_po in v_planned_project_objectives)
				{
					v_my_planned_project_objectives.push(o_po);
				}
			}
		}
	}
	v_my_planned_project_objectives=v_my_planned_project_objectives.removeduplicates();
	if(v_my_planned_project_objectives.length>0){
		for(var o_po in v_my_planned_project_objectives)
		{
		   f.call(o_po);
		}
	}
}

function san_rdpm_dyn_rel_my_prj_objectives(){
  var SAN_RDPM_REL_MY_PRJ_OBJECTIVES = new ObjectRelation(plc.contextopx2,\"SAN_RDPM_REL_MY_PRJ_OBJECTIVES\");
  SAN_RDPM_REL_MY_PRJ_OBJECTIVES.Mapmethod = san_rdpm_my_project_objectives;
  SAN_RDPM_REL_MY_PRJ_OBJECTIVES.ConnectedToClass = plc.task;
  SAN_RDPM_REL_MY_PRJ_OBJECTIVES.Comment = \"[DynRel] My Project Objectives\";
}

try{
	with(plw.no_locking){
		san_rdpm_dyn_rel_my_prj_objectives();
	}
}
catch (error e){
	plw.writeToLog(\"Failed to create SAN_RDPM_REL_MY_PRJ_OBJECTIVES\");
	plw.writeln(e);
}


// Dynamic relation \"My Studies\"
// Function to get all actvities that comes from vaccine projects and are studies

function san_rdpm_my_act_studies(f)
{
	//var v_my_active_projects = san_rdpm_js2_get_my_active_projects();
	var v_my_studies_codes = new vector();
	for (var o_proj in plc.project where o_proj.SAN_RDPM_B_RND_VACCINES_PROJECT) 
	{
		with(o_proj.fromobject()) 
		{	
			for(var o_act in plc.work_structure where o_act.SAN_UA_RDPM_B_IS_A_STUDY)
			{			
				v_my_studies_codes.push(o_act);		
				
			}
		}
	}
	v_my_studies_codes=v_my_studies_codes.removeduplicates();
	
	if(v_my_studies_codes.length>0){
		for(var o_study_code in v_my_studies_codes)
		{
		   f.call(o_study_code);
		}
	}	
}




function san_rdpm_dyn_rel_my_studies_codes(){
  var SAN_RDPM_REL_MY_ACT_STUDIES = new ObjectRelation(plc.contextopx2,\"SAN_RDPM_REL_MY_ACT_STUDIES\");
  SAN_RDPM_REL_MY_ACT_STUDIES.Mapmethod = san_rdpm_my_act_studies;
  SAN_RDPM_REL_MY_ACT_STUDIES.ConnectedToClass = plc.work_structure;
  SAN_RDPM_REL_MY_ACT_STUDIES.Comment = \"[DynRel] My Studies\";
}

try{
	with(plw.no_locking){
		san_rdpm_dyn_rel_my_studies_codes();
	}
}
catch (error e){
	plw.writeToLog(\"Failed to create SAN_RDPM_REL_MY_ACT_STUDIES\");
	plw.writeln(e);
}


// Dynamic attribute \"Next Milestone\" on Project class
// Used to identify Next Project Objectives in PFM Reports
function san_next_milestone_prj_slot_reader()
{
	var v_result_onb = 0;
	var o_project = undefined;
	// If 'this' is a Pharma Project, get Lead indication, else it is an indication
	if(this.SAN_RDPM_UA_PRJ_RND_PRJ)
	{
		with(this.fromobject())
		{
			for(var o_lead_indication in plc.project where o_lead_indication.SAN_UA_B_PRJ_IS_LEAD_INDICATION)
			{
				o_project = o_lead_indication;
				break;
			}
		}
	} else if (this.SAN_RDPM_UA_PRJ_RND_IND) {
		o_project = this;
	}
	// Get the first Project Objective
	if(o_project!=undefined)
	{
		var v_planned_project_objectives = san_rdpm_js2_get_planned_project_objectives(o_project);
		if(v_planned_project_objectives.length>0)
		{
			v_result_onb = v_planned_project_objectives[0].onb;
		}
	}
	return v_result_onb;
}

function san_next_milestone_create_prj_dynamic_attribute(){
	try{
		var slot = new objectAttribute(plc.project,\"SAN_RDPM_DA_PRJ_NEXT_MILESTONE_ONB\",\"NUMBER\");
		slot.Comment = \"[DynAtt Project] Next milestone ONB\";
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

// *********************  PRIME Project Code & Study code  *********************

// PC-2572 Project dynamic attributes, link with PRIME Project Code
// If Project code is set, use information from 'PRIME Project Code', otherwise use information from Project
function san_prj_prime_gov_slot_reader(s_prj_slot,s_prj_code_slot) {
	var plc.ordo_project o_prj = this;
	if(o_prj instanceof plc.ordo_project){
    	if(o_prj.SAN_UA_RWE_PROJECT_CODE_PRIME instanceof plc.__USER_TABLE_SAN_RWE_UT_PROJECT_CODES && (o_prj.getinternalvalue('STATE').toString()=='ACTIVE' || o_prj._PM_NF_B_IS_A_VERSION==true)){
    		return o_prj.SAN_UA_RWE_PROJECT_CODE_PRIME.get(s_prj_code_slot);
    	}
    	else if (o_prj.get('SAN_RDPM_UA_PRJ_RND_PRJ')==true) {
    	    return o_prj.get(s_prj_slot);
    	}
    	else{
    		var plc.ordo_project o_parent_prj = plc.ordo_project.get(o_prj.SAN_RDPM_UA_PRJ_S_ROOT_PROJECT);
    	    return o_parent_prj.get(s_prj_slot);
    	}
	}
}

function san_prj_prime_gov_slot_modifier(newValue,s_prj_slot) {
	var plc.ordo_project o_prj = this;
	if(o_prj instanceof plc.ordo_project){
	    o_prj.set(s_prj_slot,newValue);
	}
}
//ABO - 14/09/2021 : PC-5165 - extend the operation (when vaccine projects are not coded the dynamic attributes are not locked) for vaccine  
function san_prj_prime_gov_slot_locker(o_locker) {
	var plc.ordo_project o_prj = o_locker.object;
	if(o_prj instanceof plc.ordo_project){
    	if((o_prj.get('SAN_RDPM_UA_PRJ_RND_PRJ')==false && o_prj.get('SAN_RDPM_UA_PRJ_RND_PRJ_VAC')==false) || (o_prj.SAN_UA_RWE_PROJECT_CODE_PRIME instanceof plc.__USER_TABLE_SAN_RWE_UT_PROJECT_CODES && (o_prj.getinternalvalue('STATE').toString()=='ACTIVE' || o_prj._PM_NF_B_IS_A_VERSION==true))){	
    		return true;
    	}
    	else{
    		return false;
    	}
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
		slot.Locker = function () {return san_prj_prime_gov_slot_locker(this);};
		slot.hiddenInIntranetServer = false;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot [\"+s_da_name+\"] due to error: \" + e);
	}
}

// PC-2573 Study dynamic attributes, link with PRIME Study Code
// If Study code is set, use information from 'PRIME Study Code', otherwise use information from Study
function san_act_prime_gov_slot_reader(s_act_slot,s_study_code_slot,s_da_name) {
	var plc.work_structure o_act = this;
	var o_prj = o_act.get('PROJECT');
	if(o_act instanceof plc.work_structure && o_prj instanceof plc.ordo_project){
    	if(o_act.SAN_UA_RDPM_B_IS_A_STUDY && o_act.SAN_UA_ACT_STUDY_CODE instanceof plc.__USER_TABLE_SAN_RWE_PRIME_CODES && (o_prj.getinternalvalue('STATE').toString()=='ACTIVE' || o_prj._PM_NF_B_IS_A_VERSION==true)){
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
}

function san_act_prime_gov_slot_modifier(newValue,s_act_slot) {
	var plc.work_structure o_act = this;
	if(o_act instanceof plc.work_structure){
	    o_act.set(s_act_slot,newValue);
	}
}

function san_act_prime_gov_slot_locker(o_locker) {
	var plc.work_structure o_act = o_locker.object;
	var o_prj = o_act.get('PROJECT');
	if(o_act instanceof plc.work_structure && o_prj instanceof plc.ordo_project){
    	if(o_act.SAN_UA_RDPM_B_IS_A_STUDY==false){
    		return true;
    	}
    	else if(o_act.SAN_UA_RDPM_B_IS_A_STUDY && o_act.SAN_UA_ACT_STUDY_CODE instanceof plc.__USER_TABLE_SAN_RWE_PRIME_CODES && (o_prj.getinternalvalue('STATE').toString()=='ACTIVE' || o_prj._PM_NF_B_IS_A_VERSION==true)){
    		return true;
    	}
    	else{
    		return false;
    	}
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
		slot.Locker = function () {return san_act_prime_gov_slot_locker(this);};
		slot.hiddenInIntranetServer = false;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot [\"+s_da_name+\"] due to error: \" + e);
	}
}

//Project dynamic attributes creation
san_create_prj_prime_gov_dynamic_attributes('SAN_RDPM_UA_PRJ_UA_CODEV_PARTNER','SAN_UA_PC_PARTNER','SAN_RDPM_DA_PRJ_UA_CODEV_PARTNER');
san_create_prj_prime_gov_dynamic_attributes('SAN_RDPM_UA_S_MOA','SAN_UA_PC_S_MECANISM_OF_ACTION','SAN_RDPM_DA_S_MOA');
san_create_prj_prime_gov_dynamic_attributes('SAN_RDPM_UA_MOLECULE_SUB_TYPE','SAN_UA_PC_MOLECULE_SUB_TYPE','SAN_RDPM_DA_MOLECULE_SUB_TYPE');
san_create_prj_prime_gov_dynamic_attributes('SAN_RDPM_UA_PROJECT_CATEGORY','SAN_UA_PC_PROJECT_CATEGORY','SAN_RDPM_DA_PROJECT_CATEGORY');
san_create_prj_prime_gov_dynamic_attributes('SAN_RDPM_UA_PRJ_UA_NAME_EXT_SOURCE','SAN_UA_PC_NAME_EXT_SOURCE','SAN_RDPM_DA_PRJ_UA_NAME_EXT_SOURCE');
//ABO - 01/12/2021 : PC-4680 & PC-5165 creation of two new dynamic attributes \"Origin of NME\" & \"External Product Code\"
san_create_prj_prime_gov_dynamic_attributes('SAN_RDPM_UA_ORIGIN_OF_NME','SAN_UA_PC_ORIGIN_OF_NME','SAN_RDPM_DA_ORIGIN_OF_NME');
san_create_prj_prime_gov_dynamic_attributes('SAN_RDPM_UA_PARTNER_PROD_CODE','SAN_UA_PC_EXT_PRODUCT_CODE','SAN_RDPM_DA_EXT_PRODUCT_CODE');

//Study dynamic attributes creation
san_create_act_prime_gov_dynamic_attributes('SAN_UA_ACT_STUDY_PHASE','SAN_UA_RWE_STUDY_PHASE','SAN_DA_ACT_STUDY_PHASE');
//san_create_act_prime_gov_dynamic_attributes('SAN_RDPM_UA_CLIN_INDICATION','SAN_UA_RWE_INDICATION','SAN_RDPM_DA_CLIN_INDICATION');
//san_create_act_prime_gov_dynamic_attributes('SAN_RDPM_UA_ACT_THERAPEUTIC_AREA','SAN_UA_RWE_STUDY_TA','SAN_RDPM_DA_ACT_THERAPEUTIC_AREA');
san_create_act_prime_gov_dynamic_attributes('SAN_UA_ACT_STUDY_GROUP','SAN_UA_RWE_S_STUDY_GROUP','SAN_DA_ACT_STUDY_GROUP');
san_create_act_prime_gov_dynamic_attributes('SAN_RDPM_UA_S_PHARMA_EXT_CODE','SAN_UA_SC_S_EXTERNAL_STUDY_CODE','SAN_RDPM_DA_S_PHARMA_EXT_CODE');
san_create_act_prime_gov_dynamic_attributes('SAN_UA_ACT_B_IN_HUMAN','SAN_UA_SC_B_IN_HUMAN','SAN_DA_ACT_B_IN_HUMAN');
san_create_act_prime_gov_dynamic_attributes('SAN_UA_ACT_STUDY_PURPOSE','SAN_UA_SC_STUDY_PURPOSE','SAN_DA_ACT_STUDY_PURPOSE');
//ABE - 17/06/2021 : PC-452 - Creation of new dynamic attributes Study Sponsorship Type & Study Sponsorship Name
san_create_act_prime_gov_dynamic_attributes('SAN_RDPM_UA_ACT_STUDY_SPONSORSHIP_TYPE','SAN_RDPM_UA_SC_STUDY_SPONSORSHIP_TYPE','SAN_RDPM_DA_ACT_STUDY_SPONSORSHIP_TYPE');
//ABO - 12/10/2021 : PC-4492 - deletion of the dynamic attribute Study Sponsorship Name and replacement by the User attribute
//san_create_act_prime_gov_dynamic_attributes('SAN_RDPM_UA_ACT_STUDY_SPONSOR_NAME','SAN_RDPM_UA_SC_STUDY_SPONSOR_NAME','SAN_RDPM_DA_ACT_STUDY_SPONSOR_NAME');
//ABO - 14/09/2021 : PC-4515 - Creation of new dynamic attribute Root Product Code
san_create_act_prime_gov_dynamic_attributes('SAN_RDPM_UA_ACT_ROOT_PRODUCT_CODE','SAN_UA_RWE_STUDY_PRODUCT','SAN_RDPM_DA_ACT_ROOT_PRODUCT_CODE');


//ABE : PC-2960 & PC-3429
//Function to get all teams members releated to roles from project + all indications

// PC-4571 - Add o_project as argument in the function
// PC-5547 - Modification t take account a new management rule to propagate the project team if the project is pharma or vaccine.

function san_rdpm_team_member_from_project_parent(project_role,o_project)
{
    //var o_project=this;
    var Result_List = new vector(); 
    var filter;
    if (o_project instanceOf plc.ordo_project && project_role != undefined )
    {
        with(o_project.fromObject()){
            
			// PC-4731 Remove the part fro Pharma or vaccins to have one common behavior		
            //if(o_project.SAN_RDPM_B_RND_PHARMA_PROJECT){
                
               // for ( var pjr_team in plc.__USER_TABLE_SAN_RDPM_UT_PROJECT_TEAM_MEMBER where pjr_team.SAN_RDPM_UA_PROJECT_ROLE==project_role && pjr_team.san_rdpm_ua_user_desc !=\"\")
                    // {
                        // Result_List.Push(pjr_team.san_rdpm_ua_user_desc);
                    // }
            //}else if(o_project.SAN_RDPM_B_RND_VACCINES_PROJECT){
                
                    for ( var pjr_team in plc.__USER_TABLE_SAN_RDPM_UT_PROJECT_TEAM_MEMBER where pjr_team.SAN_RDPM_UA_PROJECT_ROLE==project_role && pjr_team.san_rdpm_ua_user_desc !=\"\" && pjr_team.FILE==o_project)
                    {
                        Result_List.Push(pjr_team.san_rdpm_ua_user_desc);
                    }
            //}
        }
    }
    return Result_List.removeduplicates().join(\",\");
}

//Function to get all teams members releated to roles from project parent and indication
// PC-4571 - Avoid global map when the project is an indication (level>1)
// PC-5547 - Modification t take account a new management rule to propagate the project team if the project is pharma or vaccine.
function san_rdpm_team_member_from_project(project_role)
{
    var obj_project_role =  plc.__USER_TABLE_SAN_RDPM_UT_PROJECT_ROLE.get(project_role);
    var o_project = this;
    var team_indication ;
    var team_project ;
    
    if (o_project instanceof plc.ordo_project && obj_project_role != undefined )
    {
        // PC-5547 - Modification t take account a new management rule to propagate the project team if the project is pharma or vaccine.
        if (o_project.LEVEL!=1) {
            
			// PC-4731 - Modification to harmonize behavior between pharma and vaccins
			team_indication =  san_rdpm_team_member_from_project_parent(obj_project_role,o_project);
			if (team_indication!=\"\") {
				return team_indication;
			}
			else {
				team_project = san_rdpm_team_member_from_project_parent(obj_project_role,o_project.PARENT);
				return team_project;
			}
        }
		else {
			team_project = san_rdpm_team_member_from_project_parent(obj_project_role,o_project);
			return team_project;
		}
    }
}
//Function to create dynamic attribute definition on Project class
function san_rdpm_create_project_role_slot_dynamic_attribute(onb,desc,attribute){
    
  try{         
      var SlotName =  \"_PO_DA_S_PROJECT_ROLE_\" + onb;
	   var classobject = plc.ordo_project;
      if(classobject.getslotbyid(SlotName) == undefined){
        var slot = new objectattribute(classobject,
                                       SlotName,
                                       \"STRING\");
        Slot.comment= desc;
        Slot.reader = san_rdpm_team_member_from_project.Closure(attribute);
        Slot.locker = false;
        Slot.hiddeninintranetserver = false;
      }
      return SlotName;  
  }catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}

//Generic function to get Team member releated Project role on Project class
function san_rdpm_create_object_project_role(field) {
	var object = this;
	if (object!=undefined) return object.project.get(field);
}

//Generic function to create dynamic attribute class object (Activity, Planned Expenditure, Planned Hour, Actual Hour)
function san_rdpm_create_object_project_role_dynamic_attribute(onb,attribute_desc, classobject)
{
  var o_class=\"\";
  if( classobject == plc.expenditure) o_class=\"_PEXP_\" ;
  if( classobject == plc.work_structure) o_class=\"_ACT_\" ;
  if( classobject == plc.task_alloc) o_class=\"_PH_\" ;
  if( classobject == plc.work_performed) o_class=\"_ACH_\" ;
	  
  var SlotName =  \"_PO_DA_S_PROJECT_ROLE_\"+ onb;
  var field =  \"_PO_DA_S_PROJECT_ROLE\"+o_class+onb;
  var slot = classobject.getslotbyid(SlotName);
  if (slot == undefined)
    {
      slot = new ObjectAttribute(classobject,field,\"STRING\");
    }
  if ( slot != undefined)
	{
		slot.comment = attribute_desc;
		slot.reader = san_rdpm_create_object_project_role.Closure(SlotName);
		slot.locker = false;
		slot.hiddeninintranetserver = false;
    }
}
//Dynamic attribute creation on Project 
try{
    with(plw.no_locking){
        for ( var o_role in  plc.__USER_TABLE_SAN_RDPM_UT_PROJECT_ROLE where o_role.SAN_RDPM_UA_PROJECT_ROLE_B_VISIBLE_PRJ_LEVEL ){
            san_rdpm_create_project_role_slot_dynamic_attribute(o_role.ONB,o_role.NAME,o_role.NAME);
		}
    }
   
}
catch (error e){ 
    plw.writeToLog(\"Failed to create san_rdpm_create_project_role_slot_dynamic_attribute on Project.\");
    plw.writeln(e);
}
//Dynamic attribute creation on Activity 
try{
    with(plw.no_locking){
        for ( var o_role in  plc.__USER_TABLE_SAN_RDPM_UT_PROJECT_ROLE where o_role.SAN_RDPM_UA_PROJECT_ROLE_B_VISIBLE_PRJ_LEVEL )
		    san_rdpm_create_object_project_role_dynamic_attribute(o_role.ONB,o_role.NAME,plc.work_structure);
    }
   
}
catch (error e){
    plw.writeToLog(\"Failed to create san_rdpm_create_act_project_role_dynamic_attribute on Activity\");
    plw.writeln(e);
}
//Dynamic attribute creation on Planned Expenditure 
try{
    with(plw.no_locking){
        for ( var o_role in  plc.__USER_TABLE_SAN_RDPM_UT_PROJECT_ROLE where o_role.SAN_RDPM_UA_PROJECT_ROLE_B_VISIBLE_PRJ_LEVEL )
		    san_rdpm_create_object_project_role_dynamic_attribute(o_role.ONB,o_role.NAME,plc.expenditure);
    }
   
}
catch (error e){
    plw.writeToLog(\"Failed to create san_rdpm_create_act_project_role_dynamic_attribute on Expenditure.\");
    plw.writeln(e);
}
//Dynamic attribute creation on task_alloc 
try{
    with(plw.no_locking){
        for ( var o_role in  plc.__USER_TABLE_SAN_RDPM_UT_PROJECT_ROLE where o_role.SAN_RDPM_UA_PROJECT_ROLE_B_VISIBLE_PRJ_LEVEL )
		    san_rdpm_create_object_project_role_dynamic_attribute(o_role.ONB,o_role.NAME,plc.task_alloc);
    }
   
}
catch (error e){
    plw.writeToLog(\"Failed to create san_rdpm_create_act_project_role_dynamic_attribute on task_alloc.\");
    plw.writeln(e);
}
//Dynamic attribute creation on work_performed 
try{
    with(plw.no_locking){
        for ( var o_role in  plc.__USER_TABLE_SAN_RDPM_UT_PROJECT_ROLE where o_role.SAN_RDPM_UA_PROJECT_ROLE_B_VISIBLE_PRJ_LEVEL )
		    san_rdpm_create_object_project_role_dynamic_attribute(o_role.ONB,o_role.NAME,plc.work_performed);
    }
   
}
catch (error e){
    plw.writeToLog(\"Failed to create san_rdpm_create_act_project_role_dynamic_attribute on work_performed.\");
    plw.writeln(e);
}

//End : PC-2960 & PC-3429

// PC-4236 - Creation of dynamic attribute \"All Root Products Codes\"
// Reader (Generic)
function san_all_root_product_code_reader() {
	return this.SAN_RDPM_UA_ACT_OTHER_ROOT_PRODUCT_CODE_F;
}

// Modifier
function san_all_root_product_code_modifier(New_value) {
   if (this instanceof plc.workstructure)
   {
	   with(plw.no_locking){
	    this.SAN_RDPM_UA_ACT_OTHER_ROOT_PRODUCT_CODE=New_value;
	   }
   }
}

//Dynamic attribute creation on Project 
try{
    with(plw.no_locking){        
		var o_act_slot = plc.work_structure.getslot(\"SAN_RDPM_UA_ACT_OTHER_ROOT_PRODUCT_CODE\");
		var o_act_slot_type = o_act_slot.descriptor.type.name;
		var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_ALL_ROOT_PRODUCT_CODES\",o_act_slot_type);
		if (o_act_slot_type.name.matchregexp('^\\.\\.\\.')){
			slot.setPlist(new symbol(\"LIST-CLASS\",\"KEYWORD\"), new symbol(o_act_slot_type.name.replaceregexp('\\.\\.\\.',''),o_act_slot_type.package));
		}
		slot.Comment = \"All Root Products Codes\";
		slot.Reader = san_all_root_product_code_reader;
		slot.Modifier = san_all_root_product_code_modifier;
		slot.hiddenInIntranetServer = false;
		slot.connecting = false;
    }   
}
catch (error e){ 
    plw.writeToLog(\"Failed to create SAN_RDPM_DA_ALL_ROOT_PRODUCT_CODES on activities.\");
    plw.writeln(e);
}

// *********************  E-Learning  *********************

// PC-3008 Dynamic attribute \"MCQ score reached?\" on Module class
// Used to check if at least on Elearning MCQ is complete
// with a score equal or higher than module score target

function san_mcq_score_reached_slot_reader(){
	
	var oModule = this;
	var bElearnMcqValidated = false;
	
	if(oModule InstanceOf plc._Gui_Pt_Modules){
		with(oModule.fromobject()) {
			//We go through the relation between subject and Module
			for(var SubjectRelation in oModule.get(\"r._ELEARN_RA_MODULE._ELEAR_PT_SUBJ_MOD_NN\")){
				//We check only Elearning subjects visible by the current user
				var Subject = SubjectRelation._Elear_RA_SUBJECT;
				if(Subject InstanceOf plc._GUI_PT_ELEARNING){
					var oMcq = Subject._ELEARN_RA_MCQ;
					//We check if the elearning has an MCQ linked to it
					if(oMcq instanceof plc._ELEARN_PT_MCQ && oMcq.NAME !=\"\"){
						if(oMcq._ELEARN_DA_N_SCORE_FIELD >= math.round(oModule._GUI_AA_N_MCQ_PERCENTAGE * 100)){
							bElearnMcqValidated = true;
							//We stop as soon as we get one MCQ with the right score
							break;
						}
					}
				}
			}
		}
	}
	return bElearnMcqValidated;
}

function san_create_mcq_score_reached_dynamic_attribute(){
	try{
		var slot = new objectAttribute(plc._Gui_Pt_Modules,\"SAN_RDPM_DA_B_MCQ_SCORE_REACHED\",\"BOOLEAN\");
		slot.Comment = \"MCQ score reached?\";
		slot.Reader = san_mcq_score_reached_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = false;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot SAN_RDPM_DA_B_MCQ_SCORE_REACHED due to error: \" + e);
	}
}

try{
	with(plw.no_locking){
		san_create_mcq_score_reached_dynamic_attribute();
	}
}
catch (error e){
	plw.writeToLog(\"Failed to create SAN_RDPM_DA_B_MCQ_SCORE_REACHED\");
	plw.writeln(e);
}

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
		for (var plh_grpm in act.ALLOCATED_RESOURCES where plh_grpm.RES==res_obj && plh.PRIMARY_SKILL==skill_obj order by [['INVERSE','FD'],['INVERSE','ONB']]) {
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
				for (var plh_cluster in act.ALLOCATED_RESOURCES where plh_cluster.RES==linked_res_to_cluster && plh.PRIMARY_SKILL==skill_obj order by [['INVERSE','FD'],['INVERSE','ONB']]) {
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
 :USER-SCRIPT 262044406270
 :VERSION 66
 :_US_AA_D_CREATION_DATE 20221215000000
 :_US_AA_S_OWNER "I0260387"
)