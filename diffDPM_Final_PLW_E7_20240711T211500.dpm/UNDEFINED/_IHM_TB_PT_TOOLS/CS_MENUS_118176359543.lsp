
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
 :_IHM_TB_AA_NP_SCRIPT "var CurrentUser = Context.Applet.User.name;�var project=CurrentpageObject();�var date_style = project._ROA_RA_PRJ_DATE_STYLE;�if (date_style!=undefined && date_style instanceof Opx_RE_PT_DATES_STYLE && date_style.file!=project)�{��var list = new vector();��list.push(\"NAME\");��list.push(project.name);��list.push(\"DESC\");��list.push(project.name);��list.push(\"_RE_AA_S_STYLE_OWNER\");��list.push(CurrentUser);��list.push(\"_INF_AA_S_EXPORT_DS \");��list.push(false);��list.push(\"FILE\");��list.push(project);��var new_date_style = date_style.copywithplist(list);��if (new_date_style instanceof Opx_RE_PT_DATES_STYLE)��{���project._ROA_RA_PRJ_DATE_STYLE=new_date_style;���date_style=new_date_style;��}���}�if(date_style instanceof Opx_RE_PT_DATES_STYLE)�{��var link =new hyperlink(\"Fvalue\",�������  \"Attribute\",�������  \"ID\",�������  \"EditorType\",�������  \"_RE_STYLE_DATES_POPUP\",�������  \"popup\",�������  true);��link.go(date_style);�}�else�{��alert(\"There is no date style defined on the roadmap.\");�}"
 :_IHM_TB_AA_S_FOLDED_LABEL "Edit dates"
 :_IHM_TB_AA_S_TYPE "MENUS"
)