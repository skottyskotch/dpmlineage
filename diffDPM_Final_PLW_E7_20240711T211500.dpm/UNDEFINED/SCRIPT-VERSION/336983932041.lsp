
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 336983932041
 :DATASET 118081000141
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_JS2_DATAHUB_IMPORT
//
//  AUTHOR  : Islam GUEROUI
//
//  Modification : 2022/05/31 ABO
//  Add control to not import empty country_country_group_rel.json files
//
//  Modification : 2022/03/17 LFA
//  Add traces in log when an error occurs
//
//  Modification : 2022/01/18 ABO
//  Addition of two impex format 'SAN_RDPM_IMPEX_IMP_FORMAT_COUNTRY_GROUP' & 'SAN_RDPM_IMPEX_IMP_FORMAT_COUNTRY_COUNTRYGROUP_REL'
//
//  Modification : 2021/10/21 IGU
//  Fix email sending in case of import fail (PC-4786)
//
//  Modification : 2021/08/30 IGU
//  Add Vaccines Project codes import (PC-3867)
//
//  Modification : 2021/05/20 IGU
//  Add a try catch to send an email in case of import failure
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
	var String s_pathFile = context.SAN_UF_S_MAIN_PATH+context.SAN_CS_DATAHUB_IMPORT_PATH+context.SAN_CS_PRIME_FOLDER+s_fileName;
	var plc.impextarget o_target;
	if( s_pathFile == context.SAN_UF_S_MAIN_PATH+context.SAN_CS_DATAHUB_IMPORT_PATH+context.SAN_CS_PRIME_FOLDER+'country_country_group_rel.json'){
		o_target = plc.impextarget.get('SAN_IMPEX_TARGET_REL_COUNT_GROUP_DATAHUB_IMPORT:Json file format');
	}
	else {
		o_target = plc.impextarget.get('SAN_IMPEX_TARGET_DATAHUB_IMPORT:Json file format');
	}
    
	plw.writetolog('**** Importing '+s_format+' from: \"'+s_pathFile+'\"****');
	
    if(o_format instanceof plc.impexformat && o_target instanceof plc.impextarget && s_pathFile.probefile()){
		var jsonFile = new plw.fileinputstream(s_pathFile);
		if (vNewFold!=\"\")
		{
    		plw.writetolog('**** Archiving file into \"'+vNewFold+'\" ****');
    		s_pathFile.copyfile(vNewFold+s_fileName);
		}
		else plw.writetolog('**** Impossible to archive file, archive folder is undefined ****');
		o_target.set('FILENAME','\"'+s_pathFile+'\"');
		// Verify if the country_country_group_rel.json file is the one imported
		if( s_pathFile == context.SAN_UF_S_MAIN_PATH+context.SAN_CS_DATAHUB_IMPORT_PATH+context.SAN_CS_PRIME_FOLDER+'country_country_group_rel.json'){
			var s_line_1 = jsonFile.readline();
			var s_line_2 = jsonFile.readline();
			var s_line = s_line_1+s_line_2;
			//Verify if the country_country_group_rel.json file is empty
			if( !s_line.matchregexp(\"\\s*\\[\\s*\\]\\s*\")){
				try{
					plw.DoImportWithFormatAndTarget(this : o_format, o_target, true);
				}
				catch(error e){
					var plist = new vector();
					plist.setplist(\"from\",context._ADM_ST_S_NOTIF_CHGLOG_EMAIL_FROM);
					plist.setplist(\"to\",context.SAN_RDPM_CS_EMAIL_NOTIF_ERROR_DATAHUB);
					plist.setplist(\"subject\",\"[Planisware] Error during importing \" + s_fileName);
					plist.setplist(\"body\",'An error occured during SAN_BA_DATAHUB_IMPORT execution on '+context.callstringformula('$DATABASE_NAME')+': '+e.toString());
					plist.setplist(\"Content-Type\",\"text/html\");
					plw.mail_send(plist);
					
					plw.writetolog(\"****** Error during importing \" + s_fileName +\" --> \" +e.toString() + \" ****\");
					plw.writetolog(\"****** Sending mail to : \" + context.SAN_RDPM_CS_EMAIL_NOTIF_ERROR_DATAHUB+ \" ****\");
				}
			}
			else{
				var plist = new vector();
				plist.setplist(\"from\",context._ADM_ST_S_NOTIF_CHGLOG_EMAIL_FROM);
				plist.setplist(\"to\",context.SAN_RDPM_CS_EMAIL_NOTIF_ERROR_DATAHUB);
				plist.setplist(\"subject\",\"[Planisware] Error during importing \" + s_fileName);
				plist.setplist(\"body\",'An error occured during SAN_BA_DATAHUB_IMPORT execution on '+context.callstringformula('$DATABASE_NAME')+': '+'The Json file is empty.');
				plist.setplist(\"Content-Type\",\"text/html\");
				plw.mail_send(plist);
				
				plw.writetolog(\"****** Error during importing \" + s_fileName +\" --> \" +'The Json file is empty' + \" ****\");
				plw.writetolog(\"****** Sending mail to : \" + context.SAN_RDPM_CS_EMAIL_NOTIF_ERROR_DATAHUB+ \" ****\");
			}
			
		}
		else{
				try{
					plw.DoImportWithFormatAndTarget(this : o_format, o_target, true);
				}
				catch(error e){
					var plist = new vector();
					plist.setplist(\"from\",context._ADM_ST_S_NOTIF_CHGLOG_EMAIL_FROM);
					plist.setplist(\"to\",context.SAN_RDPM_CS_EMAIL_NOTIF_ERROR_DATAHUB);
					plist.setplist(\"subject\",\"[Planisware] Error during importing \" + s_fileName);
					plist.setplist(\"body\",'An error occured during SAN_BA_DATAHUB_IMPORT execution on '+context.callstringformula('$DATABASE_NAME')+': '+e.toString());
					plist.setplist(\"Content-Type\",\"text/html\");
					plw.mail_send(plist);
					
					plw.writetolog(\"****** Error during importing \" + s_fileName +\" --> \" +e.toString() + \" ****\");
					plw.writetolog(\"****** Sending mail to : \" + context.SAN_RDPM_CS_EMAIL_NOTIF_ERROR_DATAHUB+ \" ****\");
				}
		}
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
san_import_datahub_data('Project codes:SAN_IMPEX_VACCINE_PROJECT','vaccine_project.json');
san_import_datahub_data('Study Codes:SAN_IMPEX_IMP_STUDY_CODES','study_codes.json');
san_import_datahub_data('Clinical Milestones:SAN_IMPEX_IMP_CLINICAL_MILESTONES','clinical_milestone.json');
san_import_datahub_data('Country Groups:SAN_RDPM_IMPEX_IMP_FORMAT_COUNTRY_GROUP','country_group.json');
san_import_datahub_data('Relations Country - Country Group:SAN_RDPM_IMPEX_IMP_FORMAT_COUNTRY_COUNTRYGROUP_REL','country_country_group_rel.json');"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 262077656373
 :VERSION 18
 :_US_AA_D_CREATION_DATE 20230719000000
 :_US_AA_S_OWNER "E0046087"
)