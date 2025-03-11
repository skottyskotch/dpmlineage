
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 296641172174
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_J2S_BATCH_RDPM_AUTOPROGRESS
// 
//  AUTHOR  : L. FAVRE
//
//  
//  Updated 01-FEB-2021 FLC
//  Add fromobject on Active & Simulation projects
//  22-FEB-2021 MDO Update: replaced vAct.PD=date; with vAct.PD=vAct.SAN_RDPM_UA_D_AUTOPROGRESS_DATE;
//
//***************************************************************************/

namespace _batch_san_ba_rdpm_pha;

var list = [];

// Loop on Projects: restrict loop to Active & Simulation projects only
var o_project_type_filter = plw.objectset(plc.project_type.get(\"Continuum.RDPM\"));
with(o_project_type_filter.fromobject())
{
	for(var o_project in plc.project where o_project.DELETED==false  && (o_project.STATE==\"Active\" || o_project.STATE==\"Simulation\"))
	{
		list.push(o_project);
	}
}

var filter = plw.objectset(list);
with(filter.fromobject())
{
	for (var vAct in plc.workstructure where vAct.SAN_UA_RDPM_B_AUTOPROGRESS)
	{
		vAct.PD=vAct.SAN_RDPM_UA_D_AUTOPROGRESS_DATE;
	}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260010498874
 :VERSION 4
 :_US_AA_D_CREATION_DATE 20210323000000
 :_US_AA_S_OWNER "E0296878"
)