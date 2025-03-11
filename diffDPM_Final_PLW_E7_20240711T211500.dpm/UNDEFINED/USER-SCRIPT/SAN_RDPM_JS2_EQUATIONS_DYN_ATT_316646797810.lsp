
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 316646797810
 :NAME "SAN_RDPM_JS2_EQUATIONS_DYN_ATT"
 :COMMENT "RDPM Equations dynamic attribute "
 :ACTIVE T
 :DATASET 118081000141
 :EVAL-ON-LOAD T
 :LOAD-ORDER 0
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_RDPM_JS2_EQUATIONS_DYN_ATT
//  2022/03/07 - LFA - Update san_rdpm_is_first_reader / san_rdpm_is_last_reader - PC-5084
//  2021/09/24 - ABO
//  Creation of the Translator cost dynamic attribute for Cost metrics (PC-4462)


namespace _RDPM_EQ_DYN_ATT;
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

// Modification - 2021/10/07 - ABO
// Added two dynamic fields \"Is First\" and \"Is Last 

// Modification - 2021/11/24 - ABO
// Taking into account the line identifier, to check Is First & Is Last

function san_rdpm_is_first_reader()
{
    var result = false;
    var activity= this;
    
    if (activity instanceof plc.workstructure)
    {
    	var study_id = activity.SAN_UA_RDPM_ACT_S_STUDY_ID;
    	var study = plc.workstructure.get(study_id);
    	var wbs_type = activity.wbs_type;
    	
    	// We are inside a study
    	if (study instanceof plc.workstructure && wbs_type instanceof plc.wbs_type)
    	{
    		var list = [];
    		list.push(study);
    		list.push(wbs_type);
    		var filter = plw.objectset(list);
    		with(filter.fromobject()){
    			for (var act in plc.workstructure order by [\"PS\",\"_PM_DA_S_LINE_ID\"])
    			{
    				if (activity._PM_DA_S_LINE_ID==act._PM_DA_S_LINE_ID && activity.PS==act.PS)
    					result=true;
    				break;
    			}			
    		}
    	}
    	// We are out of study --> Manage clinical activities only [PC-5084]
    	else
    	{
    	    
    	    if (activity.SAN_RDPM_UA_B_CLINICAL_ACT)
    	    {
    	        var root_activity = plc.workstructure.get(activity.SAN_RDPM_UA_PRJ_S_ROOT_ACTIVITY);
    	        var list = [];
        		list.push(root_activity);
        		list.push(wbs_type);
        		var filter = plw.objectset(list);
        		with(filter.fromobject()){
        			for (var act in plc.workstructure where act.SAN_UA_RDPM_ACT_S_STUDY_ID==\"\" order by [\"PS\",\"_PM_DA_S_LINE_ID\"])
        			{
        				if (activity._PM_DA_S_LINE_ID==act._PM_DA_S_LINE_ID && activity.PS==act.PS)
        					result=true;
        				break;
    			    }			
    		    }
    	    }
    	}
    }
	return result;
}



function san_rdpm_is_last_reader()
{
    var result = false;
    var activity= this;
    
    if (activity instanceof plc.workstructure)
    {
    	var study_id = activity.SAN_UA_RDPM_ACT_S_STUDY_ID;
    	var study = plc.workstructure.get(study_id);
    	var wbs_type = activity.wbs_type;
    	
    	// We are inside a study
    	if (study instanceof plc.workstructure && wbs_type instanceof plc.wbs_type)
    	{
    		var list = [];
    		list.push(study);
    		list.push(wbs_type);
    		var filter = plw.objectset(list);
    		with(filter.fromobject()){
    			for (var act in plc.workstructure order by [[\"INVERSE\",\"PS\"],[\"INVERSE\",\"_PM_DA_S_LINE_ID\"]])
    			{
    				if (activity._PM_DA_S_LINE_ID==act._PM_DA_S_LINE_ID && activity.PS==act.PS)
    					result=true;
    				break;
    			}			
    		}
    	}
    	// We are out of study --> Manage clinical activities only [PC-5084]
    	else
    	{
    	    if (activity.SAN_RDPM_UA_B_CLINICAL_ACT)
    	    {
    	        var root_activity = plc.workstructure.get(activity.SAN_RDPM_UA_PRJ_S_ROOT_ACTIVITY);
    	        var list = [];
        		list.push(root_activity);
        		list.push(wbs_type);
        		var filter = plw.objectset(list);
        		with(filter.fromobject()){
        			for (var act in plc.workstructure where act.SAN_UA_RDPM_ACT_S_STUDY_ID==\"\" order by [[\"INVERSE\",\"PS\"],[\"INVERSE\",\"_PM_DA_S_LINE_ID\"]])
        			{
        				if (activity._PM_DA_S_LINE_ID==act._PM_DA_S_LINE_ID && activity.PS==act.PS)
        					result=true;
        				break;
    			    }			
    		    }
    	    }
    	}
    }
	return result;
}

var slot = new objectAttribute(plc.workstructure,\"SAN_RDPM_DA_B_IS_FIRST\",\"BOOLEAN\");
slot.Comment = \"Is First? (Dynamic attribute)\";
slot.Reader = san_rdpm_is_first_reader;
slot.Locker = true;
slot.hiddenInIntranetServer = true;
slot.connecting = false;

var slot = new objectAttribute(plc.workstructure,\"SAN_RDPM_DA_B_IS_LAST\",\"BOOLEAN\");
slot.Comment = \"Is Last? (Dynamic attribute)\";
slot.Reader = san_rdpm_is_last_reader;
slot.Locker = true;
slot.hiddenInIntranetServer = true;
slot.connecting = false;


// Modification - WBR - 07/10/2021 : PC-1245 - Add new dynamic attribute calculating the \"Main Vaccin Region\"

// *********************  Study Main Vaccine Region  *********************
// function used in CSM and LCSM metrics
// Main vaccin region is the one with the most countries.If several regions have the same # of counties, then the main region is the one with the most sites
function san_main_vacc_region_slot_reader() {
    var n_max_nbe_countries = 0;
    var n_max_nbe_sites     = 0;
    var s_main_region       = \"\";
    
    try {
        if(this.SAN_UA_RDPM_ACT_S_STUDY_ID != \"\") {
            var s_study_id = this.SAN_UA_RDPM_ACT_S_STUDY_ID;
            var o_study_act = plc.workstructure.get(s_study_id);
            
            if(o_study_act instanceof plc.workstructure) {
                for(var s_vacc_region in o_study_act.SAN_RDPM_UA_S_LIST_REGIONS_VACC.parsevector()){
                    var n_nbe_countries = 0;
                    var n_nbe_sites     = 0;
                    for(var s_wbst_id in context.SAN_RDPM_CS_AT_STUDY.parsevector()){
                        var o_wbs_type = plc.wbs_type.get(s_wbst_id);
                        if(o_wbs_type instanceof plw.wbs_type) {
                            for(var o_act_country in o_wbs_type.get(\"r.WBS_TYPE.WORK-STRUCTURE\") where 
                                    o_act_country.SAN_UA_RDPM_PV_REG_VACC instanceof plc.__USER_TABLE_SAN_RDPM_UT_VACC_REG &&
                                    o_act_country.SAN_UA_RDPM_PV_REG_VACC.internal == false &&
                                    o_act_country.SAN_UA_RDPM_PV_REG_VACC.name == s_vacc_region &&
                                    o_act_country.SAN_UA_RDPM_ACT_S_STUDY_ID == o_study_act.printattribute()) {
                                n_nbe_countries++;
                                n_nbe_sites +=  o_act_country.callNumberFormula(\"SAN_RDPM_CF_SITES_~a\".format(s_vacc_region));
                            }
                        }
                    }
                    
                    if((n_nbe_countries > n_max_nbe_countries) || (n_nbe_countries == n_max_nbe_countries && n_nbe_sites > n_max_nbe_sites)) {
                        s_main_region = s_vacc_region;
                        n_max_nbe_countries = n_nbe_countries;
                        n_max_nbe_sites   = n_nbe_sites;
                    }
                }
            }
        }
    }
    catch(error e) {
        plw.writetolog(\"Unexpected error in dynamic reader: \" + e);
    }
    
    return s_main_region;
}


function san_pjs_create_dynamic_attribute_study_main_vaccine_region(){
    try{
        var slot = new objectAttribute(plc.workstructure,\"SAN_RDPM_DA_ACT_STUDY_MAIN_VACC_REG\",\"String\");
        slot.Comment = \"Study Main Vaccine Region\";
        slot.Reader = san_main_vacc_region_slot_reader;
        slot.Modifier = undefined;
        slot.hiddenInIntranetServer = true;
slot.connecting = false;
        slot.project_types = \"Continuum.RDPM.Pasteur\";
    }
    catch(error e){
        plw.writetolog(\"Could not create slot due to error: \" + e);
    }
}

try{
    with(plw.no_locking){
        san_pjs_create_dynamic_attribute_study_main_vaccine_region();
    }
}
catch (error e){
    plw.writetolog(\"Failed to create SAN_RDPM_DA_ACT_STUDY_MAIN_VACC_REG\");
    plw.writetolog(e);
}

// end of SAN_RDPM_DA_ACT_STUDY_MAIN_VACC_REG definition"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 10
 :_US_AA_B_BATCH_SCRIPT "0"
 :_US_AA_D_CREATION_DATE 20210927000000
 :_US_AA_S_OWNER "intranet"
)