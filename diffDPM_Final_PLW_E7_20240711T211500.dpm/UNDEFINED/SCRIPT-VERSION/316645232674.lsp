
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 316645232674
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_CONTINUUM_JS2_COMMON_FUNCTIONS
//  Common functions for Continuum
//
//  v1.0 - 2021/04/07 - Ludovic
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
var act_impact_code;
var clin_ms_start;
var clin_ms_end;
var list_ms_start = new vector();
var list_ms_end = new vector();

// Loop on Projects: restrict loop to Active & Simulation projects only
for(var o_project in plc.project where o_project.SAN_RDPM_B_RND_PHARMA_PROJECT && o_project.DELETED==false  && (o_project.STATE==\"Active\" || o_project.STATE==\"Simulation\"))
{
	list_ms_start.push(o_project);
	list_ms_end.push(o_project);
}

for (var clin_ms in plc.__USER_TABLE_SAN_RDPM_UT_CLINICAL_MILESTONES where clin_ms.SAN_UA_B_ACTUAL_FROM_IMPACT)
{
	// Clinical milestone start
	for (var act_type in clin_ms.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_CLIN_MS_START.WBS_TYPE\"))
	{
		list_ms_start.push(act_type);
	}	
	
	// Clinical milestone end
	for (var act_type in clin_ms.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_CLIN_MS_END.WBS_TYPE\"))
	{
		list_ms_end.push(act_type);
	}
}

// Create hashtable for Clinical Milestone end
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

// Create hashtable for Clinical Milestone end
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
var s_fileName=\"Impact_RDPM_Clinical_Milestones.csv\";
var s_pathFile = context.SAN_UF_S_MAIN_PATH+context.SAN_CS_IMPACT_IMPORT_PATH+s_fileName;
if (s_pathFile.probefile())
{
	var fips = new plw.fileinputstream(s_pathFile);
	var line = fips.readline();

	while(line!=undefined)
	{
		impact_input=line.split(\";\");
		impact_cl_ms=impact_input[0];
		impact_study_code=impact_input[1];
		impact_country_code=impact_input[2];
		impact_ms_period=impact_input[3];
		impact_date = impact_input[4].parsedate(\"DD-MM-YYYY\");
		impact_id = impact_cl_ms + \"_\" + impact_study_code + \"_\" + impact_country_code + \"_\"+impact_ms_period;
		
		// Update clinical milestone start
		list_act=clin_ms_start_act.get(impact_id);
		if (list_act!=undefined) 
		{
			vect_act=list_act.parselist();
			
			for (var Act in vect_act)
			{
				act_onb=Act.parsenumber(\"####\");
				act_obj=plc.workstructure.get(act_onb);
				if (act_obj instanceof plc.workstructure && act_obj.AS!=impact_date)
				{
					act_obj.AS = impact_date;
					plw.alert(\"Update actual start for activity : \" + act_obj.printattribute());
				}
			}
		}
		
		// Update clinical milestone end
		list_act=clin_ms_end_act.get(impact_id);
		if (list_act!=undefined) 
		{
			vect_act=list_act.parselist();
		   
			for (var Act in vect_act)
			{
				act_onb=Act.parsenumber(\"####\");
				act_obj=plc.workstructure.get(act_onb);
				if (act_obj instanceof plc.workstructure && act_obj.AF!=impact_date)
				{
					act_obj.AF = impact_date;
					plw.alert(\"Update actual finish for activity : \" + act_obj.printattribute());
				}
			}
		}
		
		// Read next line
		line = fips.readline();	
	}
	// Archive the file
	var date vNow=new date();
	var vNewFold=san_create_date_folder(vNow,context.SAN_UF_S_MAIN_PATH+context.SAN_CS_IMPACT_ARCH_IMPORT_PATH);
	if (vNewFold!=\"\")
	{
		plw.writetolog('**** Archiving file into \"'+vNewFold+'\" ****');
		s_pathFile.copyfile(vNewFold+s_fileName);
	}
}
else
{
	plw.writeln(\"The file was not found.\");
}
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 296654818774
 :VERSION 6
 :_US_AA_D_CREATION_DATE 20210922000000
 :_US_AA_S_OWNER "E0296878"
)