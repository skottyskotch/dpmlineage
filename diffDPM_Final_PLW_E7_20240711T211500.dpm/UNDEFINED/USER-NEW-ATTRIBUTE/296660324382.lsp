
(NEW-ATTRIBUTE::USER-NEW-ATTRIBUTE
 :OBJECT-NUMBER 296660324382
 :NAME :SAN_RDPM_UA_S_QC_TYPE_MOVEMENT
 :COMMENT "QCs on Type of movement"
 :DATASET 118081000141
 :FORMULA "IF SAN_UA_RDPM_RES_TYP_PHAR AND OBS_ELEMENT.SAN_RDPM_UA_B_OBS_CSO AND NOT SAN_UA_RDPM_RES_CTR_TYP IN(\"CONTS\",\"INTERIM\") AND NOT(_INF_AA_B_GENERIC_RES) AND NOT SAN_RDPM_UT_RES_REC_STAT IN(\"7-Cancelled\",\"9-Exception\") THEN  	 	LIST_REMOVE(\"\",  	IF (SAN_RDPM_UA_S_TYP_MOV_IN=\"\") THEN \"Type of MOVE IN shouldn't be empty\" FI + \",\"  	+   	IF (SAN_RDPM_UA_S_TYP_MOV_OUT=\"\" and EFFECTIVE_END_DATE<>\"\") THEN \"Type of MOVE OUT should be filled if there is an end date\" FI + \",\"  	+   	IF (SAN_RDPM_UA_S_TYP_MOV_OUT<>\"\" and EFFECTIVE_END_DATE=\"\") THEN \"Type of MOVE OUT filled, end date mandatory\" FI + \",\"  	+   	IF (NOT SAN_RDPM_UA_RES_MOVE_REASON IN(\"Mission\",\"Assignment\") AND SAN_RDPM_RES_B_EXCL_HEAD AND NOT SAN_UA_RDPM_RES_CTR_TYP IN(\"INTERIM\",\"CONTS\",\"APPRENT\")) THEN \"Move reason should be Mission or Assignment if Exclude from HC ticked\" FI + \",\" 	+   	IF (SAN_RDPM_UA_RES_MOVE_REASON IN(\"Mission\",\"Assignment\") AND NOT SAN_RDPM_RES_B_EXCL_HEAD) THEN \"If Move reason OUT is Mission or Assignent, Excluded from HC? should be ticked\" FI  	) FI"
 :NCLASS KERNEL-ORDO:RESOURCE
 :PTYPES (:|Continuum.RDPM.Pharma|)
 :SOURCE-DCR-SYNC-OBJECTS 0
 :TYPE STRING
)