
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 283130851869
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_DYN_RELATION
// 
//  AUTHOR  : S. AKAAYOUS
//
//  v1.2 - 2021/03/01 - David
//  Modify san_rdpm_js2_pharma_ol_act_cp_ref_map to limit on user projects and san_rdpm_js2_pharma_ol_act_cp_ref_project_map to remove the filter on PARENT project (PC-3286)
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
	for (var plc.ordo_project vProj in vListProj where vProj.SAN_RDPM_B_RND_PHARMA_PROJECT==true && vProj.PARENT.printattribute()==\"\" && \"REFERENCE_EXISTS\".callmacro(\"ACTIVITY\",vProj.printattribute(),\"MCN_NF_B_ON_CRIT_PATH\",context.SAN_RDPM_CS_LAST_MONTHLY_PHARMA)==true)
	{
		// Operational level activities that are newly on critical path only
		for(var plc.workstructure vAct in vProj.ACTIVITIES where vAct.SAN_RDPM_UA_ACT_B_OPL==true && vAct.SAN_RDPM_UF_B_CRITIC_PATH_REF==true)
		{
			f.call(vAct);
		}
	}
}

// Function to get OL activities from a project that are newly on critical path (comp with last monthly baseline)
function san_rdpm_js2_pharma_ol_act_cp_ref_project_map(f)
{
    var list l_prjt = undefined;
    if(this instanceof plc.virtualdataset) {
        l_prjt = this.getinternalvalue(\"SELECTED-DATASETS\");
    }else if(this instanceof plc.ordoproject) {
        l_prjt = new list(this);
    }
    if(l_prjt instanceof list && l_prjt.LENGTH > 0) 
    {
        for(var plc.ordoproject vProj in l_prjt) 
        {
            if (vProj instanceof plc.ordo_project && vProj.SAN_RDPM_B_RND_PHARMA_PROJECT==true && vProj.is_active && (vProj.callbooleanformula(\"OWNER = $CURRENT_USER\") || vProj._PM_NF_B_ADDITONNAL_MY_PROJECT_FILTER || (vProj.PARENT.printattribute()!=\"\" && (vProj.PARENT.callbooleanformula(\"OWNER = $CURRENT_USER\") || vProj.PARENT._PM_NF_B_ADDITONNAL_MY_PROJECT_FILTER) ))) 
            {
                for(var plc.workstructure vAct in vProj.ACTIVITIES)
                { 
                    // no use to continue if no reference
                    if (\"REFERENCE_EXISTS\".callmacro(\"ACTIVITY\",vAct.printattribute(),\"MCN_NF_B_ON_CRIT_PATH\",context.SAN_RDPM_CS_LAST_MONTHLY_PHARMA)!=true)
                        break;
                    // Operational level activities that are newly on critical path only
                    else if (vAct.SAN_RDPM_UA_ACT_B_OPL==true && vAct.SAN_RDPM_UF_B_CRITIC_PATH_REF==true)
                        f.call(vAct);
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
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260067159772
 :VERSION 3
 :_US_AA_D_CREATION_DATE 20210302000000
 :_US_AA_S_OWNER "E0296878"
)