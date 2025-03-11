
(NEW-ATTRIBUTE::USER-NEW-ATTRIBUTE
 :OBJECT-NUMBER 317325856282
 :NAME :SAN_RDPM_UA_N_FXD_CRA_MDS
 :COMMENT "Weighted average fixed CRA mandays"
 :DATASET 118081000141
 :DEFAULT-VALUE 0.0d0
 :DOCUMENTATION "When a study is shifting from Region to Countries, each inserted country has a fixed CRA workload (without considering number Patients, Sites and duration)
This fixed workload comes for the CRA Local set-up algo
The fixed workload per country is different according to the countries
To calculate the fixed workload per region, weighted average of the workload according to the number of time a country appears in a clinical study
Ex for AP: It is normal that the fixed load of JP influences more the AP region fixed load than the EG one as JP appears more than EG in the clinical studies

Source Simulation in RDPM by inserting all the countries of the library pharma dev to see the calculated mandays (wo C, P and duration)"
 :FORMULA "if SAN_UA_RDPM_S_CSU_REGION_F = \"AP\" then 71 else if SAN_UA_RDPM_S_CSU_REGION_F = \"EUR\" then 36 else if SAN_UA_RDPM_S_CSU_REGION_F = \"LAM\" then 96 else if SAN_UA_RDPM_S_CSU_REGION_F = \"NAM\" then 48 fi fi fi fi"
 :NCLASS KERNEL-ORDO:WORK-STRUCTURE
 :PTYPES (:|Continuum.RDPM.Pharma|)
 :SOURCE-DCR-SYNC-OBJECTS 0
 :TYPE NUMBER
)