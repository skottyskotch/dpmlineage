
(DYN-OBJECT:DYN
 :OBJECT-NUMBER 5245903699
 :COMMENT "Post-it content"
 :ATTRIBUTE-NAME :_TC_NF_POST_IT_CONTENT
 :CATEGORY ""
 :COMPUTE-FIELD-AT-STARTUP NIL
 :DATASET 96270999
 :DEPENDENCE-FORMULA NIL
 :DOCUMENTATION ""
 :HIDDEN-IN-INTRANET-SERVER NIL
 :INTERNAL-NAME NIL
 :MODULE ""
 :OBJECT-CLASS TIME-CARD-BASE:TIME-CARD
 :OPERATOR :VALUE
 :ORIGIN :PROJECT
 :PERSISTENT-CACHE-ON NIL
 :PTYPES NIL
 :RELATION :||
 :RELATION-FILTER-F ""
 :RELATION-VALUE-F ""
 :RETURN-TYPE STRING
 :SUBCLASS :||
 :VALUE-F "<html><p>##\"Handled \" + PRINT_NUMBER(_tc_current_total(\"\"),\"####\") + \" / \"+PRINT_NUMBER(_tc_getmax_total_timecard(),\"####\") + \" (\" +&nbsp;_tc_get_time_unit(\"\") + \")\"+\"&lt;br/&gt;\"+ _tc_activity_handled_with_percent(\"\") ##</p></html>"
)