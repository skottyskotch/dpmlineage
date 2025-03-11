
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 292393146676
 :DATASET 118081000141
 :SCRIPT-CODE "/*
* Script V2 Name : SAN_RDPM_JS2_ACTIVITY_STATE_UPDATE


* 02-JAN-21 ABE V2.00  PC-3030 : Batch to open activity to TT and \"is a study?\" from Act type table now
* 28-DEC-20 ABE V2.00  PC-2469 : Update filter to exclude non relevant projects from the treatment (permanent projects, templates, Simulation)
* 02-OCT-20 MDO V1.02 Update filter testing pharma project type
* 15-SEP-20 MDO V1.01 Update for filter with new datasets
* 03-MAR-20 HRA V1.00 Creation of script(RDPM Update Activity STATE for time tracking)
*/

namespace _san_rdpm_activity_state_update;


var list = new vector();

var o_project_type_filter = plw.objectset(plc.project_type.get(\"Continuum.RDPM\"));

with(o_project_type_filter.fromobject())
{
	// Loop on Projects: restrict loop to Active Pharma projects only and exclude non relevant projects from the treatment (permanent projects, templates, Simulation)
    for(var o_project in plc.project where o_project.DELETED==false && o_project.STATE==\"Active\" && o_project.SAN_RDPM_B_RND_PHARMA_PROJECT && o_project._INF_NF_S_PRJ_STATE_INTERNAL && o_project._WZD_AA_B_PERMANENT != true && o_project._INF_NF_B_IS_TEMPLATE != true )
    {
        list.push(o_project);
    }
}

var filter = plw.objectset(list);

with(filter.fromobject())
{
    for (var vAct in plc.workstructure )
    {
        if (vAct.SAN_UA_RDPM_B_UPDATE_ACTIVITY_STATE_TO_OPEN ) {
			vAct.state = \"Open\";
			plw.writetolog(vAct.name+\" updated to Open\");
		}
		if (vAct.SAN_UA_RDPM_B_UPDATE_ACTIVITY_STATE_TO_CLOSED) {
			vAct.state = \"Closed\";
			plw.writetolog(vAct.name+\" updated to Closed\");
		}		
    }
}
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 282704454676
 :VERSION 3
 :_US_AA_D_CREATION_DATE 20210309000000
 :_US_AA_S_OWNER "E0455451"
)