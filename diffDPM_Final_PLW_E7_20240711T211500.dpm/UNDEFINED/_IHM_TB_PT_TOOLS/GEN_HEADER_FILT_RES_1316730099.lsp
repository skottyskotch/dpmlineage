
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
 :_IHM_TB_AA_NP_SCRIPT "var Res_Suffixe = \"_RBS\";ÿvar project = context.callStringFormula(\"$CURRENT_USER\");ÿ     var Selection =this.GEN_HEADER_FILT_RES;ÿ  ÿ  if(Selection != \"\")ÿ    {ÿ      var OldValue = GetUSerParameter(Project + Res_suffixe);ÿwriteln(\"OldValue 2: \" + OldValue);ÿ      var Vector= new vector();ÿ      var Vector_Of_Element = new vector();ÿ      if(Oldvalue == undefined)ÿþ{ÿþ  Oldvalue = \"\";ÿþ}ÿ      var List = Oldvalue.parseVector(\"@@@\");ÿ      if (List.Is_In_Parameter(Selection) == false )ÿþ{ÿþ  if(Oldvalue.length > 0 )ÿþ    {ÿþ      Oldvalue = \"@@@\"+Oldvalue;ÿþ    }ÿþ  OldValue = Selection + Oldvalue;ÿþ  Vector = OldValue.ParseVector(\"@@@\");ÿþ  if(Vector != undefined && Vector.length >= 5 )ÿþ    {ÿþ      for(var Pos=0;Pos<5;Pos++)ÿþþ{ÿþþ  Vector_Of_Element.push(Vector[Pos]);ÿþþ}ÿþ      OldValue = Vector_Of_Element.join(\"@@@\");ÿþ    }ÿwriteln(\"Project : \" + Project);ÿwriteln(\"Oldvalue : \" + Oldvalue);ÿþ  SetUserParameter(Project + Res_suffixe,Oldvalue);ÿ      var NewValue = GetUSerParameter(Project + Res_suffixe);ÿwriteln(\"NewValue 2: \" + NewValue);ÿþ}ÿ    }ÿthis.editor.apply();ÿ"
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