
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 317253193341
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
	
	var clin_ms = clin_ms_rule.SAN_RDPM_UA_S_CLIN_MS;
	var operation = clin_ms_rule.SAN_RDPM_UA_S_OPERATION;
	var order_date =  clin_ms_rule.SAN_RDPM_UA_S_ORDER_DATE;
	
	if (clin_ms_rule instanceof plc.__USER_TABLE_SAN_RDPM_UT_CLIN_MS_RULES)
	{
		for (var map_act_type in clin_ms_rule.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_CLIN_MS_RULE.__USER_TABLE_SAN_RDPM_UT_MAP_CLIN_MS_ACT_TYPE\") where map_act_type.SAN_RDPM_UA_S_ACT_TYPE!=\"\" && map_act_type.SAN_RDPM_UA_S_DATE_SLOT!=\"\" order by ['SAN_RDPM_UA_N_ORDER'])
		{
			var date = -1;
			var date_slot = map_act_type.SAN_RDPM_UA_S_DATE_SLOT;
			var list = [];
			list.push(act);
			list.push(map_act_type.SAN_RDPM_UA_S_ACT_TYPE);
			
			var filter = plw.objectset(list);
			with(filter.fromobject())
			{
				if (operation==\"Increase\")
				{
					for (var vAct in plc.workstructure where vAct.get(date_slot)!=undefined order by [order_date])
					{
						date = vAct.get(date_slot);
						break;
					}
				}
				else
				{
					for (var vAct in plc.workstructure where vAct.get(date_slot)!=undefined  order by [['INVERSE',order_date]])
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
			// Case 2 - We do not use the order of activity type, and go on and compare the result to the new date
			else
			{
				if (date!=-1 && (result=-1 || (operation==\"Increase\" && date<result) || (operation==\"Decrease\" && date>result)))
				{
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
	var att_name = \"SAN_RDPM_DA_CLIN_MS_\"+clin_ms_rule.NAME;
	var att_comment = clin_ms_rule.DESC;
	
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
 :VERSION 10
 :_US_AA_D_CREATION_DATE 20211105000000
 :_US_AA_S_OWNER "E0296878"
)