
(NEW-ATTRIBUTE::USER-NEW-ATTRIBUTE
 :OBJECT-NUMBER 317325856582
 :NAME :SAN_RDPM_UA_NB_STD_COUNTRIES_PER_STUDY_TYPE
 :COMMENT "Standard number countries per study type"
 :DATASET 118081000141
 :DEFAULT-VALUE 0.0d0
 :DOCUMENTATION "Before a study is shifting from Region to Countries, we need to know how many countries will be in the study
Source Fulll Study extract 20-DEC-21
R&D studies FPI [2015-2027]
"
 :FORMULA "if SAN_UA_S_ACT_STUDY_TYPE = \"DFI\" then 16 else if SAN_UA_S_ACT_STUDY_TYPE = \"EFC\" then 15 else if SAN_UA_S_ACT_STUDY_TYPE = \"LTE\" then 13 else if SAN_UA_S_ACT_STUDY_TYPE = \"DRI\" then 12 else if SAN_UA_S_ACT_STUDY_TYPE = \"LTS\" then 11 else if SAN_UA_S_ACT_STUDY_TYPE = \"BEQ\" then 10 else if SAN_UA_S_ACT_STUDY_TYPE = \"ACT\" then 9 else if SAN_UA_S_ACT_STUDY_TYPE = \"TCD\" then 6 else if SAN_UA_S_ACT_STUDY_TYPE = \"PDY\" then 5 else if SAN_UA_S_ACT_STUDY_TYPE IN (\"SAD\",\"TED\") then 4 else if SAN_UA_S_ACT_STUDY_TYPE = \"OBS\" then 3 else if SAN_UA_S_ACT_STUDY_TYPE = \"IIT\" then 2 else 1 fi fi fi fi fi fi fi fi fi fi fi fi"
 :NCLASS KERNEL-ORDO:WORK-STRUCTURE
 :PTYPES (:|Continuum.RDPM.Pharma|)
 :SOURCE-DCR-SYNC-OBJECTS 0
 :TYPE NUMBER
)