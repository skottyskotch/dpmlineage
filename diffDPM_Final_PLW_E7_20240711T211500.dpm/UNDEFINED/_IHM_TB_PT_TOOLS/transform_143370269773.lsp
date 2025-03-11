
(TEMP-TABLE::_IHM_TB_PT_TOOLS
 :OBJECT-NUMBER 143370269773
 :NAME "transform"
 :COMMENT "transform"
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
 :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
 :_IHM_TB_AA_S_REL_ELEM_ONB "1311769699"
 :_IHM_TB_AA_S_TYPE "MENUS"
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370265573
  :NAME "DISPLAY_IN_TIMELINE"
  :COMMENT "#@menu.display_in_timeline"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "_RoaDisplayInTimeLine()"
  :_IHM_TB_AA_S_FILTER "FALSE"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370265773
  :NAME "CS_MENUS"
  :COMMENT "tool.removeUselessConstraints"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "namespace pmMod; activity_removeUselessConstraints();"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370265973
  :NAME "projectManager.transform_task_tool_label"
  :COMMENT "projectManager.transform_task_tool_label"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "CallToolOnselection(\"ENVTOOL__PM_TO_TRANSFORM_TASK\");                                                                                                                                                                                                                                                                                                                                       ÿ"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370266173
  :NAME "projectManager.update_etc_with_budget"
  :COMMENT "projectManager.update_etc_with_budget"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "if(question(write_text_key(\"projectManager.update_etc_with_budget_warning\")))                                                                                                                                                                                    ÿcalltoolonselection(\"UPDATE-ESTIMATE-FROM-BUDGET\");"
  :_IHM_TB_AA_S_FILTER "GETINTERNALSTRINGVALUE(\"ORDO-PROJECT\", $current_page_object_id, \"BUDGET_UPDATE_MODE\") <> \"false\" and GETINTERNALSTRINGVALUE(\"ORDO-PROJECT\", $current_page_object_id, \"BUDGET_UPDATE_MODE\") <> \"N\""
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370266373
  :NAME "PE.apply_equation"
  :COMMENT "PE.apply_equation"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "namespace _applyequation;ÿcontext.SAN_RDPM_UA_OC_B_EQUATIONS_RUNNING=true;ÿplw._PeApplyEquation();ÿcontext.SAN_RDPM_UA_OC_B_EQUATIONS_RUNNING=false;"
  :_IHM_TB_AA_S_FILTER "FALSE"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370266573
  :NAME "projectManager.multiple_update"
  :COMMENT "projectManager.multiple_update"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "//function defined in _pm_multiple_update.ojsÿ_PmDisplayMultipleUpdate();"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370266773
  :NAME "AE.apply"
  :COMMENT "AE.apply"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "display_estimation_by_analogy_to_apply();"
  :_IHM_TB_AA_S_FILTER "FALSE"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370266973
  :NAME "projectManager.scheduling.Allocation_gantt.resources_scheduling"
  :COMMENT "projectManager.scheduling.Allocation_gantt.resources_scheduling"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "//function defined in _Pm_resource_schedule.ojsÿ_PmdisplayPLanificationDialog();"
  :_IHM_TB_AA_S_FILTER "FALSE"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370267173
  :NAME "agile.BoardIntoWBS"
  :COMMENT "agile.BoardIntoWBS"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "agile_transformSelectionAsWBS()"
  :_IHM_TB_AA_S_FILTER "FALSE"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370267373
  :NAME "projectManager.transform_wbs_tool_label"
  :COMMENT "projectManager.transform_wbs_tool_label"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "CallToolOnselection(\"ENVTOOL__PM_TO_TRANSFORM_WBS\");                                                                                                                                                                                                                                                                                                                                       ÿ"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370267573
  :NAME "projectManager.template_synchro.tool_label"
  :COMMENT "projectManager.template_synchro.tool_label"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "//function defined in _PM_synchronize_with_template                                                                                                                                                                                                                                                                                                                                                                                                                                  ÿ//CallToolOnSelection(\"ENVTOOL__PM_TO_SYNCH\");                                                                                                                                                                                                                                                                                                                                                                                                                                ÿ_PmSynchronizeFromTemplate();                                                                                                                                                                                                                                                                                                                                                                                                                                ÿ"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370267973
  :NAME "agile.transformAsBoard"
  :COMMENT "agile.transformAsBoard"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "agile_transformSelectionAsBoard();"
  :_IHM_TB_AA_S_FILTER "FALSE"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370268173
  :NAME "menu.copy_with_link"
  :COMMENT "menu.copy_with_link"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "_PmPastewithSynchronisationLink();"
  :_IHM_TB_AA_S_FILTER "FALSE"
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370268373
  :NAME "agile.boardIntoTask"
  :COMMENT "agile.boardIntoTask"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "agile_transformSelectionAsTask()"
  :_IHM_TB_AA_S_FILTER "FALSE"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370268573
  :NAME "projectManager.update_budget_with_etc"
  :COMMENT "projectManager.update_budget_with_etc"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "_PmUpdateBudgetWithEtc();"
  :_IHM_TB_AA_S_FILTER "GETINTERNALSTRINGVALUE(\"ORDO-PROJECT\", $current_page_object_id, \"BUDGET_UPDATE_MODE\") <> \"false\" and GETINTERNALSTRINGVALUE(\"ORDO-PROJECT\", $current_page_object_id, \"BUDGET_UPDATE_MODE\") <> \"N\""
  :_IHM_TB_AA_S_NEED_TYPE "DEFAULT"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370268773
  :NAME "CS_MENUS"
  :COMMENT "tool.scaleSelectedActivities"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "_pm_scale_selected_activities_display_dialog();"
  :_IHM_TB_AA_S_FILTER "FALSE"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370268973
  :NAME "CS_MENUS"
  :COMMENT "projectManager.scheduling.reschedWithPrjLogic"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "namespace pmMod; rescheduleWithPrjtLogic();"
  :_IHM_TB_AA_S_FILTER "false"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370269173
  :NAME "CS_MENUS"
  :COMMENT "projectManager.scheduling.reschedWithProgressOverride"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "namespace pmMod; rescheduleWithPrjtOverride();"
  :_IHM_TB_AA_S_FILTER "false"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370269373
  :NAME "CS_MENUS"
  :COMMENT "menu.copy_with_bidi_link"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "_pm_paste_with_bidi_synchronization_link();"
  :_IHM_TB_AA_S_FILTER "FALSE"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370269573
  :NAME "CS_MENUS"
  :COMMENT "tool.shiftSelectedActivities"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "_pm_shift_selected_activities_display_dialog();"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370270773
  :NAME "CS_MENUS"
  :COMMENT "RDPM.SAN_RDPM_TK_CREATE_SYNCHRONIZE_WITH_LINK"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "var v_selection = selection_vector();ÿÿif (v_selection.length >1) {ÿþfor (var i=1 ; i<v_selection.length ; i=i+2){ÿþþvar o_act_1 = v_selection[i-1];ÿþþvar o_act_2 = v_selection[i];ÿþþif (o_act_1 instanceof OpxActivity && o_act_2 instanceof OpxActivity){ÿþþþif (o_act_1.SYNCHRONIZE_WITH==\"\" && o_act_2.SYNCHRONIZE_WITH==\"\"){ÿþþþþo_act_1.SYNCHRONIZE_WITH=o_act_2.printattribute();ÿþþþþfor (var o_syncRule in \"OpxSYNCHRONIZATION_RULE\".findclass() order by {{\"INVERSE\", \"PRIORITY\"}}){ÿþþþþþif (o_act_1.callbooleanformula(o_syncRule.FILTER)) {o_act_1.LAST_SYNC_RULE=o_syncRule.printattribute();break;}ÿþþþþ}ÿþþþþÿþþþþo_act_2.SYNCHRONIZE_WITH=o_act_1.printattribute();ÿþþþþfor (var o_syncRule in \"OpxSYNCHRONIZATION_RULE\".findclass() order by {{\"INVERSE\", \"PRIORITY\"}}){ÿþþþþþif (o_act_2.callbooleanformula(o_syncRule.FILTER)) {o_act_2.LAST_SYNC_RULE=o_syncRule.printattribute();break;}ÿþþþþ}ÿþþþ}ÿþþþelse {ÿþþþþif (o_act_1.SYNCHRONIZE_WITH!=\"\"){alert(\"There is already a synchronization link on \"+o_act_1.printattribute()+\", creation canceled!\");}ÿþþþþif (o_act_2.SYNCHRONIZE_WITH!=\"\"){alert(\"There is already a synchronization link on \"+o_act_2.printattribute()+\", creation canceled!\");}ÿþþþ}ÿþþ}ÿþ}ÿ}ÿelse {alert(\"Please select 2 activities at least!\");}"
  :_IHM_TB_AA_S_FILTER "FALSE"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 143370271373
  :NAME "CS_MENUS"
  :COMMENT "RDPM.SAN_RDPM_TK_REMOVE_SYNCHRONIZE_WITH_LINK"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "var v_selection = selection_vector();ÿÿif (v_selection.length >0) {ÿþfor (var o_act in v_selection){ÿþþif (o_act instanceof OpxActivity){ÿþþþvar o_act_sync = o_act.SYNCHRONIZE_WITH;ÿþþþif (o_act_sync instanceof OpxActivity && o_act==o_act_sync.SYNCHRONIZE_WITH) {ÿþþþþo_act_sync.SYNCHRONIZE_WITH=\"\";ÿþþþþo_act_sync.LAST_SYNC_RULE=\"\";ÿþþþ}ÿþþþo_act.SYNCHRONIZE_WITH=\"\";ÿþþþo_act.LAST_SYNC_RULE=\"\";ÿþþ}ÿþ}ÿ}ÿelse {alert(\"Please select 1 activity at least!\");}"
  :_IHM_TB_AA_S_FILTER "FALSE"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 260107084274
  :NAME "CS_MENUS"
  :COMMENT "Update Leader and Site from WBS Form"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 1.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "// Update Leader and Sites on activities from toolbarÿnamespace _wbs_form; ÿsan_rdpm_wbs_form_update_leader_and_site();"
  :_IHM_TB_AA_S_FOLDED_LABEL "Update Leader and Site from WBS Form"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 310229038641
  :NAME "CS_MENUS"
  :COMMENT "Link countries and cohorts"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 1.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "namespace _rdpm_recreate_links;ÿ_rdpm_auto_link_cohort_country();"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 310242054341
  :NAME "CS_MENUS"
  :COMMENT "Restore WBS Form Data in version"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 1.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "namespace _wbs_form;ÿvar version = context.CallStringFormula(\"$CURRENT_PAGE_OBJECT_ID\");ÿsan_rdpm_restore_wbs_form_data_in_version(version);"
  :_IHM_TB_AA_S_FILTER "BOOLEAN_VALUE(\"PROJECT\",$CURRENT_PAGE_OBJECT_ID,\"_PM_NF_B_IS_A_VERSION\")"
  :_IHM_TB_AA_S_FOLDED_LABEL "Restore WBS Form Data in version"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 340178724541
  :NAME "CS_MENUS"
  :COMMENT "Link GCI Assay tasks"
  :DATASET 118081000141
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 143370269773
  :_IHM_AA_N_TOOL_VERSION 1.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_HIDE_BOTH_F "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_NP_SCRIPT "namespace _rdpm_recreate_links_gci;ÿ_rdpm_auto_link_gci_assay_gci_lab_tasks();"
  :_IHM_TB_AA_S_FOLDED_LABEL "Link GCI Assay tasks"
  :_IHM_TB_AA_S_TYPE "MENUS"
 )
)