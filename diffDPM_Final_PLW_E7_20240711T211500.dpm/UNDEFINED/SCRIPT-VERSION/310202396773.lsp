
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 310202396773
 :DATASET 118081000141
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_JS2_DATAHUB_IMPORT
//
//  AUTHOR  : Islam GUEROUI
//
//  Modification : 2021/04/09 Islam
//  JSON files are archived before importing it
//
//  Modification : 2021/03/16 Islam
//  Use the customer setting SAN_CS_PRIME_FOLDER to specify from which folder the import is done (PC-3442)
//
//  Modification : 2021/02/19 David
//  Use the attribute to compute the path according to the env (PC-2849)
//
//  Modification : 2021/01/18 David
//  Add san_create_date_folder and modify san_import_datahub_data to manage file archiving (PC-2849)
//
//  Modification : 2021/01/12 IGU
//  Modification of the files names to lower case and the name of impex format to import partners
//
//  Modification : 2020/12/15 IGU
//  Modification of the order of data import
//
//  Creation : 2020/12/09 IGU
//  Script used in SAN_BA_DATAHUB_IMPORT
//
//***************************************************************************/

namespace _san_datahub_import;
var string vNewFold=\"\";

// create a folder vDate (format YYYYMMDD_hhmmss) under path vFolder
function san_create_date_folder(date vDate,string vFolder)
{
    var string vResult=\"\";
    if (vFolder.probefile()!=false)
    {
        if (vDate!=undefined && vDate instanceof date)
        {
            var string vDateStr=vDate.tostring(\"YYYYMMDDTHHMMSS\");
            vDateStr=vDateStr.replaceregexp(\"T\",\"_\");
            var string vNEwDir=vFolder+vDateStr+\"/\";
            // if directory does not exist, we create it
            if (vNEwDir.probefile()==false)
            {
                plw.writetolog(\"****** creating directory \"+vNEwDir+\" ****\");
                vNEwDir.mkdir();  
            }
            vResult=vNEwDir;
        }
        else plw.writetolog(\"****** Error on san_create_date_folder, wrong date argument ****\");
    }
    else plw.writetolog(\"****** Error on san_create_date_folder, the folder \"+vFolder+\" does not exist ****\");
    return vResult;
}

function san_import_datahub_data (String s_format, String s_fileName){
	var plc.impexformat o_format = plc.impexformat.get(s_format);
	var plc.impextarget o_target = plc.impextarget.get('SAN_IMPEX_TARGET_DATAHUB_IMPORT:Json file format');
    var String s_pathFile = context.SAN_UF_S_MAIN_PATH+context.SAN_CS_DATAHUB_IMPORT_PATH+context.SAN_CS_PRIME_FOLDER+s_fileName;
	
	plw.writetolog('**** Importing '+s_format+' from: \"'+s_pathFile+'\"****');
	
    if(o_format instanceof plc.impexformat && o_target instanceof plc.impextarget && s_pathFile.probefile()){
		if (vNewFold!=\"\")
		{
    		plw.writetolog('**** Archiving file into \"'+vNewFold+'\" ****');
    		s_pathFile.copyfile(vNewFold+s_fileName);
		}
		else plw.writetolog('**** Impossible to archive file, archive folder is undefined ****');
		o_target.set('FILENAME','\"'+s_pathFile+'\"');
		plw.DoImportWithFormatAndTarget(this : o_format, o_target, true);
    }
	else{
		if (!(o_format instanceof plc.impexformat)) {plw.writetolog('Impex Format: \"'+s_format+'\" does not exist! Import cancelled!');}
		if (!(o_target instanceof plc.impextarget)) {plw.writetolog('Impex Target: \"SAN_RDPM_IMPEX_TARGET_DATAHUB_IMPORT:Json file format\" does not exist! Import cancelled!');}
		if (!(s_pathFile.probefile())) {plw.writetolog('File: \"'+s_pathFile+'\" does not exist! Import cancelled!');}
	}
	
	plw.writetolog('**** Import of '+s_format +' done!****');
	
}

var date vNow=new date();
vNewFold=san_create_date_folder(vNow,context.SAN_UF_S_MAIN_PATH+context.SAN_CS_DATAHUB_ARCH_IMPORT_PATH);
san_import_datahub_data('Clinical indications:SAN_IMPEX_IMP_CLIN_IND','clinical_indication.json');
san_import_datahub_data('Countries:SAN_IMPEX_IMP_PRIME_COUNTRIES','country.json');
san_import_datahub_data('Root Product:SAN_IMPEX_IMP_PRODUCT','root_product.json');
san_import_datahub_data('Provider:SAN_IMPEX_IMP_PARTNER','partner.json');
san_import_datahub_data('Therapeutic Area:SAN_IMPEX_IMP_PRIME_TA','therapeutic_area.json');
san_import_datahub_data('Project codes:SAN_IMPEX_RESEARCH_PROJECT','research_project.json');
san_import_datahub_data('Project codes:SAN_IMPEX_OTHER_PROJECT','other_project.json');
san_import_datahub_data('Project codes:SAN_IMPEX_DEV_PROJECT','dev_project.json');
san_import_datahub_data('Study Codes:SAN_IMPEX_IMP_STUDY_CODES','study_codes.json');"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 262077656373
 :VERSION 8
 :_US_AA_D_CREATION_DATE 20210521000000
 :_US_AA_S_OWNER "E0448344"
)