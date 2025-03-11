
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 336983940841
 :DATASET 118081000141
 :SCRIPT-CODE "// 
// PLWSCRIPT : SAN_RDPM_JS2_PRINT_MONTHLY_REPORT
// call on batch SAN_RDPM_BA_PRINT_MONTHLY_REPORT
//
// v1.2 2022-05-12 William
// PC-5968 set the scaling =\"All in one page\"
//
// v1.1 2022-03-11 David
// Manage zip file with doc field of impex event because not possible in R&D Portfolio server to get a file from batch server (PC-1993)
//
// v1.0 2022-02-08 David
// Creation (PC-1993)
//
//***************************************************************************/
namespace _san_print;

// get the latest vaccines monthly baseline from the baseline schedule table
function san_ojs_get_last_date_vaccines_monthly_baseline()
{
	var vDate=undefined;
	var vToday=new date();
	// latest before the date of the day
	for (var vMB in plc.__USER_TABLE_SAN_RDPM_UT_VACCINES_BASELINE_SCHEDULE where vMB.SAN_RDPM_UA_D_VAC_BASELINE_DATE instanceof date && vMB.SAN_RDPM_UA_D_VAC_BASELINE_DATE!=\"\" && vMB.SAN_RDPM_UA_D_VAC_BASELINE_DATE!=-1 && vMB.SAN_RDPM_UA_D_VAC_BASELINE_DATE<vToday order by [['INVERSE','SAN_RDPM_UA_D_VAC_BASELINE_DATE']])
	{
		vDate=vMB.SAN_RDPM_UA_D_VAC_BASELINE_DATE;
	}
	return vDate;
}

// -------------------------
// Main
// -------------------------
plw.writetolog(\" -- PRINT MR -- START --\");
// id of the portfolio used for the export
var string vIdPort=\"NV_PORTFOLIO_SELECTION_PMR\";
// id of the presentation used for the export
var string vIdPrez=\"Monthtly Report View\";
//  id of the presentation used for franchise page
var string vRepFraName=\"Monthly Report - Franchise\";
// destination directory for zip file
var string vExpDirectory=Context.SAN_UF_S_MAIN_PATH+Context.SAN_CS_MONTH_REP_EXPORT_PATH;
// destination directory for pdf
var string vExpDirPdf=vExpDirectory+\"pdf_mr/\";

var vPrez=plc.presentation.get(vIdPrez);
var vPrezFra=plc.presentation.get(vRepFraName);
var vPortfolio=plc._FF_PT_FAVOR_FILTERS.get(vIdPort);
var vToday=new date();
var vPathDirZip=new pathname(vExpDirectory);
var vPathDirPdf=new pathname(vExpDirPdf);
var string vZipileName=\"\";
if (vPathDirZip.probefile()!=false)
{
	if (vPrez!=undefined)
	{
		if (vPortfolio!=undefined)
		{
			// Check if the pdf directory exists, if not create it 
			if (vPathDirPdf.probefile()==false) vExpDirPdf.mkdir();
			
			// Remove existing pdf files
			var number vNbPdfFile=0;
			for (var vFile in vPathDirPdf)
			{
				plw.writetolog(\" -- PRINT MR ------ Delete previous pdf file : \"+vFile.tostring());
				vFile.deletefile();
				vNbPdfFile++;
			}
			if (vNbPdfFile>0) plw.writetolog(\" -- PRINT MR -- \"+vNbPdfFile.tostring()+\" PDF files deleted in temporary pdf_mr directory\");
			
			// force A3 format
			var vA3Format=plc.paperformat.get(\"A3\");
			if (vA3Format!=undefined) vPrez.paper_format=vA3Format;
			// PC-5968 set the scaling =\"All in one page\"
			plw.set_scaling_monthly_report();
			
			var vDateMB=san_ojs_get_last_date_vaccines_monthly_baseline();
			var string vDateMBstr=(vDateMB!=undefined) ? \"PRINT_DATE\".callmacro(vDateMB,\"YYYY-MM\") : \"PRINT_DATE\".callmacro(vToday,\"YYYY-MM\");
			vDateMBstr=vDateMBstr.replaceregexp(\"-\",\"\");
			
			var vListProj=new vector();
			for(var o_Proj in vPortfolio.get(\"PROJECTS\") where o_Proj.LEVEL==1) vListProj.push(o_Proj);
			plw.writetolog(\" -- PRINT MR -- # of projects to print : \"+vListProj.length);
			
			var number i=0;
			var vHashFr=new hashtable();
			for (var vProj in vListProj)
			{
				i++;
				plw.writetolog(\" -- PRINT MR -- Start printing project #\"+i.tostring()+\" - \"+vProj.name);
				// name of the exported file
				var vFranch=vProj.SAN_RDPM_UA_FRANCHISE;
				var string vFranchName=\"\";
				var string vFrOrStr=\"\";
				if (vFranch!=undefined && vFranch!=\"\" && vFranch.internal==false)
				{
					vFranchName=vFranch.name;
					if (vHashFr.get(vFranch)!=undefined)
						vFrOrStr=vHashFr.get(vFranch);
					else
					{
						plw.writetolog(\" -- PRINT MR ---- Start printing franchise \"+vFranchName);
						var string vFOStr=\"PRINT_NUMBER\".callmacro(100+vFranch.SAN_RDPM_UA_N_ORDER,\"####\");
						vFrOrStr=vFOStr.substring(1,3);
						// store the order in a hashtable to get easily and have the list of franchises to print
						vHashFr.set(vFranch,vFrOrStr);
						// print once the franchise
						if (vPrezFra!=undefined)
						{
							if (vA3Format!=undefined) vPrezFra.paper_format=vA3Format;
							// file name
							var string vFileNameFra=vFrOrStr+\"_\"+vFranchName+\".pdf\";
							var vPDFpathFra=new pathname(vExpDirPdf+vFileNameFra);
							if (vPDFpathFra.probefile()!=false) vPDFpathFra.deletefile();
							var vPDFfileFra = vPrezFra.printpresentation(vProj,\"PDF-PRINTER\");
							vPDFfileFra.copyfile(vPDFpathFra);
							plw.writetolog(\" -- PRINT MR ---- End printing franchise \"+vFranchName+\" : \"+vPDFpathFra.tostring());
						}
						else plw.writetolog(\" -- PRINT MR -- Error : The presentation '\"+vRepFraName+\"' does not exist!\");
					}
				}
				var vPCode=vProj.SAN_UA_RWE_PROJECT_CODE_PRIME;
				var string vPCodeName=(vPCode!=undefined && vPCode!=\"\" && vPCode.internal==false) ? vPCode.name : \"\";
				var string vFileName=vFrOrStr+\"_\"+vFranchName+\"_\"+vProj.name+\"_\"+vPCodeName+\"_\"+vDateMBstr+\".pdf\";
				var vPDFpath =new pathname(vExpDirPdf+vFileName);
				
				var vPDFfile = vPrez.printpresentation(vProj,\"PDF-PRINTER\");
				if (vPDFpath.probefile()!=false) vPDFpath.deletefile();
				vPDFfile.copyfile(vPDFpath);
				plw.writetolog(\" -- PRINT MR ---- End printing project #\"+i.tostring()+\" - \"+vProj.name +\" : \"+vPDFpath.tostring());
			}
			vHashFr.clear();
			
			// zip files
			plw.writetolog(\" -- PRINT MR -- Start zip generation\");
			vZipileName=\"MONTHLY_REPORT_\"+vIdPort+\"_\"+vDateMBstr+\".zip\";
			var vZipFileResult=new pathname(vExpDirectory+vZipileName);
			if (vZipFileResult.probefile()!=false) vZipFileResult.deletefile();
			var vZip = new zipfile(vZipFileResult.tostring());
			vZip.appenddir(vExpDirPdf);
			// update the name of the latest zip file
			context.SAN_CS_MONTH_REP_LAST_EXPORT_NAME=vZipileName;
			// Delete and create event to store the zip file
			var vONBEvent=context.SAN_CS_MONTH_REP_LAST_EXPORT_ONB_EVENT;
			if (vONBEvent instanceof number && vONBEvent!=0)
			{
				var vEvent=plc.IMPEX_EVENT.get(vONBEvent);
				if (vEvent!=undefined)
				{
					plw.writetolog(\" -- PRINT MR -- Delete existing event \"+vEvent.printattribute());
					with(plw.no_locking){ vEvent.delete(); }
				}
			}
			plw.writetolog(\" -- PRINT MR -- Create new event to store zip file\");
			with(plw.no_applet_refresh) {
				var vCurDate=new date();
				var vObjEvent=new plc.IMPEX_EVENT(DIRECTION: \"Export\",USER: \"INTRANET\",DATE: vCurDate);
				vObjEvent._IMPEX_DF_UPLOADED_FILE=\"local://\" + vZipFileResult.Namestring;
				vObjEvent.positiveonb();
				plw.writetolog(\" -- PRINT MR ---- New event : \"+vObjEvent.printattribute()+\" (\"+\"PRINT_NUMBER\".callmacro(vObjEvent.ONB,\"####\")+\")\");
				context.SAN_CS_MONTH_REP_LAST_EXPORT_ONB_EVENT=vObjEvent.ONB;
			}
			plw.writetolog(\" -- PRINT MR ---- End zip generation\");
		}
		else plw.writetolog(\" -- PRINT MR -- Error : The portfolio '\"+vIdPort+\"' does not exist!\");
	}
	else plw.writetolog(\" -- PRINT MR -- Error : The presentation '\"+vIdPrez+\"' does not exist!\");
}
else plw.writetolog(\" -- PRINT MR -- Error : The directory '\"+vExpDirectory+\"' does not exist in the server!\");
plw.writetolog(\" -- PRINT MR -- END --\");
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 319716168069
 :VERSION 7
 :_US_AA_D_CREATION_DATE 20230720000000
 :_US_AA_S_OWNER "E0046087"
)