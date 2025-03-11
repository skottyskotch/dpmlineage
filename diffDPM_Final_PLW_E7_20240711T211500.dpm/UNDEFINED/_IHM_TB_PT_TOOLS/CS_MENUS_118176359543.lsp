
(TEMP-TABLE::_IHM_TB_PT_TOOLS
 :OBJECT-NUMBER 118176359543
 :NAME "CS_MENUS"
 :COMMENT "Edit dates"
 :DATASET 118057330253
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
 :_IHM_TB_AA_NP_SCRIPT "var CurrentUser = Context.Applet.User.name;ÿvar project=CurrentpageObject();ÿvar date_style = project._ROA_RA_PRJ_DATE_STYLE;ÿif (date_style!=undefined && date_style instanceof Opx_RE_PT_DATES_STYLE && date_style.file!=project)ÿ{ÿþvar list = new vector();ÿþlist.push(\"NAME\");ÿþlist.push(project.name);ÿþlist.push(\"DESC\");ÿþlist.push(project.name);ÿþlist.push(\"_RE_AA_S_STYLE_OWNER\");ÿþlist.push(CurrentUser);ÿþlist.push(\"_INF_AA_S_EXPORT_DS \");ÿþlist.push(false);ÿþlist.push(\"FILE\");ÿþlist.push(project);ÿþvar new_date_style = date_style.copywithplist(list);ÿþif (new_date_style instanceof Opx_RE_PT_DATES_STYLE)ÿþ{ÿþþproject._ROA_RA_PRJ_DATE_STYLE=new_date_style;ÿþþdate_style=new_date_style;ÿþ}ÿþÿ}ÿif(date_style instanceof Opx_RE_PT_DATES_STYLE)ÿ{ÿþvar link =new hyperlink(\"Fvalue\",ÿþþþþþþ  \"Attribute\",ÿþþþþþþ  \"ID\",ÿþþþþþþ  \"EditorType\",ÿþþþþþþ  \"_RE_STYLE_DATES_POPUP\",ÿþþþþþþ  \"popup\",ÿþþþþþþ  true);ÿþlink.go(date_style);ÿ}ÿelseÿ{ÿþalert(\"There is no date style defined on the roadmap.\");ÿ}"
 :_IHM_TB_AA_S_FOLDED_LABEL "Edit dates"
 :_IHM_TB_AA_S_TYPE "MENUS"
)