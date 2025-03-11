
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 260025536771
 :NAME "SAN_RDPM_EXPORT_SCRIPT"
 :COMMENT "Batch for impex target SAN_RDPM_IMPEX_TARGET_DATAHUB:Json file format"
 :ACTIVE T
 :DATASET 118081000141
 :LOAD-ORDER 0
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_RDPM_EXPORT_SCRIPT
//
//  AUTHOR  : Manuel DOUILLET
//	Script to use in the batch SAN_RDPM_IMPEX_TARGET_DATAHUB-EXPORT-Batch
//
//  Creation : 2020/13/10 MDO
//  PC-6637 - Addition of new BO Planned DMM for Planned Exp for DMM activities only
//  PC-6559 - Modification of Availability export to extend time window to Y+6 instead of Y+5
//  PC-6442 - addition of SAN_RDPM_IMPEX_TARGET_DATAHUB_GENERIC_RESOURCE:JSON file format export format in Datahub export
//  PC-6559 - Modification of Availability export to extend time window to Y+5 instead of Y+3
//  PC-6525 - Modification of WKL export part for Business unit, Departement & Platform user attribute - GSE
//  PC-6050 - addition of Project template for R&C export
//  PC-5839 - Zip BO Files - 2022-04-11 - LFA
//  PC-5853 - Remove field COMMENT from BO planned workload - 2022-03-11 - LFA
//  PC-5533 - Keep only one portfolio for the BO export
//  PC-5527 - Add fields in BO Planned workload for vaccines - 2022-01-26 - LFA
//  PC-5460 - Use the portfolio \"ALL R&D - DO NOT DELETE - USED FOR BO EXPORTS [TEMP]\" for BO Plan
//  PC-5122 - Add the BO Clinical Milestones Dates - 2021/11/30 - LFA
//  PC-4985 - Cleaning duplicaded lines in table WBS Form Data - 2021/11/09 LFA
//  PC-4983 - Use the portfolio \"ALL R&D - DO NOT DELETE - USED FOR BO EXPORTS [TEMP]\" for BO Project, Indication, Phase, Study, Task, Team Member - 2021/11/09 LFA
//  PC-4623 - Use of portfolio \"ALL - DO NOT DELETE - USED FOR BO EXPORTS\" in function san_rdpm_bo_planned_wkl_cost_export - 2021/09/28 LFA
//  PC-4297 - Change end date for Planned IPSO Export 
//  PC-4136 - Take only MANUAL and AUTO Types : 2021/07/02 LFA
//  PC-4152 - Take start of the month (SD) and end of the month (FD) to manage HES with a 0 duration  : 2021/07/01 LFA
//  PC-3796 - Use Portfolio ALL - DO NOT DELETE - USED FOR BO EXPORTS for BO Exports : 2021/05/24 LFA
//  Use Portfolio ALL - DO NOT DELETE - USED FOR BO EXPORTS for Query export to include indications : 2021/04/12 LFA
//  Modification of SanExportFromPexQuery : 2021/01/12 HRA
//  Modification of script: add Planned IPSO : 2021/02/01 HRA
//  Modification of script: added check on day of the month for Actual Workload 2021/02/09 MDO
//  Modification of script: addition of planned workload & costs csv export 15-MAR-2021 MDO
//  Modification of script: addition of study baseline dates 19-MAY-2021 LFA
//  Modification san_rdpm_bo_planned_wkl_cost_export to excluede animal resources
//  Modification - Add WBS FORM Export - PC-4268  17/08/2021
//  Modification - Add Portfolios export (PC-1744) 18/01/2022 IGU
//  Add traces in logs : look for \"-- Export\" to get all traces (PC-5557) 02/02/2022 David
//***************************************************************************/

Namespace _impexTarget;

//////////////////////////////////////////////////////////////////////////////////
///////////////////////////////EXPORT - START/////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

var integer total_nb_of_subbatch = 5;

plw.writetolog(\"\");
plw.writetolog(\" #########   SAN_RDPM_IMPEX_TARGET_DATAHUB-EXPORT-Batch is starting...   #########\");

//Now, we clean up the success files from previous failed executions
var path = context.SAN_RDPM_UA_OC_S_EXPORT_DATAHUB_PATH;
plw.writetolog(\"Testing existence of the output directory: \"+path);
var test_path=path.probefile();
if (test_path InstanceOf Pathname) {
	plw.writetolog(\"The directory \"+path+\" exists, let's continue...\");
	plw.writetolog(\"\");
	var Dir=new PathName(path);
	plw.writetolog(\"\");
	plw.writetolog(\"-- Start cleaning old subbatch files\");
	for (var file in Dir where file.type==\"subbatch\") {
		plw.writetolog(\"	Deleted file \"+file.name+ \".\" + file.type);
		file.deletefile();
	}
	plw.writetolog(\"-- Finished cleaning old subbatch files\");
	
	// PC-4985 - Cleaning duplicaded lines in table WBS Form Data
	plw.writetolog(\"\");
	plw.writetolog(\" -- Export : Cleaning table WBS Form Data.\");
	var count=0;
	for (var wbs_form_data in plc.__USER_TABLE_SAN_RDPM_UT_WBS_FORM_DATA where wbs_form_data.SAN_RDPM_DA_B_WBS_FORM_DATA_DUPLICATED)
	{
		wbs_form_data.delete();
		count++;
	}
	plw.writetolog(\" --- Export : \"+count+\" duplicated lines removed in table WBS Form Data.\");
	plw.writetolog(\"\");
	
	// Checking if required subbatches are existing...
	var test_subbatch=true;
	plw.writetolog(\"-- Checking existence of required subbatches...\");
	for (var i=1;i<=total_nb_of_subbatch;i++)
	{
		var string iStr= \"0\"+i.tostring(\"####\");
		var oBatch=plc._BA_PT_BATCH.get(\"SAN_RDPM_BA_DATAHUB_EXPORT_SUBBATCH_\"+iStr);
		if (oBatch!=undefined) {
			plw.writetolog(\" - SAN_RDPM_BA_DATAHUB_EXPORT_SUBBATCH_\"+iStr+\" found, OK!!\");
		}
		else { 
			test_subbatch=false;
			plw.writetolog(\" - SAN_RDPM_BA_DATAHUB_EXPORT_SUBBATCH_\"+iStr+\" NOT found, KO!!\");
		}
	}
	plw.writetolog(\"\");
	plw.writetolog(\"\");
	if (test_subbatch) {	
		plw.writetolog(\"-- All subbatches (SAN_RDPM_BA_DATAHUB_EXPORT_SUBBATCH_xx) for BO export found.\");
		plw.writetolog(\"\");
		plw.writetolog(\"-- Flagging a total of \"+total_nb_of_subbatch+\" subbatches to be run.\");
		var i=1;
		while (i <= total_nb_of_subbatch)
		{
			plw.writetolog(\"Flagging subbatch \"+i+\" to be launched.\");
			_impexTarget.san_pjs_flag_for_run_RDPM_export_subbatch(i);
			i++;
		}
		// flag monitoring batch to be launched
		var MonitoringBatch=plc._BA_PT_BATCH.get(\"SAN_RDPM_IMPEX_TARGET_DATAHUB-EXPORT-Batch\");
		plw.writetolog(\" -- \");
		plw.writetolog(\" -- RDPM Flag monitoring batch SAN_RDPM_IMPEX_TARGET_DATAHUB-EXPORT-Batch to be launched.\");
		MonitoringBatch.callmacro(\"_BA_TO_EXEC_BATCH\");
	}
	else {
		plw.writetolog(\"\");
		plw.writetolog(\"At least one required subbatch is missing, ABORTING...\");
		plw.writetolog(\"\");
	}
	
	plw.writetolog(\"\");
}
else {
	plw.writetolog(\"The directory \"+path+\" does not exist, ABORTING...\");
}
plw.writetolog(\" #########   END OF SAN_RDPM_IMPEX_TARGET_DATAHUB-EXPORT-Batch   #########\");"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 64
 :_US_AA_B_BATCH_SCRIPT "1"
 :_US_AA_D_CREATION_DATE 20201012000000
 :_US_AA_S_OWNER "intranet"
)