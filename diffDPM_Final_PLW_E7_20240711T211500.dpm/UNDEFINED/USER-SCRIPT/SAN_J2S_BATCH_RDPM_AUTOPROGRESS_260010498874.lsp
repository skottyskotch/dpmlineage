
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 260010498874
 :NAME "SAN_J2S_BATCH_RDPM_AUTOPROGRESS"
 :COMMENT "Pharma & Vaccines Autoprogress batch"
 :ACTIVE T
 :DATASET 118081000141
 :LOAD-ORDER 0
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_J2S_BATCH_RDPM_AUTOPROGRESS
// 
//  AUTHOR  : L. FAVRE
//
//  Updated 08-DEC-2021 EP
//  PC-5207 - reschedule batch once a week due to performance issues
//
//  Updated 04-OCT-2021 LFA
//  PC-4673 - Limit to Pharma Projects until Vaccines Projects are fully migrated
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
// Updated 02-MAR-2022 ABE
// PC-5046 : Apply auto-progress for Pharma & Vaccine projects => Replace Continuum.RDPM.Pharma by Continuum.RDPM
//
// Updated 07-APR-2022 WST
// PC-5967 : Uncomment RECOMPUTE-DATES for all modified project
//***************************************************************************/

namespace _batch_san_ba_rdpm_pha;

var date = new date();
var today=\"DAY\".call(date);
var sunday_date = \"DAY_OF_WEEK\".call(date,0);
var boolean is_sunday=false;
if (today==sunday_date) is_sunday=true;
var string result=\"Is today a sunday? --> \"+is_sunday;
plw.writetolog(\"\");
plw.writetolog(\"Is today a sunday? --> \"+result);

if (is_sunday) {
	plw.writetolog(\"\");
	plw.writetolog(\"###################################################\");
	plw.writetolog(\"\");
	plw.writetolog(\"SUNDAY: Start treatment in SAN_J2S_BATCH_RDPM_AUTOPROGRESS...\");
	var list = [];
	
	// Loop on Projects: restrict loop to Active & Simulation projects only
	// PC-4673 - Limit to Pharma Projects until Vaccines Projects are fully migrated
	// PC-5046 : Apply auto-progress for Pharma & Vaccine projects => Replace Continuum.RDPM.Pharma by Continuum.RDPM
	var o_project_type_filter = plw.objectset(plc.project_type.get(\"Continuum.RDPM\"));
	with(o_project_type_filter.fromobject())
	{
		for(var o_project in plc.project where o_project.DELETED==false  && (o_project.STATE==\"Active\" || o_project.STATE==\"Simulation\"))
		{
			list.push(o_project);
		}
	}
	
	var filter = plw.objectset(list);
	with(filter.fromobject()) {
		for (var vAct in plc.workstructure where vAct.SAN_UA_RDPM_B_AUTOPROGRESS) {
			try {	
				if (vAct.SAN_UA_RDPM_B_PF_BEFORE_TIME_NOW) {
					vAct.callmacro(\"CONFIRMPROGRESS\");
				}
				else {
					if (vAct.PD<vAct.SAN_RDPM_UA_D_AUTOPROGRESS_DATE) {
						vAct.PD=vAct.SAN_RDPM_UA_D_AUTOPROGRESS_DATE;
					}
				}
			}
			catch(error e){
				if(e != undefined){plw.writetolog(e); e.printStacktrace();}
			}
		}
	}
	
	plw.writetolog(\"End of treatment in SAN_J2S_BATCH_RDPM_AUTOPROGRESS.\");
	plw.writetolog(\"\");
	plw.writetolog(\"###################################################\");
	plw.writetolog(\"\");
	
	// Recompute dates on projects
	// !!! USELESS !!!
	for (var vProj in list)
	{
			vProj.callmacro(\"RECOMPUTE-DATES\");
	}
}
else {
	plw.writetolog(\"\");
	plw.writetolog(\"###################################################\");
	plw.writetolog(\"\");
	plw.writetolog(\"Not sunday, do not run batch SAN_BA_RDPM_AUTOPROGRESS\");
	plw.writetolog(\"\");
	plw.writetolog(\"###################################################\");
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 15
 :_US_AA_B_BATCH_SCRIPT "1"
 :_US_AA_D_CREATION_DATE 20201008000000
 :_US_AA_S_OWNER "intranet"
)