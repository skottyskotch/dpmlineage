
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 337654534541
 :NAME "SAN_RDPM_JS2_DATAHUB_EXPORT_SUBBATCH_01"
 :COMMENT "EXPORT_SUBBATCH_01"
 :ACTIVE T
 :DATASET 118081000141
 :LOAD-ORDER 0
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
plw.writetolog(\" #########   SAN_RDPM_BA_DATAHUB_EXPORT_SUBBATCH_01 is starting...   #########\");
// storing start time to be written in subbatch success file
var date now=new date();
var string start_time_string=now.tostring(\"DD-MMM-YYYY:HHhMMmSS\");

context._FF_AA_S_LIST_NAME = \"ALL - DO NOT DELETE - USED FOR BO EXPORTS\";

//LIST EXPORT START
_impexTarget.SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PROJECT:JSON file format\", \"Project:DATAHUB\");
_impexTarget.SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_INDICATION:JSON file format\", \"Activity:DATAHUBINDICATION\");
_impexTarget.SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_TEAM_MEMBER:JSON file format\", \"Project Team Member:DATAHUBTEAMMEMBER\");
_impexTarget.SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_STUDY:JSON file format\", \"Activity:DATAHUBSTUDY\");
// PC-5122 - BO Clinical Milestones
plw.writetolog(\" -- Export start : BO Clinical Milestones\");
_rdpm_clinical_milestones.san_rdpm_bo_clinical_milestones_export();
plw.writetolog(\" --- Export end : BO Clinical Milestones\");
_impexTarget.SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_STUDY:JSON file format\", \"Activity:DATAHUBSTUDY\");
_impexTarget.SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PLAN_BUSINESS_OBJECT:JSON file format\", \"Activity:DATAHUBPLAN\");
//LIST EXPORT END

plw.writetolog(\"\");
plw.writetolog(\"Generating the subbatch success file and scan the success files from other subbatch to generate (or not) the global file export.sucess\");
_impexTarget.san_js_generate_exportsuccess_subbatch_file(1,start_time_string);
plw.writetolog(\"\");
plw.writetolog(\" #########   END OF SAN_RDPM_BA_DATAHUB_EXPORT_SUBBATCH_01   #########\");"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 3
 :_US_AA_B_BATCH_SCRIPT "1"
 :_US_AA_D_CREATION_DATE 20230920000000
 :_US_AA_S_OWNER "E0046087"
)