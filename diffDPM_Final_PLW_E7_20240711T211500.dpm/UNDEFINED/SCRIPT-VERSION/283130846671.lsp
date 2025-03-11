
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 283130846671
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
		plw.writeln(\"Exporting: \"+argFormat+\"_\"+argTarget);
	}
}


//SanExport 
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PROJECT:Json file format\", \"Project:DATAHUB\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_INDICATION:Json file format\", \"Activity:DATAHUBINDICATION\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PHASE:Json file format\", \"Activity:DATAHUBPHASE\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_MILESTONE:Json file format\", \"Activity:DATAHUBMILESTONE\");
//SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_ORGANISATION:Json file format\", \"OBS element:DATAHUBORGANISATION\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_RESOURCE:Json file format\", \"Resource:DATAHUBRESOURCE\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_STUDY:Json file format\", \"Activity:DATAHUBSTUDY\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_TASK:Json file format\", \"Activity:DATAHUBTASK\");

SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_TEAM_MEMBER:Json file format\", \"Project Team Member:DATAHUBTEAMMEMBER\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_COST_ACCOUNT:Json file format\", \"Cost account:DATAHUBCOSTACCOUNT\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PLAN_BUSINESS_OBJECT:Json file format\", \"Activity:DATAHUBPLAN\");

// SanExportFromPexQuery
//Actual workload
if(Context.CallBooleanFormula(\"NTH(PRINT_DATE($CURRENT_DATE,\\\"DD-MM-YY\\\"),0,\\\"-\\\") = SAN_RDPM_CS_ACTUAL_WKL_EXPT_DAY\")){
var start_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"MONTH\\\",-1)\");
var end_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"MONTH\\\",0)\");
SanExportFromPexQuery (\"SAN_RDPM_IMPEX_TARGET_DATAHUB_ACTUAL_WKL:Json file format\", \"IMPEX_ACTUAL_WKL:DATAHUBACTUALWORKLOAD\",\"ALL - DO NOT DELETE - USED FOR BO EXPORTS\", \"SAN_RDPM_QY_BO_ACTUAL_WKL\", start_date, end_date);
} else {
plw.writeln(argFormat+\"_\"+argTarget+\": not exported as it is not the day of the month configured in SAN_RDPM_CS_ACTUAL_WKL_EXPT_DAY.\");
}

//Availability
var start_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",-1)\");
var end_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",3)\");
SanExportFromPexQuery (\"SAN_RDPM_IMPEX_TARGET_DATAHUB_HEADCOUNT_AVAILABILITIES:Json file format\", \"IMPEX_AVAILABILITIES:DATAHUBHEADCOUNTAVAILABILITIES\",\"ALL - DO NOT DELETE - USED FOR BO EXPORTS\", \"SAN_RDPM_QY_BO_AVAILABILITY\", start_date, end_date);

//Planned cost
var start_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",-2)\");
var end_date = Context.CallDateFormula(\"$TIME_WINDOW_END\");
SanExportFromPexQuery (\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PLANNED_COSTS:Json file format\", \"IMPEX_PLANNED_COSTS:DATAHUBPLANNEDCOSTS\",\"ALL - DO NOT DELETE - USED FOR BO EXPORTS\", \"SAN_RDPM_QY_BO_PLANNED_COST\", start_date, end_date);

//Planned workload
var start_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",-2)\");
var end_date = Context.CallDateFormula(\"$TIME_WINDOW_END\");
SanExportFromPexQuery (\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PLANNED_WKL:Json file format\", \"IMPEX_PLANNED_WKL:DATAHUBPLANNEDWORKLOAD\",\"ALL - DO NOT DELETE - USED FOR BO EXPORTS\", \"SAN_RDPM_QY_BO_PLANNED_WKL\", start_date, end_date);

//Planned IPSO
var start_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",-2)\");
var end_date = Context.CallDateFormula(\"$TIME_WINDOW_END\");
SanExportFromPexQuery (\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PLANNED_IPSO:Json file format\", \"IMPEX_PLANNED_IPSO:SAN_RDPM_IMPEX_FORMAT_PLANEXP_IPSO\",\"ALL - DO NOT DELETE - USED FOR BO EXPORTS\", \"SAN_RDPM_QY_BO_PLANEDXP_IPSO\", start_date, end_date);

SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_SUCCESS_FILE:Json file format\", \"Project:DATAHUBSUCCESS\");"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260025536771
 :VERSION 16
 :_US_AA_D_CREATION_DATE 20210225000000
 :_US_AA_S_OWNER "E0431101"
)