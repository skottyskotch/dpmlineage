
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 282708118570
 :DATASET 118081000141
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_RDPM_EXPORT_SCRIPT
//
//  AUTHOR  : Manuel DOUILLET
//	
//
//  Creation : 2020/13/10 MDO
//  Modification of SanExportFromPexQuery : 2021/01/12 HRA
//  script to use in the batch SAN_RDPM_IMPEX_TARGET_DATAHUB-EXPORT-Batch
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

// function to get date style onb of the query
function sanGetDateStyle (string argQuery) {
	for (var date in plc._RE_PT_DATES_STYLE where (date._PEX_RA_QUERY == plc._PEX_PT_QUERY.get(argQuery))) {
		return date.onb;
	}
}

// function to get the Start Date of the query
function sanGetStartDate (number argDateStyle_onb) {
	var DateStyle = plc._RE_PT_DATES_STYLE.get(argDateStyle_onb);
	return Context.CallDateFormula(DateStyle._RE_AA_S_CHART_START);
}

// function to get the End Date of the query
function sanGetEndDate (string argDateStyle_onb) {
	var DateStyle = plc._RE_PT_DATES_STYLE.get(argDateStyle_onb);
	return Context.CallDateFormula(DateStyle._RE_AA_S_CHART_END);
}

// Function to export impex from PEX
function SanExportFromPexQuery (string argTarget, string argFormat, string argPortfolio, string argQuery){
    var plc.impextarget Target = plc.impextarget.get(argTarget);
    var plc._FF_PT_FAVOR_FILTERS Portfolio = plc._FF_PT_FAVOR_FILTERS.get(argPortfolio);
    var plc._PEX_PT_QUERY Query = plc._PEX_PT_QUERY.get(argQuery);
    var date_style = sanGetDateStyle(argQuery);
	var startDate = sanGetStartDate(date_style);
    var endDate = sanGetEndDate(date_style);
	
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
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_ORGANISATION:Json file format\", \"OBS element:DATAHUBORGANISATION\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_RESOURCE:Json file format\", \"Resource:DATAHUBRESOURCE\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_STUDY:Json file format\", \"Activity:DATAHUBSTUDY\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_TASK:Json file format\", \"Activity:DATAHUBTASK\");

SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_TEAM_MEMBER:Json file format\", \"Project Team Member:DATAHUBTEAMMEMBER\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_COST_ACCOUNT:Json file format\", \"Cost account:DATAHUBCOSTACCOUNT\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PLAN_BUSINESS_OBJECT:Json file format\", \"Activity:DATAHUBPLAN\");

// SanExportFromPexQuery
//Actual workload
SanExportFromPexQuery (\"SAN_RDPM_IMPEX_TARGET_DATAHUB_ACTUAL_WKL:Json file format\", \"IMPEX_ACTUAL_WKL:DATAHUBACTUALWORKLOAD\",\"ALL - DO NOT DELETE - USED FOR BO EXPORTS\", \"SAN_RDPM_QY_BO_ACTUAL_WKL\");

//Availability
SanExportFromPexQuery (\"SAN_RDPM_IMPEX_TARGET_DATAHUB_HEADCOUNT_AVAILABILITIES:Json file format\", \"IMPEX_AVAILABILITIES:DATAHUBHEADCOUNTAVAILABILITIES\",\"ALL - DO NOT DELETE - USED FOR BO EXPORTS\", \"SAN_RDPM_QY_BO_AVAILABILITY\");

//Planned cost
SanExportFromPexQuery (\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PLANNED_COSTS:Json file format\", \"IMPEX_PLANNED_COSTS:DATAHUBPLANNEDCOSTS\",\"ALL - DO NOT DELETE - USED FOR BO EXPORTS\", \"SAN_RDPM_QY_BO_PLANNED_COST\");

//Planned workload
SanExportFromPexQuery (\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PLANNED_WKL:Json file format\", \"IMPEX_PLANNED_WKL:DATAHUBPLANNEDWORKLOAD\",\"ALL - DO NOT DELETE - USED FOR BO EXPORTS\", \"SAN_RDPM_QY_BO_PLANNED_WKL\");




//Specificity for avail w pex to add
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_SUCCESS_FILE:Json file format\", \"Project:DATAHUBSUCCESS\");"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260025536771
 :VERSION 10
 :_US_AA_D_CREATION_DATE 20210112000000
 :_US_AA_S_OWNER "E0431201"
)