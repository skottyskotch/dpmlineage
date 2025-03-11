
(NEW-ATTRIBUTE::USER-NEW-ATTRIBUTE
 :OBJECT-NUMBER 143491583472
 :NAME :SAN_RDPM_UA_PRJ_PRJ_STATUS
 :COMMENT "Project status detailed"
 :DATASET 118081000141
 :FORMULA "IF PARENT_PROJECT=\"\" THEN IF _sta_ra_prj_status._inf_da_s_list_label=\"completed\" THEN   (IF NOT ITER_BOOLEAN_THERE_IS_ONE(\"ACTIVITY\",\"AF=-1\")  THEN \"Completed inactive\" ELSE \"Completed active\" FI )  ELSE IF _sta_ra_prj_status._inf_da_s_list_label=\"Stopped\" THEN (IF NOT ITER_BOOLEAN_THERE_IS_ONE(\"ACTIVITY\",\"AF=-1\")   THEN \"Stopped inactive\" ELSE \"Stopped active\" FI )  ELSE _sta_ra_prj_status._inf_da_s_list_label FI FI ELSE PARENT_PROJECT.SAN_RDPM_UA_PRJ_PRJ_STATUS FI"
 :NCLASS ORDO-PROJECT:ORDO-PROJECT
 :PTYPES (:|Continuum.RDPM.Pharma| :|Continuum.RDPM.Pasteur|)
 :SOURCE-DCR-SYNC-OBJECTS 0
 :TYPE STRING
)