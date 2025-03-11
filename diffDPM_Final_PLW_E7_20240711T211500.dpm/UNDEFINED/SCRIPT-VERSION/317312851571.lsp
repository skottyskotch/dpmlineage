
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 317312851571
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
// --END-- Workaround for PC-4273 & PC-4225 + OTD 121288

// --START-- Workaround for PC-5011 + OTD 129385
// Change default ProgressPresentationMode for RND VACCINES projects
// Can be removed if OTD 129385 change request is approved
function san_rdpm_Utils_Gantt_Display_Method_Vaccines_Projects(Gantt){
	
	var AdminProgressValue = undefined;
	var o_prj = undefined;
	
	for(var oCurPageObject in plw.currentpageobject()){
		// Get the project
		if(oCurPageObject instanceof plc.work_structure){
			// Case of oCurPageObject being a work_structure (ex. in workpackage module)
			// we retrieve the project of the work_structure
			o_prj = oCurPageObject.FILE;
		}else{
			// Case of a project module
			o_prj = oCurPageObject;
		}
		// If this is an R&D VACCINES project change behavior
		if (o_prj instanceof plc.project){
			if (o_prj.SAN_RDPM_B_RND_VACCINES_PROJECT){
				AdminProgressValue = \"NO\";
				Gantt.setinternalvalue(\"ProgressPresentationMode\",AdminProgressValue);
				break;
			}
		}
	}
}
plw._Utils_Gantt_Display_Method.addwrapperafter(san_rdpm_Utils_Gantt_Display_Method_Vaccines_Projects);
plw.writetolog(\"Adding wrapper san_rdpm_Utils_Gantt_Display_Method_Vaccines_Projects to _Utils_Gantt_Display_Method for R&D Vaccines projects\");
// --END-- Workaround for PC-4273 & PC-4225 + OTD 121288"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260001077971
 :VERSION 5
 :_US_AA_D_CREATION_DATE 20220113000000
 :_US_AA_S_OWNER "E0499607"
)