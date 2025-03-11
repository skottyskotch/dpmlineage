
(NEW-ATTRIBUTE::USER-NEW-ATTRIBUTE
 :OBJECT-NUMBER 319731300482
 :NAME :SAN_RDPM_UA_S_LIST_CSU_SITES
 :COMMENT "List of CSU Sites"
 :DATASET 118081000141
 :DOCUMENTATION "Returns the list of countries or regions of the \"STUDY\" activity types of the study with an \"U\" at the end (STOP/STUDY excluded)
Ex: EURU, LAMU, JPU.
Is used in the Planned Hours QC \"Incorrect CSU values\" to display CSU (DB17) planned hours with a CSU site which is not present in the study --> to be deleted."
 :FORMULA "IF SAN_UA_RDPM_B_IS_A_STUDY THEN LIST_REMOVE_DUPLICATES(LIST_COLLECT(\"ALL_CHILDREN\",\"BELONGS(\\\"WBS_TYPE\\\",OC.SAN_RDPM_CS_AT_STUDY) and WBS_TYPE<>\\\"STOP/Study\\\"\",\"IF SAN_RDPM_UA_ACT_COUNT<>\\\"\\\" THEN SAN_RDPM_UA_ACT_COUNT+\\\"U\\\" ELSE SAN_UA_RDPM_S_CSU_REGION+\\\"U\\\"  FI\")) ELSE WBS_ELEMENT.SAN_RDPM_UA_S_LIST_CSU_SITES FI"
 :NCLASS KERNEL-ORDO:WORK-STRUCTURE
 :PTYPES (:|Continuum.RDPM.Pharma|)
 :SOURCE-DCR-SYNC-OBJECTS 0
 :TYPE STRING
)