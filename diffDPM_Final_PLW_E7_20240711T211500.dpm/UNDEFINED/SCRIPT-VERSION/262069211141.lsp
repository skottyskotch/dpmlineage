
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 262069211141
 :DATASET 118081000141
 :SCRIPT-CODE "/*
* Script V2
* Autor : Ludovic FAVRE
* JIRA : PC-386  (Study Baseline)
* Date Creation 07/12/2020
*/
namespace _rdpm_study_baseline;

function san_rdpm_take_automatic_study_baseline(refName,refDesc,relation_name)
{
	
	var vHash = new hashtable();
	var parent_project=\"\";
	var vHash_Obj=\"\";
	var exception_formula=\"\";
	var exception_formula = \"\";
	var baseline = plc._L1_PT_REF_ADMIN.get(refName);
	
	// Get the list of project with the exception formula
	for (var vact in baseline.get(relation_name))
	{
		parent_project=plc.project.get(vAct.project.SAN_RDPM_UA_PRJ_S_ROOT_PROJECT);
		vHash_Obj=vHash.get(parent_project);
		if (vHash_Obj!=undefined)
		{
			exception_formula=\"LIST_MERGE\".call(vHash_Obj,vact.printattribute());
		}
		else
		{
			exception_formula=vact.printattribute();
		}
		vHash.set(parent_project,exception_formula);
	}
	
	// Take baseline with the exception formula for identified projects
	for (var prjObj in vHash)
	{
		exception_formula=plw.compile_reference_activity_filter(refName,prjObj,vHash.get(prjObj));
		// Check baseleine exist
		var plc.reference baseline_to_update = plw._PM_Getreference(prjObj,refName);
		var boolean update = ( baseline_to_update instanceof plc.reference ) ? true : false;
		if (update)
			 plw._pm_updateReference(prjObj,baseline_to_update,exception_formula);
		// Create baseline if it does not exist
		else
		   plw.create_reference_with_parameter(refName,refDesc,prjObj,false,exception_formula);
	}
}

// Automatic beselines
san_rdpm_take_automatic_study_baseline(\"STUDY_BASELINE_1\",\"Study Baseline 1\",\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_AUTO_STUDY_BASELINE.WORK-STRUCTURE\");
san_rdpm_take_automatic_study_baseline(\"STUDY_BASELINE_2\",\"Study Baseline 2\",\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_AUTO_STUDY_BASELINE.WORK-STRUCTURE\");
san_rdpm_take_automatic_study_baseline(\"STUDY_BASELINE_3\",\"Study Baseline 3\",\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_AUTO_STUDY_BASELINE.WORK-STRUCTURE\");
// Manual Baseline
san_rdpm_take_automatic_study_baseline(\"STUDY_BASELINE_4\",\"Study Baseline 4\",\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_MANUAL_STUDY_BASELINE.WORK-STRUCTURE\");"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 0
 :VERSION 4
 :_US_AA_D_CREATION_DATE 20201216000000
 :_US_AA_S_OWNER "E0296878"
)