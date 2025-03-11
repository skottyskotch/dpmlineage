
(NEW-ATTRIBUTE::USER-NEW-ATTRIBUTE
 :OBJECT-NUMBER 296660323882
 :NAME :SAN_RDPM_UA_S_QC_RECRUITMENT
 :COMMENT "QCs on Recruitment status"
 :DATASET 118081000141
 :FORMULA "IF SAN_UA_RDPM_RES_TYP_PHAR AND OBS_ELEMENT.SAN_RDPM_UA_B_OBS_CSO AND NOT SAN_UA_RDPM_RES_CTR_TYP IN(\"CONTS\",\"INTERIM\") AND NOT(_INF_AA_B_GENERIC_RES) AND NOT SAN_RDPM_UT_RES_REC_STAT IN(\"7-Cancelled\",\"9-Exception\") THEN  	LIST_REMOVE(\"\", 	 	IF (SAN_UA_RDPM_RES_OPEN and EFFECTIVE_START_DATE>$DATE_OF_THE_DAY and NOT(SAN_RDPM_UT_RES_REC_STAT IN(\"1-Process Started\",\"2-Contacts / Short-list\",\"6-On hold\")) AND NAME=\"*OPEN*\") THEN \"Recruitment status should be 1, 2 or 6\" FI + \",\"  	+  IF (SAN_UA_RDPM_RES_OPEN and EFFECTIVE_START_DATE>$DATE_OF_THE_DAY and NOT(SAN_RDPM_UT_RES_REC_STAT IN(\"3-Candidate identified\",\"4a-Offer in progress\",\"4b-Offer accepted\")) AND NAME<>\"*OPEN*\") THEN \"Recruitment status should be 3, 4a or 4b\" FI + \",\"  	+  IF (NOT(SAN_UA_RDPM_RES_OPEN) and (EFFECTIVE_START_DATE<$DATE_OF_THE_DAY) AND (EFFECTIVE_END_DATE=\"\" or EFFECTIVE_END_DATE>$DATE_OF_THE_DAY) and NOT(SAN_RDPM_UT_RES_REC_STAT IN(\"5-Registered (position filled)\",\"6-On hold\"))) THEN \"Recruitment status should be 5 or 6\" FI + \",\"  	+  IF (NOT(SAN_UA_RDPM_RES_OPEN) and (EFFECTIVE_END_DATE<>\"\" AND EFFECTIVE_END_DATE<$DATE_OF_THE_DAY) and NOT(SAN_RDPM_UT_RES_REC_STAT IN(\"6-On hold\",\"8-People left\"))) THEN \"Recruitment status should be 6 or 8\" FI ) FI"
 :NCLASS KERNEL-ORDO:RESOURCE
 :PTYPES (:|Continuum.RDPM.Pharma|)
 :SOURCE-DCR-SYNC-OBJECTS 0
 :TYPE STRING
)