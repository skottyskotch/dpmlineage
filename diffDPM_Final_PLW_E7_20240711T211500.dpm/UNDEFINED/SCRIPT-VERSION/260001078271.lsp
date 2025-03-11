
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260001078271
 :DATASET 118081000141
 :SCRIPT-CODE "namespace pmmod;

function _pm_js_newPlannedHours(){
  var editor = plc.Report.report_getreplace(\"_RM_REVIEW_POPUP_PLH\").name;
  var file = undefined;
  if(!_utilisvirtualdataset(\"\")){
    file = CurrentPageObject();  //$CURRENT_PAGE_OBJECT_ID
  }
  var link = new hyperlink(\"CreationForm\",
                           \"Class\",\"Expenditure\",
                           \"Editortype\",Editor,
                           \"DefaultA1\",\"File\",
                           \"DefaultV1\",file,
                           \"DefaultA2\", \"WORK-STRUCTURE\",
                           \"DefaultV2\", get_selected_element(\"ACTIVITY\"));
   
  if(link != undefined) {
    link.go(context);
  }
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260001077971
 :VERSION 0
 :_US_AA_D_CREATION_DATE 20200824000000
 :_US_AA_S_OWNER "E0431101"
)