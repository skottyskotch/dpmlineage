
(TEMP-TABLE::_IHM_TB_PT_TOOLS
 :OBJECT-NUMBER 118175780899
 :NAME "_FF_AA_S_LIST_NAME"
 :COMMENT "favoriteFilter.choice"
 :DATASET 14047310199
 :EXTERNAL-ID 0
 :ORIGIN-NUMBER 0
 :ORIGIN-PROJECT 0
 :PARENT 0
 :_IHM_AA_N_TOOL_VERSION 0.0d0
 :_IHM_AA_S_COMPLETE_SCRIPT "restoreValueFromOnbOnPortfolioFilter(context._FF_AA_S_LIST_NAME);applyFilterWithoutRM(context._FF_NF_S_FAVORITE_FORMULA);"
 :_IHM_TB_AA_B_CHK_VAL_LIST "1"
 :_IHM_TB_AA_B_LIST_INPUT "0"
 :_IHM_TB_AA_B_LOM "0"
 :_IHM_TB_AA_B_NEEDS_CHECK "0"
 :_IHM_TB_AA_B_ONLY_VISIBLE "0"
 :_IHM_TB_AA_B_SELECT_INPUT "0"
 :_IHM_TB_AA_NP_SCRIPT "reset_filter();ÿthis.editor.apply();ÿrestoreValueFromOnbOnPortfolioFilter(context._FF_AA_S_LIST_NAME);ÿapplyFilter(context._FF_NF_S_FAVORITE_FORMULA);ÿif(context._KP_AA_S_PROJ_LIST != undefined)ÿ{ÿcontext._KP_AA_S_PROJ_LIST = \"\";ÿ}ÿ RefreshProjectOrganisationMatrix(context.pm_matrix_widget);"
 :_IHM_TB_AA_S_ATTR_NAME "_FF_AA_S_LIST_NAME"
 :_IHM_TB_AA_S_CHOICE_CLASS "_FF_PT_FAVOR_FILTERS"
 :_IHM_TB_AA_S_CLASS_NAME "CONTEXT-OPX2"
 :_IHM_TB_AA_S_FILTER "_FF_NF_B_FILTER AND _FF_NF_B_IS_FAVORITE"
 :_IHM_TB_AA_S_FILTER2 "RBMOD__RB_ISREPORTCLASSCONTEXT()"
 :_IHM_TB_AA_S_REL_ELEM_ONB "955869299"
 :_IHM_TB_AA_S_TYPE "FIELDS"
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 118175782899
  :NAME "favoriteFilter.choice"
  :COMMENT "favoriteFilter.choice"
  :DATASET 14047310199
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 118175780899
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_LOM "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "0"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_B_SELECT_INPUT "0"
  :_IHM_TB_AA_S_REL_ELEM_ONB "955869099"
  :_IHM_TB_AA_S_TOOL_IMG_ID "orange_arrow"
  :_IHM_TB_AA_S_TYPE "MENUS"
  (TEMP-TABLE::_IHM_TB_PT_TOOLS
   :OBJECT-NUMBER 118175781099
   :NAME "favoriteFilter.add_remove"
   :COMMENT "favoriteFilter.add_remove"
   :DATASET 14047310199
   :EXTERNAL-ID 0
   :ORIGIN-NUMBER 0
   :ORIGIN-PROJECT 0
   :PARENT 118175782899
   :_IHM_AA_N_TOOL_VERSION 0.0d0
   :_IHM_TB_AA_B_CHK_VAL_LIST "0"
   :_IHM_TB_AA_B_LIST_INPUT "0"
   :_IHM_TB_AA_B_LOM "0"
   :_IHM_TB_AA_B_NEEDS_CHECK "0"
   :_IHM_TB_AA_B_ONLY_VISIBLE "0"
   :_IHM_TB_AA_B_SELECT_INPUT "0"
   :_IHM_TB_AA_NP_SCRIPT "restoreValueFromOnbOnPortfolioFilter(context._FF_AA_S_LIST_NAME);ÿvar link = \"(:FFORMULA #.(:F\\\"_FF_AA_S_LIST_NAME\\\":STRING'#%ORDO-REQUEST:CONTEXT-OPX2:) (48674899 . \\\"_FF_POP_MODIFY_PORTFOLIO\\\") NIL T NIL #.(:F\\\"\\\":STRING'#%ORDO-REQUEST:CONTEXT-OPX2:) NIL)\"; link = unescapeBackslash(link); link = link.stringReferenceToObject(); lispcall \"report-builder::ottp-go\" (context.applet,context,link,false);"
   :_IHM_TB_AA_S_FILTER "OPX2_CONTEXT._FF_AA_S_LIST_NAME <> \"\""
   :_IHM_TB_AA_S_TYPE "MENUS"
  )
  (TEMP-TABLE::_IHM_TB_PT_TOOLS
   :OBJECT-NUMBER 118175781299
   :NAME "portfolio.editFavorites"
   :COMMENT "portfolio.editFavorites"
   :DATASET 14047310199
   :EXTERNAL-ID 0
   :ORIGIN-NUMBER 0
   :ORIGIN-PROJECT 0
   :PARENT 118175782899
   :_IHM_AA_N_TOOL_VERSION 0.0d0
   :_IHM_TB_AA_B_CHK_VAL_LIST "0"
   :_IHM_TB_AA_B_LIST_INPUT "0"
   :_IHM_TB_AA_B_LOM "0"
   :_IHM_TB_AA_B_NEEDS_CHECK "0"
   :_IHM_TB_AA_B_ONLY_VISIBLE "0"
   :_IHM_TB_AA_B_SELECT_INPUT "0"
   :_IHM_TB_AA_NP_SCRIPT "var link = \"(:FVALUE :CONTEXT-OPX2 (620854699 . \\\"_FF_POPUP_FAVORITES\\\") NIL T NIL #.(:F\\\"\\\":STRING'#%ORDO-REQUEST:CONTEXT-OPX2:) T)\"; link = unescapeBackslash(link); link = link.stringReferenceToObject(); lispcall \"report-builder::ottp-go\" (context.applet,context,link,false);"
   :_IHM_TB_AA_S_TYPE "MENUS"
  )
  (TEMP-TABLE::_IHM_TB_PT_TOOLS
   :OBJECT-NUMBER 118175781499
   :NAME "new"
   :COMMENT "new"
   :DATASET 14047310199
   :EXTERNAL-ID 0
   :ORIGIN-NUMBER 0
   :ORIGIN-PROJECT 0
   :PARENT 118175782899
   :_IHM_AA_N_TOOL_VERSION 0.0d0
   :_IHM_TB_AA_B_CHK_VAL_LIST "0"
   :_IHM_TB_AA_B_LIST_INPUT "0"
   :_IHM_TB_AA_B_LOM "0"
   :_IHM_TB_AA_B_NEEDS_CHECK "0"
   :_IHM_TB_AA_B_ONLY_VISIBLE "0"
   :_IHM_TB_AA_B_SELECT_INPUT "0"
   :_IHM_TB_AA_NP_SCRIPT "link_to_portfolio_creation()"
   :_IHM_TB_AA_S_FILTER "currentUserHasFeature(\"PTF_CREA\")"
   :_IHM_TB_AA_S_TYPE "MENUS"
  )
  (TEMP-TABLE::_IHM_TB_PT_TOOLS
   :OBJECT-NUMBER 118175781699
   :NAME "favoriteFilter.selectBucket"
   :COMMENT "favoriteFilter.selectBucket"
   :DATASET 14047310199
   :EXTERNAL-ID 0
   :ORIGIN-NUMBER 0
   :ORIGIN-PROJECT 0
   :PARENT 118175782899
   :_IHM_AA_N_TOOL_VERSION 0.0d0
   :_IHM_TB_AA_B_CHK_VAL_LIST "0"
   :_IHM_TB_AA_B_LIST_INPUT "0"
   :_IHM_TB_AA_B_LOM "0"
   :_IHM_TB_AA_B_NEEDS_CHECK "0"
   :_IHM_TB_AA_B_ONLY_VISIBLE "0"
   :_IHM_TB_AA_B_SELECT_INPUT "0"
   :_IHM_TB_AA_NP_SCRIPT "var link = \"(:FVALUE :CONTEXT-OPX2 (611964999 . \\\"_INF_POPUP_SELECT_BUCKET\\\") NIL T NIL #.(:F\\\"\\\":STRING'#%ORDO-REQUEST:CONTEXT-OPX2:) T)\"; link = unescapeBackslash(link); link = link.stringReferenceToObject(); lispcall \"report-builder::ottp-go\" (context.applet,context,link,false);"
   :_IHM_TB_AA_S_FILTER "FALSE"
   :_IHM_TB_AA_S_TYPE "MENUS"
  )
  (TEMP-TABLE::_IHM_TB_PT_TOOLS
   :OBJECT-NUMBER 118175781899
   :NAME "delete"
   :COMMENT "delete"
   :DATASET 14047310199
   :EXTERNAL-ID 0
   :ORIGIN-NUMBER 0
   :ORIGIN-PROJECT 0
   :PARENT 118175782899
   :_IHM_AA_N_TOOL_VERSION 0.0d0
   :_IHM_TB_AA_B_CHK_VAL_LIST "0"
   :_IHM_TB_AA_B_LIST_INPUT "0"
   :_IHM_TB_AA_B_LOM "0"
   :_IHM_TB_AA_B_NEEDS_CHECK "0"
   :_IHM_TB_AA_B_ONLY_VISIBLE "0"
   :_IHM_TB_AA_B_SELECT_INPUT "0"
   :_IHM_TB_AA_NP_SCRIPT "if ( question(write_text_key(\"portfolio.deleteConfirmation\").format(context._FF_AA_S_LIST_NAME)) ) {                                                                                                                                                                                                                                                                                                                                    ÿ   var portfolio = \"opx_ff_pt_favor_filters\".get(context._ff_aa_s_list_name);                                                                                                                                                                                                                                                                                                                                    ÿ   if (portfolio instanceof opx_ff_pt_favor_filters){                                                                                                                                                                                                                                                                                                                                    ÿ       portfolio.delete();                                                                                                                                                                                                                                                                                                                                    ÿ   }                                                                                                                                                                                                                                                                                                                                    ÿ}"
   :_IHM_TB_AA_S_FILTER "OPX2_CONTEXT._FF_AA_S_LIST_NAME <> \"\""
   :_IHM_TB_AA_S_TYPE "MENUS"
  )
  (TEMP-TABLE::_IHM_TB_PT_TOOLS
   :OBJECT-NUMBER 118175782099
   :NAME "reset"
   :COMMENT "reset"
   :DATASET 14047310199
   :EXTERNAL-ID 0
   :ORIGIN-NUMBER 0
   :ORIGIN-PROJECT 0
   :PARENT 118175782899
   :_IHM_AA_N_TOOL_VERSION 0.0d0
   :_IHM_TB_AA_B_CHK_VAL_LIST "0"
   :_IHM_TB_AA_B_LIST_INPUT "0"
   :_IHM_TB_AA_B_LOM "0"
   :_IHM_TB_AA_B_NEEDS_CHECK "0"
   :_IHM_TB_AA_B_ONLY_VISIBLE "0"
   :_IHM_TB_AA_B_SELECT_INPUT "0"
   :_IHM_TB_AA_NP_SCRIPT "//function defined in POrtfolio_Management.ojsÿResetFilterFromMenu();ÿÿÿ"
   :_IHM_TB_AA_S_TYPE "MENUS"
  )
  (TEMP-TABLE::_IHM_TB_PT_TOOLS
   :OBJECT-NUMBER 118175782299
   :NAME "open"
   :COMMENT "open"
   :DATASET 14047310199
   :EXTERNAL-ID 0
   :ORIGIN-NUMBER 0
   :ORIGIN-PROJECT 0
   :PARENT 118175782899
   :_IHM_AA_N_TOOL_VERSION 0.0d0
   :_IHM_TB_AA_B_CHK_VAL_LIST "0"
   :_IHM_TB_AA_B_LIST_INPUT "0"
   :_IHM_TB_AA_B_LOM "0"
   :_IHM_TB_AA_B_NEEDS_CHECK "0"
   :_IHM_TB_AA_B_ONLY_VISIBLE "0"
   :_IHM_TB_AA_B_SELECT_INPUT "0"
   :_IHM_TB_AA_NP_SCRIPT "var link = \"(:MACRO \\\"_FF_OPEN_PORTFOLIO_PROJECTS\\\" NIL NIL T NIL :PARALLEL)\"; link = unescapeBackslash(link); link = link.stringReferenceToObject(); lispcall \"report-builder::ottp-go\" (context.applet,context,link,false);"
   :_IHM_TB_AA_S_FILTER "NOT $INTRANET "
   :_IHM_TB_AA_S_TYPE "MENUS"
  )
  (TEMP-TABLE::_IHM_TB_PT_TOOLS
   :OBJECT-NUMBER 118175782499
   :NAME "portfolio.lock_portfolio"
   :COMMENT "portfolio.lock_portfolio"
   :DATASET 14047310199
   :EXTERNAL-ID 0
   :ORIGIN-NUMBER 0
   :ORIGIN-PROJECT 0
   :PARENT 118175782899
   :_IHM_AA_N_TOOL_VERSION 0.0d0
   :_IHM_TB_AA_B_CHK_VAL_LIST "0"
   :_IHM_TB_AA_B_LIST_INPUT "0"
   :_IHM_TB_AA_B_LOM "0"
   :_IHM_TB_AA_B_NEEDS_CHECK "0"
   :_IHM_TB_AA_B_ONLY_VISIBLE "0"
   :_IHM_TB_AA_B_SELECT_INPUT "0"
   :_IHM_TB_AA_NP_SCRIPT "var link = \"(:MACRO \\\"_FF_LOCK_PORTFOLIO_PROJECTS\\\" NIL NIL T NIL :PARALLEL)\"; link = unescapeBackslash(link); link = link.stringReferenceToObject(); lispcall \"report-builder::ottp-go\" (context.applet,context,link,false);"
   :_IHM_TB_AA_S_FILTER "NOT $INTRANET "
   :_IHM_TB_AA_S_TYPE "MENUS"
  )
  (TEMP-TABLE::_IHM_TB_PT_TOOLS
   :OBJECT-NUMBER 118175782699
   :NAME "portfolio.onlyFavorites"
   :COMMENT "portfolio.onlyFavorites"
   :DATASET 14047310199
   :EXTERNAL-ID 0
   :ORIGIN-NUMBER 0
   :ORIGIN-PROJECT 0
   :PARENT 118175782899
   :_IHM_AA_N_TOOL_VERSION 0.0d0
   :_IHM_TB_AA_B_CHK_VAL_LIST "0"
   :_IHM_TB_AA_B_LIST_INPUT "0"
   :_IHM_TB_AA_B_LOM "0"
   :_IHM_TB_AA_B_NEEDS_CHECK "0"
   :_IHM_TB_AA_B_ONLY_VISIBLE "0"
   :_IHM_TB_AA_B_SELECT_INPUT "0"
   :_IHM_TB_AA_NP_SCRIPT "contexT._FF_AA_B_ONLY_FAVORITES = true;"
   :_IHM_TB_AA_NP_SCRIPT2 "context._FF_AA_B_ONLY_FAVORITES = false;"
   :_IHM_TB_AA_S_FILTER "NOT _FF_AA_B_ONLY_FAVORITES"
   :_IHM_TB_AA_S_FILTER2 "_FF_AA_B_ONLY_FAVORITES"
   :_IHM_TB_AA_S_TOOL_IMG_ID "OPX2_TOGGLE_ON_ICON"
   :_IHM_TB_AA_S_TYPE "MENUS"
  )
 )
)