
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 317256722774
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_CONTINUUM_JS2_COMMON_FUNCTIONS
//  Common functions for Continuum
//
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
var act_iStore_code;
var clin_ms_start;
var clin_ms_end;
var count_clin_ms_start=0;
var count_clin_ms_end=0;
var list_ms_start = new vector();
var list_ms_end = new vector();
var project_vec = new vector();

// Loop on Projects: restrict loop to Active
for(var o_project in plc.project where o_project.SAN_RDPM_B_RND_PHARMA_PROJECT && o_project.DELETED==false  && o_project.STATE==\"Active\" && o_project._PM_NF_B_IS_A_VERSION==false)
{
	list_ms_start.push(o_project);
	list_ms_end.push(o_project);
	project_vec.push(o_project);
}

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

// Process data from impact
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
        				if (act_obj instanceof plc.workstructure && act_obj.SAN_RDPM_UA_D_ISTORE_AS!=iStore_date)
        				{
        				    PS_Before=act_obj.PS;
        				    act_obj.SAN_RDPM_UA_D_ISTORE_AS=iStore_date;
        					act_obj.AS = iStore_date;
        					plw.writetolog(\"Update actual start for activity : \" + act_obj.printattribute() + \"[\"+act_obj.SAN_RDPM_UA_S_PHARMA_ISTORE_CODE_START_MS+\"] - PS before update :  \"+PS_Before+\" - New date : \"+ iStore_date);
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
        				    
        				    if (act_obj.SAN_RDPM_UA_D_ISTORE_AF!=iStore_date_end)
        				    {
        				        act_obj.SAN_RDPM_UA_D_ISTORE_AF=iStore_date_end;
        				        if (iStore_date_end<act_obj.PS)
        				        {
        				            // The actual finish is before the planned
        				            plw.writetolog(\"Update actual finish for activity : \" + act_obj.printattribute()+ \"[\"+act_obj.SAN_RDPM_UA_S_PHARMA_ISTORE_CODE_END_MS+\"] is not possible because the actual finish is before the start of the activity.\");
        				            
        				        }
        				        else
        				        {
                				    PF_Before=act_obj.PF;
                					act_obj.AF = iStore_date_end;
                					plw.writetolog(\"Update actual finish for activity : \" + act_obj.printattribute()+ \"[\"+act_obj.SAN_RDPM_UA_S_PHARMA_ISTORE_CODE_END_MS+\"] - PF before update : \"+PF_Before+\" - New date : \"+ iStore_date);
        				        }
        				    }
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
    	
    	// Recompute dates on projects
        for (var vProj in project_vec)
        {
        	vProj.callmacro(\"RECOMPUTE-DATES\");
        }
    }
}
else
{
	plw.writeln(\"The file was not found.\");
}
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 296654818774
 :VERSION 20
 :_US_AA_D_CREATION_DATE 20211116000000
 :_US_AA_S_OWNER "E0296878"
)