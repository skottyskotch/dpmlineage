
(NEW-ATTRIBUTE::USER-NEW-ATTRIBUTE
 :OBJECT-NUMBER 143484882172
 :NAME :SAN_RDPM_ACT_S_OBS_WORKSPACE
 :COMMENT "OBS linked to Activity & Ressource Allocations"
 :ADMIN-ONLY T
 :DATASET 118081000141
 :FORMULA "if ( _UtilIsVirtualDataset(\"\") and (project.san_rdpm_b_rnd_vaccines_project or project.san_rdpm_b_rnd_pharma_project) )then LIST_REMOVE_DUPLICATES(list_merge(obs_element,list_collect(\"ALLOCATED_RESOURCES\",\"true\",\"resource.obs_element\")))  else \"\" fi"
 :NCLASS KERNEL-ORDO:WORK-STRUCTURE
 :PTYPES (:|Continuum.RDPM|)
 :SOURCE-DCR-SYNC-OBJECTS 0
 :TYPE STRING
)