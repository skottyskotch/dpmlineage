
(NEW-ATTRIBUTE::USER-NEW-ATTRIBUTE
 :OBJECT-NUMBER 317325857782
 :NAME :SAN_RDPM_UA_DISTRIB_COUNTRIES_PER_REGION
 :COMMENT "Distribution of countries per region"
 :DATASET 118081000141
 :DEFAULT-VALUE 0.0d0
 :DOCUMENTATION "To know in what regions the countries will most likely be allocated 
Source Fulll Study extract 20-DEC-21
R&D studies FPI [2015-2027]"
 :FORMULA "if SAN_UA_RDPM_S_CSU_REGION_F = \"AP\" then 0.25 else if SAN_UA_RDPM_S_CSU_REGION_F = \"EUR\" then 0.54 else if SAN_UA_RDPM_S_CSU_REGION_F = \"NAM\" then 0.13 else if SAN_UA_RDPM_S_CSU_REGION_F = \"LAM\" then 0.08 fi fi fi fi"
 :NCLASS KERNEL-ORDO:WORK-STRUCTURE
 :PTYPES (:|Continuum.RDPM.Pharma|)
 :SOURCE-DCR-SYNC-OBJECTS 0
 :TYPE NUMBER
)