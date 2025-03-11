
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 338831799341
 :DATASET 118081000141
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_RDPM_EXPORT_SCRIPT
//
//  AUTHOR  : Manuel DOUILLET
//	Script to use in the batch SAN_RDPM_IMPEX_TARGET_DATAHUB-EXPORT-Batch
//
//  Creation : 2020/13/10 MDO
//  PC-6637 - Addition of new BO Planned DMM for Planned Exp for DMM activities only
//  PC-6559 - Modification of Availability export to extend time window to Y+6 instead of Y+5
//  PC-6442 - addition of SAN_RDPM_IMPEX_TARGET_DATAHUB_GENERIC_RESOURCE:Json file format export format in Datahub export
//  PC-6559 - Modification of Availability export to extend time window to Y+5 instead of Y+3
//  PC-6525 - Modification of WKL export part for Business unit, Departement & Platform user attribute - GSE
//  PC-6050 - addition of Project template for R&C export
//  PC-5839 - Zip BO Files - 2022-04-11 - LFA
//  PC-5853 - Remove field COMMENT from BO planned workload - 2022-03-11 - LFA
//  PC-5533 - Keep only one portfolio for the BO export
//  PC-5527 - Add fields in BO Planned workload for vaccines - 2022-01-26 - LFA
//  PC-5460 - Use the portfolio \"ALL R&D - DO NOT DELETE - USED FOR BO EXPORTS [TEMP]\" for BO Plan
//  PC-5122 - Add the BO Clinical Milestones Dates - 2021/11/30 - LFA
//  PC-4985 - Cleaning duplicaded lines in table WBS Form Data - 2021/11/09 LFA
//  PC-4983 - Use the portfolio \"ALL R&D - DO NOT DELETE - USED FOR BO EXPORTS [TEMP]\" for BO Project, Indication, Phase, Study, Task, Team Member - 2021/11/09 LFA
//  PC-4623 - Use of portfolio \"ALL - DO NOT DELETE - USED FOR BO EXPORTS\" in function san_rdpm_bo_planned_wkl_cost_export - 2021/09/28 LFA
//  PC-4297 - Change end date for Planned IPSO Export 
//  PC-4136 - Take only MANUAL and AUTO Types : 2021/07/02 LFA
//  PC-4152 - Take start of the month (SD) and end of the month (FD) to manage HES with a 0 duration  : 2021/07/01 LFA
//  PC-3796 - Use Portfolio ALL - DO NOT DELETE - USED FOR BO EXPORTS for BO Exports : 2021/05/24 LFA
//  Use Portfolio ALL - DO NOT DELETE - USED FOR BO EXPORTS for Query export to include indications : 2021/04/12 LFA
//  Modification of SanExportFromPexQuery : 2021/01/12 HRA
//  Modification of script: add Planned IPSO : 2021/02/01 HRA
//  Modification of script: added check on day of the month for Actual Workload 2021/02/09 MDO
//  Modification of script: addition of planned workload & costs csv export 15-MAR-2021 MDO
//  Modification of script: addition of study baseline dates 19-MAY-2021 LFA
//  Modification san_rdpm_bo_planned_wkl_cost_export to excluede animal resources
//  Modification - Add WBS FORM Export - PC-4268  17/08/2021
//  Modification - Add Portfolios export (PC-1744) 18/01/2022 IGU
//  Add traces in logs : look for \"-- Export\" to get all traces (PC-5557) 02/02/2022 David
//***************************************************************************/

Namespace _impexTarget;


function rdpm_fn_date_end_month(o_date)
{
	if(o_date instanceof DATE)
	{
		return plw.date_addTimeUnit(plw.periodstart(o_date,\"MONTH\",1),-1,\"DAY\");
	}
}

function san_rdpm_bo_planned_wkl_cost_export()
{
	// The scope of the data exported can be changed thanks to this o_ptf var where you can put any portfolio the INTRANET user has access to
	var o_ptf = plc._FF_PT_FAVOR_FILTERS.get(\"ALL - DO NOT DELETE - USED FOR BO EXPORTS\");
	
	// The time window of the export can be modified thanks to the numbers in the start_horizon_date and end_horizon_date var below
	var t_start = new Date().getElapsedTime();
	var start_horizon_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",-2)\"); 
	var start_date_compute = start_horizon_date;
	var end_horizon_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",15)\"); 
	var end_date_compute = end_horizon_date;
	var vdate=new date();
	
	// Global variable
	var curvename = cost.findCurveName(\"AEAC\");
	
	// CSV Export Variables
	var filepath = \"/tmp/\";
	var Costsfilename = \"-PLANNED_COSTS.csv\";
	var Costsfilepath = new PathName(filepath+\"TEMP\"+Costsfilename);
	var wklfilename = \"-PLANNED_WORKLOAD.csv\";
	var Wklfilepath = new PathName(filepath+\"TEMP\"+wklfilename);
	var file_separator = \",\";
	
	if(Costsfilepath.probefile())
	{
		Costsfilepath.deletefile();
		plw.alert(\"san_rdpm_bo_planned_wkl_cost_export - Deleted already existing working file: \"+Costsfilepath);
	}
	if(Wklfilepath.probefile())
	{
		Wklfilepath.deletefile();
		plw.alert(\"san_rdpm_bo_planned_wkl_cost_export - Deleted already existing working file: \"+Wklfilepath);
	}
	
	var WklFile = new plw.fileOutputStream(Wklfilepath,\"overwrite\");
	var CostsFile = new plw.fileOutputStream(Costsfilepath,\"overwrite\");
	//PC-5527 - Add new fields for Vaccines in planned workload
	WklFile.writeln(\"\\\"ACTIVITY_TYPE\\\",\\\"RESOURCE\\\",\\\"RESOURCE_OBS\\\",\\\"SITE\\\",\\\"SAN_RDPM_UA_PH_SOURCING\\\",\\\"SAN_RDPM_UA_PH_PROVIDER\\\",\\\"PLANNED_HOURS_TYPE\\\",ACTIVITY_ONB,\\\"SKILL\\\",START-DATE,END-DATE,DAY_PLANNED_HOURS,LOAD-CALENDAR_PLANNED_HOURS,TASK_WEIGHTING,\\\"_RM_REVIEW_RA_ROLE\\\",\\\"SAN_UA_RDPM_RES_BU\\\",\\\"SAN_UA_RDPM_RES_DEP\\\",\\\"SAN_UA_RDPM_RES_PLATFORM\\\",SAN_RDPM_UA_N_NB_DAY_FTE_VAC\");
	CostsFile.writeln(\"\\\"ACTIVITY_TYPE\\\",\\\"RESOURCE\\\",\\\"RESOURCE_OBS\\\",\\\"SITE\\\",\\\"SOURCING\\\",\\\"PROVIDER\\\",\\\"EXPENDITURE_TYPE\\\",ACTIVITY_ONB,\\\"COST_ACCOUNT\\\",\\\"SAN_RDPM_UA_B_COMMITTED_COSTS\\\",START-DATE,END-DATE,QUANTITY_KEUROS,TASK_WEIGHTING\");
	
	
	// Build a vector of Project
	var v_proj_vect = new vector();
	
	for(var o_project in o_ptf.get(\"PROJECTS\") where o_project.LEVEL==1) v_proj_vect.push(o_project);
	// Addition of Template project - PC-6050
    for(var o_project in plc.project where o_project._INF_NF_B_IS_TEMPLATE && o_project.SAN_RDPM_UA_TEMPLATE_CODE!=\"\" && o_project.LEVEL==1) v_proj_vect.push(o_project);
    v_proj_vect.removeduplicates();
	
	// Loop on each project to export
	for (var o_project in v_proj_vect)
	{
		plw.writetolog(\" ---- Export Processing Project: \"+o_project.name);
		with(o_project.fromobject())
		{
			for(var o_hes in plc.TIME_SYNTHESIS where o_hes.RES.SAN_RDPM_UA_B_RES_SPECIES==false &&  ((o_hes.FD instanceof DATE) && !(o_hes.FD<start_horizon_date) && (o_hes.SD instanceof DATE) && !(o_hes.SD>end_horizon_date)) && !(o_hes.ACTIVITY.SAN_RDPM_UA_B_OLD_BRANCH_FILTER_F))
			{
				var v_hes_string = \"\";
				
				//Each print check if instanceof else \"\"
				if (o_hes.ACTIVITY instanceof plc.work_structure && o_hes.ACTIVITY.WBS_TYPE instanceof plc.WBS_TYPE) {v_hes_string += \"\\\"\"+o_hes.ACTIVITY.WBS_TYPE.printattribute()+\"\\\"\"+file_separator;} else {v_hes_string += \"\\\"\\\"\"+file_separator;} // Activity type
				if (o_hes.RES instanceof plc.RESOURCE) {v_hes_string += \"\\\"\"+o_hes.RES.printattribute()+\"\\\"\"+file_separator;} else {v_hes_string += \"\\\"\\\"\"+file_separator;} // Resource
				if (o_hes.RES instanceof plc.RESOURCE && o_hes.RES.OBS_ELEMENT instanceof plw.RESPONSIBILITY) {v_hes_string += \"\\\"\"+o_hes.RES.OBS_ELEMENT.printattribute()+\"\\\"\"+file_separator;} else {v_hes_string += \"\\\"\\\"\"+file_separator;} // Resource obs
				if (o_hes._RM_REVIEW_RA_LOCATION instanceof plc._RM_REVIEW_PT_LOCATIONS) {v_hes_string += \"\\\"\"+o_hes._RM_REVIEW_RA_LOCATION.printattribute()+\"\\\"\"+file_separator;} else {v_hes_string += \"\\\"\\\"\"+file_separator;} // Site
				if (o_hes._INF_RA_CBS2 instanceof plc._INF_PT_CBS2) {v_hes_string += \"\\\"\"+o_hes._INF_RA_CBS2.printattribute()+\"\\\"\"+file_separator;} else {v_hes_string += \"\\\"\\\"\"+file_separator;} // Sourcing
				if (o_hes._INF_RA_CBS3 instanceof plc._INF_PT_CBS3) {v_hes_string += \"\\\"\"+o_hes._INF_RA_CBS3.printattribute()+\"\\\"\"+file_separator;} else {v_hes_string += \"\\\"\\\"\"+file_separator;} // Provider
				v_hes_string += \"\\\"\"+o_hes.TYPE+\"\\\"\"+file_separator; // Type cannot be empty
				if (o_hes.ACTIVITY instanceof plc.work_structure) {v_hes_string += o_hes.ACTIVITY.ONB.toString(\"####\")+file_separator;} else {v_hes_string += \"\\\"\\\"\"+file_separator;} // Activity Internal number
				
				// To avoid additional 'Weighted estimate at completion' curves calculation, recover the weight of the activity to build Weighted information
				var v_weight = o_hes.ACTIVITY.WEIGHT;
				
				//PC-5527 - Add new fields for Vaccines in planned workload
				var v_hes_string_wkl = \"\";
				if (o_hes._RM_REVIEW_RA_ROLE instanceof plc._RM_REVIEW_PT_ROLE) {v_hes_string_wkl += \"\\\"\"+o_hes._RM_REVIEW_RA_ROLE.printattribute()+\"\\\"\"+file_separator;} else {v_hes_string_wkl += \"\\\"\\\"\"+file_separator;} // Role
				if (o_hes.RES instanceof plc.RESOURCE) {v_hes_string_wkl += \"\\\"\"+o_hes.RES.SAN_UA_RDPM_RES_BU+\"\\\"\"+file_separator;} else {v_hes_string_wkl += \"\\\"\\\"\"+file_separator;} // Resource BU
				if (o_hes.RES instanceof plc.RESOURCE) {v_hes_string_wkl += \"\\\"\"+o_hes.RES.SAN_UA_RDPM_RES_DEP+\"\\\"\"+file_separator;} else {v_hes_string_wkl += \"\\\"\\\"\"+file_separator;} // Resource Department
				if (o_hes.RES instanceof plc.RESOURCE) {v_hes_string_wkl += \"\\\"\"+o_hes.RES.SAN_UA_RDPM_RES_PLATFORM+\"\\\"\"+file_separator;} else {v_hes_string_wkl += \"\\\"\\\"\"+file_separator;} // Resource Plateform
				v_hes_string_wkl += o_hes.SAN_RDPM_UA_N_NB_DAY_FTE_VAC.toString(\"####\");
				
				// define dates for computation
				// PC-4152 - Take start of the month (SD) and end of the month (FD) to manage HES with a 0 duration
				var start_hes = \"PERIOD_START\".callmacro(o_hes.SD,\"MONTH\",0);
				var end_hes = \"PERIOD_START\".callmacro(o_hes.FD,\"MONTH\",1);
				if (start_horizon_date>start_hes) {start_date_compute = start_horizon_date;} else {start_date_compute=start_hes;}
				if (end_horizon_date<end_hes) {end_date_compute = end_horizon_date;} else {end_date_compute=end_hes;}
				
				// Build a Date Vector to parse 
				var v_DateVect = new plw.datevector(\"MONTH\",start_date_compute,end_date_compute);
				// Remove last value as it will return 0 (Next month)
				v_DateVect.pop();
				
				//Get type of the HES
				var hes_type = o_hes.TYPE;
				
				//check type
				// PC-4262 - Take only MANUAL and AUTO Types
				if(o_hes._PM_NF_B_BASIC_TYPE_HOURS && (hes_type == \"AUTO\" || hes_type == \"MANUAL\")){
					
					// Build EAC curves on 'Hours and expenditures' object
					var curve_eac_day = cost.computecurves(curvename, \"Day\", \"MONTH\", false, start_date_compute, end_date_compute, o_hes);
					var curve_eac_fte = cost.computecurves(curvename, \"FTE (Full Time Equivalent)\", \"MONTH\", false, start_date_compute, end_date_compute, o_hes);
					
					// Loop on all dates
					for(var s_date in v_DateVect)
					{
						// Calculate curves
						var eac_day = curve_eac_day.get(s_date);
						var eac_fte = curve_eac_fte.get(s_date);
						
						var v_line_string = v_hes_string;
						
						//Add specific attributes
						v_line_string += \"\\\"\"+o_hes.PRIMARY_SKILL.printattribute()+\"\\\"\"+file_separator; // Primary skill
						//Add dates
						v_line_string += s_date.toString(\"YYYY-MM-DD\")+file_separator; //start date
						v_line_string += rdpm_fn_date_end_month(s_date).toString(\"YYYY-MM-DD\")+file_separator; //end date
						
						//Add curve values
						v_line_string += eac_day.toString(\"####.0000\")+file_separator;
						v_line_string += eac_fte.toString(\"####.0000\")+file_separator;
						//Add weight
						if (o_hes.ACTIVITY instanceof plc.work_structure) {if (v_weight == -1){v_line_string += \"1.00\";}else{v_line_string += v_weight.toString(\"####.00\");}} else {v_line_string += \"\";} //wieghting
						
						// PC-5527 - Add vaccines information
						v_line_string +=file_separator+v_hes_string_wkl;
						
						
						// Export line
						WklFile.writeln(v_line_string);
						
					}
					// Warning: carefully destroy the curves object after their usage to insure that memory used to compute this curves is reallocated correctly.
					curve_eac_day.delete();
					curve_eac_fte.delete();
				}
				
				// PC-4136 - Take only MANUAL and AUTO Types
				if(hes_type == \"AUTO\" || hes_type == \"MANUAL\"){
					
					// Build EAC curves on 'Hours and expenditures' object
					var curve_eac_keuros = cost.computecurves(curvename, \"k€\", \"MONTH\", false, start_date_compute, end_date_compute, o_hes);
					
					// Loop on all dates
					for(var s_date in v_DateVect)
					{
						// Get curve data
						var eac_Keuros = curve_eac_keuros.get(s_date);
						
						var v_line_string = v_hes_string;
						
						// Add specific attributes
						if(o_hes.COST_ACCOUNT instanceof plw.COST_ACCOUNT) {v_line_string += \"\\\"\"+o_hes.COST_ACCOUNT.printattribute()+\"\\\"\"+file_separator;} else {v_line_string += \"\\\"\\\"\"+file_separator;} // Cost Account
						if(o_hes.SAN_RDPM_UA_B_COMMITTED_COSTS instanceof BOOLEAN) {v_line_string += \"\\\"\"+o_hes.SAN_RDPM_UA_B_COMMITTED_COSTS.toString()+\"\\\"\"+file_separator;} else {v_line_string += \"\\\"\\\"\"+file_separator;} // Committed costs
						
						//Add dates
						v_line_string += s_date.toString(\"YYYY-MM-DD\")+file_separator; //start date
						v_line_string += rdpm_fn_date_end_month(s_date).toString(\"YYYY-MM-DD\")+file_separator; //end date
						
						//Add curve values
						v_line_string += eac_Keuros.toString(\"####.0000\")+file_separator;
						
						//Add weight
						if (o_hes.ACTIVITY instanceof plc.work_structure) {if (v_weight == -1){v_line_string += \"1.00\";}else{v_line_string += v_weight.toString(\"####.00\");}} else {v_line_string += \"\";} //wieghting
						
						// Export line
						CostsFile.writeln(v_line_string);
					}
					// Warning: carefully destroy the curves object after their usage to insure that memory used to compute this curves is reallocated correctly.
					curve_eac_keuros.delete();
				}
			}
		}
	}
	
	
	// Close file
	WklFile.close();
	CostsFile.close();
	// Rename files to add start timestamp
	var filepath = context.SAN_RDPM_UA_OC_S_EXPORT_DATAHUB_PATH;
	
	Costsfilename = vdate.tostring(\"YYYYMMDDTHHMMSSZ\")+\"-PLANNED_COSTS.csv\";
	Costsfilepath.renamefile(filepath+Costsfilename);
	
	wklfilename = vdate.tostring(\"YYYYMMDDTHHMMSSZ\")+\"-PLANNED_WORKLOAD.csv\";
	wklfilepath.renamefile(filepath+wklfilename);
	
	Wklfilepath = new PathName(filepath+wklfilename);
	Costsfilepath = new PathName(filepath+Costsfilename);
	
	
	plw.writetolog(\" ----- Export : Wklfilepath: \"+Wklfilepath);
	plw.writetolog(\" ----- Export : Costsfilepath: \"+Costsfilepath);
	//log info on batch
	var t_end = new Date().getElapsedTime();
	var t_duration = t_end-t_start;
	plw.writetolog(\" ----- Export : On portfolio: \"+o_ptf);
	plw.writetolog(\" ----- Export : #Projects = \"+v_proj_vect.length);
	plw.writetolog(\" ----- Export : Duration = \"+t_duration+\" ms (\"+\"PRINT_NUMBER\".callmacro(t_duration/60000,\"#####.00\")+\" min)\");
	var vDurProj=(v_proj_vect.length!=0) ? t_duration/v_proj_vect.length : 0;
	plw.writetolog(\" ----- Export : Duration (/project) = \"+vDurProj+\" ms (\"+\"PRINT_NUMBER\".callmacro(vDurProj/60000,\"#####.00\")+\" min)\");
}

////////////////////////////////////////////////////////////////////////

function san_rdpm_bo_actual_workload(){
	//Actual workload
    if(Context.CallBooleanFormula(\"NTH(PRINT_DATE($DATE_OF_THE_DAY,\\\"DD-MM-YY\\\"),0,\\\"-\\\") = SAN_RDPM_CS_ACTUAL_WKL_EXPT_DAY\")){
		var start_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"MONTH\\\",-1)\");
		var end_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"MONTH\\\",0)\");
		_impexTarget.SanExportFromPexQuery (\"SAN_RDPM_IMPEX_TARGET_DATAHUB_ACTUAL_WKL:Json file format\", \"IMPEX_ACTUAL_WKL:DATAHUBACTUALWORKLOAD\",\"ALL - DO NOT DELETE - USED FOR BO EXPORTS\", \"SAN_RDPM_QY_BO_ACTUAL_WKL\", start_date, end_date);
	} 
	else {
		plw.writetolog(\" -- Export IMPEX_ACTUAL_WKL:DATAHUBACTUALWORKLOAD  /  SAN_RDPM_IMPEX_TARGET_DATAHUB_ACTUAL_WKL:Json file format: not exported as it is not the day of the month configured in SAN_RDPM_CS_ACTUAL_WKL_EXPT_DAY.\");
	}
}

function san_rdpm_bo_headcount_availabilities(){
	//Availability
    var start_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",-1)\");
    var end_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",6)\");
    _impexTarget.SanExportFromPexQuery (\"SAN_RDPM_IMPEX_TARGET_DATAHUB_HEADCOUNT_AVAILABILITIES:Json file format\", \"IMPEX_AVAILABILITIES:DATAHUBHEADCOUNTAVAILABILITIES\",\"ALL - DO NOT DELETE - USED FOR BO EXPORTS\", \"SAN_RDPM_QY_BO_AVAILABILITY\", start_date, end_date);
}

function san_rdpm_bo_planned_IPSO(){
//Planned IPSO
var start_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",-2)\");
var end_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",5)\");
_impexTarget.SanExportFromPexQuery (\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PLANNED_IPSO:Json file format\", \"IMPEX_PLANNED_IPSO:SAN_RDPM_IMPEX_FORMAT_PLANEXP_IPSO\",\"ALL - DO NOT DELETE - USED FOR BO EXPORTS\", \"SAN_RDPM_QY_BO_PLANEDXP_IPSO\", start_date, end_date);
}

function san_rdpm_bo_planned_DMM(){
	//Planned DMM
    var start_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",-1)\");
    var end_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",5)\");
    _impexTarget.SanExportFromPexQuery (\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PLANNED_DMM:Json file format\", \"IMPEX_PLANNED_DMM:SAN_RDPM_IMPEX_FORMAT_PLANEXP_DMM\",\"ALL - DO NOT DELETE - USED FOR BO EXPORTS\", \"SAN_RDPM_QY_BO_PLANEDXP_DMM\", start_date, end_date);
}

function san_pjs_flag_for_run_RDPM_export_subbatch(integer sub_batch_number) 
{
    //Function used to launch the sub batch
	var string iStr=(\"0\"+sub_batch_number.tostring(\"####\"));
	var vBatch=plc._INF_PT_REQ.get(\"SAN_RDPM_BA_DATAHUB_EXPORT_SUBBATCH_\"+iStr);
	if (vBatch==undefined) {
		plw.writetolog(\"SAN_RDPM_BA_DATAHUB_EXPORT_SUBBATCH_\"+iStr+\" not found.\");
		return false;
	}
	plw.writetolog(\" -- RDPM Flag batch SAN_RDPM_BA_DATAHUB_EXPORT_SUBBATCH_\"+iStr+\" to be launched.\");
	vBatch.callmacro(\"_BA_TO_EXEC_BATCH\");
}

function san_js_generate_exportsuccess_subbatch_file(integer subbatch_number,string starttimest) {
    //Generating exportsuccess.subbatch file
    var string iStr= \"0\"+subbatch_number.tostring(\"####\");
    plw.writetolog(\" -- Generating file exportsuccess_\"+iStr+\".subbatch.\");
    var path = context.SAN_RDPM_UA_OC_S_EXPORT_DATAHUB_PATH;
    var SuccessFileName=\"exportsuccess_\"+iStr+\".subbatch\";
   	var subbatch_filePath = new PathName(path+SuccessFileName);
	var subbatch_file = new plw.fileOutputStream(subbatch_filePath,\"overwrite\");
	var now=new date();
	var timestamp=now.tostring(\"DD-MMM-YYYY:HHhMMmSS\");
	subbatch_file.writeln(\"Start time: \"+starttimest+\" - End time: \"+timestamp);
	subbatch_file.close();
    plw.writetolog(\" -- SAN_RDPM_BA_DATAHUB_EXPORT_SUBBATCH_\"+iStr+\" is finished, \"+subbatch_filePath+\" is generated!\");
}

function san_js_generate_exportsuccess_global_file(integer total_nb_of_subbatch) {
	var check_OK=false;
	context._FF_AA_S_LIST_NAME = \"ALL - DO NOT DELETE - USED FOR BO EXPORTS\";
	plw.writetolog(\" Checking the results of the \"+total_nb_of_subbatch+\" subbatches...\");
	
	//we build the expected exportsuccess.subbatch file list and then we compare it with the files found in path. 
	var i=1;
	var success_file_vect=new vector();
	while (i<=total_nb_of_subbatch) {
	    var string iStr= \"0\"+i.tostring(\"####\");
		var success_file_name=\"exportsuccess_\"+iStr+\".subbatch\".tostring();
		success_file_vect.push(success_file_name);
		i++;
	}
	plw.writetolog(\" -- List of sub batch success files to check : \");
	plw.writetolog(\" --  \"+success_file_vect.join(\",\"));
	
	var subbatch_file_vect=new vector();
	var path = context.SAN_RDPM_UA_OC_S_EXPORT_DATAHUB_PATH;
	var Dir=new PathName(path);
	for (var file in Dir where file.type==\"subbatch\"){
		var success_file=file.name+ \".\" + file.type;
		subbatch_file_vect.push(success_file);
	}
	plw.writetolog(\" -- List of sub batch success files checked : \");
	plw.writetolog(\" --  \"+subbatch_file_vect.join(\",\"));
	var control_vect=plw.intersection(subbatch_file_vect,success_file_vect);
	var result=false;
	if (control_vect.length==success_file_vect.length) result=true;
	plw.writetolog(\" -- Are all the expected \"+total_nb_of_subbatch+\" sub batch success files found ? --> \"+result);
	
	if (result) 
	{
		//If all sub batches are success then Zip BO files and wrtite success file
		plw.writetolog(\" -- All the \"+total_nb_of_subbatch+\" expected sub batch success files were found! --> zipping all BO files...\");
		plw.writetolog(\" -- Zip BO file.\");
		var path = context.SAN_RDPM_UA_OC_S_EXPORT_DATAHUB_PATH;
		var Dir=new PathName(path);
		for (var file in Dir where file.type!=\"zip\" && file.type!=\"success\" && file.type!=\"subbatch\"){
			plw.writetolog(\"Zip file \"+file.name+ \".\" + file.type);
			var zipfile = new plw.zipfile(path+file.name+\".zip\");
			zipfile.append(file, file.name + \".\" + file.type);
			plw.writetolog(\"Delete file \"+file.name+ \".\" + file.type);
			file.deletefile();
		}
		plw.writetolog(\" --- End Zip BO file.\");
		
		plw.writetolog(\"Now generating the global file export.sucess ...\");
		_impexTarget.SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_SUCCESS_FILE:Json file format\", \"Project:DATAHUBSUCCESS\");
		plw.writetolog(\"Global file export.sucess generated!\");
		plw.writetolog(\"\");
		plw.writetolog(\" -- Exports: Success, on portfolio: \"+context._FF_AA_S_LIST_NAME.toString());
		
		//Now, we clean up the success files which are now useless and build the content of the summary
		var breakline=plw.char(10);
		var overall_summary_vect=new vector();
		overall_summary_vect.push(\"************************\");
		var path = context.SAN_RDPM_UA_OC_S_EXPORT_DATAHUB_PATH;
		var Dir=new PathName(path);
		plw.writetolog(\"\");
		plw.writetolog(\"-- Start cleaning old subbatch files\");
		for (var file in Dir where file.type==\"subbatch\") {
			
			var subbatchfile=new plw.fileinputstream(file);
			var subbatchfilecontent=subbatchfile.readline();
			subbatchfile.close();
			
			var subsummary=file.name+ \".\" + file.type+\" - \"+subbatchfilecontent;
			overall_summary_vect.push(subsummary);
			plw.writetolog(\"	Deleted file \"+file.name+ \".\" + file.type);
			file.deletefile();
		}
		plw.writetolog(\"-- Finished cleaning old subbatch files\");
		
		var summarytxt=overall_summary_vect.join(breakline);
		plw.writetolog(\"\");
		plw.writetolog(\"\");
		plw.writetolog(\"##############################################################################\");
		plw.writetolog(\"##############################################################################\");
		plw.writetolog(\"\");
		plw.writetolog(\"\");
		plw.writetolog(\"                 EXECUTION SUMMARY for BO export batch:\");
		plw.writetolog(summarytxt);
		plw.writetolog(\"\");
		plw.writetolog(\"\");
		plw.writetolog(\"##############################################################################\");
		plw.writetolog(\"##############################################################################\");
		plw.writetolog(\"\");
		plw.writetolog(\"\");
		plw.writetolog(\" -- Export : ***** END EXPORT ****\");
		check_OK=true;
	}
	return check_OK;
}

function san_js_scan_subbatches_success_files(total_nb_of_subbatches,timeout_seconds,integer interval) {
	plw.writetolog(\"Will checking during \"+timeout_seconds+\" seconds the status of subbatches....\");
	var test_subbatches=false;
	var i=0;
	while(i<=timeout_seconds) {
		plw.writetolog(\"\");
		plw.writetolog(\"########## Iteration after \"+i+\" seconds ##########\");
		test_subbatches=san_js_generate_exportsuccess_global_file(total_nb_of_subbatches);
		if (test_subbatches) {
			return true;
		}
		plw.processsleep(interval);
		i=i+interval;
		plw.writetolog(\"###################################################\");
	}
	// plantage volontaire en fin de timeout
	if (test_subbatches==false) {
		plw.writetolog(\"####################   /!\\ /!\\ /!\\ /!\\ /!\\ /!\\ /!\\ /!\\ /!\\ /!\\ /!\\ /!\\ /!\\  ###############################\");
		plw.writetolog(\"#################### BO EXPORT TIMEOUT AFTER \"+timeout_seconds+\" seconds!!! ###############################\");
		plw.writetolog(\"####################   /!\\ /!\\ /!\\ /!\\ /!\\ /!\\ /!\\ /!\\ /!\\ /!\\ /!\\ /!\\ /!\\  ###############################\");
		// The code below will crash ON PURPOSE with a stack Error : \"Unknown class UNBOUND\"
		var no_project=plc.ordo_project.get(\"no_project\");
		no_project.get(\"NAME\");
	}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 337654536641
 :VERSION 0
 :_US_AA_D_CREATION_DATE 20231220000000
 :_US_AA_S_OWNER "I0260387"
)