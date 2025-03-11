
(TEMP-TABLE::_IHM_TB_PT_TOOLS
 :OBJECT-NUMBER 5241107999
 :NAME "_TC_AA_S_TC_PARAM"
 :COMMENT "timeCard.Parameters"
 :DATASET 96270999
 :EXTERNAL-ID 0
 :ORIGIN-NUMBER 0
 :ORIGIN-PROJECT 0
 :PARENT 0
 :_IHM_AA_N_TOOL_VERSION 0.0d0
 :_IHM_AA_S_COMPLETE_SCRIPT "var user = context.applet.user; var current_user = new vector();  current_user.push(user); var list_resources_managed =_tc_build_resource_list_from_user(current_user); var listprofile = new vector();for (var res in list_resources_managed) {listprofile.push(res._TC_NF_S_CURR_PROF);} this.possiblevalues = listprofile.removeduplicates();"
 :_IHM_TB_AA_B_CHK_VAL_LIST "1"
 :_IHM_TB_AA_B_LIST_INPUT "0"
 :_IHM_TB_AA_B_NEEDS_CHECK "0"
 :_IHM_TB_AA_B_ONLY_VISIBLE "0"
 :_IHM_TB_AA_B_SELECT_INPUT "1"
 :_IHM_TB_AA_NP_SCRIPT "this.editor.apply();"
 :_IHM_TB_AA_S_ATTR_NAME "_TC_AA_S_TC_PARAM"
 :_IHM_TB_AA_S_CLASS_NAME "CONTEXT-OPX2"
 :_IHM_TB_AA_S_FILTER2 "IF _tc_multi_profile_count(\"\") <= 1 AND OC._IHM_DA_B_IS_FOLDED then FALSE ELSE TRUE FI"
 :_IHM_TB_AA_S_REL_ELEM_ONB "1087601499,1087601399"
 :_IHM_TB_AA_S_TYPE "FIELDS"
)