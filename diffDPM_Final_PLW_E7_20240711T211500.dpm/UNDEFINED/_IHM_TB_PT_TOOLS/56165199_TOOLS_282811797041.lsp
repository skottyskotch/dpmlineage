
(TEMP-TABLE::_IHM_TB_PT_TOOLS
 :OBJECT-NUMBER 282811797041
 :NAME "56165199_TOOLS"
 :COMMENT "RDPM_GANTT_TOOLS"
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
 :_IHM_TB_AA_S_REL_ELEM_ONB "1311769399"
 :_IHM_TB_AA_S_TYPE "TOOLS"
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370267773
  :NAME "menu.synchronize_with_link"
  :COMMENT "menu.synchronize_with_link"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "_PmSynchroniseWithlink();"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TOOL_IMG_ID "SAN_RDPM_IM_PJT_SYNC_ACT_IMG"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811789841
  :NAME "tool_WT.WBS_library_insert"
  :COMMENT "tool_WT.WBS_library_insert"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "compute_selection();                          ÿif(get_library_selection()!=\"\"){                          ÿþvar link =  new hyperlink(\"fvalue\",                                                                                                                                        ÿþ\"attribute\",                                                                                                                                        ÿþ\"ID\",                                                                                                                                        ÿþ\"editortype\",                                                                                                                                        ÿþ\"WBS_LIBRARY_FORM\",                                                                                                                                        ÿþ\"POPUP\",                                                                                                                                        ÿþtrue);                                                                                                                                        ÿþcontext.WBS_LIBRARY_FILTER = \"\";                                                                                                                                        ÿþif(link instanceof hyperlink){                          ÿþþlink.go(context);                          ÿþ}                          ÿ}                          ÿelse{                          ÿþalert(write_text_key(\"tool_WT.WBS_library_insert.Selection_warning\"));                          ÿ}"
  :_IHM_TB_AA_S_FILTER "USER_IN_GROUP($CURRENT_USER,\"R_ITS_ADMIN,M_VACCINES,M_PHARMA\")"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TOOL_IMG_ID "SAN_RDPM_IM_PJT_LIBRARY_IMG"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811790041
  :NAME "COPY"
  :COMMENT "Copy"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "\"COPY\".Activatetool();"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811790241
  :NAME "PASTE"
  :COMMENT "Paste"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "\"PASTE\".Activatetool();"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811790441
  :NAME "EDIT"
  :COMMENT "Edit..."
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "\"EDIT\".Activatetool();"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811790841
  :NAME "INSERT-LINE"
  :COMMENT "Insert a line"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "\"INSERT-LINE\".Activatetool();"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811791041
  :NAME "SUPPRESS"
  :COMMENT "Delete"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "Utils_DeleteOnlyProjectObjects();"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811791241
  :NAME "INSERT-ANNOTATION"
  :COMMENT "Insert an annotation"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "\"INSERT-ANNOTATION\".Activatetool();"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811791441
  :NAME "FORMAT-CELLS"
  :COMMENT "Format cells"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "\"FORMAT-CELLS\".Activatetool();"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TOOL_IMG_ID "ic_grid_on_dark_grey_18"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811791641
  :NAME "FINISH-START"
  :COMMENT "Create a finish->start Link"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "\"FINISH-START\".Activatetool();"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811791841
  :NAME "projectManager.start_start_link"
  :COMMENT "projectManager.start_start_link"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "Calltoolonselection(\"START-START\");                                                                                                                                                                                                                                                                                                                                       ÿ"
  :_IHM_TB_AA_S_FILTER "USER_IN_GROUP($CURRENT_USER,\"R_ITS_ADMIN,M_VACCINES,M_PHARMA\")"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TOOL_IMG_ID "SAN_RDPM_IM_PJT_LINK_SS_IMG"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811792041
  :NAME "projectManager.end_end_link"
  :COMMENT "projectManager.end_end_link"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "CallToolOnSelection(\"FINISH-FINISH\");                                                                                                                                                                                                                                                                                                                                       ÿ"
  :_IHM_TB_AA_S_FILTER "USER_IN_GROUP($CURRENT_USER,\"R_ITS_ADMIN,M_VACCINES,M_PHARMA\")"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TOOL_IMG_ID "SAN_RDPM_IM_PJT_LINK_FF_IMG"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811792241
  :NAME "REMOVE-LINK"
  :COMMENT "Remove links"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "\"REMOVE-LINK\".Activatetool();"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811792441
  :NAME "CS_MENUS"
  :COMMENT "RDPM.SAN_RDPM_TK_CREATE_SYNCHRONIZE_WITH_LINK"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "var v_selection = selection_vector();ÿÿif (v_selection.length >1) {ÿþfor (var i=1 ; i<v_selection.length ; i=i+2){ÿþþvar o_act_1 = v_selection[i-1];ÿþþvar o_act_2 = v_selection[i];ÿþþif (o_act_1 instanceof OpxActivity && o_act_2 instanceof OpxActivity){ÿþþþif (o_act_1.SYNCHRONIZE_WITH==\"\" && o_act_2.SYNCHRONIZE_WITH==\"\"){ÿþþþþo_act_1.SYNCHRONIZE_WITH=o_act_2.printattribute();ÿþþþþfor (var o_syncRule in \"OpxSYNCHRONIZATION_RULE\".findclass() order by {{\"INVERSE\", \"PRIORITY\"}}){ÿþþþþþif (o_act_1.callbooleanformula(o_syncRule.FILTER)) {o_act_1.LAST_SYNC_RULE=o_syncRule.printattribute();break;}ÿþþþþ}ÿþþþþÿþþþþo_act_2.SYNCHRONIZE_WITH=o_act_1.printattribute();ÿþþþþfor (var o_syncRule in \"OpxSYNCHRONIZATION_RULE\".findclass() order by {{\"INVERSE\", \"PRIORITY\"}}){ÿþþþþþif (o_act_2.callbooleanformula(o_syncRule.FILTER)) {o_act_2.LAST_SYNC_RULE=o_syncRule.printattribute();break;}ÿþþþþ}ÿþþþ}ÿþþþelse {ÿþþþþif (o_act_1.SYNCHRONIZE_WITH!=\"\"){alert(\"There is already a synchronization link on \"+o_act_1.printattribute()+\", creation canceled!\");}ÿþþþþif (o_act_2.SYNCHRONIZE_WITH!=\"\"){alert(\"There is already a synchronization link on \"+o_act_2.printattribute()+\", creation canceled!\");}ÿþþþ}ÿþþ}ÿþ}ÿ}ÿelse {alert(\"Please select 2 activities at least!\");}"
  :_IHM_TB_AA_S_FILTER "USER_IN_GROUP($CURRENT_USER,\"R_ITS_ADMIN,M_VACCINES,M_PHARMA\")"
  :_IHM_TB_AA_S_TOOL_IMG_ID "SAN_RDPM_IM_PJT_SYNC_LINK_IMG"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811792641
  :NAME "CS_MENUS"
  :COMMENT "RDPM.SAN_RDPM_TK_REMOVE_SYNCHRONIZE_WITH_LINK"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "var v_selection = selection_vector();ÿÿif (v_selection.length >0) {ÿþfor (var o_act in v_selection){ÿþþif (o_act instanceof OpxActivity){ÿþþþvar o_act_sync = o_act.SYNCHRONIZE_WITH;ÿþþþif (o_act_sync instanceof OpxActivity && o_act==o_act_sync.SYNCHRONIZE_WITH) {ÿþþþþo_act_sync.SYNCHRONIZE_WITH=\"\";ÿþþþþo_act_sync.LAST_SYNC_RULE=\"\";ÿþþþ}ÿþþþo_act.SYNCHRONIZE_WITH=\"\";ÿþþþo_act.LAST_SYNC_RULE=\"\";ÿþþ}ÿþ}ÿ}ÿelse {alert(\"Please select 1 activity at least!\");}"
  :_IHM_TB_AA_S_FILTER "USER_IN_GROUP($CURRENT_USER,\"R_ITS_ADMIN,M_VACCINES,M_PHARMA\")"
  :_IHM_TB_AA_S_TOOL_IMG_ID "SAN_RDPM_IM_PJT_SYNC_LINK_DEL_IMG"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811792841
  :NAME "CS_BUTTON"
  :COMMENT "hours&Expenditures.summary.planned_hours_detailled"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "namespace _pmmod;ÿ_pm_js_newPlannedHours();"
  :_IHM_TB_AA_S_FILTER "USER_IN_GROUP($CURRENT_USER,\"R_ITS_ADMIN,M_VACCINES,M_PHARMA\")"
  :_IHM_TB_AA_S_TOOL_IMG_ID "SAN_RDPM_IM_PJT_ALLOCATION_IMG"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811793041
  :NAME "tool.to_create_expenditure"
  :COMMENT "tool.to_create_expenditure"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "_PM_JS_NEWEXPENDITURE()"
  :_IHM_TB_AA_S_FILTER "USER_IN_GROUP($CURRENT_USER,\"R_ITS_ADMIN,M_VACCINES,M_PHARMA\")"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TOOL_IMG_ID "SAN_RDPM_IM_PJT_COST_IMG"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811793241
  :NAME "DECREMENT"
  :COMMENT "Decrement level"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "\"DECREMENT\".Activatetool();"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811793441
  :NAME "INCREMENT"
  :COMMENT "Increment level"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "\"INCREMENT\".Activatetool();"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811793641
  :NAME "CS_MENUS"
  :COMMENT "Apply Equation"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 1.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "namespace _applyequation;ÿcontext.SAN_RDPM_UA_OC_B_EQUATIONS_RUNNING=true;ÿ_san_equa.san_PeApplyEquation();ÿcontext.SAN_RDPM_UA_OC_B_EQUATIONS_RUNNING=false;"
  :_IHM_TB_AA_S_TOOL_IMG_ID "SAN_RDPM_IM_PJT_EQUATION_IMG"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811793841
  :NAME "ENVTOOL__PM_TO_ADJUST_TOOL"
  :COMMENT "#@projectManager.adjust_tool_label"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "\"ENVTOOL__PM_TO_ADJUST_TOOL\".Activatetool();"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TOOL_IMG_ID "ic_touch_app_dark_grey_18"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811794041
  :NAME "CS_BUTTON"
  :COMMENT "change_time_now"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "namespace _pmmod;ÿ//var link = \"(:FVALUE :CONTEXT-OPX2 (39724899 . \\\"_INF_POPUP_CHANGE_TIME_NOW\\\") NIL T ÿ//NIL #.(:F\\\"\\\":STRING'^DATASET) T NIL)\"; link = unescapeBackslash(link); link = link.stringReferenceToObject(); lispcall \"report-builder::ottp-go\" (context.applet,context,link,false);ÿ_pm_js_changeTimenow();"
  :_IHM_TB_AA_S_FILTER "USER_IN_GROUP($CURRENT_USER,\"R_ITS_ADMIN,M_VACCINES\")"
  :_IHM_TB_AA_S_FILTER2 "USER_IN_GROUP($CURRENT_USER,\"R_ITS_ADMIN,M_VACCINES\")"
  :_IHM_TB_AA_S_TOOL_IMG_ID "SAN_RDPM_IM_PJT_TIME_NOW_IMG"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 282811794241
  :NAME "confirm_progress"
  :COMMENT "confirm_progress"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 282811797041
  :_IHM_AA_N_TOOL_VERSION 2.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "namespace _progress;ÿplw.CallToolOnSelection(\"REDUCE-ETC\");                                                                                                                                                                                                                                               ÿplw.CallToolOnSelection(\"CONFIRM-FURTHERANCE\");"
  :_IHM_TB_AA_S_TOOL_IMG_ID "SAN_RDPM_IM_PJT_PROGRESS_IMG"
  :_IHM_TB_AA_S_TYPE "TOOLS"
 )
)