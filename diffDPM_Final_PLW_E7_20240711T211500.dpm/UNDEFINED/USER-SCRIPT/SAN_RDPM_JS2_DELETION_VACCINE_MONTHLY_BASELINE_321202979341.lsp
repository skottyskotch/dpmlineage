
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 321202979341
 :NAME "SAN_RDPM_JS2_DELETION_VACCINE_MONTHLY_BASELINE"
 :COMMENT "Batch used by Admin functional to RDPM Delete the old Vaccine Monthly Baselines "
 :ACTIVE T
 :DATASET 118081000141
 :LOAD-ORDER 0
 :SCRIPT-CODE "/*
* Jira : PC-746
* Autor : Bekkal Amine
* Date : 22-03-2022
* Description : - Delete Vaccine Monthly baseline for the previous years N-2 and before keep only December ‘YYYY-12’ monthly baselines
                - Delete Vaccine Monthly baseline reference for the previous years N-2 and before keep only December ‘YYYY-12’ monthly baselines
*/

namespace _san_batch_del_vaccine_monthly_baseline;

var ligne_file=\"\";
var nb_bl_deleted=0;


// Delete for Vaccine Monthly baseline for the previous years N-2 and before keep only December ‘YYYY-12’ monthly baselines

plw.writeln(\"Start _san_delete_vaccine_monthly_baseline .... \");
try {
	
	for (var o_ref in plc.reference where o_ref.project.SAN_RDPM_B_RND_VACCINES_PROJECT && o_ref.callBooleanFormula(\" AD <> - 1 AND AD < PERIOD_START($DATE_OF_THE_DAY,\\\"YEAR\\\",-2) and NAME<>\\\"*_12\\\" AND TEMPLATE=\\\"SAN_RDPM_MONTHLY_BASELINE\\\"\"))
	{
		ligne_file=o_ref.onb+\";\"+ o_ref.name+\";\"+o_ref.desc+\";\"+o_ref.AD;		
						
		with(plw.no_locking){	
			o_ref.delete();
			nb_bl_deleted++;
			plw.writeln(\"Deletion of vaccine monthly baseline => \"+ligne_file);		
		}
	}
	plw.writeln(nb_bl_deleted + \" vaccine monthly baseline deleted.\");	
	plw.writeln(\"End _san_delete_vaccine_monthly_baseline .... \");
}
catch(error e) { 
	
	plw.writeln(\"Exception catched.... ==> ~s\"+e);
}


// Delete for Vaccine Monthly baseline reference for the previous years N-2 and before keep only December ‘YYYY-12’ monthly baselines
ligne_file=\"\";
nb_bl_deleted=0;
plw.writeln(\"Start _san_delete_vaccine_monthly_baseline_reference .... \");
try {
	
	for (var ref_vacc in plc._L1_PT_REF_ADMIN where ref_vacc.SAN_RDPM_UA_B_BASELINE_ADMIN_VACC_MONTHLY && ref_vacc.callBooleanFormula(\"SAN_RDPM_UA_D_CREATION_DATE <> -1 AND SAN_RDPM_UA_D_CREATION_DATE < PERIOD_START($DATE_OF_THE_DAY,\\\"YEAR\\\",-2) and NAME<>\\\"*_12\\\"\"))
	{
		ligne_file=ref_vacc.onb+\";\"+ ref_vacc.name+\";\"+ref_vacc.desc+\";\"+ref_vacc.SAN_RDPM_UA_D_CREATION_DATE+\";\" +ref_vacc._L1_AA_S_REF_TEMPLATE  	
					+ \";\"+ref_vacc.SAN_RDPM_UA_B_BASELINE_ADMIN_VACC_MONTHLY +\";\" +ref_vacc._L1_AA_B_REF_IS_LOADED+\";\"+ ref_vacc._L1_AA_S_REF_PRJTYP;
						
		with(plw.no_locking){	
			ref_vacc.delete();
			nb_bl_deleted++;
			plw.writeln(\"Deletion of vaccine monthly baseline reference => \"+ligne_file);
		}
	}
	plw.writeln(nb_bl_deleted + \" vaccine monthly baseline reference deleted.\");	
	plw.writeln(\"End _san_delete_vaccine_monthly_baseline_reference.... \");
}
catch(error e) { 
	
	plw.writeln(\"Exception catched.... ==> ~s\"+e);
		
}



"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 2
 :_US_AA_B_BATCH_SCRIPT "1"
 :_US_AA_D_CREATION_DATE 20220323000000
 :_US_AA_S_OWNER "E0455451"
)