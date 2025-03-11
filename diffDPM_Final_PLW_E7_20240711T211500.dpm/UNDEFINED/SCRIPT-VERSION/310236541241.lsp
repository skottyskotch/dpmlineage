
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 310236541241
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_EQUATION_UTILS
// 
//  AUTHOR  : David
//
//  v1.2 - 2021/06/10 - David
//  Add san_rdpm_js_apply_equation_on_list to apply equation on a list of project (PC-3947), san_rdpm_js_get_ph_pe_to_vector to get the ph and pe of an activity (PC-4032)
// 
//  v1.1 - 2021/05/31 - David
//  Add functions san_common_PeApplyEquation and san_PeApplyEquation to add a filter on activities when running the equations on projects. Modify san_PeApplyEquation_LoadArray to use the same filter (PC-3957)
//
//  v1.0 - 2021/05/27 - David
//  Add function san_PeApplyEquation_LoadArray to run the equation on activity when selecting a line on Cost and load reports (PC-3026)
//
//***************************************************************************/
namespace _san_equa;

// get the ph and pe of an activity
method san_rdpm_js_get_ph_pe_to_vector on plc.workstructure()
{
	var vVect=new vector();
	var plc.workstructure vAct=this;
	for (var plc.taskalloc vAff in vAct.get(#ALLOCATIONS#))
	{
		vVect.push(vAff);
	}
	for (var plc.expenditure vExp in vAct.get(#EXPENDITURES#))
	{
		vVect.push(vExp);
	}
	return vVect;
}

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
		{
			selectionvector.push(vAct);
			// apply equations on planned hours and expenditures
			var vector vAllocExp=vAct.san_rdpm_js_get_ph_pe_to_vector();
			if (vAllocExp.length>0) selectionvector=selectionvector+vAllocExp;
		}
    }
    else
    {
		if (item instanceof plc.workstructure && item.SAN_RDPM_UF_B_EQUA_FILTER==true)
		{
			selectionvector.push(item);
			// apply equations on planned hours and expenditures
			var vector vAllocExp=item.san_rdpm_js_get_ph_pe_to_vector();
			if (vAllocExp.length>0) selectionvector=selectionvector+vAllocExp;
		}
    }
  }
  if(selectionvector.Length>0){
    selectionvector.Applyequations(undefined);
  }else{
    if(plw.Question(plw.write_text_key(\"PE.apply_equation_on_everything\"))){
      with(CurrentProject.fromobject()){
        // filter added
        for(var Activity in plc.workstructure where Activity.SAN_RDPM_UF_B_EQUA_FILTER==true)
		 {
			selectionvector.Push(Activity);
			// apply equations on planned hours and expenditures
			var vector vAllocExp=Activity.san_rdpm_js_get_ph_pe_to_vector();
			if (vAllocExp.length>0) selectionvector=selectionvector+vAllocExp;
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
}

// apply equation in a list of projects (call in the multiple intranet batch)
function san_rdpm_js_apply_equation_on_list(vVect)
{
	context.SAN_RDPM_UA_OC_B_EQUATIONS_RUNNING=true;
	plw.writetolog(\"Starting ApplyEquations on projects \");
	var SelectionVector=new vector();
	for(var o_projname in vVect)
	{
		var o_proj=plc.ordo_project.get(o_projname);
		if (o_proj!=undefined)
		{
			SelectionVector.clear();
			SelectionVector=new vector();
			plw.writetolog(\"Starting : \"+ o_proj.NAME);
			// browse all project's activities and select only not leaf activities
			// PC-2851 : force study also
			for(var plc.workstructure vAct in o_proj.ACTIVITIES where (vAct.IS_A_LEAF==true || vAct.SAN_UA_RDPM_B_IS_A_STUDY==true) && vAct.SAN_RDPM_UF_B_EQUA_FILTER==true)
			{
				selectionvector.push(vAct);
				// apply equations on planned hours and expenditures
				var vector vAllocExp=vAct.san_rdpm_js_get_ph_pe_to_vector();
				if (vAllocExp.length>0) selectionvector=selectionvector+vAllocExp;
			}
			SelectionVector.Applyequations(undefined);
		}
		else plw.writetolog(\"Not possible to find project : \"+ o_projname);
	}

	//Clear context.SAN_RDPM_UA_OC_B_EQUATIONS_RUNNING after equations application
	context.SAN_RDPM_UA_OC_B_EQUATIONS_RUNNING=false;
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 310206688941
 :VERSION 3
 :_US_AA_D_CREATION_DATE 20210715000000
 :_US_AA_S_OWNER "E0476882"
)