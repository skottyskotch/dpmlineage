
(TEMP-TABLE::_IHM_TB_PT_TOOLS
 :OBJECT-NUMBER 1316730099
 :NAME "GEN_HEADER_FILT_RES"
 :COMMENT "RBS"
 :DATASET 96270999
 :EXTERNAL-ID 0
 :ORIGIN-NUMBER 0
 :ORIGIN-PROJECT 0
 :PARENT 0
 :_IHM_AA_N_TOOL_VERSION 0.0d0
 :_IHM_TB_AA_B_CHK_VAL_LIST "1"
 :_IHM_TB_AA_B_LIST_INPUT "1"
 :_IHM_TB_AA_B_NEEDS_CHECK "0"
 :_IHM_TB_AA_B_ONLY_VISIBLE "0"
 :_IHM_TB_AA_B_SELECT_INPUT "0"
 :_IHM_TB_AA_NP_SCRIPT "var Res_Suffixe = \"_RBS\";�var project = context.callStringFormula(\"$CURRENT_USER\");�     var Selection =this.GEN_HEADER_FILT_RES;�  �  if(Selection != \"\")�    {�      var OldValue = GetUSerParameter(Project + Res_suffixe);�writeln(\"OldValue 2: \" + OldValue);�      var Vector= new vector();�      var Vector_Of_Element = new vector();�      if(Oldvalue == undefined)��{��  Oldvalue = \"\";��}�      var List = Oldvalue.parseVector(\"@@@\");�      if (List.Is_In_Parameter(Selection) == false )��{��  if(Oldvalue.length > 0 )��    {��      Oldvalue = \"@@@\"+Oldvalue;��    }��  OldValue = Selection + Oldvalue;��  Vector = OldValue.ParseVector(\"@@@\");��  if(Vector != undefined && Vector.length >= 5 )��    {��      for(var Pos=0;Pos<5;Pos++)���{���  Vector_Of_Element.push(Vector[Pos]);���}��      OldValue = Vector_Of_Element.join(\"@@@\");��    }�writeln(\"Project : \" + Project);�writeln(\"Oldvalue : \" + Oldvalue);��  SetUserParameter(Project + Res_suffixe,Oldvalue);�      var NewValue = GetUSerParameter(Project + Res_suffixe);�writeln(\"NewValue 2: \" + NewValue);��}�    }�this.editor.apply();�"
 :_IHM_TB_AA_S_ATTR_NAME "GEN_HEADER_FILT_RES"
 :_IHM_TB_AA_S_CHOICE_CLASS "RESOURCE"
 :_IHM_TB_AA_S_CLASS_NAME "CONTEXT-OPX2"
 :_IHM_TB_AA_S_FILTER "_TC_NF_B_RES_LISTTC_FILTER"
 :_IHM_TB_AA_S_GROUPING "filter.plural"
 :_IHM_TB_AA_S_NEED_TYPE "MANDATORY"
 :_IHM_TB_AA_S_REL_ELEM_ONB "714472599"
 :_IHM_TB_AA_S_TYPE "FIELDS"
 (TEMP-TABLE::_IHM_TB_PT_TOOLS
  :OBJECT-NUMBER 1316730299
  :NAME "RBS"
  :COMMENT "RBS"
  :DATASET 96270999
  :EXTERNAL-ID 0
  :ORIGIN-NUMBER 0
  :ORIGIN-PROJECT 0
  :PARENT 1316730099
  :_IHM_AA_N_TOOL_VERSION 0.0d0
  :_IHM_AA_S_COMPLETE_SCRIPT "GenerateFilterReminder(\"RBS\");"
  :_IHM_TB_AA_B_CHK_VAL_LIST "0"
  :_IHM_TB_AA_B_LIST_INPUT "0"
  :_IHM_TB_AA_B_NEEDS_CHECK "1"
  :_IHM_TB_AA_B_ONLY_VISIBLE "0"
  :_IHM_TB_AA_S_NEED_TYPE "MANDATORY"
  :_IHM_TB_AA_S_REL_ELEM_ONB "444677399"
  :_IHM_TB_AA_S_TYPE "MENUS"
  (TEMP-TABLE::_IHM_TB_PT_TOOLS
   :OBJECT-NUMBER 1316730499
   :NAME "SM"
   :COMMENT "menu.reset_filter"
   :DATASET 96270999
   :EXTERNAL-ID 0
   :ORIGIN-NUMBER 0
   :ORIGIN-PROJECT 0
   :PARENT 1316730299
   :_IHM_AA_N_TOOL_VERSION 0.0d0
   :_IHM_TB_AA_B_CHK_VAL_LIST "0"
   :_IHM_TB_AA_B_LIST_INPUT "0"
   :_IHM_TB_AA_B_NEEDS_CHECK "0"
   :_IHM_TB_AA_B_ONLY_VISIBLE "0"
   :_IHM_TB_AA_NP_SCRIPT "ResetMenuReminderfilter(\"RBS\")"
   :_IHM_TB_AA_S_NEED_TYPE "MANDATORY"
   :_IHM_TB_AA_S_TYPE "MENUS"
  )
  (TEMP-TABLE::_IHM_TB_PT_TOOLS
   :OBJECT-NUMBER 1316730699
   :NAME "SM"
   :COMMENT "timeCard.myResources"
   :DATASET 96270999
   :EXTERNAL-ID 0
   :ORIGIN-NUMBER 0
   :ORIGIN-PROJECT 0
   :PARENT 1316730299
   :_IHM_AA_N_TOOL_VERSION 0.0d0
   :_IHM_TB_AA_B_CHK_VAL_LIST "0"
   :_IHM_TB_AA_B_LIST_INPUT "0"
   :_IHM_TB_AA_B_NEEDS_CHECK "0"
   :_IHM_TB_AA_B_ONLY_VISIBLE "0"
   :_IHM_TB_AA_NP_SCRIPT "_tm_ApplyMenuReminder_my_res()"
   :_IHM_TB_AA_S_NEED_TYPE "MANDATORY"
   :_IHM_TB_AA_S_TYPE "MENUS"
  )
 )
)