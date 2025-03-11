
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 316665567674
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _rdpm_clinical_milestones;

function san_rdpm_get_clinical_milestone_date(act,clin_ms_rule)
{
	var result = -1;
	
	var clin_ms = clin_ms_rule.SAN_RDPM_UA_S_CLIN_MS;
	var date_slot = clin_ms_rule.SAN_RDPM_UA_S_DATE_SLOT;
	var operation = clin_ms_rule.SAN_RDPM_UA_S_OPERATION;
	
	if (clin_ms_rule instanceof plc.__USER_TABLE_SAN_RDPM_UT_CLIN_MS_RULES)
	{
	for (var map_act_type in clin_ms_rule.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_CLIN_MS_RULE.__USER_TABLE_SAN_RDPM_UT_MAP_CLIN_MS_ACT_TYPE\") where map_act_type.SAN_RDPM_UA_S_ACT_TYPE!=\"\" order by ['SAN_RDPM_UA_N_ORDER'])
	{
		
		var list = [];
		list.push(act);
		list.push(map_act_type.SAN_RDPM_UA_S_ACT_TYPE);
		
		var filter = plw.objectset(list);
		with(filter.fromobject())
		{
			if (operation==\"MIN\")
			{
				for (var vAct in plc.workstructure where vAct.get(date_slot)!=undefined order by [date_slot])
				{
					result = vAct.get(date_slot);
					break;
				}
			}
			else
			{
				for (var vAct in plc.workstructure where vAct.get(date_slot)!=undefined  order by [['INVERSE',date_slot]])
				{
					result = vAct.get(date_slot);
					break;
				}
			}
		}
			
		if (result!=-1)
			break;
	}
	}
	
	return result;
}

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
	var att_comment = clin_ms_rule.NAME;
	
	var date_slot = plc.workstructure.getslot(clin_ms_rule.SAN_RDPM_UA_S_DATE_SLOT);
	var date_slot_type = date_slot.descriptor.type.name;
	
	try{
		var slot = new objectAttribute(plc.workstructure,att_name,date_slot_type);
		
		slot.Comment = att_comment;
		slot.Reader = san_clinical_milestone_slot_reader.closure(clin_ms_rule);
		slot.Locker = function () {return true;};
		slot.hiddenInIntranetServer = false;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot [\"+att_name+\"] due to error: \" + e);
	}
}

for (var rule in plc.__USER_TABLE_SAN_RDPM_UT_CLIN_MS_RULES)
{
	san_create_clinical_milestone_dynamic_attributes(rule);
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 316665535974
 :VERSION 5
 :_US_AA_D_CREATION_DATE 20211027000000
 :_US_AA_S_OWNER "E0296878"
)