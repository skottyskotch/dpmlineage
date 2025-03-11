
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260121941476
 :DATASET 118081000141
 :SCRIPT-CODE "/*
* Script V2
* Autor : Bekkal Amine
* JIRA : PC-387  (Monthly baseline Reference for Pharma project)
* Date Creation 26/10/2020
*/


Namespace _monthlyRefBaselineBatch;
	
var ref_name = context.SAN_RDPM_UA_OC_S_MONTHLY_BASELINE_NAME;
var ref_obj = plc._L1_PT_REF_ADMIN.get(ref_name);

	var mb_batch = plc._BA_PT_BATCH.get(260106100376);

if (mb_batch instanceof plc._BA_PT_BATCH)
	{
		if (ref_obj instanceof plc._L1_PT_REF_ADMIN)
		{
			plw.writeln(\"Reference already exist!\");
		}
		else
		{
			ref_obj = new plc._L1_PT_REF_ADMIN (NAME : ref_name,DESC : ref_name,_L1_AA_S_REF_TEMPLATE : \"SAN_RDPM_YEARLY_BASELINE\",_L1_AA_B_REF_IS_LOADED : true,_L1_AA_S_REF_PRJTYP : \"Continuum.RDPM\",FILE : \"SAN_CF_RDPM_BASELINE\");
		} 
		mb_batch._BA_AA_S_BATCH_PARAM_ADD=ref_name;
	}
	else
	{
		plw.writeln(\"Batch does not exist!\");
	}
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 0
 :VERSION 5
 :_US_AA_D_CREATION_DATE 20201102000000
 :_US_AA_S_OWNER "E0455451"
)