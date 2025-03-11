
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321181433541
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _RDPM_PM;

// AHI - 09/12/2021 - PC-410 - Add a control on o_prj (o_prj.FILE) to make the field study code in toolbar work in workpackages module
// LFA PC-4595 - Modification of filter on study code in PM Toolbar to avoid global map on study code table
// Used in Toolbar SAN_RDPM_TB_GANTT_ACT

function san_rdpm_list_study_code()
{
    var v_current_prj_codes = new vector();
    var v_study_codes = new vector();
	var o_prj = undefined;

    for(var oCurPageObject in plw.currentpageobject()){
		
    	if(oCurPageObject instanceof plc.work_structure){
			// Case of oCurPageObject being a work_structure (ex. in workpackage module)
			// we retrieve the project of the work_structure
			o_prj = oCurPageObject.FILE;
		}else{
			o_prj = oCurPageObject;
		}

		if(o_prj instanceof plc.ordo_project){
			if(o_prj.SAN_UA_RWE_PROJECT_CODE_PRIME!=''){
				v_current_prj_codes.push(o_prj.SAN_UA_RWE_PROJECT_CODE_PRIME);
			}
		}
    }
    v_current_prj_codes = v_current_prj_codes.removeduplicates();
    
    
    for (var prj_code in v_current_prj_codes)
    {
    	for(var o_study_code in prj_code.get(\"USER_ATTRIBUTE_INVERSE_SAN_UA_RWE_PROJ_CODE.__USER_TABLE_SAN_RWE_PRIME_CODES\"))
    	{	
    		v_study_codes.push(o_study_code);
    	}
    }
    this.possiblevalues=v_study_codes;
}

"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 316646123941
 :VERSION 3
 :_US_AA_D_CREATION_DATE 20220214000000
 :_US_AA_S_OWNER "E0296878"
)