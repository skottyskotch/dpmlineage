
(TEMP-TABLE::_IHM_TB_PT_TOOLS
 :OBJECT-NUMBER 310213066241
 :NAME "CS_BUTTON"
 :COMMENT "Reorganize elements"
 :DATASET 118057330253
 :EXTERNAL-ID 0
 :ORIGIN-NUMBER 0
 :ORIGIN-PROJECT 0
 :PARENT 0
 :_IHM_AA_N_TOOL_VERSION 1.0d0
 :_IHM_TB_AA_B_CHK_VAL_LIST "0"
 :_IHM_TB_AA_B_LIST_INPUT "0"
 :_IHM_TB_AA_B_LOM "0"
 :_IHM_TB_AA_B_NEEDS_CHECK "0"
 :_IHM_TB_AA_B_ONLY_VISIBLE "0"
 :_IHM_TB_AA_B_SELECT_INPUT "0"
 :_IHM_TB_AA_NP_SCRIPT "namespace _rdpm_roadmap;ÿvar position=0;ÿvar Roadmap = plw.currentPageobject();ÿwith (Roadmap.fromObject())ÿ{ÿþfor (var group in plc._ROA_PT_GROUP_HEIGHT where group._ROA_AA_S_GRPID!=\"\")ÿþ{ÿþþposition=0;ÿþþfor (var act in plc.workstructure where act.SAN_RDPM_UA_ACT_HLP_GROUPING instanceof plc.__USER_TABLE_SAN_RDPM_UT_HLP_GROUPING && act.SAN_RDPM_UA_ACT_HLP_GROUPING.printattribute()==group._ROA_AA_S_GRPID order by [\"_ROA_DA_N_RPS_VOFFSET\"])ÿþþ{ÿþþþact._ROA_DA_N_RPS_VOFFSET=position;ÿþþþposition++;ÿþþ}þþÿþþgroup._ROA_AA_N_HEIGHT=position;ÿþ}ÿ}"
 :_IHM_TB_AA_S_FILTER "USER_IN_GROUP($CURRENT_USER,\"O_GSF_RND\") "
 :_IHM_TB_AA_S_FOLDED_LABEL "Reorganize elements"
 :_IHM_TB_AA_S_TOOL_IMG_ID "horizontal_cylinder_16_template"
 :_IHM_TB_AA_S_TYPE "MENUS"
)