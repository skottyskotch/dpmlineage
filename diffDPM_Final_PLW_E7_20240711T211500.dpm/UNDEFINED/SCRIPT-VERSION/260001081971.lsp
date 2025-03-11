
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260001081971
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _pmmod;
function _pm_js_newPlannedHours(){
   var editor = plc.Report.report_getreplace(\"_RM_REVIEW_POPUP_PLH\");
   var file = undefined;
   if(!_utilisvirtualdataset(\"\")){
     file = CurrentPageObject();  //$CURRENT_PAGE_OBJECT_ID
   }
   plw.alert(\"toto\" + file + \" -\" + editor.printattribute() +\"----- \");}   "
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260001077971
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20200824000000
 :_US_AA_S_OWNER "E0431101"
)