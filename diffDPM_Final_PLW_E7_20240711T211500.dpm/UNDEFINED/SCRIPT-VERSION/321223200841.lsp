
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321223200841
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_CONTINUUM_JS2_COMMON_FUNCTIONS
//  Common functions for Continuum
//
//  V2.2 - 20220429 - PC-6052 - Change the name of file for Actual Subjects - Ludovic
//  V2.1 - Add e-mail notification in case of fail - PC-5832
//  V2.0 - Change activity type from \"Study\" to \"STUDY\" to identify the countries
//  v1.9 - 2022-02-03 - PC-5350 - Update archive folder path
//  v1.8 - 2022-01-18 - PC-4336 - Add import of actual subjects on countries
//  v1.7 - 2021/12/16 - PC-5349 - No automatic update of actual dates
//  v1.6 - 2021/11/15 - PC-4988 - Fix bugs + Improvements 
//  v1.5 - 2021/11/09 - PC-4979 - Use the table \"Clinical Milestone Rules\" for the interface
//  v1.4 - 2021/10/28 - Ludovic
//                    - Manage case where country code is empty
//                    - Restrict to Pharma Active projects
//                    - Add PS/PF before modification in the log    
//  v1.3 - 2021/10/15 - Add control if no clinical milestone is define
//  v1.2 - 2021/10/14 - PC-4609 - Improve Interface for actual dates import from ISTORE - Badereddine
//  v1.1 - 2021/09/22 - PV-4311 - use json - Ludovic
//  v1.0 - 2021/04/07 - Ludovic
//
//
//***************************************************************************/
namespace _san_impact_import;
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

// Creation of hashtable of activities linked to the clinical milestones
// Clinical milestone start
var clin_ms_start_act = new hashtable(\"STRING\");
var clin_ms_end_act = new hashtable(\"STRING\");
var countries = new hashtable(\"STRING\");
var act_iStore_code;
var clin_ms_start;
var clin_ms_end;
var count_clin_ms_start=0;
var count_clin_ms_end=0;
var list_ms_start = new vector();
var list_ms_end = new vector();
var list_country = new vector();
var project_vec = new vector();

// Loop on Projects: restrict loop to Active
for(var o_project in plc.project where o_project.SAN_RDPM_B_RND_PHARMA_PROJECT && o_project.DELETED==false  && o_project.STATE==\"Active\" && o_project._PM_NF_B_IS_A_VERSION==false)
{
	list_ms_start.push(o_project);
	list_ms_end.push(o_project);
	list_country.push(o_project);
	project_vec.push(o_project);
}

// Clinical milestones
plw.writetolog(\"Search for activity types linked to the clinical milestones.\");
for (var act_type in plc.wbs_type)
{
    // Clinical milestone start
    if (act_type.SAN_RDPM_UA_S_CLIN_MS_START_PHARMA!=\"\")
    {
        list_ms_start.push(act_type);
		count_clin_ms_start++;
    }
    // Clinical milestone end
    if (act_type.SAN_RDPM_UA_S_CLIN_MS_END_PHARMA!=\"\")
    {
        list_ms_end.push(act_type);
		count_clin_ms_end++;
    }
}
plw.writetolog(count_clin_ms_start + \" activity types found for clinical milestone start.\");
plw.writetolog(count_clin_ms_end + \" activity types found for clinical milestone end.\");

// Countries
var country_act_type = plc.WBS_TYPE.get(\"STUDY\");
list_country.push(country_act_type);
country_act_type = plc.WBS_TYPE.get(\"Study\");
list_country.push(country_act_type);

// Create hashtable for Clinical Milestone start
if (count_clin_ms_start>0)
{
    plw.writetolog(\"Creation of activities hashtable for clinical milestones start.\");
    var filter = plw.objectset(list_ms_start);
    with(filter.fromobject()){		
    	for(var vAct in plc.work_structure)
    	{
    		act_iStore_code=vAct.SAN_RDPM_UA_S_PHARMA_ISTORE_CODE_START_MS;
    		clin_ms_start=clin_ms_start_act.get(act_iStore_code);
    		if (clin_ms_start==undefined)
    			clin_ms_start_act.set(act_iStore_code,vAct.ONB.tostring());
    		else
    			clin_ms_start_act.set(act_iStore_code,clin_ms_start+\",\"+vAct.ONB.tostring());
    	}
    }
}

// Create hashtable for Clinical Milestone end
if (count_clin_ms_end>0)
{
    plw.writetolog(\"Creation of activities hashtable for clinical milestones end.\");
    var filter = plw.objectset(list_ms_end);
    with(filter.fromobject()){		
    	for(var vAct in plc.work_structure)
    	{
    		
    		
    		act_iStore_code=vAct.SAN_RDPM_UA_S_PHARMA_ISTORE_CODE_END_MS;
    		clin_ms_end=clin_ms_end_act.get(act_iStore_code);
    		if (clin_ms_end==undefined)
    			clin_ms_end_act.set(act_iStore_code,vAct.ONB.tostring());
    		else
    			clin_ms_end_act.set(act_iStore_code,clin_ms_end+\",\"+vAct.ONB.tostring(\"####\"));
    	}
    }
}

// Create hashtable for countries
plw.writetolog(\"Creation of countries hashtable.\");
var filter = plw.objectset(list_country);
with(filter.fromobject()){		
	for(var vAct in plc.work_structure)
	{
		countries.set(vAct.SAN_RDPM_UA_S_ISTORE_COUNTRY_CODE,vAct);
	}
}


// Process data from impact
//*************************************************************************************************//
//********************* Processing clincal milestone dates ***************************************//
//************************************************************************************************//
var iStore_cl_ms=\"\";
var iStore_study_code=\"\";
var iStore_country_code=\"\";
var iStore_ms_period=\"\";
var iStore_id=\"\";
var iStore_date=\"\";
var iStore_date_end=\"\";
var cal_act=\"\";
var list_act;
var vect_act = new vector();
var act_onb=\"\";
var act_obj=\"\";
var PS_Before=-1;
var PF_Before=-1;
var date_of_day = new date();

// Archive directory
// Archive the file
var date vNow=new date();
var vNewFold=san_create_date_folder(vNow,context.SAN_UF_S_MAIN_PATH+context.SAN_CS_ISTORE_ARCH_IMPORT_PATH);
    
    
try{
    // Read data to import
    var s_fileName=\"istore_clinical_milestones.json\";
    var s_pathFile = context.SAN_UF_S_MAIN_PATH+context.SAN_CS_IMPACT_IMPORT_PATH+s_fileName;
    
    if (s_pathFile.probefile())
    {
        plw.writetolog(\"Processing clinical milestones file...\");
        with(plw.no_locking)
        {
        	var fis = new plw.fileinputstream(s_pathFile);
        	// Create a vector of object from the json file
        	var vec_obj = rest.parse(fis.lispstream);
        	fis.close();
        	
        	// Loop on object
        	for (var o in vec_obj)
        	{
        		// Access to the attributes of the objects as defined in the json
        		iStore_cl_ms=o.MILESTONE_CODE;
        		iStore_study_code=o.STUDY_CODE;
        		iStore_country_code=o.COUNTRY_CODE;
        		iStore_ms_period=o.PERIOD_NUM;
        		if (iStore_ms_period==undefined) iStore_ms_period=0;
        		if (iStore_country_code==undefined) iStore_country_code=\"\";
        		iStore_date = o.ACTUAL_DATE.parsedate(\"YYYY-MM-DD\");
        		iStore_id = iStore_cl_ms + \"_\" + iStore_study_code + \"_\" + iStore_country_code + \"_\"+iStore_ms_period;
        		
        		plw.writetolog(\"Processing  : \"+iStore_id);
        		
        		// Update clinical milestone start
        		if (count_clin_ms_start>0)
                {
            		list_act=clin_ms_start_act.get(iStore_id);
            		if (list_act!=undefined) 
            		{
            			vect_act=list_act.parselist();
            			
            			for (var Act in vect_act)
            			{
            				act_onb=Act.parsenumber(\"####\");
            				act_obj=plc.workstructure.get(act_onb);
            				// If there is no modification of the date sent from iStore --> No update
            				if (act_obj instanceof plc.workstructure && act_obj.SAN_RDPM_UA_D_ISTORE_AS!=iStore_date)
            				{
            				    PS_Before=act_obj.PS;
            				    act_obj.SAN_RDPM_UA_D_ISTORE_AS=iStore_date;
            				    act_obj.SAN_RDPM_UA_D_ISTORE_LAST_UPDATE_DATE=date_of_day;
            				    plw.writetolog(\"Update iStore actual start for activity : \" + act_obj.printattribute() + \"[\"+act_obj.SAN_RDPM_UA_S_PHARMA_ISTORE_CODE_START_MS+\"]\");
            					/*act_obj.AS = iStore_date;
            					plw.writetolog(\"Update actual start for activity : \" + act_obj.printattribute() + \"[\"+act_obj.SAN_RDPM_UA_S_PHARMA_ISTORE_CODE_START_MS+\"] - PS before update :  \"+PS_Before+\" - New date : \"+ iStore_date);*/
            				}
            			}
            		}
                }
        		
        		// Update clinical milestone end
        		if (count_clin_ms_end>0)
                {
            		list_act=clin_ms_end_act.get(iStore_id);
            		if (list_act!=undefined) 
            		{
            			vect_act=list_act.parselist();
            		   
            			for (var Act in vect_act)
            			{
            				act_onb=Act.parsenumber(\"####\");
            				act_obj=plc.workstructure.get(act_onb);
            				if (act_obj instanceof plc.workstructure)
            				{
                				// Add 1 day for Actual Finish because of end date format in Planisware
                				iStore_date_end = \"PERIOD_START\".call(iStore_date,\"DAY\",1);
            				    // If there is no modification of the date sent from iStore --> No update
            				    if (act_obj.SAN_RDPM_UA_D_ISTORE_AF!=iStore_date_end)
            				    {
            				        act_obj.SAN_RDPM_UA_D_ISTORE_AF=iStore_date_end;
            				        act_obj.SAN_RDPM_UA_D_ISTORE_LAST_UPDATE_DATE=date_of_day;
            				        plw.writetolog(\"Update iStore actual finish for activity : \" + act_obj.printattribute() + \"[\"+act_obj.SAN_RDPM_UA_S_PHARMA_ISTORE_CODE_START_MS+\"]\");
            				        /*if (iStore_date_end<act_obj.PS)
            				        {
            				            // The actual finish is before the planned
            				            plw.writetolog(\"Update actual finish for activity : \" + act_obj.printattribute()+ \"[\"+act_obj.SAN_RDPM_UA_S_PHARMA_ISTORE_CODE_END_MS+\"] is not possible because the actual finish is before the start of the activity.\");
            				            
            				        }
            				        else
            				        {
                    				    PF_Before=act_obj.PF;
                    					act_obj.AF = iStore_date_end;
                    					plw.writetolog(\"Update actual finish for activity : \" + act_obj.printattribute()+ \"[\"+act_obj.SAN_RDPM_UA_S_PHARMA_ISTORE_CODE_END_MS+\"] - PF before update : \"+PF_Before+\" - New date : \"+ iStore_date);
            				        }*/
            				    }
            				}
            			}
            		}
                }
        	}
        	
        	plw.writetolog(\"End of processing file Clinical Milestones ...\");
        	// Archive the file
        	if (vNewFold!=\"\")
        	{
        		plw.writetolog('**** Archiving file into \"'+vNewFold+'\" ****');
        		s_pathFile.copyfile(vNewFold+s_fileName);
        	}
        }
    }
    else
    {
    	plw.writetolog(\"The file \"+ s_pathFile+\" was not found.\");
    }
}
catch(error e){
	var plist = new vector();
	plist.setplist(\"from\",context._ADM_ST_S_NOTIF_CHGLOG_EMAIL_FROM);
	plist.setplist(\"to\",context.SAN_RDPM_CS_EMAIL_NOTIF_ERROR_DATAHUB);
	plist.setplist(\"subject\",\"[Planisware] Error during importing clinical milestone dates from iStore\");
	plist.setplist(\"body\",'An error occured during SAN_RDPM_BA_IMPACT_UPDATE execution on '+context.callstringformula('$DATABASE_NAME')+': '+e.toString());
	plist.setplist(\"Content-Type\",\"text/html\");
	plw.mail_send(plist);
	
	plw.writetolog(\"Error during importing clinical milestone dates from iStore --> \" +e.toString());
	plw.writetolog(\"Sending mail to : \" + context.SAN_RDPM_CS_EMAIL_NOTIF_ERROR_DATAHUB);
}

//*************************************************************************************************//
//************************** Processing Actual subjects ******************************************//
//************************************************************************************************//

try{
    var iStore_study_code=\"\";
    var iStore_country_code=\"\";
    var iStore_id=\"\";
    var iStore_actual_subject = 0;
    var country_act=\"\";
    
    // Read data to import
    var s_fileName=\"istore_actual_subjects.json\";
    var s_pathFile = context.SAN_UF_S_MAIN_PATH+context.SAN_CS_IMPACT_IMPORT_PATH+s_fileName;
    
    
    if (s_pathFile.probefile())
    {
        plw.writetolog(\"Processing actual subjects file...\");
        with(plw.no_locking)
        {
        	var fis = new plw.fileinputstream(s_pathFile);
        	// Create a vector of object from the json file
        	var vec_obj = rest.parse(fis.lispstream);
        	fis.close();
        	
        	// Loop on object
        	for (var o in vec_obj)
        	{
        		// Access to the attributes of the objects as defined in the json
        		iStore_study_code=o.STUDY_CODE;
        		iStore_country_code=o.COUNTRY_CODE;
        		iStore_actual_subject=o.ENTERED_TREATMENT;
        		iStore_id = iStore_study_code + \"_\" + iStore_country_code;
        		
        		plw.writetolog(\"Processing  : \"+iStore_id);
        		
        		country_act = countries.get(iStore_id);
        		if (country_act instanceof plc.workstructure && country_act.SAN_RDPM_CF_ACTUAL_SUBJECTS!=iStore_actual_subject)
        		{
        		    
        		    country_act.SAN_RDPM_CF_ACTUAL_SUBJECTS=iStore_actual_subject;
        		    country_act.SAN_RDPM_UA_D_ISTORE_LAST_UPDATE_DATE=date_of_day;
        		    plw.writetolog(\"Update actual subjects for activity : \" + country_act.printattribute() + \"[\"+country_act.SAN_RDPM_UA_S_ISTORE_COUNTRY_CODE+\"]\");
        		}
        	}
        }
        
        plw.writetolog(\"End of processing file Actual Subjects ...\");
    	if (vNewFold!=\"\")
    	{
    		plw.writetolog('**** Archiving file into \"'+vNewFold+'\" ****');
    		s_pathFile.copyfile(vNewFold+s_fileName);
    	}
    }
    else
    {
    	plw.writetolog(\"The file \"+ s_pathFile+\" was not found.\");
    }
}
catch(error e){
	var plist = new vector();
	plist.setplist(\"from\",context._ADM_ST_S_NOTIF_CHGLOG_EMAIL_FROM);
	plist.setplist(\"to\",context.SAN_RDPM_CS_EMAIL_NOTIF_ERROR_DATAHUB);
	plist.setplist(\"subject\",\"[Planisware] Error during importing actual subjects from iStore\");
	plist.setplist(\"body\",'An error occured during SAN_RDPM_BA_IMPACT_UPDATE execution on '+context.callstringformula('$DATABASE_NAME')+': '+e.toString());
	plist.setplist(\"Content-Type\",\"text/html\");
	plw.mail_send(plist);
	
	plw.writetolog(\"Error during importing actual subjects from iStore --> \" +e.toString());
	plw.writetolog(\"Sending mail to : \" + context.SAN_RDPM_CS_EMAIL_NOTIF_ERROR_DATAHUB);
}
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 296654818774
 :VERSION 33
 :_US_AA_D_CREATION_DATE 20220509000000
 :_US_AA_S_OWNER "E0499298"
)