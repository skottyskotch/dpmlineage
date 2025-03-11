
(TEMP-TABLE::_IHM_TB_PT_TOOLS
 :OBJECT-NUMBER 142734873241
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
 :_IHM_TB_AA_NP_SCRIPT "var Selection = new Symbol(\"SELECTION-ATOM\",\"TOOL-BAR\");ÿ            var parent = \"\";ÿ            for (var object in Selection)ÿ            {ÿ            þparent=object;ÿ            þbreak;ÿ            }ÿÿ            var form_type=\"Standard\";ÿ            var operationnality=\"\";ÿÿ            if (parent!=\"\")ÿ            {þÿ            þif (parent.SAN_UA_RDPM_RES_TYP_PHAR)ÿ            þ{ÿ            þþform_type=\"R&D Pharma\";ÿ            þ}ÿ            þelseÿ            þ{ÿ            þþif (parent.SAN_UA_RDPM_RES_TYP_PAST)ÿ            þþ{ÿ            þþþform_type=\"R&D Pasteur\";ÿ            þþþoperationnality=\"Direct\";ÿ            þþ}ÿ            þ}þÿ            þÿ            þvar link = new Hyperlink(\"CreationForm\",ÿ            þ\"Class\",\"RESOURCE\",ÿ            þ\"EditorType\",\"_RM_POPUP_MODIFY_RESOURCE\"ÿ            þ,\"DefaultA1\",\"ELEMENT-OF\"ÿ            þ,\"DefaultV1\",parentÿ            þ,\"DefaultA2\",\"SAN_UA_S_RES_FORM_TYPE\"ÿ            þ,\"DefaultV2\",form_typeÿ            þ,\"DefaultA3\",\"SAN_UA_RDPM_RES_OPER\"ÿ            þ,\"DefaultV3\",operationnalityÿ            þ,\"DefaultA4\",\"FILE\"ÿ            þ,\"DefaultV4\",\"SAN_CF_DEFAULT_RES_DATA\"ÿ            þ);ÿ            þlink.go();ÿ            }ÿ            elseÿ            {ÿ            þalert(\"Please select a parent to create a new resource!\");ÿ            }ÿÿ"
 :_IHM_TB_AA_S_FILTER "USER_IN_GROUP($CURRENT_USER,\"P_ADM\") or USER_IN_GROUP($CURRENT_USER,\"R_RBS\")"
 :_IHM_TB_AA_S_NEED_TYPE "MANDATORY"
 :_IHM_TB_AA_S_TYPE "MENUS"
)