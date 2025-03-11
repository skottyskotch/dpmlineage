
(TEMP-TABLE::_IHM_TB_PT_TOOLS
 :OBJECT-NUMBER 340178933941
 :NAME "CS_MENUS"
 :COMMENT "Vaccine Roadmap project"
 :DATASET 118081000141
 :EXTERNAL-ID 0
 :ORIGIN-NUMBER 0
 :ORIGIN-PROJECT 0
 :PARENT 1319694999
 :_IHM_AA_N_TOOL_VERSION 1.0d0
 :_IHM_TB_AA_B_CHK_VAL_LIST "0"
 :_IHM_TB_AA_B_HIDE_BOTH_F "0"
 :_IHM_TB_AA_B_LIST_INPUT "0"
 :_IHM_TB_AA_B_LOM "0"
 :_IHM_TB_AA_B_NEEDS_CHECK "0"
 :_IHM_TB_AA_B_ONLY_VISIBLE "0"
 :_IHM_TB_AA_B_SELECT_INPUT "0"
 :_IHM_TB_AA_NP_SCRIPT "namespace _Roadmapcreation;ÿvar sd = context._PM_NF_D_PROJECT_CREATION_OD;ÿvar ed = new date (sd.date + 365*24*60*60);ÿvar link = new Hyperlink(\"CreationForm\",ÿþ\"Class\",\"Project\",ÿþ\"EditorType\",\"_ROA_POP_ROADMAP_PROJECT_FOLDER\"ÿþ,\"DefaultA1\",\"OD\"ÿþ,\"DefaultV1\",context._PM_NF_D_PROJECT_CREATION_ODÿþ,\"DefaultA2\",\"ED\"ÿþ,\"DefaultV2\",edÿþ,\"DefaultA3\",\"_ROA_AA_B_ROADMAP_PROJECT\"ÿþ,\"DefaultV3\",trueÿþ,\"DefaultA4\",\"CREATE_WBS_ELT_BY_DEFAULT\"ÿþ,\"DefaultV4\",falseÿþ,\"DefaultA5\",\"COMMON_FILES\"ÿþ,\"DefaultV5\",context._ADM_SET_GLOBAL_COMMON_FILEÿþ,\"DefaultA6\",\"PROJECT_TYPE\"ÿþ,\"DefaultV6\",\"_GuiGetDefaultProjectType\".Call(this,\"ROA\")ÿþ,\"DefaultA7\",\"READ_WRITE_GROUPS\"ÿþ,\"DefaultV7\",\"OR_FUNCT_ADM_VACCINES,R_PM,R_ITS_ADMIN\"ÿþ,\"DefaultA8\",\"READ_ONLY_GROUPS\"ÿþ,\"DefaultV8\",\"O_GBU_VACCINES\"ÿ);ÿlink.go();"
 :_IHM_TB_AA_S_FILTER "USER_IN_GROUP($CURRENT_USER,\"OR_FUNCT_ADM_VACCINES,R_ITS_ADMIN,OR_PLANNER_VACCINES\")"
 :_IHM_TB_AA_S_TYPE "MENUS"
)