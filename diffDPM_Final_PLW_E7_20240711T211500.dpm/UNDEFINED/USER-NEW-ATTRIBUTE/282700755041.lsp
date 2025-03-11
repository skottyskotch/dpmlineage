
(NEW-ATTRIBUTE::USER-NEW-ATTRIBUTE
 :OBJECT-NUMBER 282700755041
 :NAME :SAN_RDPM_ACT_B_FILTER_OBS_WORKSPACE
 :COMMENT "Filter on activities to hide when enter in PM module with \"By OBS\""
 :ADMIN-ONLY T
 :DATASET 118081000141
 :FORMULA "if (_UtilIsVirtualDataset(\"\") and (project.san_rdpm_b_rnd_vaccines_project or project.san_rdpm_b_rnd_pharma_project) and oc.SAN_RDPM_CT_NTP_WORK_OBS<>\"\" )then ?task and list_intersect(oc.SAN_RDPM_CT_NTP_WORK_OBS,SAN_RDPM_ACT_S_OBS_WORKSPACE)=\"\" else false fi"
 :NCLASS KERNEL-ORDO:WORK-STRUCTURE
 :PTYPES (:|Continuum.RDPM.Pasteur|)
 :SOURCE-DCR-SYNC-OBJECTS 0
 :TYPE OBJECT:YES-OR-NO
)