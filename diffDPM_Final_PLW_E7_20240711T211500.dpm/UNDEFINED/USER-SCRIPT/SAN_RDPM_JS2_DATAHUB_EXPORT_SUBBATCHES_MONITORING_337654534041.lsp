
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 337654534041
 :NAME "SAN_RDPM_JS2_DATAHUB_EXPORT_SUBBATCHES_MONITORING"
 :COMMENT "BO export subbatches monoriting"
 :ACTIVE T
 :DATASET 118081000141
 :LOAD-ORDER 0
 :SCRIPT-CODE "Namespace _impexTarget;

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

// san_js_scan_subbatches_success_files(arg1,arg2,arg3)
// arg1 : total number of subbatches to monitor
// arg2 : timeout value in seconds (ex 7200 for 2h)
// arg3 : check interval in seconds (120 for a check every 2 minuts)
san_js_scan_subbatches_success_files(5,14400,120);"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 3
 :_US_AA_B_BATCH_SCRIPT "1"
 :_US_AA_D_CREATION_DATE 20230920000000
 :_US_AA_S_OWNER "E0046087"
)