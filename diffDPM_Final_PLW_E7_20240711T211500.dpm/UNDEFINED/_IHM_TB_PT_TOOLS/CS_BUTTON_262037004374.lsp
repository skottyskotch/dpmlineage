
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
 :_IHM_TB_AA_NP_SCRIPT "namespace _TBLink;ÿ ÿvar parent =\"\";ÿfor( var object in plw.selection_vector()){ÿþparent=object;ÿ}ÿÿvar b_service = (parent instanceof plc.resource && parent.SAN_RDPM_UA_RES_ENT_TYP instanceof plc.__USER_TABLE_SAN_RDPM_UT_ENTITY_TYPE && parent.SAN_RDPM_UA_RES_ENT_TYP.printattribute() ==\"Service\")? true :false;ÿÿif (b_service) {ÿþvar link = new Hyperlink(\"CreationForm\",ÿþ\"Class\",\"Resource\",ÿþ\"EditorType\",\"_RM_POPUP_MODIFY_RESOURCE\"ÿþ,\"DefaultA1\",\"SAN_RDPM_UA_B_IS_A_TEAM\"ÿþ,\"DefaultV1\",trueÿþ,\"DefaultA2\",\"ELEMENT-OF\"ÿþ,\"DefaultV2\",parentÿþ,\"DefaultA3\",\"FILE\"ÿþ,\"DefaultV3\",\"SAN_CF_DEFAULT_RES_DATA\"ÿþ);ÿþlink.go();ÿ} else {ÿþplw.alert(\"Team can only be created under a Service\");ÿ}ÿÿ"
 :_IHM_TB_AA_S_FILTER "USER_IN_GROUP($CURRENT_USER,\"P_ADM\") or USER_IN_GROUP($CURRENT_USER,\"R_RBS\")"
 :_IHM_TB_AA_S_FOLDED_LABEL "New Team"
 :_IHM_TB_AA_S_TYPE "MENUS"
)