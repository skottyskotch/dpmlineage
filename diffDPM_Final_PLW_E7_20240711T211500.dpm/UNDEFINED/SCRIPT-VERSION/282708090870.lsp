
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 282708090870
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

// For impex using PEX
function SanExportFromPexQuery (string argTarget, string argFormat, string argPortfolio, string argQuery)
{
    
    var plc.impextarget Target = plc.impextarget.get(argTarget);
    var plc._FF_PT_FAVOR_FILTERS Portfolio = plc._FF_PT_FAVOR_FILTERS.get(argPortfolio);
    var plc._PEX_PT_QUERY Query = plc._PEX_PT_QUERY.get(argQuery);
    
    ////var StartDate period_start($DATE_OF_THE_DAY,\"YEAR\",-1); Context.CallDateFormula(\"PERIOD_START($DATE_OF_THE_DAY,\\\"\\Year\\\",-1)\");
    ////var EndDate period_start($DATE_OF_THE_DAY,\"YEAR\",3);
    
    //if(Target instanceOf plc.ImpexTarget and Portfolio instanceOf plc._FF_PT_FAVOR_FILTERS and Query instanceOf plc._PEX_PT_QUERY){
        
    //    var plc.impexformat Format = plc.impexformat.get(argFormat);
        
    //    if(Target._IMPEX_AA_B_TRUNCATE){
    //        plw._Impex_TruncateTable(Target,Format);
   //     }
        
    //    _impex_exportPEXQueryCostTable(Portfolio, Query, Format, Target, startDate, endDate)
    //}
    
}

//Export 
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PROJECT:Json file format\", \"Project:DATAHUB\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_INDICATION:Json file format\", \"Activity:DATAHUBINDICATION\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PHASE:Json file format\", \"Activity:DATAHUBPHASE\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_MILESTONE:Json file format\", \"Activity:DATAHUBMILESTONE\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_ORGANISATION:Json file format\", \"OBS element:DATAHUBORGANISATION\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_RESOURCE:Json file format\", \"Resource:DATAHUBRESOURCE\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_STUDY:Json file format\", \"Activity:DATAHUBSTUDY\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_TASK:Json file format\", \"Activity:DATAHUBTASK\");

//added on sprint 16
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_TEAM_MEMBER:Json file format\", \"Project Team Member:DATAHUBTEAMMEMBER\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_COST_ACCOUNT:Json file format\", \"Cost account:DATAHUBCOSTACCOUNT\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PLAN_BUSINESS_OBJECT:Json file format\", \"Activity:DATAHUBPLAN\");

//Specificity for avail w pex to add
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_SUCCESS_FILE:Json file format\", \"Project:DATAHUBSUCCESS\");

//SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_ACTUAL_WKL:Json file format\", \"Actual hours:DATAHUBACTUALWORKLOAD\");"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260025536771
 :VERSION 9
 :_US_AA_D_CREATION_DATE 20210112000000
 :_US_AA_S_OWNER "E0431201"
)