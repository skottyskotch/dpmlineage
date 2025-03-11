
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 316654256374
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_J2S_BATCH_RDPM_AUTOPROGRESS
// 
//  AUTHOR  : L. FAVRE
//
//  
//  Updated 01-FEB-2021 FLC
//  Add fromobject on Active & Simulation projects
//
//  Updated 22-FEB-2021 MDO 
//  Replaced vAct.PD=date; with vAct.PD=vAct.SAN_RDPM_UA_D_AUTOPROGRESS_DATE;
//
//  Updated 07-JUN-2021 IGU 
//  Add a try catch to manage errors (unknown activities)
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
    	try{	
    		if (vAct.SAN_UA_RDPM_B_PF_BEFORE_TIME_NOW)
    		{
    			vAct.callmacro(\"CONFIRMPROGRESS\");
    		}
    		else
    		{
    			if (vAct.PD<vAct.SAN_RDPM_UA_D_AUTOPROGRESS_DATE)
    			{
    				vAct.PD=vAct.SAN_RDPM_UA_D_AUTOPROGRESS_DATE;
    			}
    		}
    	}
    	catch(error e){
    	    if(e != undefined){plw.writetolog(e); e.printStacktrace();}
    	}
	}
}

// Recompute dates on projects
for (var vProj in list)
{
	vProj.callmacro(\"RECOMPUTE-DATES\");
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260010498874
 :VERSION 10
 :_US_AA_D_CREATION_DATE 20211005000000
 :_US_AA_S_OWNER "E0296878"
)