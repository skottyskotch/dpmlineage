
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 334587567641
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _wpa_export;
//Macro called in the batch
function csv_batch_macro_export_pex(portfolio_id,pexquery_id,format_id,target_id,start_date,end_date)
{
	//var event = Format.DoExportWithFormatAndTarget(Target);
	var event=plw._impex_exportPEXQueryCostTable(portfolio_id, pexquery_id, format_id, target_id, start_date, end_date);
	plw.alert(\"event: \"+event);
	var filePath = Event.get(\"Target_fileName\");
	plw.alert(\"filePath: \"+filePath);
	context.set(\"?LOCAL_DOCUMENT_PATH\", true);
	with(plw.no_locking) 
	{
		with (plw.no_alerts)
		{
			plw.writeln(\"Storing document in DB\");
			event._IMPEX_DF_UPLOADED_FILE = filePath;
        }
	}
	context.set(\"?LOCAL_DOCUMENT_PATH\", false);
	plw.writeln(\"End of batch\");
}

var start_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",-1)\");
var end_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",10)\");
csv_batch_macro_export_pex(\"CSO Resources\",\"SAN_RDPM_PEX_QU_CSO_WPA\",\"SAN_CT_PEX_QU_CSO_WPA:TEST_EXP_WPA\",\"test_wpa_export_target:CSV file format\",start_date,end_date);"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 321302154282
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20230607000000
 :_US_AA_S_OWNER "I0260387"
)