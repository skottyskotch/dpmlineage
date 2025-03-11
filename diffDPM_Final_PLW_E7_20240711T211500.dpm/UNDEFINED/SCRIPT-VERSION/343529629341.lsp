
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 343529629341
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _impexTarget;

// Must define function SanExport and SanExportFromPexQuery in the subbatch code as the call to 
//_Impex_TruncateTable is allowed only withing a batch exection (cannot be evaluated as a regular script)

/////////////////////////////////////////////////////////////////////

function SanExport (string argTarget, string argFormat)
{
    plw.writetolog(\" -- Export start : \"+argFormat+\"  /  \"+argTarget);
    var plc.impextarget Target = plc.impextarget.get(argTarget);
    
    if(Target instanceOf plc.ImpexTarget){
        
        var plc.impexformat Format = plc.impexformat.get(argFormat);
        
        if(Target._IMPEX_AA_B_TRUNCATE){
            plw._Impex_TruncateTable(Target,Format);
		}
        
        Format.DoExportWithFormatAndTarget(Target);
        var filename = Target.CallStringFormula(\"EVALUATE_STRING(Filename)\");
        plw.writetolog(\" ----- Export file name : \"+filename);
		plw.writetolog(\" --- Export end : \"+argFormat+\"  /  \"+argTarget);
	}
    
}

// Function to export impex from PEX
function SanExportFromPexQuery (string argTarget, string argFormat, string argPortfolio, string argQuery, date startDate, date endDate){
	plw.writetolog(\" -- Export start : \"+argFormat+\"  /  \"+argTarget);
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
        plw.writetolog(\" ----- Export file name : \"+filename);
		plw.writetolog(\" --- Export end : \"+argFormat+\"  /  \"+argTarget);
	}
}

plw.writetolog(\"\");
plw.writetolog(\" #########   SAN_RDPM_BA_DATAHUB_EXPORT_SUBBATCH_02 is starting...   #########\");

// storing start time to be written in subbatch success file
var date now=new date();
var string start_time_string=now.tostring(\"DD-MMM-YYYY:HHhMMmSS\");

context._FF_AA_S_LIST_NAME = \"ALL - DO NOT DELETE - USED FOR BO EXPORTS\";

//LIST EXPORT START
_impexTarget.SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_RESOURCE:Json file format\", \"Resource:DATAHUBRESOURCE\");
// PC-6442 - BO Generic resources for Vaccines only
_impexTarget.SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_GENERIC_RESOURCE:Json file format\", \"Resource:DATAHUGENERICBRESOURCE\");
_impexTarget.SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_STUDY_BASELINE:Json file format\", \"Activity:DATAHUBBASELINE\");
_impexTarget.SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_COST_ACCOUNT:Json file format\", \"Cost account:DATAHUBCOSTACCOUNT\");
_impexTarget.SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_WBS_FORM:Json file format\", \"WBS Form Data:DATAHUB_WBS_FORM\");
//Portfolio (PC-1744)
_impexTarget.SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PORTFOLIO:Json file format\", \"User-defined portfolios:DATAHUBPORTFOLIO\");
_impexTarget.san_rdpm_bo_headcount_availabilities();
_impexTarget.san_rdpm_bo_planned_IPSO();
//_impexTarget.san_rdpm_bo_planned_DMM();
_impexTarget.SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PHASE:Json file format\", \"Activity:DATAHUBPHASE\");
//OTD-160726
_impexTarget.san_rdpm_bo_planned_DMM_v2();
//LIST EXPORT END

plw.writetolog(\"\");
plw.writetolog(\"Generating the subbatch success file and scan the success files from other subbatch to generate (or not) the global file export.sucess\");
_impexTarget.san_js_generate_exportsuccess_subbatch_file(2,start_time_string);
plw.writetolog(\"\");
plw.writetolog(\" #########   END OF SAN_RDPM_BA_DATAHUB_EXPORT_SUBBATCH_02   #########\");
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 337654534441
 :VERSION 4
 :_US_AA_D_CREATION_DATE 20240617000000
 :_US_AA_S_OWNER "I0260387"
)