
(TEMP-TABLE::_IHM_TB_PT_TOOLS
 :OBJECT-NUMBER 319706796741
 :NAME "version.plural"
 :COMMENT "version"
 :DATASET 118081000141
 :EXTERNAL-ID 0
 :ORIGIN-NUMBER 0
 :ORIGIN-PROJECT 0
 :PARENT 0
 :_IHM_AA_N_TOOL_VERSION 2.0d0
 :_IHM_TB_AA_B_CHK_VAL_LIST "0"
 :_IHM_TB_AA_B_LIST_INPUT "0"
 :_IHM_TB_AA_B_LOM "0"
 :_IHM_TB_AA_B_NEEDS_CHECK "0"
 :_IHM_TB_AA_B_ONLY_VISIBLE "0"
 :_IHM_TB_AA_B_SELECT_INPUT "0"
 :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
 :_IHM_TB_AA_S_REL_ELEM_ONB "950063899"
 :_IHM_TB_AA_S_TYPE "MENUS"
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 319706795941
  :NAME "new"
  :COMMENT "new"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 319706796741
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "context._PV_AA_S_VERS_CREATE = _IhmGetCurrentTabObject().printattribute();�pr(\"current object\",context._PV_AA_S_VERSION_CREATE);�var link = \"(:FVALUE :CONTEXT-OPX2 (32162099 . \\\"_PV_POP_OC_NEW_PROJECT_VERSION\\\") � NIL T NIL #.(:F\\\"\\\":STRING'^OPJ) T)\"; link = unescapeBackslash(link); link = link.stringReferenceToObject(); lispcall \"report-builder::ottp-go\" (context.applet,context,link,false);"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 319706796141
  :NAME "open.selectedVersions"
  :COMMENT "open.selectedVersions"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 319706796741
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "var listofOpeningReports = new vector(\"PM\", \"PM_CREA_2_ACT_GANTT_HOME\"    �                                                                ,\"ROA\", \"_BM_REPORT_STRATEGIC_ROADMAP\"    �                                                                ,\"PLM\", \"_BM_REPORT_STRATEGIC_ROADMAP\");    �    �pv_open_selected_versions(listofOpeningReports.getPlist(getcurrentmodule(\"\"), \"PM.PM_CREA_2_ACT_GANTT_HOME\"));    �    �listofOpeningReports.delete();"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 319706796341
  :NAME "CS_MENUS"
  :COMMENT "versionRestorationTools.Restore"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 319706796741
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "namespace jsonversionsMod; restoreVersionInProject();"
  :_IHM_TB_AA_S_FILTER "NOT jsonversionsMod_useOldVersions()  and USER_IN_GROUP($CURRENT_USER,\"R_ITS_ADMIN,OR_FUNCT_ADM_VACCINES,R_PORT_VACCINES\")"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 319706796541
  :NAME "CS_MENUS"
  :COMMENT "versionRestorationTools.Merge"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 319706796741
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "namespace jsonversionsMod; PreviewRestorationOfVersionInProject();"
  :_IHM_TB_AA_S_FILTER "NOT jsonversionsMod_useOldVersions()  and USER_IN_GROUP($CURRENT_USER,\"R_ITS_ADMIN,OR_FUNCT_ADM_VACCINES,R_PORT_VACCINES\")"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 321181434041
  :NAME "CS_MENUS"
  :COMMENT "Copy baselines"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 319706796741
  :_IHM_AA_N_TOOL_VERSION 1.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "namespace _RDPM_PM;�var Selection = new Symbol(\"SELECTION-ATOM\",\"TOOL-BAR\");�var version=\"\";�var count=0;�for (var object in Selection where object instanceof plc.project && object._PM_NF_B_IS_A_VERSION && object.SAN_RDPM_B_RND_VACCINES_PROJECT)�{��version = object;��count++;�}��if (count==0)�{��plw.alert(\"Please select a version.\");�}�else�{��if (count>1)��{���plw.alert(\"Please select only one version.\");��}��else��{���san_rdpm_vac_copy_baselines_to_version(version);��}�}"
  :_IHM_TB_AA_S_FILTER "GetCurrentModule(\"\")=\"RD_PM_VACCINES\""
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
)