
(TEMP-TABLE::_IHM_TB_PT_TOOLS
 :OBJECT-NUMBER 317243098341
 :NAME "_TC_AA_S_TC_PARAM"
 :COMMENT "#@timeCard.Parameters"
 :DATASET 118081000141
 :EXTERNAL-ID 0
 :ORIGIN-NUMBER 0
 :ORIGIN-PROJECT 0
 :PARENT 0
 :_IHM_AA_N_TOOL_VERSION 1.0d0
 :_IHM_AA_S_COMPLETE_SCRIPT "namespace _san_tb; var user = context.applet.user; var current_user = new vector(); current_user.push(user); var list_resources_managed =plw._tc_build_resource_list_from_user(current_user); var listprofile = new vector(); for (var res in list_resources_managed) {listprofile.push(res._TC_NF_S_CURR_PROF);} this.possiblevalues = listprofile.removeduplicates();"
 :_IHM_TB_AA_B_CHK_VAL_LIST "1"
 :_IHM_TB_AA_B_LIST_INPUT "0"
 :_IHM_TB_AA_B_LOM "0"
 :_IHM_TB_AA_B_NEEDS_CHECK "0"
 :_IHM_TB_AA_B_ONLY_VISIBLE "0"
 :_IHM_TB_AA_B_SELECT_INPUT "1"
 :_IHM_TB_AA_NP_SCRIPT "namespace _san_tb;ÿthis.editor.apply();ÿif (context._TC_AA_S_TC_PARAM==\"PASTEUR\")ÿ{ÿcontext.GEN_CHART_DD=context.calldateformula(\"PERIOD_START($DATE_OF_THE_DAY,\\\"MONTH\\\",0)\");ÿcontext.GEN_CHART_ED=context.calldateformula(\"PERIOD_START($DATE_OF_THE_DAY,\\\"MONTH\\\",1)\");ÿ}"
 :_IHM_TB_AA_S_ATTR_NAME "_TC_AA_S_TC_PARAM"
 :_IHM_TB_AA_S_CLASS_NAME "CONTEXT-OPX2"
 :_IHM_TB_AA_S_FILTER2 "IF _tc_multi_profile_count(\"\") <= 1 AND OC._IHM_DA_B_IS_FOLDED then FALSE ELSE TRUE FI"
 :_IHM_TB_AA_S_REL_ELEM_ONB "1087601499,1087601399"
 :_IHM_TB_AA_S_TYPE "FIELDS"
)