
(TEMP-TABLE::_IHM_TB_PT_TOOLS
 :OBJECT-NUMBER 143485531472
 :NAME "CS_BUTTON"
 :COMMENT "New"
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
 :_IHM_TB_AA_NP_SCRIPT "var Selection = new Symbol(\"SELECTION-ATOM\",\"TOOL-BAR\"); var count=0; var wbs_type = \"\"; �for (var object in Selection) { �count++; �wbs_type=object; } �if (count==0) { ��var link = new Hyperlink(\"CreationForm\", �\"Class\",\"Activitytype\", �\"EditorType\",\"X_GEN_CREA_WBS_TYPE\" �,\"DefaultA1\",\"file\" �,�\"DefaultV1\",context.wbs_type_default_file) �link.go();��} ��else if (count>0) { ��var link = new Hyperlink(\"CreationForm\", �\"Class\",\"Activitytype\", �\"EditorType\",\"X_GEN_CREA_WBS_TYPE\" �,\"DefaultA1\",\"file\" �,�\"DefaultV1\",wbs_type.file,\"DefaultA2\",\"parent\",\"DefaultV2\",wbs_type.name) �link.go();��}��"
 :_IHM_TB_AA_S_FILTER "USER_IN_GROUP($CURRENT_USER,\"OR_FUNCT_ADM_PHARMA,OR_FUNCT_ADM_RWE,OR_FUNCT_ADM_VACCINES,OR_FUNCT_ADM_CONTINUUM,R_ITS_ADMIN\")"
 :_IHM_TB_AA_S_FOLDED_LABEL "New"
 :_IHM_TB_AA_S_TYPE "MENUS"
)