
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 310213390141
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_EQUATION_UTILS
// 
//  AUTHOR  : David
//
//  v1.0 - 2021/05/27 - David
//  Add function san_PeApplyEquation_LoadArray to run the equation on activity when selecting a line on Cost and load reports (PC-3026)
//
//***************************************************************************/
namespace _san_equa;

function san_PeApplyEquation_LoadArray(){
  var CurrentProject = plw.CurrentPageObject();
  var SelectionVector = new vector();
  var selection = new symbol(\"SELECTION-ATOM\",\"TOOL-BAR\");
  for(var item in selection){
	// go to activity
	var vAct=item.activity;
	if (vAct!=undefined && vAct instanceof plc.workstructure)
    selectionvector.push(item.activity);
  }
  if(selectionvector.Length>0){
    selectionvector.Applyequations(undefined);
  }else{
    if(plw.Question(plw.write_text_key(\"PE.apply_equation_on_everything\"))){
      with(CurrentProject.fromobject()){
        for(var Activity in plc.workstructure){
          selectionvector.Push(Activity);
        }
        selectionvector.Applyequations(undefined);
      }
    }
  }
  return true;
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 310206688941
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20210531000000
 :_US_AA_S_OWNER "E0476882"
)