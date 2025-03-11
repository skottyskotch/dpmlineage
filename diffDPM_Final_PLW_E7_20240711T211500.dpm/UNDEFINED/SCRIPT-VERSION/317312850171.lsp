
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 317312850171
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _pmmod;

function _pm_js_newPlannedHours(){
   var editor = plc.Report.report_getreplace(\"_RM_REVIEW_POPUP_PLH\");
   var file = undefined;
   if(! plw._utilisvirtualdataset(\"\")){
     file = plw.CurrentPageObject();  //$CURRENT_PAGE_OBJECT_ID
   }
     
   var link = new hyperlink(\"CreationForm\",
                            \"Class\",\"ALLOCATION\",
                            \"Editortype\",editor.name,
                            \"DefaultA1\",\"File\",
                            \"DefaultV1\",file,
                            \"DefaultA2\", \"WORK-STRUCTURE\",
                            \"DefaultV2\", plw.get_selected_element(\"ACTIVITY\"));

 


   if(link != undefined) {
     link.go(context);
   }
 }
 
 function _pm_js_changeTimenow(){
     
  var hl = new hyperlink(\"Fvalue\",
                        \"Attribute\", \"ID\",
                        \"EditorType\", \"_INF_POPUP_CHANGE_TIME_NOW\",
                        \"Popup\", true);
    hl.go(context);
  }
  
  // --START-- Workaround for PC-4273 & PC-4225 + OTD 121288
function san_rdpm_init_curves_at_startup() {
	plw.writeln(\"################################\");
	plw.writeln(\"Curves list initialization starting...\");
	var number count=0;
	for (var eachCurve in cost.listAllCurvesName(\"*\")) {
		count++;
	}
	plw.writeln(\"Initialized \"+count+\" curves!\");
	plw.writeln(\"Curves list initialization DONE!\");
	plw.writeln(\"################################\");
}

wrap.intranetStarted.addWrapperAfter(san_rdpm_init_curves_at_startup);
// --END-- Workaround for PC-4273 & PC-4225 + OTD 121288"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260001077971
 :VERSION 4
 :_US_AA_D_CREATION_DATE 20220113000000
 :_US_AA_S_OWNER "E0499607"
)