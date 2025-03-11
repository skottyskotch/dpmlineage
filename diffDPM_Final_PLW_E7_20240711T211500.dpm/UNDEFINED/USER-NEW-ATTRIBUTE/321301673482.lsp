
(NEW-ATTRIBUTE::USER-NEW-ATTRIBUTE
 :OBJECT-NUMBER 321301673482
 :NAME :SAN_RDPM_UA_ACT_PACK_ORTEMS
 :COMMENT "PACK load from ORTEMS?"
 :DATASET 118081000141
 :DOCUMENTATION "For Packaging and Re-supply activity types, returns TRUE if there is at least 1 planned hour with the Resource = \"CSC\", Primary skill = \"PACK\" and Planned hour type = \"MANUAL\" --> This means the workplan of the task has been customized with data from ORTEMS tool."
 :FORMULA "WBS_TYPE in (\"Packaging\",\"Re-supply\") AND ITER_BOOLEAN_THERE_IS_ONE(\"ALLOCATIONS\",\"RES=\\\"CSC\\\" AND PRIMARY_SKILL IN(\\\"PACK\\\") AND TYPE = \\\"MANUAL\\\"\")"
 :NCLASS KERNEL-ORDO:WORK-STRUCTURE
 :PTYPES (:|Continuum.RDPM.Pharma| :|Continuum.RDPM.Pasteur|)
 :SOURCE-DCR-SYNC-OBJECTS 0
 :TYPE OBJECT:YES-OR-NO
 :_USERATT_AA_B_HIDE_IN_CFG "0"
)