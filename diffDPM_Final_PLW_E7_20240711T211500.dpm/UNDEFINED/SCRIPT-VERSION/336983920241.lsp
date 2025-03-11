
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 336983920241
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
//  Modification 0.1 2020/10/06 SAK  : Add PC-686 only obs of the resource and the parent obs of the resource
//
//  Modification 0.2 2021/05/21 IGU  : PC-3686 Financial task should be displayed if OBS element (Financial task) = OBS element (Resource) in My OBS
//
//  Modification 0.3 2021/11/15 IGU  : Bug fixes for Pasteur Add Activity popup
//
//  Modification 0.4 2021/12/17 IGU  : PC-5328 Fix diplayed activities in My OBS view for Vaccines
//
//  Modification 0.5 2022/02/18 EPA  : PC-5540 Fix diplayed activities in My role view for Vaccines
//
//  Modification 0.6 2022/04/07 LFA  : PC-5567 - Take into account filter on Vaccines project portfolio
//
//***************************************************************************/
namespace _san_rdpm_tc_search;

// function to get the study of the activity 
function san_rdpm_get_study(act) {
	var result=undefined;
	var ActStudy=plc.work_structure.get(act.SAN_UA_RDPM_ACT_S_STUDY_ID);
	if (ActStudy!=undefined) result=ActStudy;
	return result;
}

// function to check if the activity can be inserted
/*function san_rdpm_check_act_can_be_inserted(act) {
	var result=false;
	if (Act.getinternalvalue(\"STATE\").ToString()!=\"O\") {
	return false;
	}
	else {
	if (
	Act.project.VERSION_NUMBER==0 &&
	Act.project.getinternalvalue(\"STATE\").ToString()==\"ACTIVE\" &&
	Act.project._wzd_aa_b_permanent==false &&
	Act.CallBooleanFormula(\"MATCH_STRING(OC._TCM_AA_S_SA_ACTIVITYFILTER)\")) {
	result=true;
	}
	}
	return result;
}*/

function san_rdpm_check_project_can_be_inserted(prj) {
	var result=false;
	if (prj.getinternalvalue(\"STATE\").ToString()==\"ACTIVE\" && prj.VERSION_NUMBER==0 && prj._wzd_aa_b_permanent==false) result=true;
	return result;
}

function san_rdpm_check_act_can_be_inserted(act) {
	var result=false;
	if (Act.getinternalvalue(\"STATE\").ToString()!=\"O\") {
		return false;
	}
	else {
		if (Act.CallBooleanFormula(\"MATCH_STRING(OC._TCM_AA_S_SA_ACTIVITYFILTER)\")) result=true;
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
	var act_table=new hashtable(\"OBJECT\");
	//var study_table=new hashtable(\"OBJECT\");
	var insert_act_table=new hashtable(\"OBJECT\");
	var TC_projects_table=new hashtable(\"OBJECT\");
	
	var total_plh=0;
	var total_distinct_act=0;
	var total_distinct_std_ft=0;
	var total_std_insertable=0;
	var total_distinct_ft=0;
	var total_ft_insertable=0;	
	
	//plw.alert(vRes);
	if(vRes != undefined && vRes instanceOf plc.Resource) {
		var vResTcProfile=vRes.CURRENT_TIMECARD_PROFILE.printattribute();
		var ResSkill=vRes.PRIMARY_SKILL;
		var ResSite=vRes._RM_REVIEW_RA_LOCATION;
		
		var FinancialTaskType=plc.wbs_type.get(context.SAN_RDPM_CS_AT_FIN_TASK);
		//plw.alert(FinancialTaskType);
		
		if (ResSkill!= undefined) {
			// Pharma case (PC-649)
			// return the study of the activity on which the planned hour is created
			var SkillString=ResSkill.printattribute();
			if (vResTcProfile==\"PHARMA\") {
				// potential optim with sc9651 3.8 + table key on planned hour \"PRIMARY_SKILL\" 
				//le ka  ne renvoit pas tte les activtés apres modification de la skill.
				// to be reviewed anyway as using a table key on computed user attribute is a very bad idea
				
				var v_attributes = new vector(\"SAN_UA_RDPM_S_PRIMARY_SKILL_FOR_TABLE_KEY\");
				var v_values = new vector(SkillString);
				var ka = new Keyattribute(plc.task_alloc,v_attributes,v_values);
				
				if (ka instanceof KeyAttribute){
					with(ka.fromObject()){
						for (var talloc in plc.taskalloc) {
							total_plh++;
							var MyRoleAct=talloc.ACTIVITY;
							var MyRolePrj=talloc.PROJECT;
							//plw.alert(\"MyRolePrj: \"+MyRolePrj);
							//plw.writeln(\"TC_projects_table.get(MyRolePrj) :\"+TC_projects_table.get(MyRolePrj));
							if (TC_projects_table.get(MyRolePrj)==undefined) {
								TC_projects_table.set(MyRolePrj,san_rdpm_check_project_can_be_inserted(MyRolePrj));
							}
							
							if (TC_projects_table.get(MyRolePrj)==true) {
								if (act_table.get(MyRoleAct)==undefined) {
									act_table.set(MyRoleAct,true);
									total_distinct_act++;
									//var MyRoleActStudy=san_rdpm_get_study(MyRoleAct);
									var MyRoleActInsert=undefined;
									
									//plw.alert(MyRoleAct.WBS_TYPE);
									if (MyRoleAct.WBS_TYPE==FinancialTaskType) {
										MyRoleActInsert=MyRoleAct;
										//plw.alert(MyRoleActInsert);
									}
									else {
										MyRoleActInsert=san_rdpm_get_study(MyRoleAct);
									}
									
									if (MyRoleActInsert!=undefined && insert_act_table.get(MyRoleActInsert)==undefined){
										total_distinct_std_ft++;
										insert_act_table.set(MyRoleActInsert,true);
										if (san_rdpm_check_act_can_be_inserted(MyRoleActInsert)) {
											vActResult.push(MyRoleActInsert);
											total_std_insertable++;
										}
									}
								}
							}
						}
					}
				}
				
				// Adding Financial tasks
				// Removed following PC-3573
				/*if (FinancialTaskType!=undefined) {
					with(FinancialTaskType.fromobject()) {   // fromobject OK
					for (var FinAct in plc.work_structure) {
					total_distinct_ft++;
					var FinActProject=FinAct.PROJECT;
					if (san_rdpm_check_project_can_be_inserted(FinActProject)) {
					if (san_rdpm_check_act_can_be_inserted(FinAct)) {
					vActResult.push(FinAct);
					total_ft_insertable++;
					}
					}
					}
					}
				}*/
				// Removed following PC-3573
				plw.writetolog(\"\");
				plw.writetolog(\"############# Scanned insertable studies for skill \"+SkillString+\" #########\");
				plw.writetolog(\"Nb of scanned planned hours: \"+total_plh);
				plw.writetolog(\"Nb of distinct activities in TC projects: \"+total_distinct_act);
				plw.writetolog(\"Nb of distinct studies / financial tasks: \"+total_distinct_std_ft);
				plw.writetolog(\"Nb of insertable studies  / financial tasks: \"+total_std_insertable);
				//plw.writeln(\"Nb of financial tasks: \"+total_distinct_ft);
				//plw.writeln(\"Nb of insertable financial tasks: \"+total_ft_insertable);
				plw.writetolog(\"TOTAL of activities to display in dialog: \"+vActResult.length);
				plw.writetolog(\"######################\");
			}
			
			// Vaccines case
			if (vResTcProfile==\"PASTEUR\") {
				if (ResSite!=undefined) {
					// we start from the site, then check the resource OR the skill of the planned hour
					var SiteString=ResSite.printattribute();
					with(ResSite.fromObject()){  // from object OK
						for (var talloc in plc.taskalloc where (talloc.PRIMARY_SKILL==ResSkill || talloc.RES==vRes)) {
							total_plh++;
							var MyRoleAct=talloc.ACTIVITY;
							var MyRolePrj=talloc.PROJECT;
							//var MyRoleActStudy=san_rdpm_get_study(MyRoleAct); not need activity study
							// PC-5567 - Take into account filter on vaccines Portfolio
							if (MyRoleAct!=undefined && MyRolePrj.SAN_RDPM_UA_B_TC_SEARCH_PROJECT_PORT_FILTER && san_rdpm_check_project_can_be_inserted(MyRolePrj)) {
							    //plw.writetolog(\"MyRoleAct: \"+MyRoleAct);
								if (san_rdpm_check_act_can_be_inserted(MyRoleAct)) vActResult.push(MyRoleAct);
							}
							
						}
					}
					vActResult=vActResult.removeduplicates();
					total_distinct_act=vActResult.length;
					plw.writetolog(\"\");
					plw.writetolog(\"############# Scanned insertable studies for skill \"+SkillString+\" and site \"+SiteString+\" #########\");
					plw.writetolog(\"Nb of scanned planned hours: \"+total_plh);
					plw.writetolog(\"Nb of distinct activities in TC projects: \"+total_distinct_act);
					plw.writetolog(\"TOTAL of activities to display in dialog: \"+vActResult.length);
					plw.writetolog(\"######################\");
				}
			}
			
			if (vActResult.length>0) {
				for (var Act in vActResult) {
					f.call(Act);
				}
			}
		}
	}
	act_table.delete();
	insert_act_table.delete();
	TC_projects_table.delete();
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
	
	var act_table=new hashtable(\"OBJECT\");
	var study_table=new hashtable(\"OBJECT\");
	var TC_projects_table=new hashtable(\"OBJECT\");
	
	var total_distinct_act=0;
	var total_distinct_std=0;
	var total_std_insertable=0;
	var total_act_insertable=0;
	
	//plw.alert(vRes);
	if(vRes != undefined && vRes instanceOf plc.Resource && vObs != undefined && !vObs.internal  && vObs instanceOf plc.obs_node)
	{
		var vResTcProfile=vRes.CURRENT_TIMECARD_PROFILE.printattribute();
		
		// Pharma case (PC-649)
		if (vResTcProfile==\"PHARMA\") {
			with(vObs.fromobject()) {
				//for (var ObsAct in vObs.get(\"OBS_CHILDREN\") where ObsAct instanceof plc.work_structure) {
				for (var ObsAct in  plc.work_structure) {
					total_distinct_act++;
					var ObsActPrj=ObsAct.PROJECT;
					if (TC_projects_table.get(ObsActPrj)==undefined) {
						TC_projects_table.set(ObsActPrj,san_rdpm_check_project_can_be_inserted(ObsActPrj));
					}
					if (TC_projects_table.get(ObsActPrj)==true) {
						var ObsActStudy=san_rdpm_get_study(ObsAct);
						if (ObsActStudy!=undefined && study_table.get(ObsActStudy)==undefined) {
							total_distinct_std++;
							study_table.set(ObsActStudy,true);
							if (ObsActStudy!=undefined && ObsAct.OBS_ELEMENT==vObs && san_rdpm_check_act_can_be_inserted(ObsActStudy)) {
								total_std_insertable++;
								vActResult.push(ObsActStudy);
							}
						}
						//PC-3686 Financial task should be displayed if OBS element (Financial task) = OBS element (Resource)
						if (ObsAct.wbs_type.printattribute()==context.SAN_RDPM_CS_AT_FIN_TASK && ObsAct.OBS_ELEMENT==vObs && san_rdpm_check_act_can_be_inserted(ObsAct)) {
							total_act_insertable++;
							vActResult.push(ObsAct);
						}
					}
				}
			}
			plw.writetolog(\"\");
			plw.writetolog(\"############# Scanned insertable studies and activities for OBS \"+vObs+\" #########\");
			plw.writetolog(\"Nb of distinct activities in TC projects: \"+total_distinct_act);
			plw.writetolog(\"Nb of distinct studies: \"+total_distinct_std);
			plw.writetolog(\"Nb of insertable studies: \"+total_std_insertable);
			plw.writetolog(\"Nb of insertable activities: \"+total_act_insertable);
			plw.writetolog(\"TOTAL of activities to display in dialog: \"+vActResult.length);
			plw.writetolog(\"######################\");
		}
		
		// Pasteur case (PC-686)
		if (vResTcProfile==\"PASTEUR\"){	
			var o_lvl4_res = vRes;
			var o_lvl4_res_obs;
			
			while(o_lvl4_res.LEVEL>4){o_lvl4_res=o_lvl4_res.ELEMENT_OF;}
			
			with(vObs.fromobject()){
				// PC-5567 - Take into account filter on vaccines Portfolio
				for (var vObsAct in plc.work_structure where vObsAct.project.SAN_RDPM_UA_B_TC_SEARCH_PROJECT_PORT_FILTER)  {								
					if (san_rdpm_check_act_can_be_inserted(vObsAct)) vActResult.push(vObsAct);
				}
			}
			
			if(o_lvl4_res.LEVEL==4){
				o_lvl4_res_obs = o_lvl4_res.OBS_ELEMENT;
				if(o_lvl4_res_obs != undefined && !o_lvl4_res_obs.internal  && o_lvl4_res_obs instanceOf plc.obs_node){
					with(o_lvl4_res_obs.fromobject()){
						// PC-5567 - Take into account filter on vaccines Portfolio
						for (var vObsAct in plc.work_structure where vObsAct.project.SAN_RDPM_UA_B_TC_SEARCH_PROJECT_PORT_FILTER)  {								
							if (san_rdpm_check_act_can_be_inserted(vObsAct)) vActResult.push(vObsAct);
						}
					}
				}
			}
			// PC-5567 - Take into account filter on vaccines Portfolio
			for ( var prj in plc.ordo_project where prj.san_rdpm_b_rnd_vaccines_project  && prj.getinternalvalue(\"STATE\").ToString()==\"ACTIVE\" && !(prj._wzd_aa_b_permanent) && prj.parent.printattribute()==\"\" && prj.SAN_RDPM_UA_B_TC_SEARCH_PROJECT_PORT_FILTER){
				var ActL1 = plc.network.get(prj.name);
				if (ActL1 instanceof plc.network && ActL1.obs_element.internal && san_rdpm_check_act_can_be_inserted(ActL1)){vActResult.push(ActL1);}
			}
		}
		
		vActResult = vActResult.removeduplicates();
		for (var o_act in vActResult){
			f.call(o_act);
		}
	}
}

// #################   All Activities   #################

function san_rdpm_tc_filter_all_activities(f) {	
	// on branche sur la relation standard
	// if there is not search filter, do nothing
	if (context._TCM_AA_S_SA_ACTIVITYFILTER==\"\"){
		return false;
	}
	else{
		// E7 compliancy, replace _TC_filter_my_contextual_projects_activities by context.get(\"_TC_OC_REL_CONTEXTUAL_FILTERED_WORKSTRUCTURES\")
		// PC-5567 - Take into account filter on vaccines Portfolio
		for (var act in context.get(\"_TC_OC_REL_CONTEXTUAL_FILTERED_WORKSTRUCTURES\") where act.project.SAN_RDPM_UA_B_TC_SEARCH_PROJECT_PORT_FILTER){
			f.call(act);
		}
	}
}

// #################   Global filter   #################

function san_rdpm_tc_filter_global(f) {
    // E7 compliance replace write_text_key by multilingual_writeTextKey
	var cond1=plw.multilingual_writeTextKey(\"RDPM.SAN_RDPM_TK_TC_PORT_MR\");
	var cond2=plw.multilingual_writeTextKey(\"RDPM.SAN_RDPM_TK_TC_PORT_MD\");
	var cond3=plw.multilingual_writeTextKey(\"RDPM.SAN_RDPM_TK_TC_PORT_ALL\");
	
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

var objectRelation SAN_RDPM_Global_TC_Context_Activity_Relation = plc.contextopx2.getSlotByID('RDPM_GLOBAL_TC_OC_REL_FILTERED_WORKSTRUCTURES');
if(!(SAN_RDPM_Global_TC_Context_Activity_Relation instanceof ObjectRelation)){
	SAN_RDPM_Global_TC_Context_Activity_Relation = new ObjectRelation(plc.contextopx2,'RDPM_GLOBAL_TC_OC_REL_FILTERED_WORKSTRUCTURES');
} 
SAN_RDPM_Global_TC_Context_Activity_Relation.comment = 'RDPM Time card global filtered Work-structures';
SAN_RDPM_Global_TC_Context_Activity_Relation.connectedtoclass = plc.work_structure;
SAN_RDPM_Global_TC_Context_Activity_Relation.mapmethod = san_rdpm_tc_filter_global;

// #################   Funtion to insert activity into the TimeSheet, without history   #################

function san_rdpm_pjs_tcm_addActivityInTimesheet(id) {
	// standard function, without history management (bad perf)
	//if (this.object instanceof opxactivity) {
	if (this.object instanceof plw.work_structure) {
		//generate hystory
		//_tcm_GenerateHistory();
		// E7 compliancy, replace create_time_input_line by timecard_addActivityToCurrentTimeSheet
		this.object.timecard_addActivityToCurrentTimeSheet();
		return true;
	}
	return false;
}

function san_rdpm_init_table_key_plh_skill() {
	for (var ResSkill in plc.resourceskill where ResSkill.SAN_RDPM_UA_B_IS_MAIN_SKILL) {
		var SkillString=ResSkill.printattribute();
		var total_plh=0;
		var v_attributes = new vector(\"SAN_UA_RDPM_S_PRIMARY_SKILL_FOR_TABLE_KEY\");
		var v_values = new vector(SkillString);
		var ka = new Keyattribute(plc.task_alloc,v_attributes,v_values);
		
		if (ka instanceof KeyAttribute){
			with(ka.fromObject()){
				for (var talloc in plc.taskalloc) {
					total_plh++;
				}
			}
		}
		plw.writetolog(\"## Initialized table key for skill \"+SkillString+\" --> \"+total_plh+\" planned hours\");
	}
}
// initilize tk
//san_rdpm_init_table_key_plh_skill();
// since 7.0.1, init with wrapper
// will be reviewed anyway as using a table key on computed user attribute is a very bad idea
wrap.intranetstarted.addwrapperafter(san_rdpm_init_table_key_plh_skill);

// ###################   PC-3695 ########################
function san_rdpm_tc_js_list_resources() {
	// PC-3695
	// reuse of standard function _tc_js_list_resources and add RDPM filter
	var user = context.applet.user;
	var current_user = new vector();
	current_user.push(user);
	var list_resources_managed = plw._tc_build_resource_list_from_user(current_user);
	//this.possiblevalues=list_resources_managed.vector_copy();
	var result1=list_resources_managed.vector_copy();
	var result2=new vector();
	for (var res in result1 where res.SAN_UA_RDPM_B_FILTER_RESOURCE_LIST_FOR_TC_INPUT) {
		result2.push(res);
	}
	this.possiblevalues=result2;
}
// ###################   PC-3695 ########################

// ###################   PC-4134 ########################
// function used to properly build URL in reminder emails sent to users via the workbox, esp. for TimeCard reminders
function san_rdpm_set_setting_value_HOME_ST_DEFAULT_APPLICATION_URL () {
	//--------- PC-4134 we must identify if we are on preprod or prod, built on specific architecture for TC
	var string current_db=context.CallStringFormula(\"$DATABASE_NAME\");
	
	var test_prod=context.CallBooleanFormula(\"\\\"\"+current_db+\"\\\"=\\\"*_PROD*\\\"\");
	var test_preprod=context.CallBooleanFormula(\"\\\"\"+current_db+\"\\\"=\\\"*_PREPROD*\\\"\");
	
	var prod_base_url=\"https://sanofi-continuum.planisware.live/app/plw/127.0.0.1:8100/\";
	var preprod_base_url=\"https://sanofi-continuum-preprod.planisware.live/app/plw/127.0.0.1:8100/\";
	
	if (test_prod) {
		plw.writetolog(\"[san_rdpm_set_setting_value_HOME_ST_DEFAULT_APPLICATION_URL] Currently on a prod environmnent.\");
		if (context._HOME_ST_DEFAULT_APPLICATION_URL!=prod_base_url) {
			context._HOME_ST_DEFAULT_APPLICATION_URL=prod_base_url;
		}
		plw.writetolog(\"Value for setting _HOME_ST_DEFAULT_APPLICATION_URL: \"+context._HOME_ST_DEFAULT_APPLICATION_URL);
	}
	else {
		if (test_preprod) {
			plw.writetolog(\"[san_rdpm_set_setting_value_HOME_ST_DEFAULT_APPLICATION_URL] Currently on a preprod environmnent.\");
			if (context._HOME_ST_DEFAULT_APPLICATION_URL!=preprod_base_url) {
				context._HOME_ST_DEFAULT_APPLICATION_URL=preprod_base_url;
			}
			plw.writetolog(\"Value for setting _HOME_ST_DEFAULT_APPLICATION_URL: \"+context._HOME_ST_DEFAULT_APPLICATION_URL);
		}
		else {
			plw.writetolog(\"[san_rdpm_set_setting_value_HOME_ST_DEFAULT_APPLICATION_URL] Currently on an environmnent different from prod and preprod, setting should be empty.\");
			context._HOME_ST_DEFAULT_APPLICATION_URL=\"\";
			plw.writetolog(\"Value for setting _HOME_ST_DEFAULT_APPLICATION_URL: \"+context._HOME_ST_DEFAULT_APPLICATION_URL);
		}
	}
	//--------- End PC-4134 -----------------------------------------------
}

wrap.intranetStarted.addWrapperAfter(san_rdpm_set_setting_value_HOME_ST_DEFAULT_APPLICATION_URL);
// ###################   PC-4134 ########################

"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260029509872
 :VERSION 32
 :_US_AA_D_CREATION_DATE 20230719000000
 :_US_AA_S_OWNER "E0046087"
)