
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 317304671410
 :DATASET 118081000141
 :SCRIPT-CODE "//  AUTHOR  : ABO
//	Script to use in the batch SAN_RDPM_IMPEX_TARGET_DATAHUB-EXPORT-Batch to export automatically the actual workload

namespace _autowklexport;

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
if(Context.CallBooleanFormula(\"NTH(PRINT_DATE($DATE_OF_THE_DAY,\\\"DD-MM-YY\\\"),0,\\\"-\\\") = SAN_RDPM_CS_NOMINATIVE_ACTUAL_WKL_EXPT_DAY\")){
var start_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"MONTH\\\",-1)\");
var end_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"MONTH\\\",0)\");
SanExportFromPexQuery (\"SAN_RDPM_IMPEX_TARGET_DATAHUB_NOMINATIVE_ACTUAL_WKL:CSV file format\", \"IMPEX_NOMINATIVE_RES_ACTUAL_WKL:DATAHUBNOMINATIVEACTUALWORKLOAD\",\"ALL - DO NOT DELETE - USED FOR BO EXPORTS\", \"SAN_RDPM_QY_BO_NOM_RES_ACTUAL_WKL\", start_date, end_date);
} else {
plw.writeln(\"IMPEX_NOMINATIVE_RES_ACTUAL_WKL:DATAHUBNOMINATIVEACTUALWORKLOAD_SAN_RDPM_IMPEX_TARGET_DATAHUB_NOMINATIVE_ACTUAL_WKL:CSV file format: not exported as it is not the day of the month configured in SAN_RDPM_CS_NOMINATIVE_ACTUAL_WKL_EXPT_DAY.\");
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 317304671110
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20220105000000
 :_US_AA_S_OWNER "E0499298"
)