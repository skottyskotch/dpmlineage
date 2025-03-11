
(TEMP-TABLE::_IHM_TB_PT_TOOLS
 :OBJECT-NUMBER 321189349976
 :NAME "CS_FIELDS"
 :COMMENT "Baseline 2"
 :DATASET 118081000141
 :EXTERNAL-ID 0
 :ORIGIN-NUMBER 0
 :ORIGIN-PROJECT 0
 :PARENT 0
 :_IHM_AA_N_TOOL_VERSION 1.0d0
 :_IHM_AA_S_COMPLETE_SCRIPT "namespace _san_tb; var list_baseline = new vector();for (var o_ref in plc._L1_PT_REF_ADMIN where o_ref._L1_AA_S_REF_PRJTYP == \"Continuum.RDPM\" || o_ref._L1_AA_S_REF_PRJTYP == \"Continuum.RDPM.Pasteur\") {list_baseline.push(o_ref.name);} this.possiblevalues = list_baseline.removeduplicates();"
 :_IHM_TB_AA_B_CHK_VAL_LIST "0"
 :_IHM_TB_AA_B_LIST_INPUT "0"
 :_IHM_TB_AA_B_LOM "0"
 :_IHM_TB_AA_B_NEEDS_CHECK "0"
 :_IHM_TB_AA_B_ONLY_VISIBLE "0"
 :_IHM_TB_AA_B_SELECT_INPUT "1"
 :_IHM_TB_AA_NP_SCRIPT "namespace _san_tb; this.editor.apply();"
 :_IHM_TB_AA_S_ATTR_NAME "DATE2"
 :_IHM_TB_AA_S_CHOICE_CLASS "_L1_PT_REF_ADMIN"
 :_IHM_TB_AA_S_CLASS_NAME "CONTEXT-OPX2"
 :_IHM_TB_AA_S_GROUPING "filter.plural"
 :_IHM_TB_AA_S_TYPE "FIELDS"
)