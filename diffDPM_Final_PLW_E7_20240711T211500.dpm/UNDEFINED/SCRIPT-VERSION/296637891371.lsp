
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 296637891371
 :DATASET 118081000141
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_RDPM_EXPORT_SCRIPT
//
//  AUTHOR  : Manuel DOUILLET
//	Script to use in the batch SAN_RDPM_IMPEX_TARGET_DATAHUB-EXPORT-Batch
//
//  Creation : 2020/13/10 MDO
//  Modification of SanExportFromPexQuery : 2021/01/12 HRA
//	Modification of script: add Planned IPSO : 2021/02/01 HRA
//  Modification of script: added check on day of the month for Actual Workload 2021/02/09 MDO
//  Modification of script: addition of planned workload & costs csv export 15-MAR-2021 MDO
//
//***************************************************************************/

Namespace _impexTarget;

function SanExport (string argTarget, string argFormat)
{
    
    var plc.impextarget Target = plc.impextarget.get(argTarget);
    
    if(Target instanceOf plc.ImpexTarget){
        
        var plc.impexformat Format = plc.impexformat.get(argFormat);
        
        if(Target._IMPEX_AA_B_TRUNCATE){
            plw._Impex_TruncateTable(Target,Format);
        }
        
        Format.DoExportWithFormatAndTarget(Target);
        var filename = Target.CallStringFormula(\"EVALUATE_STRING(Filename)\");
        plw.writeln(filename);
		plw.writeln(\"Exporting: \"+argFormat+\"_\"+argTarget);
    }
    
}

// Function to export impex from PEX
function SanExportFromPexQuery (string argTarget, string argFormat, string argPortfolio, string argQuery, date startDate, date endDate){
    var plc.impextarget Target = plc.impextarget.get(argTarget);
    var plc._FF_PT_FAVOR_FILTERS Portfolio = plc._FF_PT_FAVOR_FILTERS.get(argPortfolio);
    var plc._PEX_PT_QUERY Query = plc._PEX_PT_QUERY.get(argQuery);
	
    if(Target instanceOf plc.ImpexTarget && Portfolio instanceOf plc._FF_PT_FAVOR_FILTERS && Query instanceOf plc._PEX_PT_QUERY) {
        var plc.impexformat Format = plc.impexformat.get(argFormat);
        if(Target._IMPEX_AA_B_TRUNCATE)
			{
			plw._Impex_TruncateTable(Target,Format);
		}
		plw._impex_exportPEXQueryCostTable(Portfolio, Query, Format, Target, startDate, endDate);
        var filename = Target.CallStringFormula(\"EVALUATE_STRING(Filename)\");
        plw.writeln(filename);
		plw.writeln(\"Exporting: \"+argFormat+\"_\"+argTarget);
	}
}

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
	var o_ptf = plc._FF_PT_FAVOR_FILTERS.get(\"ALL LEVEL 1 - DO NOT DELETE - USED FOR BO EXPORTS\");
	
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
	WklFile.writeln(\"\\\"ACTIVITY_TYPE\\\",\\\"RESOURCE\\\",\\\"RESOURCE_OBS\\\",\\\"SITE\\\",\\\"SAN_RDPM_UA_PH_SOURCING\\\",\\\"SAN_RDPM_UA_PH_PROVIDER\\\",\\\"PLANNED_HOURS_TYPE\\\",ACTIVITY_ONB,\\\"SKILL\\\",START-DATE,END-DATE,DAY_PLANNED_HOURS,LOAD-CALENDAR_PLANNED_HOURS,TASK_WEIGHTING\");
	CostsFile.writeln(\"\\\"ACTIVITY_TYPE\\\",\\\"RESOURCE\\\",\\\"RESOURCE_OBS\\\",\\\"SITE\\\",\\\"SOURCING\\\",\\\"PROVIDER\\\",\\\"EXPENDITURE_TYPE\\\",ACTIVITY_ONB,\\\"COST_ACCOUNT\\\",\\\"SAN_RDPM_UA_B_COMMITTED_COSTS\\\",START-DATE,END-DATE,QUANTITY_KEUROS,TASK_WEIGHTING\");


	// Build a vector of Project
	var v_proj_vect = new vector();
	
	for(var o_project in o_ptf.get(\"PROJECTS\")) v_proj_vect.push(o_project);

	// Loop on each project to export

		for (var o_project in v_proj_vect)
			{
			plw.writetolog(\"Processing Project: \"+o_project.name);
				with(o_project.fromobject())
				{
					for(var o_hes in plc.TIME_SYNTHESIS where ((o_hes.FD instanceof DATE) && !(o_hes.FD<start_horizon_date) && (o_hes.SD instanceof DATE) && !(o_hes.SD>end_horizon_date)) && !(o_hes.ACTIVITY.SAN_RDPM_UA_B_OLD_BRANCH_FILTER_F))
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

							// define dates for computation
							if (start_horizon_date>o_hes.SD) {start_date_compute = start_horizon_date;} else {start_date_compute=o_hes.SD;}
							if (end_horizon_date<o_hes.FD) {end_date_compute = end_horizon_date;} else {end_date_compute=o_hes.FD;}
							
							// Build a Date Vector to parse 
							var v_DateVect = new plw.datevector(\"MONTH\",start_date_compute,end_date_compute);
							// Remove last value as it will return 0 (Next month)
							v_DateVect.pop();

							//Get type of the HES
							var hes_type = o_hes.TYPE;
							
							//check type
							if (o_hes._PM_NF_B_BASIC_TYPE_HOURS){
								
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
										
										// Export line
										WklFile.writeln(v_line_string);
										
									}
								// Warning: carefully destroy the curves object after their usage to insure that memory used to compute this curves is reallocated correctly.
								curve_eac_day.delete();
								curve_eac_fte.delete();
							}
							
							if(hes_type == \"AUTO\" || hes_type == \"Hours\" || hes_type == \"MANUAL\" || hes_type == \"Expenditures\" || hes_type == \"Sites\" || hes_type == \"Subjects\"){
								
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
	
	plw.writetolog(\"Wklfilepath: \"+Wklfilepath);
	plw.writetolog(\"Costsfilepath: \"+Costsfilepath);
	//log info on batch
	var t_end = new Date().getElapsedTime();
	var t_duration = t_end-t_start;
	plw.writetolog(\"On portfolio: \"+o_ptf);
	plw.writetolog(\"#Projects = \"+v_proj_vect.length);
	plw.writetolog(\"Duration = \"+t_duration+\" ms\");
	plw.writetolog(\"Duration (/project) = \"+t_duration/v_proj_vect.length+\" ms\");
}

//Portfolio filter to be set prior to the call of the export to restrict the data exported
context._FF_AA_S_LIST_NAME = \"ALL LEVEL 1 - DO NOT DELETE - USED FOR BO EXPORTS\";

//SanExport 
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PROJECT:Json file format\", \"Project:DATAHUB\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_INDICATION:Json file format\", \"Activity:DATAHUBINDICATION\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PHASE:Json file format\", \"Activity:DATAHUBPHASE\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_RESOURCE:Json file format\", \"Resource:DATAHUBRESOURCE\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_STUDY:Json file format\", \"Activity:DATAHUBSTUDY\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_TASK:Json file format\", \"Activity:DATAHUBTASK\");

SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_TEAM_MEMBER:Json file format\", \"Project Team Member:DATAHUBTEAMMEMBER\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_COST_ACCOUNT:Json file format\", \"Cost account:DATAHUBCOSTACCOUNT\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PLAN_BUSINESS_OBJECT:Json file format\", \"Activity:DATAHUBPLAN\");

// SanExportFromPexQuery
//Actual workload
if(Context.CallBooleanFormula(\"NTH(PRINT_DATE($DATE_OF_THE_DAY,\\\"DD-MM-YY\\\"),0,\\\"-\\\") = SAN_RDPM_CS_ACTUAL_WKL_EXPT_DAY\")){
var start_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"MONTH\\\",-1)\");
var end_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"MONTH\\\",0)\");
SanExportFromPexQuery (\"SAN_RDPM_IMPEX_TARGET_DATAHUB_ACTUAL_WKL:Json file format\", \"IMPEX_ACTUAL_WKL:DATAHUBACTUALWORKLOAD\",\"ALL LEVEL 1 - DO NOT DELETE - USED FOR BO EXPORTS\", \"SAN_RDPM_QY_BO_ACTUAL_WKL\", start_date, end_date);
} else {
plw.writeln(\"IMPEX_ACTUAL_WKL:DATAHUBACTUALWORKLOAD_SAN_RDPM_IMPEX_TARGET_DATAHUB_ACTUAL_WKL:Json file format: not exported as it is not the day of the month configured in SAN_RDPM_CS_ACTUAL_WKL_EXPT_DAY.\");
}

//Availability
var start_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",-1)\");
var end_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",3)\");
SanExportFromPexQuery (\"SAN_RDPM_IMPEX_TARGET_DATAHUB_HEADCOUNT_AVAILABILITIES:Json file format\", \"IMPEX_AVAILABILITIES:DATAHUBHEADCOUNTAVAILABILITIES\",\"ALL LEVEL 1 - DO NOT DELETE - USED FOR BO EXPORTS\", \"SAN_RDPM_QY_BO_AVAILABILITY\", start_date, end_date);

//Planned IPSO
var start_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",-2)\");
var end_date = Context.CallDateFormula(\"$TIME_WINDOW_END\");
SanExportFromPexQuery (\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PLANNED_IPSO:Json file format\", \"IMPEX_PLANNED_IPSO:SAN_RDPM_IMPEX_FORMAT_PLANEXP_IPSO\",\"ALL LEVEL 1 - DO NOT DELETE - USED FOR BO EXPORTS\", \"SAN_RDPM_QY_BO_PLANEDXP_IPSO\", start_date, end_date);

plw.writeln(\"Exporting: Planned Workload & Planned Costs\");
san_rdpm_bo_planned_wkl_cost_export();

SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_SUCCESS_FILE:Json file format\", \"Project:DATAHUBSUCCESS\");
plw.writeln(\"Exports: Success\");"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260025536771
 :VERSION 28
 :_US_AA_D_CREATION_DATE 20210319000000
 :_US_AA_S_OWNER "E0431101"
)