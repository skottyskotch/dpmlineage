
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321183398641
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_DYN_RELATION
// 
//  AUTHOR  : S. AKAAYOUS
//
//  v1.7 - 2022/02/22 - Antoine
//  Add timesynthesis for managed resources dyn attributes for the Actual report in timecard
//
//  v1.6 - 2021/12/15 - Islam
//  Modify relations for workboxe Team members enable project access (PC-5251)
//
//  v1.5 - 2021/11/23 - Islam
//  Modify relations for workboxes Newly positioned on critical path (PC-4857)
//
//  v1.4 - 2021/11/17 - Islam
//  Add relations for workboxes Team members enable/disable project access (PC-4272)
//
//  v1.3 - 2021/04/01 - Florian
//  Create generic relation 'san_context_dr_project_phases_map' to list Project phases based on Portfolio filter (Portfolio Module). Used for PC-2930 Success Rates entry by PFM
// 
//  v1.2 - 2021/03/01 - David
//  Modify san_rdpm_js2_pharma_ol_act_cp_ref_map to limit on user projects and san_rdpm_js2_pharma_ol_act_cp_ref_project_map to manage multi-projects and use of table key for perf (PC-3286)
//
//  v1.1 - 2021/02/02 - David 
//  Add relations for workboxes Newly positioned on critical path (PC-1649)
//
//  v1.0 - 2020/10/12 - SAK
//  Script used for PC 140 : Traces set up: Record modifications on Resources & availabilities 
//
//***************************************************************************/
namespace _san_rdpm_res;

// ------------------------- PC 140 : Traces set up: Record modifications on Resources & availabilities -----------------------

function san_rdpm_tc_manager_time_synthesis(f)
{
	var Current_user = Context.Applet.User;
	if (Current_user instanceof plc.Opx2_user)
	{
		for (var Res in Current_user.get(\"MANAGED-RESOURCES\"))
		{
			for (var TS in Res.get(\"TIME-SYNTS\"))
			{
				f.call(TS);
			}
		}
	}
}

//dynamic relation between context and hours and expenditures summaries of resources managed by current user (Timecard)
function san_rdpm_dyn_rel_tc_manager_hes(){
  var SAN_RDPM_REL_TC_MANAGER_HES = new ObjectRelation(plc.contextopx2,\"SAN_RDPM_DYN_REL_TC_MANAGER_HES\");
  SAN_RDPM_REL_TC_MANAGER_HES.Mapmethod = san_rdpm_tc_manager_time_synthesis;
  SAN_RDPM_REL_TC_MANAGER_HES.ConnectedToClass = plc.timesynthesis;
  SAN_RDPM_REL_TC_MANAGER_HES.Comment = \"RDPM TIME_CARD MANAGER TIME SYNTHESIS\";
}


// Declaration of the dynamic relation 
try{
	with(plw.no_locking){
		san_rdpm_dyn_rel_tc_manager_hes();
	}
}
catch (error e){
	plw.writeToLog(\"Failed to create SAN_RDPM_DYN_REL_TC_MANAGER_HES\");
	plw.writeln(e);
}

function san_rdpm_func_res_trace(f){
	var res = this;
	var result = new vector();
	if ( res instanceof plc.resource){
		for (var trace in res.get(\"TRACE-LOGS\"))
		{
			result.push(trace);
		}
		for (var dispo in res.get(\"Availabilities\"))
		{
			for (var trace in dispo.get(\"TRACE-LOGS\"))
			{
				result.push(trace);
			}
		}  
		for (var trace in result)
		{
			f.call(trace);
		}
	}
}


//dynamic relation between resources and traces resources & availability
function san_rdpm_dyn_rel_res_traces(){
  var SAN_RDPM_REL_RES_TRACES = new ObjectRelation(plc.Resource,\"SAN_RDPM_RES_AVAIL_TRACES\");
  SAN_RDPM_REL_RES_TRACES.Mapmethod = san_rdpm_func_res_trace;
  SAN_RDPM_REL_RES_TRACES.ConnectedToClass = plc.trace_log;
  SAN_RDPM_REL_RES_TRACES.Comment = \"RDPM RESOURCE AND AVAILABILITIES TRACES\";
}
// ## Declaration of the dynamic relation ##
try{
with(plw.no_locking){
san_rdpm_dyn_rel_res_traces();
}
}
catch (error e){
 plw.writeToLog(\"Failed to create SAN_RDPM_RES_AVAIL_TRACES\");
 plw.writeln(e);
}

// ------------------------- PC 1649 : Relations for workboxes Newly positioned on critical path -----------------------

// Function to get all OL activities that are newly on critical path (comp with last monthly baseline)
function san_rdpm_js2_pharma_ol_act_cp_ref_map(f)
{
    // get the list of user projects (porject team) as for project objectives
    var vListProj=_san_rdpm_dyn_attribute.san_rdpm_js2_get_my_active_projects();
	// filter on projects where the field ciritical path exists on last monthly baseline
	for (var plc.ordo_project vProj in vListProj where vProj.SAN_RDPM_B_RND_PHARMA_PROJECT==true && \"REFERENCE_EXISTS\".callmacro(\"ACTIVITY\",vProj.printattribute(),\"MCN_NF_B_ON_CRIT_PATH\",context.SAN_RDPM_CS_LAST_MONTHLY_PHARMA)==true){
		with(vProj.fromObject()){
			for(var vAct in plc.workstructure where vAct.SAN_RDPM_UF_B_CRITIC_PATH_REF==true){
				f.call(vAct);
			}
		}
	}
}

// Function to get OL activities from a project that are newly on critical path (comp with last monthly baseline)
function san_rdpm_js2_pharma_ol_act_cp_ref_project_map(f)
{
	var list l_prjt = undefined;
	if(this instanceof plc.virtualdataset){
		l_prjt = this.getinternalvalue(\"SELECTED-DATASETS\");
	}
	else if(this instanceof plc.ordoproject){
		l_prjt = new list(this);
	}
	if(l_prjt instanceof list && l_prjt.LENGTH > 0){
		for(var plc.ordoproject vProj in l_prjt){
			if (vProj instanceof plc.ordo_project && vProj.SAN_RDPM_B_RND_PHARMA_PROJECT==true && \"REFERENCE_EXISTS\".callmacro(\"ACTIVITY\",vProj.printattribute(),\"MCN_NF_B_ON_CRIT_PATH\",context.SAN_RDPM_CS_LAST_MONTHLY_PHARMA)==true){
				with(vProj.fromObject()){
					for(var vAct in plc.workstructure where vAct.SAN_RDPM_UF_B_CRITIC_PATH_REF==true){
						f.call(vAct);
					}
				}
			}
		}
	}
}

//dynamic relation between context user and activities
function san_rdpm_dr_my_pharma_ol_act_cp_ref(){
	var SAN_RDPM_REL_PHARMA_OL_ACT_CP_REF = new ObjectRelation(plc.contextopx2,\"SAN_RDPM_REL_MY_PHARMA_OL_ACT_CP_REF\");
	SAN_RDPM_REL_PHARMA_OL_ACT_CP_REF.Mapmethod = san_rdpm_js2_pharma_ol_act_cp_ref_map;
	SAN_RDPM_REL_PHARMA_OL_ACT_CP_REF.ConnectedToClass = plc.workstructure;
	SAN_RDPM_REL_PHARMA_OL_ACT_CP_REF.Comment = \"RDPM My OL activities newly on critical path\";
	var SAN_RDPM_REL_PHARMA_OL_ACT_CP_REF_PM = new ObjectRelation(plc.dataset,\"SAN_RDPM_REL_PRJ_OL_ACT_CP_REF\");
	SAN_RDPM_REL_PHARMA_OL_ACT_CP_REF_PM.Mapmethod = san_rdpm_js2_pharma_ol_act_cp_ref_project_map;
	SAN_RDPM_REL_PHARMA_OL_ACT_CP_REF_PM.ConnectedToClass = plc.workstructure;
	SAN_RDPM_REL_PHARMA_OL_ACT_CP_REF_PM.Comment = \"RDPM OL activities newly on critical path\";
}

// Declaration of the dynamic relation 
try{
	with(plw.no_locking){
		san_rdpm_dr_my_pharma_ol_act_cp_ref();
	}
}
catch (error e){
	plw.writeToLog(\"Failed to create SAN_RDPM_REL_MY_PHARMA_OL_ACT_CP_REF / SAN_RDPM_REL_PRJ_OL_ACT_CP_REF\");
	plw.writeln(e);
}

// ----------------------- PC-2930 : Relation for Project phases based on Portfolio filter used for Success Rates entry (PFM) -----------------------

function san_context_dr_project_phases_map(f)
{
	// Use hashtable to avoid the return of duplicates
	var san_portfolio_project_phases = new hashtable();
	for(var o_project in plc.project where o_project.PM_PRJ_FILTER)
	{
		for(var o_act in o_project.get(\"_PAC_DR_PROJECT_PHASES\"))
		{
			san_portfolio_project_phases.set(o_act,0);
		}
	}
	for(var o_act in san_portfolio_project_phases)
	{
		f.call(o_act);
	}
}

// Dynamic relation
function san_context_dr_project_phases_definition(){
	var san_context_dr_project_phases = new ObjectRelation(plc.contextopx2,\"SAN_CONTEXT_DR_PROJECT_PHASES\");
	san_context_dr_project_phases.Mapmethod = san_context_dr_project_phases_map;
	san_context_dr_project_phases.ConnectedToClass = plc.workstructure;
	san_context_dr_project_phases.Comment = \"Project phases based on Portfolio filter\";
}

// Declaration of the dynamic relation 
try{
	with(plw.no_locking){
		san_context_dr_project_phases_definition();
	}
} catch (error e) {
	plw.writeToLog(\"Failed to create SAN_CONTEXT_DR_PROJECT_PHASES\");
	plw.writeln(e);
}

// ------------------------- PC-4272 : Relation for workbox Team members to manage -----------------------

// Function to get team members (users) that needs to be enabled
function san_rdpm_js2_tm_to_enable(f){
	var v_user_groups = ['P_STD','M_VACCINES','O_GBU_VACCINES'];
	if(context.callbooleanformula('USER_IN_GROUP($CURRENT_USER,\"OR_FUNCT_ADM_VACCINES\")')){
		var o_project_type = plc.project_type.get('Continuum.RDPM.Pasteur');
		with(o_project_type.fromobject()){
			for(var o_project in plc.project where o_project.is_active && o_project.SAN_RDPM_B_RND_VACCINES_PROJECT && o_project.parent.printattribute()==''){
				with(o_project.fromobject()){		
					for(var o_tm in plc.__USER_TABLE_SAN_RDPM_UT_PROJECT_TEAM_MEMBER where o_tm.get('SAN_RDPM_UA_PROJECT_ROLE')!=''){	
						if(o_tm.get('SAN_RDPM_UA_PROJECT_ROLE').get('SAN_RDPM_UA_PR_B_PRJ_READ_PERMISSION')){
							var o_tm_user = o_tm.SAN_RDPM_UA_USER;
							if(o_tm_user instanceof plc.opx2_user){
								var b_tm_to_manage = false;
								//Check user groups of the project team member
								for(var s_user_group in v_user_groups){
									if(o_tm_user.callbooleanformula('NOT USER_IN_GROUP(ID,\"'+s_user_group+'\")')){b_tm_to_manage=true;break;}
								}
								//Check the other properties
								if(!(o_tm_user.get('OPX2_INTRANET_ACCESS') && o_tm_user.get('READ_ONLY_ACCESS'))){b_tm_to_manage=true;}
								if(b_tm_to_manage){f.call(o_tm_user);}
							}
						}
					}
				}
			}
		}
	}
}

// Function to get team members (users) that needs to disabled
function san_rdpm_js2_tm_to_disable(f){
	var v_user_groups = ['P_STD','M_VACCINES','O_GBU_VACCINES'];
	if(context.callbooleanformula('USER_IN_GROUP($CURRENT_USER,\"OR_FUNCT_ADM_VACCINES\")')){
		for(var o_user in plc.opx2_user where o_user.callbooleanformula('USER_IN_GROUP(ID,\"O_GBU_VACCINES\")') && o_user.get('OPX2_INTRANET_ACCESS')){
			if(o_user.GROUPS_LIST.split(',').length==3 && o_user.GROUPS_LIST.split(',').difference(v_user_groups)==false){
				plw.alert(o_user);
			}
		}
	}
}

//dynamic relations between context user and users
function san_rdpm_dr_tm_to_manage(){
	var SAN_RDPM_REL_TM_TO_ENABLE = new ObjectRelation(plc.contextopx2,\"SAN_RDPM_REL_TM_TO_ENABLE\");
	SAN_RDPM_REL_TM_TO_ENABLE.Mapmethod = san_rdpm_js2_tm_to_enable;
	SAN_RDPM_REL_TM_TO_ENABLE.ConnectedToClass = plc.opx2_user;
	SAN_RDPM_REL_TM_TO_ENABLE.Comment = \"Team Member Users to Enable\";
	
	var SAN_RDPM_REL_TM_TO_DISABLE = new ObjectRelation(plc.contextopx2,\"SAN_RDPM_REL_TM_TO_DISABLE\");
	SAN_RDPM_REL_TM_TO_DISABLE.Mapmethod = san_rdpm_js2_tm_to_disable;
	SAN_RDPM_REL_TM_TO_DISABLE.ConnectedToClass = plc.opx2_user;
	SAN_RDPM_REL_TM_TO_DISABLE.Comment = \"Team Member Users to Disable\";
}

// Declaration of the dynamic relation 
try{
	with(plw.no_locking){
		san_rdpm_dr_tm_to_manage();
	}
}
catch (error e){
	plw.writeToLog(\"Failed to create SAN_RDPM_REL_TM_TO_ENABLE and SAN_RDPM_REL_TM_TO_DISABLE\");
	plw.writeln(e);
}


// ------------------------- PC-4272 : Relation for workbox Newly -----------------------

// Function to get team members (users) that needs to be enabled
function san_rdpm_js2_tm_to_enable(f){
	var v_user_groups = ['P_STD','M_VACCINES','O_GBU_VACCINES'];
	var v_tm_users_enable = new vector();
	if(context.callbooleanformula('USER_IN_GROUP($CURRENT_USER,\"OR_FUNCT_ADM_VACCINES\")')){
		for(var o_project in plc.project where o_project.is_active && o_project.SAN_RDPM_B_RND_VACCINES_PROJECT && o_project.parent.printattribute()==''){
			with(o_project.fromobject()){		
				for(var o_tm in plc.__USER_TABLE_SAN_RDPM_UT_PROJECT_TEAM_MEMBER where o_tm.get('SAN_RDPM_UA_PROJECT_ROLE')!=''){	
					if(o_tm.get('SAN_RDPM_UA_PROJECT_ROLE').get('SAN_RDPM_UA_PR_B_PRJ_READ_PERMISSION')){
						var o_tm_user = o_tm.SAN_RDPM_UA_USER;
						if(o_tm_user instanceof plc.opx2_user){
							if(o_tm_user.GROUPS_LIST.split(',').length<=3){
								var b_tm_to_manage = false;
								//Check user groups of the project team member
								for(var s_user_group in v_user_groups){
									if(o_tm_user.callbooleanformula('NOT USER_IN_GROUP(ID,\"'+s_user_group+'\")')){b_tm_to_manage=true;break;}
								}
								//Check the other properties
								if(!(o_tm_user.get('OPX2_INTRANET_ACCESS') && o_tm_user.get('READ_ONLY_ACCESS'))){b_tm_to_manage=true;}
								if(b_tm_to_manage){v_tm_users_enable.push(o_tm_user);}
							}
						}
					}
				}
			}
		}
		v_tm_users_enable = v_tm_users_enable.removeduplicates();
		for(var o_tm_user_enable in v_tm_users_enable){
			f.call(o_tm_user_enable);
		}
	}
}

// Function to get team members (users) that needs to disabled
function san_rdpm_js2_tm_to_disable(f){
	var v_user_groups = ['P_STD','M_VACCINES','O_GBU_VACCINES'];
	var v_active_basic_users = new vector();
	var v_team_members = new vector();
	var v_basic_users_to_disable = new vector();
	if(context.callbooleanformula('USER_IN_GROUP($CURRENT_USER,\"OR_FUNCT_ADM_VACCINES\")')){
		for(var o_user in plc.opx2_user where o_user.callbooleanformula('USER_IN_GROUP(ID,\"O_GBU_VACCINES\")') && o_user.get('OPX2_INTRANET_ACCESS')){
			if(o_user.GROUPS_LIST.split(',').length==3 && o_user.GROUPS_LIST.split(',').difference(v_user_groups)==false){
				v_active_basic_users.push(o_user);
			}
		}
		for(var o_project in plc.project where o_project.is_active && o_project.SAN_RDPM_B_RND_VACCINES_PROJECT && o_project.parent.printattribute()==''){
			with(o_project.fromobject()){		
				for(var o_tm in plc.__USER_TABLE_SAN_RDPM_UT_PROJECT_TEAM_MEMBER where o_tm.get('SAN_RDPM_UA_PROJECT_ROLE')!=''){	
					if(o_tm.get('SAN_RDPM_UA_PROJECT_ROLE').get('SAN_RDPM_UA_PR_B_PRJ_READ_PERMISSION')){
						var o_tm_user = o_tm.SAN_RDPM_UA_USER;
						if(o_tm_user instanceof plc.opx2_user){
							v_team_members.push(o_tm_user);
						}
					}
				}
			}
		}
		v_basic_users_to_disable = v_active_basic_users.difference(v_team_members);
		if(v_basic_users_to_disable.length>0){
			for(var o_user in v_basic_users_to_disable){
				f.call(o_user);
			}
		}
	}
}

//dynamic relations between context user and users
function san_rdpm_dr_tm_to_manage(){
	var SAN_RDPM_REL_TM_TO_ENABLE = new ObjectRelation(plc.contextopx2,\"SAN_RDPM_REL_TM_TO_ENABLE\");
	SAN_RDPM_REL_TM_TO_ENABLE.Mapmethod = san_rdpm_js2_tm_to_enable;
	SAN_RDPM_REL_TM_TO_ENABLE.ConnectedToClass = plc.opx2_user;
	SAN_RDPM_REL_TM_TO_ENABLE.Comment = \"Team Member Users to Enable\";
	
	var SAN_RDPM_REL_TM_TO_DISABLE = new ObjectRelation(plc.contextopx2,\"SAN_RDPM_REL_TM_TO_DISABLE\");
	SAN_RDPM_REL_TM_TO_DISABLE.Mapmethod = san_rdpm_js2_tm_to_disable;
	SAN_RDPM_REL_TM_TO_DISABLE.ConnectedToClass = plc.opx2_user;
	SAN_RDPM_REL_TM_TO_DISABLE.Comment = \"Team Member Users to Disable\";
}

// Declaration of the dynamic relation 
try{
	with(plw.no_locking){
		san_rdpm_dr_tm_to_manage();
	}
}
catch (error e){
	plw.writeToLog(\"Failed to create SAN_RDPM_REL_TM_TO_ENABLE and SAN_RDPM_REL_TM_TO_DISABLE\");
	plw.writeln(e);
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260067159772
 :VERSION 11
 :_US_AA_D_CREATION_DATE 20220222000000
 :_US_AA_S_OWNER "E0496980"
)