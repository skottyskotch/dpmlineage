
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 316651606310
 :DATASET 118081000141
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_RDPM_JS2_DYN_TRANSLATOR_COST 
//  2021/09/24 - ABO
//  Creation of the Translator cost dynamic attribute for Cost metrics (PC-4462)
//
//***************************************************************************/
// Modfication 2021/10/07 - ABO
// Added two dynamic fields \"Is First\" and \"Is Last 

namespace _translator_costs;
function san_rdpm_act_translator_costs_reader()
{
	var country_list = this.SAN_RDPM_UA_S_LIST_COUNTRIES;
	var act_type = this.WBS_TYPE;
	var tm_costs = 0;
	if (act_type.SAN_RDPM_UA_B_TRANSLATOR)
	{
		//Get the list of countries of the activity
		var country_vec = country_list.parsevector();
		var country_obj = \"\";
		var key=\"\";
		var hashtable = new hashtable(\"STRING\");
		for (var country in  country_vec)
		{
			country_obj = plc.__USER_TABLE_SAN_RWE_UT_COUNTRY.get(country);
			// Get all Translator Metrics linked to the country
			for (var tr_metric in country_obj.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_TM_COUNTRY.__USER_TABLE_SAN_RDPM_UT_TRANSLATOR_METRICS\") where (act_type.printattribute()==\"V_S_COST\" || tr_metric.SAN_RDPM_UA_TM_WBS_TYPE==act_type))
			{
				key = tr_metric.SAN_RDPM_UA_TM_WBS_TYPE.printattribute() + \"_\" + tr_metric.SAN_RDPM_UA_TM_LANGUAGE.printattribute();
				if (hashtable.get(key)!=undefined)
				{
					// If there is already the language for this activity type, check if the new cost value is higher
					if (hashtable.get(key)<tr_metric.SAN_RDPM_UA_TM_TRA_COST)
						hashtable.set(key,tr_metric.SAN_RDPM_UA_TM_TRA_COST);
				}
				else
				{
					// If the value is not in the hashtable --> Add it
					hashtable.set(key,tr_metric.SAN_RDPM_UA_TM_TRA_COST);
				}
			}
			
		}
		// Make the sum of all costs
		for (var key in hashtable)
		{
			tm_costs=tm_costs+hashtable.get(key);
		}
		
		hashtable.delete();
	}
	return tm_costs;
}

var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_N_TRANSLATOR_COST\",\"NUMBER\");
		slot.Comment = \"Translator cost\";
		slot.Reader = san_rdpm_act_translator_costs_reader;
		slot.Locker = function () {return true;};
		slot.hiddenInIntranetServer = false;
		slot.connecting = false;



function san_rdpm_is_first_reader()
{
	var study_id = this.SAN_UA_RDPM_ACT_S_STUDY_ID;
	var study = plc.workstructure.get(study_id);
	var wbs_type = this.wbs_type;
	var result = false;
	
	if (study instanceof plc.workstructure && wbs_type instanceof plc.wbs_type)
	{
		var list = [];
		list.push(study);
		list.push(wbs_type);
		var filter = plw.objectset(list);
		with(filter.fromobject()){
			for (var act in plc.workstructure order by [\"PS\"])
			{
				if (this.PS==act.PS)
					result=true;
				break;
			}			
		}
	}
	return result;
}



function san_rdpm_is_last_reader()
{
	var study_id = this.SAN_UA_RDPM_ACT_S_STUDY_ID;
	var study = plc.workstructure.get(study_id);
	var wbs_type = this.wbs_type;
	var result = false;
	
	if (study instanceof plc.workstructure && wbs_type instanceof plc.wbs_type)
	{
		var list = [];
		list.push(study);
		list.push(wbs_type);
		var filter = plw.objectset(list);
		with(filter.fromobject()){
			for (var act in plc.workstructure order by [[\"INVERSE\",\"PS\"]])
			{
				if (this.PS==act.PS)
					result=true;
				break;
			}			
		}
	}
	return result;
}

var slot = new objectAttribute(plc.workstructure,\"SAN_RDPM_UA_B_IS_FIRST\",\"BOOLEAN\");
slot.Comment = \"Is First?\";
slot.Reader = san_rdpm_is_first_reader;
slot.Locker = true;
slot.hiddenInIntranetServer = true;
slot.connecting = false;

var slot = new objectAttribute(plc.workstructure,\"SAN_RDPM_UA_B_IS_LAST\",\"BOOLEAN\");
slot.Comment = \"Is Last?\";
slot.Reader = san_rdpm_is_last_reader;
slot.Locker = true;
slot.hiddenInIntranetServer = true;
slot.connecting = false;"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 316646797810
 :VERSION 3
 :_US_AA_D_CREATION_DATE 20211007000000
 :_US_AA_S_OWNER "E0296878"
)