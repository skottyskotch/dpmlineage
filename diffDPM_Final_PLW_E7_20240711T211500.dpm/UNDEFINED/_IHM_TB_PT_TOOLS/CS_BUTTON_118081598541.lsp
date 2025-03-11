
(TEMP-TABLE::_IHM_TB_PT_TOOLS
 :OBJECT-NUMBER 118081598541
 :NAME "CS_BUTTON"
 :COMMENT "New"
 :DATASET 118081000141
 :EXTERNAL-ID 0
 :ORIGIN-NUMBER 0
 :ORIGIN-PROJECT 0
 :PARENT 0
 :_IHM_AA_N_TOOL_VERSION 0.0d0
 :_IHM_AA_S_COMPLETE_SCRIPT "context.SAN_RDPM_CT_NTP_WORK_OBS=\"\";"
 :_IHM_TB_AA_B_CHK_VAL_LIST "0"
 :_IHM_TB_AA_B_LIST_INPUT "0"
 :_IHM_TB_AA_B_LOM "0"
 :_IHM_TB_AA_B_NEEDS_CHECK "0"
 :_IHM_TB_AA_B_ONLY_VISIBLE "0"
 :_IHM_TB_AA_B_SELECT_INPUT "0"
 :_IHM_TB_AA_S_FILTER "GetCurrentModule(\"\")=\"RD_PM\" OR GetCurrentModule(\"\")=\"RD_PM_VACCINES\""
 :_IHM_TB_AA_S_FOLDED_LABEL "New"
 :_IHM_TB_AA_S_TYPE "MENUS"
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 142735533741
  :NAME "CS_MENUS"
  :COMMENT "R&D Pharma Project"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 118081598541
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "var link = new Hyperlink(\"CreationForm\",��\"Class\",\"Project\",��\"EditorType\",\"_PM_POPUP_PROJECT_FORM\"��,\"DefaultA1\",\"PROJECT-TYPE\"��,\"DefaultV1\",\"Continuum.RDPM.Pharma.Project\"��,\"DefaultA3\",\"ORIGIN-DATE\"��,\"DefaultV3\",context.callDATEFormula(\"$DATE_OF_THE_DAY\")��,\"DefaultA4\",\"COMMON_FILES\"��,\"DefaultV4\",\"SAN_CF_RDPM_COMMON_DATA,SAN_CF_RDPM_COMMON_DATA_PHARMA,SAN_CF_PHARMA_RES_DATA\"�);�link.go();"
  :_IHM_TB_AA_S_FILTER "(USER_IN_GROUP($CURRENT_USER,\"OR_FUNCT_ADM_PHARMA\") OR USER_IN_GROUP($CURRENT_USER,\"R_ITS_ADMIN\")) AND GetCurrentModule(\"\")=\"RD_PM\" "
  :_IHM_TB_AA_S_FOLDED_LABEL "R&D Pharma Project"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 142735534541
  :NAME "CS_MENUS"
  :COMMENT "R&D Pharma Project template"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 118081598541
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "var link = new Hyperlink(\"CreationForm\",��\"Class\",\"Project\",��\"EditorType\",\"_PM_POPUP_TEMPLATE_FORM\"��,\"DefaultA1\",\"PROJECT-TYPE\"��,\"DefaultV1\", \"Continuum.RDPM.Pharma.Project\"��,\"DefaultA2\",\"STATUS\"��,\"DefaultV2\",\"Project template\"��,\"DefaultA3\",\"RIGHTS\"��,\"DefaultV3\",\"Inaccessible to others\"��,\"DefaultA4\",\"READ_WRITE_GROUPS\"��,\"DefaultV4\",\"OR_FUNCT_ADM_PHARMA,R_ITS_ADMIN\"��,\"DefaultA5\",\"READ_ONLY_GROUPS\"��,\"DefaultV5\",\"O_GSF_RND\"��,\"DefaultA6\",\"COMMON_FILES\"��,\"DefaultV6\",\"SAN_CF_RDPM_COMMON_DATA,SAN_CF_RDPM_COMMON_DATA_PHARMA,SAN_CF_PHARMA_RES_DATA\"�);�link.go();"
  :_IHM_TB_AA_S_FILTER "(USER_IN_GROUP($CURRENT_USER,\"OR_FUNCT_ADM_PHARMA\") OR USER_IN_GROUP($CURRENT_USER,\"R_ITS_ADMIN\")) AND GetCurrentModule(\"\")=\"RD_PM\" "
  :_IHM_TB_AA_S_FOLDED_LABEL "R&D Pharma Project template"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143484586841
  :NAME "CS_MENUS"
  :COMMENT "R&D Vaccines Project"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 118081598541
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "var link = new Hyperlink(\"CreationForm\",��\"Class\",\"Project\",��\"EditorType\",\"_PM_POPUP_PROJECT_FORM\"��,\"DefaultA1\",\"PROJECT-TYPE\"��,\"DefaultV1\",\"Continuum.RDPM.Pasteur.Project\"��,\"DefaultA2\",\"NAME\"��,\"DefaultV2\",\"GENERATE_CODE\".call(\"SAN_RDPM_SG_PROJ_TEMP_NAME\") ��,\"DefaultA3\",\"ORIGIN-DATE\"��,\"DefaultV3\",context.callDATEFormula(\"$DATE_OF_THE_DAY\")��,\"DefaultA4\",\"COMMON_FILES\"��,\"DefaultV4\",\"SAN_CF_RDPM_COMMON_DATA,SAN_CF_PASTEUR_RES_DATA,SAN_CF_RDPM_COMMON_DATA_VACCINES\"��,\"DefaultA5\",\"STATE\"��,\"DefaultV5\",\"Active\"��,\"DefaultA6\",\"SAN_RDPM_UA_PROJECT_CATEGORY\"��,\"DefaultV6\",\"D\"�);�link.go();"
  :_IHM_TB_AA_S_FILTER "GetCurrentModule(\"\")=\"RD_PM_VACCINES\" AND USER_IN_GROUP($CURRENT_USER,\"OR_FUNCT_ADM_VACCINES,R_ITS_ADMIN,R_PORT_VACCINES\")"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143484587441
  :NAME "CS_MENUS"
  :COMMENT "R&D Vaccines Project Template"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 118081598541
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "var link = new Hyperlink(\"CreationForm\",��\"Class\",\"Project\",��\"EditorType\",\"_PM_POPUP_TEMPLATE_FORM\"��,\"DefaultA1\",\"PROJECT-TYPE\"��,\"DefaultV1\",\"Continuum.RDPM.Pasteur.Project\"��,\"DefaultA2\",\"STATUS\"��,\"DefaultV2\",\"Project template\"��,\"DefaultA3\",\"RIGHTS\"��,\"DefaultV3\",\"Inaccessible to others\"��,\"DefaultA4\",\"READ_WRITE_GROUPS\"��,\"DefaultV4\",\"OR_FUNCT_ADM_VACCINES,R_ITS_ADMIN\"��,\"DefaultA5\",\"READ_ONLY_GROUPS\"��,\"DefaultV5\",\"O_GBU_VACCINES\"��,\"DefaultA6\",\"COMMON_FILES\"��,\"DefaultV6\",\"SAN_CF_RDPM_COMMON_DATA,SAN_CF_PASTEUR_RES_DATA,SAN_CF_RDPM_COMMON_DATA_VACCINES\"�);�link.go();"
  :_IHM_TB_AA_S_FILTER "GetCurrentModule(\"\")=\"RD_PM_VACCINES\" AND (USER_IN_GROUP($CURRENT_USER,\"OR_FUNCT_ADM_VACCINES\") OR USER_IN_GROUP($CURRENT_USER,\"R_ITS_ADMIN\"))"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 260076291672
  :NAME "CS_MENUS"
  :COMMENT "R&D Pharma Indication"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 118081598541
  :_IHM_AA_N_TOOL_VERSION 1.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "namespace _san_rdpm_toolbar;�var v_selection = plw.selection_vector();�var v_parent;�var v_projectcode=\"PJTCODE\";�if(v_selection.length==1 && v_selection[0] instanceof plc.ordo_project && v_selection[0].get('PARENT').printattribute()=='' && v_selection[0].DATASET_CLASS == plc.project_type.get(\"Continuum.RDPM.Pharma.Project\") ){��v_parent=v_selection[0];��v_projectcode=v_parent.NAME;�}�else{��v_parent=\"\";�}�var link = new Hyperlink(\"CreationForm\",��\"Class\",\"Project\",��\"EditorType\",\"SAN_RDPM_RP_PRJ_PHAR_IND\"��,\"DefaultA1\",\"PROJECT-TYPE\"��,\"DefaultV1\",\"Continuum.RDPM.Pharma.Indication\"��,\"DefaultA2\",\"NAME\"��,\"DefaultV2\",v_projectcode+\"_INDXXX\"��,\"DefaultA3\",\"ORIGIN-DATE\"��,\"DefaultV3\",context.callDATEFormula(\"$DATE_OF_THE_DAY\")��,\"DefaultA4\",\"COMMON_FILES\"��,\"DefaultV4\",\"SAN_CF_RDPM_COMMON_DATA,SAN_CF_RDPM_COMMON_DATA_PHARMA,SAN_CF_PHARMA_RES_DATA\"��,\"DefaultA5\",\"PARENT\"��,\"DefaultV5\",v_parent��);�link.go();"
  :_IHM_TB_AA_S_FILTER "USER_IN_GROUP($CURRENT_USER,\"R_ITS_ADMIN,OR_FUNCT_ADM_PHARMA,R_PORT_PHARMA,OR_PLANNER_PHARMA\") AND GetCurrentModule(\"\")=\"RD_PM\" "
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 310244691076
  :NAME "CS_MENUS"
  :COMMENT "R&D Vaccine Indication"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 118081598541
  :_IHM_AA_N_TOOL_VERSION 1.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "namespace _san_rdpm_prj;�var v_selection = plw.selection_vector();�var v_parent;�if(v_selection.length==1 && v_selection[0] instanceof plc.ordo_project && v_selection[0].get('PARENT').printattribute()=='' && v_selection[0].DATASET_CLASS == plc.project_type.get(\"Continuum.RDPM.Pasteur.Project\")){��v_parent=v_selection[0];�}�else{��v_parent=\"\";�}�var link = new Hyperlink(\"CreationForm\",��\"Class\",\"Project\",��\"EditorType\",\"SAN_RDPM_RP_PRJ_PHAR_IND\"��,\"DefaultA1\",\"PROJECT-TYPE\"��,\"DefaultV1\",\"Continuum.RDPM.Pasteur.Indication\"��,\"DefaultA3\",\"ORIGIN-DATE\"��,\"DefaultV3\",context.callDATEFormula(\"$DATE_OF_THE_DAY\")��,\"DefaultA4\",\"COMMON_FILES\"��,\"DefaultV4\",\"SAN_CF_RDPM_COMMON_DATA,SAN_CF_PASTEUR_RES_DATA,SAN_CF_RDPM_COMMON_DATA_VACCINES\"��,\"DefaultA5\",\"PARENT\"��,\"DefaultV5\",v_parent��);�link.go();"
  :_IHM_TB_AA_S_FILTER "GetCurrentModule(\"\")=\"RD_PM_VACCINES\" AND USER_IN_GROUP($CURRENT_USER,\"OR_FUNCT_ADM_VACCINES,R_ITS_ADMIN,R_PORT_VACCINES\")"
  :_IHM_TB_AA_S_FOLDED_LABEL "R&D Vaccine Indication"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 317295970041
  :NAME "CS_MENUS"
  :COMMENT "R&D Vaccine simulation project"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 118081598541
  :_IHM_AA_N_TOOL_VERSION 1.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "namespace _rdpm;�var link = new Hyperlink(\"CreationForm\",��\"Class\",\"Project\",��\"EditorType\",\"_PM_POPUP_PROJECT_FORM\"��,\"DefaultA1\",\"PROJECT-TYPE\"��,\"DefaultV1\",\"Continuum.RDPM.Pasteur.Project\"��,\"DefaultA2\",\"NAME\"��,\"DefaultV2\",\"GENERATE_CODE\".call(\"SAN_RDPM_SG_PROJ_TEMP_NAME\") ��,\"DefaultA3\",\"ORIGIN-DATE\"��,\"DefaultV3\",context.callDATEFormula(\"$DATE_OF_THE_DAY\")��,\"DefaultA4\",\"COMMON_FILES\"��,\"DefaultV4\",\"SAN_CF_RDPM_COMMON_DATA,SAN_CF_PASTEUR_RES_DATA,SAN_CF_RDPM_COMMON_DATA_VACCINES\"��,\"DefaultA5\",\"STATE\"��,\"DefaultV5\",\"Simulation\"��,\"DefaultA6\",\"SAN_RDPM_UA_PROJECT_CATEGORY\"��,\"DefaultV6\",\"D\"��,\"DefaultA7\",\"RIGHTS\"��,\"DefaultV7\",\"Inaccessible to others\"��,\"DefaultA8\",\"READ_ONLY_GROUPS\"��,\"DefaultV8\",\"\"�);�link.go();"
  :_IHM_TB_AA_S_FILTER "GetCurrentModule(\"\")=\"RD_PM_VACCINES\" AND USER_IN_GROUP($CURRENT_USER,\"R_ITS_ADMIN,OR_FUNCT_ADM_VACCINES,R_PORT_VACCINES\")"
  :_IHM_TB_AA_S_FOLDED_LABEL "R&D Vaccine simulation project"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
)