
(TEMP-TABLE::_IHM_TB_PT_TOOLS
 :OBJECT-NUMBER 262037004374
 :NAME "CS_BUTTON"
 :COMMENT "New Team"
 :DATASET 118081000141
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
 :_IHM_TB_AA_NP_SCRIPT "namespace _TBLink;� �var parent =\"\";�for( var object in plw.selection_vector()){��parent=object;�}��var b_service = (parent instanceof plc.resource && parent.SAN_RDPM_UA_RES_ENT_TYP instanceof plc.__USER_TABLE_SAN_RDPM_UT_ENTITY_TYPE && parent.SAN_RDPM_UA_RES_ENT_TYP.printattribute() ==\"Service\")? true :false;��if (b_service) {��var link = new Hyperlink(\"CreationForm\",��\"Class\",\"Resource\",��\"EditorType\",\"_RM_POPUP_MODIFY_RESOURCE\"��,\"DefaultA1\",\"SAN_RDPM_UA_B_IS_A_TEAM\"��,\"DefaultV1\",true��,\"DefaultA2\",\"ELEMENT-OF\"��,\"DefaultV2\",parent��,\"DefaultA3\",\"FILE\"��,\"DefaultV3\",\"SAN_CF_DEFAULT_RES_DATA\"��);��link.go();�} else {��plw.alert(\"Team can only be created under a Service\");�}��"
 :_IHM_TB_AA_S_FILTER "USER_IN_GROUP($CURRENT_USER,\"P_ADM\") or USER_IN_GROUP($CURRENT_USER,\"R_RBS\")"
 :_IHM_TB_AA_S_FOLDED_LABEL "New Team"
 :_IHM_TB_AA_S_TYPE "MENUS"
)