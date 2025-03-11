
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 262140689374
 :DATASET 118081000141
 :SCRIPT-CODE "/*
* Script V2
* Autor : Ludovic FAVRE
* JIRA : PC-386  (Study Baseline)
* Date Creation 07/12/2020
*/
namespace _rdpm_study_baseline;

function san_rdpm_take_study_baseline(vAct,refName,refDesc)
{
	var prjObj=plc.project.get(vAct.project.SAN_RDPM_UA_PRJ_S_ROOT_PROJECT);
	var exception_formula = plw.compile_reference_activity_filter(refName,prjObj,vAct.printattribute());
	// Check baseleine exist
	var plc.reference baseline_to_update = plw._PM_Getreference(prjObj,refName);
	var boolean update = ( baseline_to_update instanceof plc.reference ) ? true : false;
	if (update)
		 plw._pm_updateReference(prjObj,baseline_to_update,exception_formula);
	// Create baseline if it does not exist
	else
	   plw.create_reference_with_parameter(refName,refDesc,prjObj,false,exception_formula);
}

var refName=\"\";
var refDesc=\"\";

// Manual baseline
var manual_baseline = plc._L1_PT_REF_ADMIN.get(\"STUDY_BASELINE_4\");
var refName=\"STUDY_BASELINE_4\";
var refDesc=\"Study Baseline 4\";

for (var vact in manual_baseline.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_MANUAL_STUDY_BASELINE.WORK-STRUCTURE\"))
{
    vAct.SAN_RDPM_UA_B_STUDY_BAS_4_TAKEN=true;
	san_rdpm_take_study_baseline(vAct,refName,refDesc);
	vact.SAN_RDPM_UA_B_TAKE_STUDY_BASELINE=false;
}

// Study Baseline 1
var Study_Baseline_1 = plc._L1_PT_REF_ADMIN.get(\"STUDY_BASELINE_1\");
var refName=\"STUDY_BASELINE_1\";
var refDesc=\"Study Baseline 1\";
var study=\"\";

for (var vact in Study_Baseline_1.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_AUTO_STUDY_BASELINE.WORK-STRUCTURE\"))
{
	study = plc.workstructure.get(vact.SAN_UA_RDPM_ACT_S_STUDY_ID);
	san_rdpm_take_study_baseline(study,refName,refDesc);
	with(plw.no_locking){vact.SAN_RDPM_UA_B_STUDY_BASELINE_TAKEN=true;}
}

// Study Baseline 2
var Study_Baseline_2 = plc._L1_PT_REF_ADMIN.get(\"STUDY_BASELINE_2\");
var refName=\"STUDY_BASELINE_2\";
var refDesc=\"Study Baseline 2\";

for (var vact in Study_Baseline_2.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_AUTO_STUDY_BASELINE.WORK-STRUCTURE\"))
{
	study = plc.workstructure.get(vact.SAN_UA_RDPM_ACT_S_STUDY_ID);
	san_rdpm_take_study_baseline(study,refName,refDesc);
	with(plw.no_locking){vact.SAN_RDPM_UA_B_STUDY_BASELINE_TAKEN=true;}
}

// Study Baseline 3
var Study_Baseline_3 = plc._L1_PT_REF_ADMIN.get(\"STUDY_BASELINE_3\");
var refName=\"STUDY_BASELINE_3\";
var refDesc=\"Study Baseline 3\";

for (var vact in Study_Baseline_3.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_AUTO_STUDY_BASELINE.WORK-STRUCTURE\"))
{
	study = plc.workstructure.get(vact.SAN_UA_RDPM_ACT_S_STUDY_ID);
	san_rdpm_take_study_baseline(study,refName,refDesc);
	with(plw.no_locking){vact.SAN_RDPM_UA_B_STUDY_BASELINE_TAKEN=true;}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 0
 :VERSION 3
 :_US_AA_D_CREATION_DATE 20201215000000
 :_US_AA_S_OWNER "E0296878"
)