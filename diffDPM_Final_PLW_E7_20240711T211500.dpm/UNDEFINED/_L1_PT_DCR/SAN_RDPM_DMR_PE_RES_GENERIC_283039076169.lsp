
(TEMP-TABLE::_L1_PT_DCR
 :OBJECT-NUMBER 283039076169
 :NAME "SAN_RDPM_DMR_PE_RES_GENERIC"
 :DATASET 118081000141
 :ORIGIN-NUMBER 0
 :ORIGIN-PROJECT 0
 :PTYPES "(:|Continuum.RDPM|)"
 :_L1_AA_B_ACTIVE "1"
 :_L1_AA_B_ATT_MANDATORY "0"
 :_L1_AA_B_CREATION_ONLY "0"
 :_L1_AA_B_NEVER_LOCK "0"
 :_L1_AA_S_ATTR "RESOURCE"
 :_L1_AA_S_CLASS "EXPENDITURE"
 :_L1_AA_S_CLASS_FILTER "NOT TYPE IN (\"*Site*\",\"*Subject*\",\"Autoinjector\",\"Capsule\",\"Cartridge\",\"g\",\"kg\",\"Kit\",\"Pen\",\"Tablet\",\"PFS\",\"Vector genome\",\"Vial\",\"Other\") and not ( type in (\"IPSO 1\",\"IPSO 2\") and onb<0 )  AND GET_INTERNAL_VALUE(\"TYPE\")<>\"SAN_ET_RDPM_NOMINATIVE\""
 :_L1_AA_S_MSG_LABEL "\"You can only set generic resources here.\""
 :_L1_AA_S_MSG_TYPE "ERROR"
 :_L1_AA_S_RULE "_INF_AA_B_GENERIC_RES"
)