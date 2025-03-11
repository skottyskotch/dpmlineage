
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 316665461174
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_CONTINUUM_JS2_COMMON_FUNCTIONS
//  Common functions for Continuum
//
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

plw.writetolog(\"Start of batch SAN_RDPM_J2S_IMPACT_UPDATE.\");

// Creation of hashtable of activities linked to the clinical milestones
// Clinical milestone start
var clin_ms_start_act = new hashtable(\"STRING\");
var clin_ms_end_act = new hashtable(\"STRING\");
var act_impact_code;
var clin_ms_start;
var clin_ms_end;
var count_clin_ms_start=0;
var count_clin_ms_end=0;
var list_ms_start = new vector();
var list_ms_end = new vector();

// Loop on Projects: restrict loop to Active & Simulation projects only
for(var o_project in plc.project where o_project.SAN_RDPM_B_RND_PHARMA_PROJECT && o_project.DELETED==false  && (o_project.STATE==\"Active\" || o_project.STATE==\"Simulation\"))
{
	list_ms_start.push(o_project);
	list_ms_end.push(o_project);
}

plw.writetolog(\"Search for activity types linked to the clinical milestones.\");
for (var clin_ms in plc.__USER_TABLE_SAN_RDPM_UT_CLINICAL_MILESTONES where clin_ms.SAN_UA_B_ACTUAL_FROM_IMPACT)
{
	// Clinical milestone start
	for (var act_type in clin_ms.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_CLIN_MS_START.WBS_TYPE\"))
	{
		list_ms_start.push(act_type);
		count_clin_ms_start++;
	}	
	plw.writetolog(count_clin_ms_start + \" activity types found for clinical milestone start.\");
	
	// Clinical milestone end
	for (var act_type in clin_ms.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_CLIN_MS_END.WBS_TYPE\"))
	{
		list_ms_end.push(act_type);
		count_clin_ms_end++;
	}
	plw.writetolog(count_clin_ms_end + \" activity types found for clinical milestone end.\");
}

// Create hashtable for Clinical Milestone start
if (count_clin_ms_start>0)
{
    plw.writetolog(\"Creation of activities hashtable for clinical milestones start.\");
    var filter = plw.objectset(list_ms_start);
    with(filter.fromobject()){		
    	for(var vAct in plc.work_structure)
    	{
    		act_impact_code=vAct.SAN_RDPM_UA_S_IMPACT_CODE_START_MS;
    		clin_ms_start=clin_ms_start_act.get(act_impact_code);
    		if (clin_ms_start==undefined)
    			clin_ms_start_act.set(act_impact_code,vAct.ONB.tostring());
    		else
    			clin_ms_start_act.set(act_impact_code,clin_ms_start+\",\"+vAct.ONB.tostring());
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
    		act_impact_code=vAct.SAN_RDPM_UA_S_IMPACT_CODE_END_MS;
    		clin_ms_end=clin_ms_end_act.get(act_impact_code);
    		if (clin_ms_end==undefined)
    			clin_ms_end_act.set(act_impact_code,vAct.ONB.tostring());
    		else
    			clin_ms_end_act.set(act_impact_code,clin_ms_end+\",\"+vAct.ONB.tostring(\"####\"));
    	}
    }
}

// Process data from impact
var impact_cl_ms=\"\";
var impact_study_code=\"\";
var impact_country_code=\"\";
var impact_ms_period=\"\";
var impact_id=\"\";
var impact_date=\"\";
var list_act;
var vect_act = new vector();
var act_onb=\"\";
var act_obj=\"\";
var impact_input = new vector();

// Read data to import
var s_fileName=\"istore_clinical_milestones.json\";
var s_pathFile = context.SAN_UF_S_MAIN_PATH+context.SAN_CS_IMPACT_IMPORT_PATH+s_fileName;
if (s_pathFile.probefile())
{
    plw.writetolog(\"Processing file...\");
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
    		impact_cl_ms=o.MILESTONE_CODE;
    		impact_study_code=o.STUDY_CODE;
    		impact_country_code=o.COUNTRY_CODE;
    		impact_ms_period=o.PERIOD_NUM;
    		if (impact_ms_period==undefined) impact_ms_period=0;
    		impact_date = o.ACTUAL_DATE.parsedate(\"YYYY-MM-DD\");
    		impact_id = impact_cl_ms + \"_\" + impact_study_code + \"_\" + impact_country_code + \"_\"+impact_ms_period;
    		
    		plw.writetolog(\"Processing  : \"+impact_id);
    		
    		// Update clinical milestone start
    		if (count_clin_ms_start>0)
            {
        		list_act=clin_ms_start_act.get(impact_id);
        		if (list_act!=undefined) 
        		{
        			vect_act=list_act.parselist();
        			
        			for (var Act in vect_act)
        			{
        				act_onb=Act.parsenumber(\"####\");
        				act_obj=plc.workstructure.get(act_onb);
        				if (act_obj instanceof plc.workstructure && act_obj.AS!=impact_date && act_obj.wbs_type.SAN_RDPM_UA_B_ACTIVE_ISTORE_AD==true)
        				{
        					act_obj.AS = impact_date;
        					act_obj.SAN_RDPM_UA_S_SYSTEM_OWNER_ACTUAL_START = \"ISTORE\";
        					plw.writetolog(\"Update actual start for activity : \" + act_obj.printattribute() + \"[\"+act_obj.SAN_RDPM_UA_S_IMPACT_CODE_START_MS+\"] - New date : \"+ impact_date);
        				}
        			}
        		}
            }
    		
    		// Update clinical milestone end
    		if (count_clin_ms_end>0)
            {
        		list_act=clin_ms_end_act.get(impact_id);
        		if (list_act!=undefined) 
        		{
        			vect_act=list_act.parselist();
        		   
        			for (var Act in vect_act)
        			{
        				act_onb=Act.parsenumber(\"####\");
        				act_obj=plc.workstructure.get(act_onb);
        				if (act_obj instanceof plc.workstructure && act_obj.AF!=impact_date && act_obj.wbs_type.SAN_RDPM_UA_B_ACTIVE_ISTORE_AD==true)
        				{
        					act_obj.AF = impact_date;
        					act_obj.SAN_RDPM_UA_S_SYSTEM_OWNER_ACTUAL_FINISH = \"ISTORE\";
        					plw.writetolog(\"Update actual finish for activity : \" + act_obj.printattribute()+ \"[\"+act_obj.SAN_RDPM_UA_S_IMPACT_CODE_END_MS+\"] - New date : \"+ impact_date);
        				}
        			}
        		}
            }
    		
    	}
    	
    	plw.writetolog(\"End of processing file...\");
    	// Archive the file
    	var date vNow=new date();
    	var vNewFold=san_create_date_folder(vNow,context.SAN_UF_S_MAIN_PATH+context.SAN_CS_IMPACT_ARCH_IMPORT_PATH);
    	if (vNewFold!=\"\")
    	{
    		plw.writetolog('**** Archiving file into \"'+vNewFold+'\" ****');
    		s_pathFile.copyfile(vNewFold+s_fileName);
    	}
    }
}
else
{
	plw.writetolog(\"The file was not found.\");
}

plw.writetolog(\"End of batch SAN_RDPM_J2S_IMPACT_UPDATE.\");
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 296654818774
 :VERSION 12
 :_US_AA_D_CREATION_DATE 20211021000000
 :_US_AA_S_OWNER "E0296878"
)