
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 317277372274
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _rdpm_clinical_milestones;

// V1.2 Modification to add \"Order date\" to order activities
// V1.1 Modification to take into account option \"Ignore activity type order\"

//********************************************************************************************************************************************//
//******************************** Generic function to retrieve clinical milestone dates *****************************************************//
//********************************************************************************************************************************************//

function san_rdpm_get_clinical_milestone_date(act,clin_ms_rule)
{
	var result = -1;
	var sort_result = -1;
	
	var clin_ms = clin_ms_rule.SAN_RDPM_UA_S_CLIN_MS;
	var operation = clin_ms_rule.SAN_RDPM_UA_S_OPERATION;
	var sort_date_rule =  clin_ms_rule.SAN_RDPM_UA_S_ORDER_DATE;
	
	if (clin_ms_rule instanceof plc.__USER_TABLE_SAN_RDPM_UT_CLIN_MS_RULES)
	{
		for (var map_act_type in clin_ms_rule.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_CLIN_MS_RULE.__USER_TABLE_SAN_RDPM_UT_MAP_CLIN_MS_ACT_TYPE\") where map_act_type.SAN_RDPM_UA_S_ACT_TYPE!=\"\" && map_act_type.SAN_RDPM_UA_S_DATE_SLOT!=\"\" order by ['SAN_RDPM_UA_N_ORDER'])
		{
			var date = -1;
			var sort_date=-1;
			var date_slot = map_act_type.SAN_RDPM_UA_S_DATE_SLOT;
			var list = [];
			list.push(act);
			list.push(map_act_type.SAN_RDPM_UA_S_ACT_TYPE);
			
			var filter = plw.objectset(list);
			with(filter.fromobject())
			{
				if (operation==\"Increase\")
				{
					for (var vAct in plc.workstructure where vAct.get(date_slot)!=undefined order by [sort_date_rule])
					{
						date = vAct.get(date_slot);
						sort_date = vAct.get(sort_date_rule);
						break;
					}
				}
				else
				{
					for (var vAct in plc.workstructure where vAct.get(date_slot)!=undefined  order by [['INVERSE',sort_date_rule]])
					{
						date = vAct.get(date_slot);
						break;
					}
				}
			}
			
			// Check if we need to stop
			// Case 1 - We use the order of activity type and we stop processing if the date is not undefined
			if (clin_ms_rule.SAN_RDPM_UA_B_IGNORE_AT_ORDER==false)
			{
				result=date;
				break;
			}
			// Case 2 - We do not use the order of activity type, and go on and compare the date use for sorting
			else
			{
				if (date!=-1 && (sort_result=-1 || (operation==\"Increase\" && sort_result<sort_result) || (operation==\"Decrease\" && sort_result>sort_result)))
				{
					sort_result=sort_date;
					result=date;
				}
			}
		}
	}
	
	return result;
}

//**********************************************************************************************************************************//
//*******************************************Dynamic attributes*********************************************************************//
//**********************************************************************************************************************************//

function san_clinical_milestone_slot_reader(clin_ms_rule)
{

	var result = -1;
	var level = clin_ms_rule.SAN_RDPM_UA_S_LEVEL;
	
	if ((level==\"STUDY\" && this.SAN_UA_RDPM_B_IS_A_STUDY) || (level==\"STEP\" && this.WBS_TYPE!=\"\" && this.WBS_TYPE.SAN_RDPM_UA_AT_B_IS_STEP))
	{
		result=san_rdpm_get_clinical_milestone_date(this,clin_ms_rule);
	}
	
	return result;
}

function san_create_clinical_milestone_dynamic_attributes(clin_ms_rule)
{
	var att_name = \"SAN_RDPM_DA_CLIN_MS_\"+clin_ms_rule.ONB;
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
		
		plw.writeln(\"Creation of dynamic attribute \" +att_name);
	}
	catch(error e){
		plw.writeln(\"Could not create slot [\"+att_name+\"] due to error: \" + e);
	}
}

for (var rule in plc.__USER_TABLE_SAN_RDPM_UT_CLIN_MS_RULES where rule.SAN_RDPM_UA_B_GENERATE_FIELD)
{
	san_create_clinical_milestone_dynamic_attributes(rule);
}

//*******************************************************************************************************************************************************//"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 316665535974
 :VERSION 12
 :_US_AA_D_CREATION_DATE 20211130000000
 :_US_AA_S_OWNER "E0296878"
)