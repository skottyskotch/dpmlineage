
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260029672772
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_TC_UTILS
// 
//  AUTHOR  : S. AKAAYOUS
//
//
//  Creation V0 2020/10/02 SAK
//  Creation of the script to resolve the performance issue using Add activity button in timecard , PC-1658
//
//***************************************************************************/
namespace _san_rdpm_tc_search;

// function to get the study of the activity 
function san_rdpm_get_study(act) {
	var result=undefined;
	var ActParent=act.WBS_ELEMENT;
	if (act.san_ua_rdpm_b_is_a_study) {
		result=act;
	}
	else {
		if (act.LEVEL>1) result=san_rdpm_get_study(ActParent);
	}
	return result;
}

// function to check if the activity can be inserted
function san_rdpm_check_act_can_be_inserted(act) {
	var result=false;
	if (Act.STATE==\"Open\" && Act.CallBooleanFormula(\"MATCH_STRING(OC._TCM_AA_S_SA_ACTIVITYFILTER)\") && 
		Act.project.VERSION_NUMBER==0 &&
		Act.project.getinternalvalue(\"STATE\").ToString()==\"ACTIVE\" &&
		Act.project._wzd_aa_b_permanent==false) {
		result=true;
	}
	return result;
}

// #################   My role   #################

// SAN_RDPM_UA_ACT_TC_PORT_MR
// (san_ua_rdpm_b_is_a_study and ITER_BOOLEAN_THERE_IS_ONE(\"CHILDREN\",\"SAN_UA_HAS_ALLOC_WITH_SKILL_OF_CURRENT_TC_RES\")) or wbs_type=\"Financial Task\"

// SAN_RDPM_UA_ACT_TC_PORT_VACC_MR
// SAN_UA_HAS_ALLOC_WITH_SITE_OF_CURRENT_TC_RES and (SAN_UA_HAS_ALLOC_WITH_SKILL_OF_CURRENT_TC_RES or SAN_UA_HAS_ALLOC_WITH_RES_OF_CURRENT_TC_RES) 

function san_rdpm_tc_filter_my_role_activities(f) {
	var vRes = plc.resource.get(context._TC_AA_S_RESOURCE);
	
	var vActResult=new vector();
	//plw.alert(vRes);
	if(vRes != undefined && vRes instanceOf plc.Resource) {
		var vResTcProfile=vRes.CURRENT_TIMECARD_PROFILE.printattribute();
		var ResSkill=vRes.PRIMARY_SKILL;
		var ResSite=vRes._RM_REVIEW_RA_LOCATION;
		
		// Warning : hard coded \"Financial task\". Prefer plug it on a setting
		var FinancialTaskType=plc.wbs_type.get(\"Financial Task\");
		
		if (ResSkill!= undefined) {
			// Pharma case (PC-649)
			// return the study of the activity on which the planned hour is created
			if (vResTcProfile==\"PHARMA\") {
				// potential optim with sc9651 3.8 + table key on planned hour \"PRIMARY_SKILL\" 
				/*var SkillString=ResSkill.printattribute();
				
				var v_attributes = new vector(\"SAN_UA_RDPM_PRIMARY_SKILL_INDEX\");
				var v_values = new vector(SkillString);
				var ka = new Keyattribute(plc.task_alloc,v_attributes,v_values);
				
				if (ka instanceof KeyAttribute){
					with(ka.fromObject()){
						for (var talloc in plc.taskalloc) {
							var MyRoleAct=talloc.ACTIVITY;
							var MyRoleActStudy=san_rdpm_get_study(MyRoleAct);
							
							if (MyRoleActStudy!=undefined) {
								if (san_rdpm_check_act_can_be_inserted(MyRoleActStudy)) vActResult.push(MyRoleActStudy);
							}
						}
					}
				}*/
				for (var MyRoleAct in ResSkill.get(\"Allocations\"))
				{
				var MyRoleActStudy=san_rdpm_get_study(MyRoleAct.activity);
                if (MyRoleActStudy!=undefined) {
								if (san_rdpm_check_act_can_be_inserted(MyRoleActStudy)) vActResult.push(MyRoleActStudy);
							}				
				}
				
				// Adding Financial tasks
				if (FinancialTaskType!=undefined) {
					with(FinancialTaskType.fromobject()) {   // fromobject OK
						for (var FinAct in plc.work_structure) {
							if (san_rdpm_check_act_can_be_inserted(FinAct)) vActResult.push(FinAct);
						}
					}
				}
			}
			
			// Vaccines case
			if (vResTcProfile==\"PASTEUR\") {
				if (ResSite!=undefined) {
					// we start from the site, then check the resource OR the skill of the planned hour
					with(ResSite.fromObject()){  // from object OK
						for (var talloc in plc.taskalloc where (talloc.PRIMARY_SKILL==ResSkill || talloc.RES==vRes)) {
							var MyRoleAct=talloc.ACTIVITY;
							//var MyRoleActStudy=san_rdpm_get_study(MyRoleAct); not need activity study
							if (MyRoleAct!=undefined) {
								if (san_rdpm_check_act_can_be_inserted(MyRoleAct)) vActResult.push(MyRoleAct);
							}
							
						}
					}
				}
			}
			vActResult=vActResult.removeduplicates();
			if (vActResult.length>0) {
				for (var Act in vActResult) {
					f.call(Act);
				}
			}
		}
	}		
}


// #################   My OBS   #################

// SAN_UA_HAS_OBS_OF_CURRENT_TC_RES_PHAR
// san_ua_rdpm_b_is_a_study   and obs_element <>\"\" and 	
//( obs_element= STRING_VALUE(\"RESOURCE\",OC._TC_AA_S_RESOURCE,\"OBS_ELEMENT\") or ITER_BOOLEAN_THERE_IS_ONE(\"CHILDREN\",\"obs_element= STRING_VALUE(\\\"RESOURCE\\\",OC._TC_AA_S_RESOURCE,\\\"OBS_ELEMENT\\\")\") 	)

// PAST
// SAN_UA_HAS_OBS_OF_CURRENT_TC_RES   *** obs res belongs to act obs
// ( LEVEL = 1 and OBS_ELEMENT=\"\")  or (OBS_ELEMENT<>\"\" and EVALUATE_BOOLEAN_ON_OBJECT(\"RESOURCE\",OC._TC_AA_S_RESOURCE,\"BELONGS(\\\"RESPONSIBILITY\\\",\\\"\"+OBS_ELEMENT+\"\\\")\") )

function san_rdpm_tc_filter_my_OBS_activities(f) {
	var vRes = plc.resource.get(context._TC_AA_S_RESOURCE);
	var vObs = vRes.OBS_ELEMENT;
	var vActObsParent=new vector();
	var vActResult=new vector();
	//plw.alert(vRes);
	if(vRes != undefined && vRes instanceOf plc.Resource && vObs != undefined && vObs instanceOf plc.obs_node)
	{
		var vResTcProfile=vRes.CURRENT_TIMECARD_PROFILE.printattribute();
		
		// Pharma case (PC-649)
			/*if (vResTcProfile==\"PHARMA\") {
			with(vObs.fromobject()) {   // fromobject KO
				for (var ObsAct in plc.work_structure) {
					var ObsActStudy=RDPM_get_study(ObsAct);
					if (ObsAct.OBS_ELEMENT==vObs && RDPM_check_act_can_be_inserted(ObsActStudy)) vActResult.push(ObsActStudy);
				}
			}
		}*/
		
		if (vResTcProfile==\"PHARMA\") {
			with(vObs.fromobject()) {
				for (var ObsAct in vObs.get(\"OBS_CHILDREN\") where ObsAct instanceof plc.work_structure) {
					var ObsActStudy=san_rdpm_get_study(ObsAct);
					if (ObsActStudy!=undefined && ObsAct.OBS_ELEMENT==vObs && san_rdpm_check_act_can_be_inserted(ObsActStudy)) vActResult.push(ObsActStudy);
					}
				}
		}
		
		// Pasteur case
		if (vResTcProfile==\"PASTEUR\") {
			/*
			with(vObs.fromobject()) {
				for (var ObsAct in instanceof plc.work_structure)  {					
					if ( vRes.CallBooleanFormula(\"BELONGS(\\\"RESPONSIBILITY\\\",\\\"\"+ObsAct.OBS_ELEMENT.printattribute()+\"\\\")\") &&   san_rdpm_check_act_can_be_inserted(ObsAct)) vActResult.push(ObsAct);
				}
			}*/
			vActObsParent.push(vObs);	
			for (var ObsPart in vObs.get(\"ALL_PARENTS\") ){				
				vActObsParent.push(ObsPart);		 
		    }
			
			for (var vObsPart in vActObsParent){		
				with(vObsPart.fromobject()) {
					for (var vObsAct in vObsPart.get(\"OBS_CHILDREN\") where vObsAct instanceof plc.work_structure)  {			
						  if ( san_rdpm_check_act_can_be_inserted(vObsAct)) vActResult.push(vObsAct);
					}
				}		
            }
			// add activity level 1 and obs =\"\" // to optimize
		   for ( var prj in plc.ordo_project where prj.san_rdpm_b_rnd_vaccines_project  && prj.getinternalvalue(\"STATE\").ToString()==\"ACTIVE\" 
		   && prj._wzd_aa_b_permanent==false && prj.parent.printattribute()==\"\")
			 {
				 var ActL1=plc.network.get(prj.name);
				 if ( ActL1 instanceof plc.network && san_rdpm_check_act_can_be_inserted(ActL1) && ActL1.obs_element.printattribute()==\"\")
				 {	 vActResult.push(ActL1); 
				 }
			 }

		}

		vActResult=vActResult.removeduplicates();
		for (var Act in vActResult) {
			f.call(Act);
		}
	}
}

// #################   All Activities   #################

function san_rdpm_tc_filter_all_activities(f) {	
	// on branche sur la relation standard
	// if there is not search filter, do nothing
	if (context._TCM_AA_S_SA_ACTIVITYFILTER==\"\") {
		
		return false;
	}
	else {
		plw._TC_filter_my_contextual_projects_activities(f);
	}
}

// #################   Global filter   #################

function san_rdpm_tc_filter_global(f) {
	var cond1=plw.write_text_key(\"RDPM.SAN_RDPM_TK_TC_PORT_MR\");
	var cond2=plw.write_text_key(\"RDPM.SAN_RDPM_TK_TC_PORT_MD\");
	var cond3=plw.write_text_key(\"RDPM.SAN_RDPM_TK_TC_PORT_ALL\");
	
	if (context.SAN_RDPM_UA_CP_TC_PORT_CHOICE==cond1) {
		san_rdpm_tc_filter_my_role_activities(f);
	}
	else {
		if (context.SAN_RDPM_UA_CP_TC_PORT_CHOICE==cond2) {
			san_rdpm_tc_filter_my_OBS_activities(f);
		}
		else {
			if (context.SAN_RDPM_UA_CP_TC_PORT_CHOICE==cond3) {
				san_rdpm_tc_filter_all_activities(f);
			}
			else {
				return false;
			}
		}
	}
}

// ## Declaration of the dynamic relation ##

var objectRelation RDPM_global_TC_Context_Activity_Relation = plc.contextopx2.getSlotByID('RDPM_GLOBAL_TC_OC_REL_FILTERED_WORKSTRUCTURES');
if(!(RDPM_global_TC_Context_Activity_Relation instanceof ObjectRelation)){
	RDPM_global_TC_Context_Activity_Relation = new ObjectRelation(plc.contextopx2,'RDPM_GLOBAL_TC_OC_REL_FILTERED_WORKSTRUCTURES');
} 
RDPM_global_TC_Context_Activity_Relation.comment = 'RDPM Time card global filtered Work-structures';
RDPM_global_TC_Context_Activity_Relation.connectedtoclass = plc.work_structure;
RDPM_global_TC_Context_Activity_Relation.mapmethod = san_rdpm_tc_filter_global;

// #################   Funtion to insert activity into the TimeSheet, without history   #################

function rdpm_pjs_tcm_addActivityInTimesheet(id) {
	// standard function, without history management (bad perf)
	//if (this.object instanceof opxactivity) {
	if (this.object instanceof plw.work_structure) {
		//generate hystory
		//_tcm_GenerateHistory();
		plw.create_time_input_line(this.object,true);
		return true;
	}
	return false;
}			"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260029509872
 :VERSION 7
 :_US_AA_D_CREATION_DATE 20201005000000
 :_US_AA_S_OWNER "E0431065"
)