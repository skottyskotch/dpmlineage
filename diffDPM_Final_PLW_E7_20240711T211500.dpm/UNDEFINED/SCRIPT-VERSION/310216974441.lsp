
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 310216974441
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_EQUATION_UTILS
// 
//  AUTHOR  : David
//
//  v1.1 - 2021/05/31 - David
//  Add functions san_common_PeApplyEquation and san_PeApplyEquation to add a filter on activities when running the equations on projects. Modify san_PeApplyEquation_LoadArray to use the same filter (PC-3957)
//
//  v1.0 - 2021/05/27 - David
//  Add function san_PeApplyEquation_LoadArray to run the equation on activity when selecting a line on Cost and load reports (PC-3026)
//
//***************************************************************************/
namespace _san_equa;

// common part on apply equations
function san_common_PeApplyEquation(vType){
  var CurrentProject = plw.CurrentPageObject();
  var SelectionVector = new vector();
  var selection = new symbol(\"SELECTION-ATOM\",\"TOOL-BAR\");
  for(var item in selection){
    // filter added
    if (vType!=undefined && vType==\"costandload\")
    {
	    // go to activity
	    var vAct=item.activity;
	    if (vAct!=undefined && vAct instanceof plc.workstructure && vAct.SAN_RDPM_UF_B_EQUA_FILTER==true)
            selectionvector.push(vAct);
    }
    else
    {
        if (item instanceof plc.workstructure && item.SAN_RDPM_UF_B_EQUA_FILTER==true)
        selectionvector.push(item);
    }
  }
  if(selectionvector.Length>0){
    selectionvector.Applyequations(undefined);
  }else{
    if(plw.Question(plw.write_text_key(\"PE.apply_equation_on_everything\"))){
      with(CurrentProject.fromobject()){
        // filter added
        for(var Activity in plc.workstructure where Activity.SAN_RDPM_UF_B_EQUA_FILTER==true){
          selectionvector.Push(Activity);
        }
        selectionvector.Applyequations(undefined);
      }
    }
  }
  return true;
}

// used on button Apply equation
function san_PeApplyEquation()
{
    return san_common_PeApplyEquation(\"\");
}

// used on button Apply equation in Cost and Load
function san_PeApplyEquation_LoadArray()
{
    return san_common_PeApplyEquation(\"costandload\");
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 310206688941
 :VERSION 2
 :_US_AA_D_CREATION_DATE 20210610000000
 :_US_AA_S_OWNER "E0476882"
)