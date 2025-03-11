
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 283008124474
 :DATASET 118081000141
 :SCRIPT-CODE "/*
* Script V2
* Autor : Ludovic FAVRE
* JIRA : PC-2468  (Baselines)
* Date Creation 04/01/2021
*/

namespace _rdpm_baseline;

function san_rdpm_js2_create_monthly_baseline()
{
	var ref_name=context.SAN_RDPM_UA_OC_S_MONTHLY_BASELINE_NAME;
	var ref_obj = plc._L1_PT_REF_ADMIN.get(ref_name);
	if (ref_obj instanceof plc._L1_PT_REF_ADMIN)
	{
		plw.writeln(\"Reference already exist! : \"+ref_obj);
	}
	else
	{
		ref_obj = new plc._L1_PT_REF_ADMIN (NAME : ref_name,DESC : ref_name,_L1_AA_S_REF_TEMPLATE : \"SAN_RDPM_MONTHLY_BASELINE\",_L1_AA_B_REF_IS_LOADED : true,_L1_AA_S_REF_PRJTYP : \"Continuum.RDPM\",FILE : \"SAN_CF_RDPM_BASELINE\");	
		plw.writeln(\"Creation a new Reference : \"+ref_obj);
	} 
	
	return ref_name;
}

function san_rdpm_js2_create_yearly_baseline_name()
{
	var ref_name = context.SAN_RDPM_UA_OC_S_YEARLY_BASELINE_NAME;
	var ref_obj = plc._L1_PT_REF_ADMIN.get(ref_name);


	if (ref_obj instanceof plc._L1_PT_REF_ADMIN)
	{
		plw.writeln(\"Reference already exist! : \"+ref_obj);
	}
	else
	{
		ref_obj = new plc._L1_PT_REF_ADMIN (NAME : ref_name,DESC : ref_name,_L1_AA_S_REF_TEMPLATE : \"SAN_RDPM_YEARLY_BASELINE\",_L1_AA_B_REF_IS_LOADED : true,_L1_AA_S_REF_PRJTYP : \"Continuum.RDPM\",FILE : \"SAN_CF_RDPM_BASELINE\");	
		plw.writeln(\"Creation a new Reference : \"+ref_obj);

	}

	var ybase = plc._L1_PT_REF_ADMIN.get(\"YEARLY\"); 
	if (ybase instanceof plc._L1_PT_REF_ADMIN)
	{
		ybase._L1_AA_S_REF_BKUP_NAME=ref_name;
	}	
	else
	{
		plw.writeln(\"YEARLY Baseline does not exist!\");
	}
	
	return \"YEARLY\";
}

var date = new date();

/*
*** PHARMA *****
*/

// Monthly Baseline
if (\"PRINT_DATE\".call(date,\"DD-MM-YYYY\")==\"PRINT_DATE\".call(context.SAN_RDPM_CS_D_PHARMA_MONTHLY_BASELINE,\"DD-MM-YYYY\"))
{
	var Ref_Name=san_rdpm_js2_create_monthly_baseline();
	var Ref_Obj =  plc._L1_PT_REF_ADMIN.get(Ref_Name);
	var Project_Filter=context.SAN_RDPM_CS_S_PHARMA_BASELINE_PROJECT_FILTER;
	plw.writeln(\"Generate pharma monthly baseline : \" + Ref_Name);
	context._write_transactions_in_log_=false;
	plw.take_Reference_with_parameter_in_batch_ext(Ref_Name,Project_Filter,\"\",true);
	context._write_transactions_in_log_=true;
	
	// Update description of baseline
	/*for (var ref in plc.Reference where ref.name==Ref_Name && ref.AD>=date)
	{
		ref.desc=Ref_Name;
	}*/
	
	// Deactivate loading for previous baselines
	for (var reference in plc._L1_PT_REF_ADMIN)
	{
		reference.SAN_RDPM_UA_B_PHARMA_LOADED_BASELINE=false;	
	}
	Ref_Obj.SAN_RDPM_UA_B_PHARMA_LOADED_BASELINE=true;
}


// Vaccines


/*
VACCINES
*/

// Monthly Baseline
if (\"PRINT_DATE\".call(date,\"DD-MM-YYYY\")==\"PRINT_DATE\".call(context.SAN_RDPM_CS_D_VACCINES_MONTHLY_BASELINE,\"DD-MM-YYYY\"))
{
	var Ref_Name=san_rdpm_js2_create_monthly_baseline();
	var Ref_Obj =  plc._L1_PT_REF_ADMIN.get(Ref_Name);
	var Project_Filter=context.SAN_RDPM_CS_S_VACCINES_BASELINE_PROJECT_FILTER;
	plw.writeln(\"Generate vaccines monthly baseline : \" + Ref_Name);
	context._write_transactions_in_log_=false;
	plw.take_Reference_with_parameter_in_batch_ext(Ref_Name,Project_Filter,\"\",true);
	context._write_transactions_in_log_=true;
	
	// Deactivate loading for previous baselines
	for (var reference in plc._L1_PT_REF_ADMIN)
	{
		reference.SAN_RDPM_UA_B_VACCINES_LOADED_BASELINE=false;	
	}
	Ref_Obj.SAN_RDPM_UA_B_VACCINES_LOADED_BASELINE=true;
}

// Yearly Baseline
if (\"PRINT_DATE\".call(date,\"DD-MM-YYYY\")==\"PRINT_DATE\".call(context.SAN_RDPM_CS_D_VACCINES_YEARLY_BASELINE,\"DD-MM-YYYY\"))
{
	var Ref_Name=san_rdpm_js2_create_yearly_baseline_name();
	var Project_Filter=context.SAN_RDPM_CS_S_VACCINES_BASELINE_PROJECT_FILTER;
	plw.writeln(\"Generate vaccines yearly baseline.\");
	context._write_transactions_in_log_=false;
	plw.take_Reference_with_parameter_in_batch_ext(Ref_Name,Project_Filter,\"\",true);
	context._write_transactions_in_log_=true;
}


/*
STUDY BASELINES
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
			exception_formula=\"LIST_MERGE\".call(vHash_Obj,vact.SAN_UA_RDPM_ACT_S_STUDY_ID);
		}
		else
		{
			exception_formula=vact.SAN_UA_RDPM_ACT_S_STUDY_ID;
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
 :USER-SCRIPT 282705872274
 :VERSION 6
 :_US_AA_D_CREATION_DATE 20210119000000
 :_US_AA_S_OWNER "E0296878"
)