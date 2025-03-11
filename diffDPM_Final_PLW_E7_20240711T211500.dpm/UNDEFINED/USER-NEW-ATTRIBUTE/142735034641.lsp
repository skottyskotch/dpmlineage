
(NEW-ATTRIBUTE::USER-NEW-ATTRIBUTE
 :OBJECT-NUMBER 142735034641
 :NAME :SAN_UA_RDPM_RES_TC_MANAG
 :COMMENT "TC Managers"
 :DATASET 118081000141
 :FORMULA "if managers<>\"\" then string_value(\"user\",managers,\"Desc\") + \",\" else \"\" fi + string_value(\"user\",res_manager,\"Desc\") "
 :NCLASS KERNEL-ORDO:RESOURCE
 :PTYPES (:|Continuum.RDPM|)
 :SOURCE-DCR-SYNC-OBJECTS 0
 :TYPE STRING
)