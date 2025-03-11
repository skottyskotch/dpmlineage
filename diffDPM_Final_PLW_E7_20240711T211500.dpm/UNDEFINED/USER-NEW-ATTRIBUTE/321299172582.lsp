
(NEW-ATTRIBUTE::USER-NEW-ATTRIBUTE
 :OBJECT-NUMBER 321299172582
 :NAME :SAN_RDPM_UA_ACT_PROD_PLAN_CAMPAIGN
 :COMMENT "Number of production plan CSC campaigns"
 :DATASET 118081000141
 :DEFAULT-VALUE 0.0d0
 :DOCUMENTATION "Number of production plan campaigns = Number of Activity Types \"Packaging\" and \"Re-supply\" inserted in the plan of the study."
 :FORMULA "IF SAN_UA_RDPM_B_IS_A_STUDY THEN ITER_NUMBER_SUM(\"ALL_CHILDREN\",\"BELONGS(\\\"WBS_TYPE\\\",\\\"Packaging,Re-supply\\\")\",\"1\") else WBS_ELEMENT.SAN_RDPM_UA_ACT_PROD_PLAN_CAMPAIGN FI"
 :NCLASS KERNEL-ORDO:WORK-STRUCTURE
 :PTYPES (:|Continuum.RDPM.Pharma| :|Continuum.RDPM.Pasteur|)
 :SOURCE-DCR-SYNC-OBJECTS 0
 :TYPE NUMBER
 :_USERATT_AA_B_HIDE_IN_CFG "0"
)