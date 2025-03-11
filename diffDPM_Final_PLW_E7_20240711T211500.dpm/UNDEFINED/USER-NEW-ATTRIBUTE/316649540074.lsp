
(NEW-ATTRIBUTE::USER-NEW-ATTRIBUTE
 :OBJECT-NUMBER 316649540074
 :NAME :SAN_RDPM_UA_ACT_GRP_TIMELINE_VACCINE
 :COMMENT "Label indication Timeline Vaccine"
 :ADMIN-ONLY T
 :DATASET 118081000141
 :FORMULA "if SAN_RDPM_UA_ACT_S_INDICATION_ID<>\"\" then string_value(\"Activity\",SAN_RDPM_UA_ACT_S_INDICATION_ID,\"ORDER_NUMBER\")  + \"_\"+ string_value(\"Activity\",SAN_RDPM_UA_ACT_S_INDICATION_ID,\"DESC\") + \"        | LPH : \" +_PO_DA_S_PROJECT_ROLE_ACT_262005442140  + \"                 \"+\"|  LPM : \"+_PO_DA_S_PROJECT_ROLE_ACT_310218237640 +\"                 | Commercial Opportunity / Velocity : \"+ string_value(\"Activity\",SAN_RDPM_UA_ACT_S_INDICATION_ID,\"SAN_RDPM_UA_ACT_S_ECO_VALUE\") + \" / \"+string_value(\"Activity\",SAN_RDPM_UA_ACT_S_INDICATION_ID,\"SAN_RDPM_UA_ACT_SEGMENT\") else \"\" fi"
 :NCLASS KERNEL-ORDO:WORK-STRUCTURE
 :PTYPES (:|Continuum.RDPM.Pharma|)
 :SOURCE-DCR-SYNC-OBJECTS 0
 :TYPE STRING
)