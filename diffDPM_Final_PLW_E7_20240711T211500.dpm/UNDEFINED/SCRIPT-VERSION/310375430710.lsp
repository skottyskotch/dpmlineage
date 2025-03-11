
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 310375430710
 :DATASET 118081000141
 :SCRIPT-CODE "// dev
//  PLWSCRIPT : SAN_RDPM_JS2_DYN_ATTRIBUTES
//
//
//  Modification : 2020/01/12 IGU
//  Dynamic attributes to manage PRIME - RDPM fields governance added
//  Modification : 29-JAN-2021 FLC
//  Merge with 'SAN_RDPM_JS2_DYN_REL_PROJ_OBJ_AND_TECH_MIL' to include Project objectives relations & attributes
//  Modification - SAK - 24/03/2021 : PC-3573 - PPM should receives an alert when delay at OL
//  Modification - ABE - 17/06/2021 : PC-452 - Creation of new dynamic attributes Study Sponsorship Type & Study Sponsorship Name
//  Modification - ABE - 28/07/2021 : PC-2960 & PC-3429 - Creation of new dynamic attributes Project role related to team member on Project, Activity, Planned Expenditure, Planned Hour and Actual Hour class. 
//                                    
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

// *********************  Project Objectives  *********************

// Function used to list the planned Project Objectives for a given project. Used by the dynamic relation on Project Objectives (Workbox aggregator) and the dynamic attribute \"Next Milestone\" on Project class
function san_rdpm_js2_get_planned_project_objectives(o_project)
{
	var v_vect_planned_po = new vector();
	
	// Get the list of Project Objectives Activity types
	var list = [];
	for(var o_proj_obj_report_mile_type in plc.__USER_TABLE_SAN_RDPM_UT_REPORT_MILE_TYPE where context.SAN_RDPM_CS_PROJECT_OBJECTIVE.parsevector().position(o_proj_obj_report_mile_type.printattribute())!=undefined)
	{
		for (var o_wbstype in o_proj_obj_report_mile_type.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_AT_REPORT_MILE_TYPE\")) 
		{
			list.push(o_wbstype);
		}
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
		for(var o_project in plc.project where o_project.is_active && (o_project.callbooleanformula(\"OWNER = $CURRENT_USER\") || o_project._PM_NF_B_ADDITONNAL_MY_PROJECT_FILTER)){
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

function san_prj_prime_gov_slot_locker(o_locker) {
	var plc.ordo_project o_prj = o_locker.object;
	if(o_prj instanceof plc.ordo_project){
    	if((o_prj.get('SAN_RDPM_UA_PRJ_RND_PRJ')==false) || (o_prj.SAN_UA_RWE_PROJECT_CODE_PRIME instanceof plc.__USER_TABLE_SAN_RWE_UT_PROJECT_CODES && (o_prj.getinternalvalue('STATE').toString()=='ACTIVE' || o_prj._PM_NF_B_IS_A_VERSION==true))){
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
san_create_act_prime_gov_dynamic_attributes('SAN_RDPM_UA_ACT_STUDY_SPONSOR_NAME','SAN_RDPM_UA_SC_STUDY_SPONSOR_NAME','SAN_RDPM_DA_ACT_STUDY_SPONSOR_NAME');


//ABE : PC-2960 & PC-3429
//Function to get all teams members releated to roles from project + all indications

function san_rdpm_team_member_from_project_parent(project_role)
{
    var o_project=this;
    var Result_List = new vector();
    if (o_project instanceOf plc.ordo_project && project_role != undefined )
    {
        with(o_project.fromObject()){
            for ( var pjr_team in plc.__USER_TABLE_SAN_RDPM_UT_PROJECT_TEAM_MEMBER where pjr_team.SAN_RDPM_UA_PROJECT_ROLE==project_role && pjr_team.san_rdpm_ua_user_desc !=\"\")
                {
                    Result_List.Push(pjr_team.san_rdpm_ua_user_desc);
                }
            
        }
    }
    return Result_List.removeduplicates().join(\", \");
}
//Function to get all teams members releated to roles from project parent and indication
function san_rdpm_team_member_from_project(project_role)
{
    var obj_project_role =  plc.__USER_TABLE_SAN_RDPM_UT_PROJECT_ROLE.get(project_role);
    var o_project = this;
    var Result_List = new vector();
    if (o_project instanceof plc.ordo_project && obj_project_role != undefined )
    {
        if (o_project.LEVEL ==1) {
            
                return san_rdpm_team_member_from_project_parent(obj_project_role);
        }
        else {
            
            for ( var pjr_team in plc.__USER_TABLE_SAN_RDPM_UT_PROJECT_TEAM_MEMBER where (pjr_team.project==o_project || pjr_team.project==o_project.parent ) && pjr_team.SAN_RDPM_UA_PROJECT_ROLE==obj_project_role && pjr_team.san_rdpm_ua_user_desc !=\"\")
            {
                Result_List.Push(pjr_team.san_rdpm_ua_user_desc);
            }
                
        return Result_List.removeduplicates().join(\", \");
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
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 262044406270
 :VERSION 35
 :_US_AA_D_CREATION_DATE 20210824000000
 :_US_AA_S_OWNER "E0296878"
)