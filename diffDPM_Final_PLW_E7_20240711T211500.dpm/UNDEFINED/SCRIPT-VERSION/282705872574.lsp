
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 282705872574
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
	var ref_name=OC.SAN_RDPM_UA_OC_S_MONTHLY_BASELINE_NAME;
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
		plw.writeln(\"YEARLY Baseline does not exist!\")
	}
	
	return \"YEARLY\";
}

var date = new date();

// RDPM Monthtly baseline
// Pharma
if (\"PRINT_DATE\".call(date,\"DD-MM-YYYY\")==\"PRINT_DATE\".call(OC.SAN_RDPM_CS_D_PHARMA_MONTHLY_BASELINE,\"DD-MM-YYYY\"))
{
	var Ref_Name=san_rdpm_js2_create_monthly_baseline();
	var Project_Filter=context.SAN_RDPM_CS_S_PHARMA_BASELINE_PROJECT_FILTER;
	plw.writeln(\"Generate pharma monthly baseline : \" + Ref_Name);
	context.WRITETRANSACTIONSINLOG=false;
	plw.take_Reference_with_parameter_in_batch_ext(Ref_Name,Project_Filter,\"\",true);
	context.WRITETRANSACTIONSINLOG=true;
}
// Vaccines
if (\"PRINT_DATE\".call(date,\"DD-MM-YYYY\")==\"PRINT_DATE\".call(OC.SAN_RDPM_CS_D_VACCINES_MONTHLY_BASELINE,\"DD-MM-YYYY\"))
{
	var Ref_Name=san_rdpm_js2_create_monthly_baseline();
	var Project_Filter=context.SAN_RDPM_CS_S_VACCINES_BASELINE_PROJECT_FILTER;
	plw.writeln(\"Generate vaccines monthly baseline : \" + Ref_Name);
	context.WRITETRANSACTIONSINLOG=false;
	plw.take_Reference_with_parameter_in_batch_ext(Ref_Name,Project_Filter,\"\",true);
	context.WRITETRANSACTIONSINLOG=true;
}

// RDPM Yearly baseline
// Pharma
if (\"PRINT_DATE\".call(date,\"DD-MM-YYYY\")==\"PRINT_DATE\".call(OC.SAN_RDPM_CS_D_PHARMA_YEARLY_BASELINE,\"DD-MM-YYYY\"))
{
	var Ref_Name=san_rdpm_js2_create_yearly_baseline_name();
	var Project_Filter=context.SAN_RDPM_CS_S_PHARMA_BASELINE_PROJECT_FILTER;
	plw.writeln(\"Generate pharma yearly baseline.\");
	context.WRITETRANSACTIONSINLOG=false;
	plw.take_Reference_with_parameter_in_batch_ext(Ref_Name,Project_Filter,\"\",true);
	context.WRITETRANSACTIONSINLOG=true;
}
// Vaccines
if (\"PRINT_DATE\".call(date,\"DD-MM-YYYY\")==\"PRINT_DATE\".call(OC.SAN_RDPM_CS_D_VACCINES_YEARLY_BASELINE,\"DD-MM-YYYY\"))
{
	var Ref_Name=san_rdpm_js2_create_yearly_baseline_name();
	var Project_Filter=context.SAN_RDPM_CS_S_VACCINES_BASELINE_PROJECT_FILTER;
	plw.writeln(\"Generate vaccines yearly baseline.\");
	context.WRITETRANSACTIONSINLOG=false;
	plw.take_Reference_with_parameter_in_batch_ext(Ref_Name,Project_Filter,\"\",true);
	context.WRITETRANSACTIONSINLOG=true;
}
// RDPM Study Baselines
// Include Study Baseline script here"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 282705872274
 :VERSION 0
 :_US_AA_D_CREATION_DATE 20210104000000
 :_US_AA_S_OWNER "E0296878"
)