
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321185321369
 :DATASET 118081000141
 :SCRIPT-CODE "// 
// PLWSCRIPT : SAN_RDPM_JS2_PRINT_MONTHLY_REPORT
// call on batch SAN_RDPM_BA_PRINT_MONTHLY_REPORT
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
// name of the repor used to export Franchise intermed pages
var string vRepFraName=\"SAN_RDPM_REP_MR_PRINT_FRANCHISE\";
// destination directory for zip file
var string vExpDirectory=context.SAN_UF_S_MAIN_PATH+context.SAN_CS_MONTH_REP_EXPORT_PATH;
// destination directory for pdf
var string vExpDirPdf=context.SAN_UF_S_MAIN_PATH+context.SAN_CS_MONTH_REP_EXPORT_PATH+\"pdf/\";

var vPrez=plc.presentation.get(vIdPrez);
var vPortfolio=plc._FF_PT_FAVOR_FILTERS.get(vIdPort);
var vToday=new date();
var vPathDirZip=new pathname(vExpDirectory);
var vPathDirPdf=new pathname(vExpDirPdf);
if (vPathDirZip.probefile()!=false)
{
	if (vPrez!=undefined)
	{
		if (vPortfolio!=undefined)
		{
			// Check if the pdf directory exists, if not create it 
			if (vPathDirPdf.probefile()==false) vExpDirPdf.mkdir();
			
			// Remove existing pdf files
			for (var vFile in vPathDirPdf)
				vFile.deletefile();
			
			// force A3 format
			var vA3Format=plc.paperformat.get(\"A3\");
			if (vA3Format!=undefined) vPrez.paper_format=vA3Format;
			
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
						var string vFOStr=\"PRINT_NUMBER\".callmacro(100+vFranch.SAN_RDPM_UA_N_ORDER,\"####\");
						vFrOrStr=vFOStr.substring(1,3);
						// store the order in a hashtable to get easily and have the list of franchises to print
						vHashFr.set(vFranch,vFrOrStr);
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
			
			plw.writetolog(\" -- PRINT MR -- Start franchise printing\");
			// list of franchise
			var number j=0;
			var vRepF=plc.report.get(vRepFraName);
			if (vRepF!=undefined)
			{
				for (var vFra in vHashFr)
				{
					j++;
					var string vFOStr=vHashFr.get(vFra);
					// file name
					var string vFileNameFra=vFOStr+\"_\"+vFra.name+\".pdf\";
					var vPDFpathFra=new pathname(vExpDirPdf+vFileNameFra);
					if (vPDFpathFra.probefile()!=false) vPDFpathFra.deletefile();
					var vPDFfileFra=vRepF.print(vFra, \"PDF-PRINTER\", \"A3\", \"LANDSCAPE\", vPDFpathFra.tostring());
					plw.writetolog(\" -- PRINT MR ---- End printing Franchise \"+vFra.name+\" : \"+vPDFpathFra.tostring());
				}
			}
			else plw.writetolog(\" -- PRINT MR -- Error : The report '\"+vRepFraName+\"' does not exist!\");
			plw.writetolog(\" -- PRINT MR ---- End franchise printing : \"+j.tostring());
			
			// zip files
			var vZipFileResult=new pathname(vExpDirectory+\"MONTHLY_REPORT_\"+vIdPort+\"_\"+vDateMBstr+\".zip\");
			if (vZipFileResult.probefile()!=false) vZipFileResult.deletefile();
			var vZip = new zipfile(vZipFileResult.tostring());
			vZip.appenddir(vExpDirPdf);
			vHashFr.clear();
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
 :VERSION 3
 :_US_AA_D_CREATION_DATE 20220225000000
 :_US_AA_S_OWNER "E0476882"
)