
(TEMP-TABLE::_IHM_TB_PT_TOOLS
 :OBJECT-NUMBER 317303379010
 :NAME "CS_FIELDS"
 :COMMENT "Study Status"
 :DATASET 118081000141
 :EXTERNAL-ID 0
 :ORIGIN-NUMBER 0
 :ORIGIN-PROJECT 0
 :PARENT 0
 :_IHM_AA_N_TOOL_VERSION 1.0d0
 :_IHM_AA_S_COMPLETE_SCRIPT "namespace _rdpmstudystatus; var vec = new vector(); for (var object in plc.__USER_TABLE_SAN_RDPM_UT_STUD_STAT where object.NAME!=\"Active\" order by [\"onb\"]) vec.push(object.printattribute()); vec.push(\"Completed\"); vec.push(\"Ongoing\"); vec.push(\"Planned\"); this.possiblevalues=vec;"
 :_IHM_TB_AA_B_CHK_VAL_LIST "1"
 :_IHM_TB_AA_B_LIST_INPUT "1"
 :_IHM_TB_AA_B_LOM "0"
 :_IHM_TB_AA_B_NEEDS_CHECK "0"
 :_IHM_TB_AA_B_ONLY_VISIBLE "1"
 :_IHM_TB_AA_B_SELECT_INPUT "1"
 :_IHM_TB_AA_NP_SCRIPT "namespace _studystatus;�this.editor.apply();"
 :_IHM_TB_AA_S_ATTR_NAME "USER_ATTRIBUTE_SAN_UA_REP_S_STUDY_STATUS_FILTER"
 :_IHM_TB_AA_S_CLASS_NAME "CONTEXT-OPX2"
 :_IHM_TB_AA_S_GROUPING "filter.plural"
 :_IHM_TB_AA_S_TYPE "FIELDS"
)