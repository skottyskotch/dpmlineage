
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
 :_IHM_TB_AA_NP_SCRIPT "var Selection = new Symbol(\"SELECTION-ATOM\",\"TOOL-BAR\");�var parent = \"\";�for (var object in Selection)�{��parent=object;��break;�}��var form_type=\"Standard\";�var operationnality=\"\";��if (parent!=\"\")�{���if (parent.SAN_UA_RDPM_RES_TYP_PHAR)��{���form_type=\"R&D Pharma\";��}��else��{���if (parent.SAN_UA_RDPM_RES_TYP_PAST)���{����form_type=\"R&D Pasteur\";����operationnality=\"Direct\";������}��}��}��var link = new Hyperlink(\"CreationForm\",�\"Class\",\"RESOURCE\",�\"EditorType\",\"_RM_POPUP_MODIFY_RESOURCE\"�,\"DefaultA1\",\"ELEMENT-OF\"�,\"DefaultV1\",parent�,\"DefaultA2\",\"SAN_UA_S_RES_FORM_TYPE\"�,\"DefaultV2\",form_type�,\"DefaultA4\",\"SAN_UA_RDPM_RES_OPER\"�,\"DefaultV4\",operationnality�,\"DefaultA5\",\"FILE\"�,\"DefaultV5\",\"SAN_CF_DEFAULT_RES_DATA\"�);�link.go();"
 :_IHM_TB_AA_S_FILTER "USER_IN_GROUP($CURRENT_USER,\"P_ADM\") "
 :_IHM_TB_AA_S_NEED_TYPE "MANDATORY"
 :_IHM_TB_AA_S_TYPE "MENUS"
)