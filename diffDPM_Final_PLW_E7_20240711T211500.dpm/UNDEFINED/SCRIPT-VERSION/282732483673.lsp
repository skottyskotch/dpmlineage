
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 282732483673
 :DATASET 118081000141
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_JS2_DATAHUB_IMPORT
//
//  AUTHOR  : Islam GUEROUI
//
//
//  Creation : 2020/12/09 IGU
//  Script used in SAN_BA_DATAHUB_IMPORT
//
//  Modification : 2020/12/15 IGU
//  Modification of the order of data import
//
//***************************************************************************/

namespace _san_datahub_import;

function san_import_datahub_data (String s_format, String s_fileName){
	var plc.impexformat o_format = plc.impexformat.get(s_format);
	var plc.impextarget o_target = plc.impextarget.get('SAN_IMPEX_TARGET_DATAHUB_IMPORT:Json file format');
    var String s_pathFile = context.SAN_CS_DATAHUB_IMPORT_PATH+s_fileName;
	
	plw.writetolog('**** Importing '+s_format+' from: \"'+s_pathFile+'\"****');
	
    if(o_format instanceof plc.impexformat && o_target instanceof plc.impextarget && s_pathFile.probefile()){
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

san_import_datahub_data('Clinical indications:SAN_IMPEX_IMP_CLIN_IND','CLINICAL_INDICATION.json');
san_import_datahub_data('Countries:SAN_IMPEX_IMP_PRIME_COUNTRIES','COUNTRY.json');
san_import_datahub_data('Root Product:SAN_IMPEX_IMP_PRODUCT','ROOT_PRODUCT.json');
san_import_datahub_data('Partner (RDPM):SAN_IMPEX_IMP_PARTNER','PARTNER.json');
san_import_datahub_data('Therapeutic Area:SAN_IMPEX_IMP_PRIME_TA','THERAPEUTIC_AREA.json');
san_import_datahub_data('Project codes:SAN_IMPEX_RESEARCH_PROJECT','RESEARCH_PROJECT.json');
san_import_datahub_data('Project codes:SAN_IMPEX_OTHER_PROJECT','OTHER_PROJECT.json');
san_import_datahub_data('Project codes:SAN_IMPEX_DEV_PROJECT','DEV_PROJECT.json');
san_import_datahub_data('Study Codes:SAN_IMPEX_IMP_STUDY_CODES','STUDY_CODES.json');"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 262077656373
 :VERSION 2
 :_US_AA_D_CREATION_DATE 20210112000000
 :_US_AA_S_OWNER "E0448344"
)