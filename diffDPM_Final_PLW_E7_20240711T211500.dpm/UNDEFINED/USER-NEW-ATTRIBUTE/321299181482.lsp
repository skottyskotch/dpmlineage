
(NEW-ATTRIBUTE::USER-NEW-ATTRIBUTE
 :OBJECT-NUMBER 321299181482
 :NAME :SAN_RDPM_UA_ACT_PROD_PLAN
 :COMMENT "Customized CSC production plan?"
 :DATASET 118081000141
 :DOCUMENTATION "Customized production plan = Number of kit of the earliest \"Packaging\" or \"Re-supply\" activity type > 1. Else, the production plan is not customized."
 :FORMULA "SAN_UA_RDPM_B_IS_A_STUDY AND ITER_NUMBER_MIN(\"ALL_CHILDREN\",\"BELONGS(\\\"WBS_TYPE\\\",\\\"Packaging,Re-supply\\\") AND PS = SAN_RDPM_UA_ACT_PS_MIN_CAMPAIGN\",\"SAN_RDPM_UA_ACT_KITS_QUANTITY\") > 1"
 :NCLASS KERNEL-ORDO:WORK-STRUCTURE
 :PTYPES (:|Continuum.RDPM.Pharma| :|Continuum.RDPM.Pasteur|)
 :SOURCE-DCR-SYNC-OBJECTS 0
 :TYPE OBJECT:YES-OR-NO
 :_USERATT_AA_B_HIDE_IN_CFG "0"
)