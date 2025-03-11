
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 296654843974
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_CONTINUUM_JS2_COMMON_FUNCTIONS
//  Common functions for Continuum
//
//  v1.0 - 2021/04/07 - Ludovic
//
//***************************************************************************/
namespace _san_impact_import;

// Creation of hashtable of activities linked to the clinical milestones
// Clinical milestone start
var clin_ms_start_act = new hashtable(\"STRING\");
var clin_ms_end_act = new hashtable(\"STRING\");
var act_impact_code;
var clin_ms_start;
var clin_ms_end;
var list_ms_start = new vector();
var list_ms_end = new vector();

// Loop on Projects: restrict loop to Active & Simulation projects only
for(var o_project in plc.project where o_project.SAN_RDPM_B_RND_PHARMA_PROJECT && o_project.DELETED==false  && (o_project.STATE==\"Active\" || o_project.STATE==\"Simulation\"))
{
	list_ms_start.push(o_project);
	list_ms_end.push(o_project);
}

for (var clin_ms in plc.__USER_TABLE_SAN_RDPM_UT_CLINICAL_MILESTONES)
{
	// Clinical milestone start
	for (var act_type in clin_ms.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_CLIN_MS_START.WBS_TYPE\"))
	{
		list_ms_start.push(act_type);
	}	
	
	// Clinical milestone end
	for (var act_type in clin_ms.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_CLIN_MS_END.WBS_TYPE\"))
	{
		list_ms_end.push(act_type);
	}
}

// Create hashtable for Clinical Milestone end
var filter = plw.objectset(list_ms_start);
with(filter.fromobject()){		
	for(var vAct in plc.work_structure)
	{
		act_impact_code=vAct.SAN_RDPM_UA_S_IMPACT_CODE_START_MS;
		clin_ms_start=clin_ms_start_act.get(act_impact_code);
		if (clin_ms_start==undefined)
			clin_ms_start_act.set(act_impact_code,vAct.ONB.tostring());
		else
			clin_ms_start_act.set(act_impact_code,clin_ms_start+\",\"+vAct.ONB.tostring());
	}
}

// Create hashtable for Clinical Milestone end
var filter = plw.objectset(list_ms_end);
with(filter.fromobject()){		
	for(var vAct in plc.work_structure)
	{
		act_impact_code=vAct.SAN_RDPM_UA_S_IMPACT_CODE_END_MS;
		clin_ms_end=clin_ms_end_act.get(act_impact_code);
		if (clin_ms_end==undefined)
			clin_ms_end_act.set(act_impact_code,vAct.ONB.tostring());
		else
			clin_ms_end_act.set(act_impact_code,clin_ms_end+\",\"+vAct.ONB.tostring());
	}
}

for (var obj in clin_ms_start_act)
{
	plw.alert(\"Impact code : \" +obj + \" - List activities : \" +clin_ms_start_act.get(obj));
}

// Read data to import
/*var path = \"/tmp/test\";
var fips = new fileinputstream(path);
var line = fips.readline();
alert(line);*/
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 296654818774
 :VERSION 2
 :_US_AA_D_CREATION_DATE 20210421000000
 :_US_AA_S_OWNER "E0296878"
)