
(TEMP-TABLE::_IHM_TB_PT_TOOLS
 :OBJECT-NUMBER 142735285241
 :NAME "1345276399_BUTTON"
 :COMMENT "New Resource"
 :DATASET 118081000141
 :EXTERNAL-ID 0
 :ORIGIN-NUMBER 0
 :ORIGIN-PROJECT 0
 :PARENT 0
 :_IHM_AA_N_TOOL_VERSION 0.0d0
 :_IHM_TB_AA_B_CHK_VAL_LIST "0"
 :_IHM_TB_AA_B_LIST_INPUT "0"
 :_IHM_TB_AA_B_LOM "0"
 :_IHM_TB_AA_B_NEEDS_CHECK "0"
 :_IHM_TB_AA_B_ONLY_VISIBLE "0"
 :_IHM_TB_AA_B_SELECT_INPUT "0"
 :_IHM_TB_AA_NP_SCRIPT "var Selection = new Symbol(\"SELECTION-ATOM\",\"TOOL-BAR\");ÿvar parent = \"\";ÿfor (var object in Selection)ÿ{ÿþparent=object;ÿþbreak;ÿ}ÿÿvar form_type=\"Standard\";ÿvar operationnality=\"\";ÿÿif (parent!=\"\")ÿ{þÿþif (parent.SAN_UA_RDPM_RES_TYP_PHAR)ÿþ{ÿþþform_type=\"R&D Pharma\";ÿþ}ÿþelseÿþ{ÿþþif (parent.SAN_UA_RDPM_RES_TYP_PAST)ÿþþ{ÿþþþform_type=\"R&D Pasteur\";ÿþþþoperationnality=\"Direct\";ÿþþÿþþ}ÿþ}þÿ}ÿÿvar link = new Hyperlink(\"CreationForm\",ÿ\"Class\",\"RESOURCE\",ÿ\"EditorType\",\"_RM_POPUP_MODIFY_RESOURCE\"ÿ,\"DefaultA1\",\"ELEMENT-OF\"ÿ,\"DefaultV1\",parentÿ,\"DefaultA2\",\"SAN_UA_S_RES_FORM_TYPE\"ÿ,\"DefaultV2\",form_typeÿ,\"DefaultA4\",\"SAN_UA_RDPM_RES_OPER\"ÿ,\"DefaultV4\",operationnalityÿ,\"DefaultA5\",\"FILE\"ÿ,\"DefaultV5\",\"SAN_CF_DEFAULT_RES_DATA\"ÿ);ÿlink.go();"
 :_IHM_TB_AA_S_FILTER "USER_IN_GROUP($CURRENT_USER,\"P_ADM\") "
 :_IHM_TB_AA_S_NEED_TYPE "MANDATORY"
 :_IHM_TB_AA_S_TYPE "MENUS"
)