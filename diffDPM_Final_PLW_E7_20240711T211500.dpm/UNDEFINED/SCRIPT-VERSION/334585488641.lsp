
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 334585488641
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _rdpm_clinical_milestones;

// V2.0 Correcting this to avoid endless looping - PC-6268 - WST - 05/09/2022
// V1.9 Propagate the dates of the Clinical milestones under the activities of the study - PC-6104 - WST - 19-MAY-2022
// V1.8 Add functionnal description of planned date in export - PC-5707 - LFA - 28-FEB-2021
// V1.7 Fix problem on actual date - LFA - PC-5671 - LFA
// V1.6 Review script to add controls - LFA - 14-DEC-2021
// V1.5 Date not returned when it is not the first activity type - PC-5305 - LFA - 10-DEC-2021
// V1.4 Change technical name for Dynamic Attributes - PC-5274
// V1.3 Add function for the export of Clinical Milestone Dates BO - PC-5122 - LFA - 30-NOV-2021
// V1.2 Modification to add \"Order date\" to order activities
// V1.1 Modification to take into account option \"Ignore activity type order\"

//********************************************************************************************************************************************//
//******************************** Generic function to retrieve clinical milestone dates *****************************************************//
//********************************************************************************************************************************************//

function san_rdpm_get_clinical_milestone_date(act,clin_ms_rule)
{
	var date = -1;
	
	if (clin_ms_rule instanceof plc.__USER_TABLE_SAN_RDPM_UT_CLIN_MS_RULES && act instanceof plc.workstructure)
	{		
		var clin_ms = clin_ms_rule.SAN_RDPM_UA_S_CLIN_MS;
		var operation = clin_ms_rule.SAN_RDPM_UA_S_OPERATION;
		var sort_date_rule =  clin_ms_rule.SAN_RDPM_UA_S_ORDER_DATE;
		
		// Case 1 - We take into acount the order of activity type
		if (clin_ms_rule.SAN_RDPM_UA_B_IGNORE_AT_ORDER==false)
		{
			var v_break = false;
						
			for (var map_act_type in clin_ms_rule.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_CLIN_MS_RULE.__USER_TABLE_SAN_RDPM_UT_MAP_CLIN_MS_ACT_TYPE\") where map_act_type.SAN_RDPM_UA_S_ACT_TYPE!=\"\" && map_act_type.SAN_RDPM_UA_S_ACT_TYPE instanceof plc.wbs_type && map_act_type.SAN_RDPM_UA_S_DATE_SLOT!=\"\" order by ['SAN_RDPM_UA_N_ORDER'])
			{
				var date_slot = map_act_type.SAN_RDPM_UA_S_DATE_SLOT;
				var list = [];
				list.push(act);
				list.push(map_act_type.SAN_RDPM_UA_S_ACT_TYPE);
				
				var filter = plw.objectset(list);
				with(filter.fromobject())
				{
					if (operation==\"Increase\")
					{
						for (var vAct in plc.workstructure /*where vAct.get(date_slot)!=undefined*/ order by [sort_date_rule])
						{
							date = vAct.get(date_slot);
							v_break = true;
							break;
						}
					}
					else
					{
						for (var vAct in plc.workstructure /*where vAct.get(date_slot)!=undefined*/  order by [['INVERSE',sort_date_rule]])
						{
							date = vAct.get(date_slot);
							v_break = true;
							break;
						}
					}
				}
				
				if (v_break)
				{
					break;
				}
			}		
		}
		// Case 2 - We ignore the order of activity type 
		else
		{
			var list = [];
			list.push(act);
			// In this case the date slot is the one defined at rule level
			var date_slot = clin_ms_rule.SAN_RDPM_UA_S_DATE_SLOT;
			// Generate the vector of activity types
			for (var map_act_type in clin_ms_rule.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_CLIN_MS_RULE.__USER_TABLE_SAN_RDPM_UT_MAP_CLIN_MS_ACT_TYPE\") where map_act_type.SAN_RDPM_UA_S_ACT_TYPE!=\"\" && map_act_type.SAN_RDPM_UA_S_ACT_TYPE instanceof plc.wbs_type)
			{
				list.push(map_act_type.SAN_RDPM_UA_S_ACT_TYPE);
			}
			
			var filter = plw.objectset(list);
			with(filter.fromobject())
			{
				if (operation==\"Increase\")
				{
					for (var vAct in plc.workstructure /*where vAct.get(date_slot)!=undefined*/ order by [sort_date_rule])
					{
						date = vAct.get(date_slot);
						break;
					}
				}
				else
				{
					for (var vAct in plc.workstructure /*where vAct.get(date_slot)!=undefined*/  order by [['INVERSE',sort_date_rule]])
					{
						date = vAct.get(date_slot);
						break;
					}
				}
			}
		}		
	}
	
	if (date==undefined)
	    date=-1;
	
	return date;
}

//**********************************************************************************************************************************//
//*******************************************Dynamic attributes*********************************************************************//
//**********************************************************************************************************************************//

function san_clinical_milestone_slot_reader(clin_ms_rule)
{
	var result = -1;
	var act = this;
	if (act instanceof plc.workstructure)
	{
		var level = clin_ms_rule.SAN_RDPM_UA_S_LEVEL;
		if ((level==\"STUDY\" && act.SAN_UA_RDPM_B_IS_A_STUDY) || (level==\"STEP\" && act.WBS_TYPE!=\"\" && act.WBS_TYPE.SAN_RDPM_UA_AT_B_IS_STEP))
		{
			result=san_rdpm_get_clinical_milestone_date(act,clin_ms_rule);
		}
		// PC-6268 Correcting this to avoid endless looping
		// PC-6104 Propagate the dates of the Clinical milestones under the activities of the study
		else if (level==\"STUDY\") {
			var att_name = \"SAN_RDPM_DA_CLIN_MS_\"+clin_ms_rule.NAME;
			var o_study_act = plc.work_structure.get(act.SAN_UA_RDPM_ACT_S_STUDY_ID);
			if (o_study_act instanceof plc.work_structure && o_study_act!=act) {return o_study_act.get(att_name);}
		}
		// PC-6104 Propagate the dates of the Clinical milestones under the activities of the step
		else if (level==\"STEP\") {
			var att_name = \"SAN_RDPM_DA_CLIN_MS_\"+clin_ms_rule.NAME;
			if (act.SAN_RDPM_UA_N_ACT_STEP_ONB!= \"\") {
				var o_study_act = plc.work_structure.get(act.SAN_RDPM_UA_N_ACT_STEP_ONB);
				if (o_study_act instanceof plc.work_structure && o_study_act!=act && o_study_act.WBS_TYPE!=\"\" && o_study_act.WBS_TYPE.SAN_RDPM_UA_AT_B_IS_STEP) {return o_study_act.get(att_name);}
			}
		}
	}
	return result;
}

function san_create_clinical_milestone_dynamic_attributes(clin_ms_rule)
{
	if (clin_ms_rule instanceof plc.__USER_TABLE_SAN_RDPM_UT_CLIN_MS_RULES)
	{
		var att_name = \"SAN_RDPM_DA_CLIN_MS_\"+clin_ms_rule.NAME;
		var att_comment = clin_ms_rule.DESC;
		if (clin_ms_rule.SAN_RDPM_UA_S_FUNC_DESC!=\"\")
			att_comment = clin_ms_rule.SAN_RDPM_UA_S_FUNC_DESC;
		
		var date_slot = plc.workstructure.getslot(clin_ms_rule.SAN_RDPM_UA_S_DATE_SLOT);
		var date_slot_type = date_slot.descriptor.type.name;
		
		try{
			var slot = new objectAttribute(plc.workstructure,att_name,date_slot_type);
			
			slot.Comment = att_comment;
			slot.Reader = san_clinical_milestone_slot_reader.closure(clin_ms_rule);
			slot.Locker = function () {return true;};
			slot.hiddenInIntranetServer = false;
			slot.connecting = false;
			
			plw.writeln(\"Creation of dynamic attribute \" +att_name + \" by san_create_clinical_milestone_dynamic_attributes.\");
		}
		catch(error e){
			plw.writeln(\"Could not create slot [\"+att_name+\"] due to error: \" + e);
		}
	}
}

for (var rule in plc.__USER_TABLE_SAN_RDPM_UT_CLIN_MS_RULES where rule.SAN_RDPM_UA_B_GENERATE_FIELD)
{
	san_create_clinical_milestone_dynamic_attributes(rule);
}

//********************************************************************************************************************************************//
//******************************** Function to generate the Clinical Milestones Dates BO *****************************************************//
//********************************************************************************************************************************************//

// Generate file for BO Clinical Milestone
namespace _rdpm_clinical_milestones;

// Function to process a clinical milestone for BO Export
function san_rdpm_export_activity_clinical_milestone(clin_milestone,level,activity_vector,rule_planned,rule_actual,file)
{ 
	var activity_id=\"\";
	var activity_onb=\"\";
	var planned_date = -1;
	var planned_date_string=\"\";
	var actual_date = -1;
	var actual_date_string=\"\";
	var file_separator = \",\";
	var new_line=\"\";
	var planned_desc =\"\";
	var actual_desc =\"\";
	
	// Define common 	
	for (var act in activity_vector where act instanceof plc.workstructure)
	{
		// Retrieve the planned date
		if (rule_planned!=\"\" && rule_planned instanceof plc.__USER_TABLE_SAN_RDPM_UT_CLIN_MS_RULES)
		{
			planned_date = san_rdpm_get_clinical_milestone_date(act,rule_planned);
			if (planned_date!=-1)
			{
				if (rule_planned.SAN_RDPM_UA_S_DATE_SLOT==\"PS\" || rule_planned.SAN_RDPM_UA_S_DATE_SLOT==\"AS\")
				{
					planned_date_string=\"PRINT_DATE\".call(planned_date,\"YYYY-MM-DD\");
				}
				else
				{
					planned_date_string=\"PRINT_END_DATE\".call(planned_date,\"YYYY-MM-DD\");
				}
			}
			else
			{
				planned_date_string=\"\";
			}
			
			planned_desc = rule_planned.SAN_RDPM_UA_S_FUNC_DESC;
		}
		
		// Retrieve the actual date
		if (rule_actual!=\"\" && rule_actual instanceof plc.__USER_TABLE_SAN_RDPM_UT_CLIN_MS_RULES)
		{
			actual_date = san_rdpm_get_clinical_milestone_date(act,rule_actual);
			if (actual_date!=-1)
			{
				if (rule_actual.SAN_RDPM_UA_S_DATE_SLOT==\"PS\" || rule_actual.SAN_RDPM_UA_S_DATE_SLOT==\"AS\")
				{
					actual_date_string=\"PRINT_DATE\".call(actual_date,\"YYYY-MM-DD\");
				}
				else
				{
					actual_date_string=\"PRINT_END_DATE\".call(actual_date,\"YYYY-MM-DD\");
				}
			}
			else
			{
				actual_date_string=\"\";
			}
			
			actual_desc = rule_actual.SAN_RDPM_UA_S_FUNC_DESC;
		}
		
		if (planned_date_string!=\"\" || actual_date_string!=\"\")
		{
			activity_id=act.printattribute();
			activity_onb=\"PRINT_NUMBER\".call(act.ONB,\"####\");
			// Add clinical milestone line to file
			new_line=\"\\\"\"+clin_milestone+\"\\\"\"+file_separator+\"\\\"\"+level+\"\\\"\"+file_separator+\"\\\"\"+activity_id+\"\\\"\"+file_separator+activity_onb+file_separator+planned_date_string+file_separator+actual_date_string+file_separator+\"\\\"\"+planned_desc+\"\\\"\";
			file.writeln(new_line);
		}
	}
		
}

function san_rdpm_bo_clinical_milestones_export()
{
	// CSV Export Variables
	var filepath = \"/tmp/\";
	var ClinMSfilename = \"-CLINICAL_MILESTONES_DATES.csv\";
	var ClinMSfilepath = new PathName(filepath+\"TEMP\"+ClinMSfilename);
	
	if(ClinMSfilepath.probefile())
	{
		ClinMSfilepath.deletefile();
		plw.alert(\"san_rdpm_bo_clinical_milestones_export - Deleted already existing working file: \"+ClinMSfilepath);
	}
	
	var ClinMSFile = new plw.fileOutputStream(ClinMSfilepath,\"overwrite\");


	ClinMSFile.writeln(\"\\\"CLINICAL_MILESTONE\\\",\\\"LEVEL\\\",\\\"ACTIVITY_ID\\\",\\\"ACTIVITY_ONB\\\",\\\"PLANNED_DATE\\\",\\\"ACTUAL_DATE\\\",\\\"SAN_RDPM_UA_S_FUNC_DESC\\\"\");
	
	
	// Generate the list of studies and step to work on
	var study_list = new vector();
	var step_list = new vector();

	// Loop on Project
	var list = [];
	// Loop on Projects: restrict loop to Pasteur Active Projects
	for(var o_project in plc.project where o_project.DELETED==false && o_project.SAN_RDPM_B_RND_VACCINES_PROJECT && o_project.STATE==\"Active\" && o_project._WZD_AA_B_PERMANENT == false)
	{
		list.push(o_project);
	}

	var filter = plw.objectset(list);
	with(filter.fromobject()){
		for(var o_act in plc.work_structure)
		{
			if (o_act.SAN_UA_RDPM_B_IS_A_STUDY && o_act.SAN_RDPM_UA_B_STUDY_EXPORT_FILTER)
			{
				study_list.push(o_act);
			}
			else
			{
				if (o_act.WBS_TYPE!=\"\" && o_act.WBS_TYPE.SAN_RDPM_UA_AT_B_IS_STEP && o_act.SAN_RDPM_UA_B_TASK_EXPORT_FILTER)
				{
					step_list.push(o_act);
				}
			}
		}
	}


	for (var clin_ms in plc.__USER_TABLE_SAN_RDPM_UT_CLINICAL_MILESTONES where clin_ms.INACTIVE==false)
	{
		var clin_ms_rule_study_planned = \"\";
		var clin_ms_rule_study_actual = \"\";
		var clin_ms_rule_step_planned = \"\";
		var clin_ms_rule_step_actual = \"\";
		
		// For the considered milestone, search for different rules [Study/Step - Planned/Actual]
		for (var clin_ms_rule in clin_ms.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_CLIN_MS.__USER_TABLE_SAN_RDPM_UT_CLIN_MS_RULES\") where clin_ms_rule.SAN_RDPM_UA_B_EXPORT)
		{
			// Vaccines rules only
			if (clin_ms_rule.SAN_RDPM_UA_S_APPLY_TO==\"VACCINES\" || clin_ms_rule.SAN_RDPM_UA_S_APPLY_TO==\"COMMON\")
			{
				if (clin_ms_rule.SAN_RDPM_UA_S_LEVEL==\"STUDY\")
				{
					if (clin_ms_rule.SAN_RDPM_UA_S_MILESTONE_TYPE==\"PLANNED\")
					{
						clin_ms_rule_study_planned = clin_ms_rule;
					}
					else
					{
						if (clin_ms_rule.SAN_RDPM_UA_S_MILESTONE_TYPE==\"ACTUAL\")
						{
							clin_ms_rule_study_actual = clin_ms_rule;
						}
					}
				}
				else
				{
					if (clin_ms_rule.SAN_RDPM_UA_S_LEVEL==\"STEP\")
					{
						if (clin_ms_rule.SAN_RDPM_UA_S_MILESTONE_TYPE==\"PLANNED\")
						{
							clin_ms_rule_step_planned = clin_ms_rule;
						}
						else
						{
							if (clin_ms_rule.SAN_RDPM_UA_S_MILESTONE_TYPE==\"ACTUAL\")
							{
								clin_ms_rule_step_actual = clin_ms_rule;
							}
						}
					}
				}
			}
		}
		
		// Process Study
		if (clin_ms_rule_study_planned!=\"\" || clin_ms_rule_study_actual!=\"\")
		{
			san_rdpm_export_activity_clinical_milestone(clin_ms.NAME,\"STUDY\",study_list,clin_ms_rule_study_planned,clin_ms_rule_study_actual,ClinMSFile);
		}
		
		// Process Step
		if (clin_ms_rule_step_planned!=\"\" || clin_ms_rule_step_actual!=\"\")
		{
			san_rdpm_export_activity_clinical_milestone(clin_ms.NAME,\"STEP\",step_list,clin_ms_rule_step_planned,clin_ms_rule_step_actual,ClinMSFile);
		}
	}
	
	// Close file
	ClinMSFile.close();
	
	// Rename files to add start timestamp
	var filepath = context.SAN_RDPM_UA_OC_S_EXPORT_DATAHUB_PATH;
	var vdate = new date();
	ClinMSfilename = vdate.tostring(\"YYYYMMDDTHHMMSSZ\")+\"-CLINICAL_MILESTONES_DATES.csv\";
	ClinMSfilepath.renamefile(filepath+ClinMSfilename);	
	ClinMSfilepath = new PathName(filepath+ClinMSfilename);
	
	plw.writetolog(\"ClinMSfilepath: \"+ClinMSfilepath);
}

//*******************************************************************************************************************************************************//"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 316665535974
 :VERSION 23
 :_US_AA_D_CREATION_DATE 20230330000000
 :_US_AA_S_OWNER "I0260387"
)