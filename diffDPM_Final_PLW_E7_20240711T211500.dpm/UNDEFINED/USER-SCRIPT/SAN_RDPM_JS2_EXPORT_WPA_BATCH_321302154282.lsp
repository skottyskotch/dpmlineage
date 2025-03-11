
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 321302154282
 :NAME "SAN_RDPM_JS2_EXPORT_WPA_BATCH"
 :ACTIVE T
 :DATASET 118081000141
 :LOAD-ORDER 0
 :SCRIPT-CODE "namespace _wpa_export;
//Macro called in the batch
function csv_batch_macro_export_pex(portfolio_id,pexquery_id,format_id,target_id,start_date,end_date)
{
	//var event = Format.DoExportWithFormatAndTarget(Target);
	var event=plw._impex_exportPEXQueryCostTable(portfolio_id, pexquery_id, format_id, target_id, start_date, end_date);
	//plw.alert(\"event: \"+event);
	var filePath = Event.get(\"Target_fileName\");
	//plw.alert(\"filePath: \"+filePath);
	context.set(\"?LOCAL_DOCUMENT_PATH\", true);
	with(plw.no_locking) 
	{
		with (plw.no_alerts)
		{
			//plw.writeln(\"Storing document in DB\");
			plw.writeln(\"Attaching \"+filePath+\" to the event \"+event+\" (_IMPEX_DF_UPLOADED_FILE)\");
			event._IMPEX_DF_UPLOADED_FILE = filePath;
        }
	}
	context.set(\"?LOCAL_DOCUMENT_PATH\", false);
	plw.writeln(\"End of batch\");
}

var start_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",-1)\");
var end_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",10)\");
csv_batch_macro_export_pex(\"CSO Resources\",\"SAN_RDPM_PEX_QU_CSO_WPA\",\"SAN_CT_PEX_QU_CSO_WPA:SAN_IMPEX_WPA_EXPORT\",\"SAN_IMPEX_TARGET_WPA_EXPORT:CSV file format\",start_date,end_date);"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 3
 :_US_AA_B_BATCH_SCRIPT "1"
 :_US_AA_D_CREATION_DATE 20230412000000
 :_US_AA_S_OWNER "I0260387"
)