
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321210092841
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_EQUATION_UTILS
// 
//  AUTHOR  : David
//
//  v1.5 - 2022/03/15 - David
//  Modify san_common_PeApplyEquation to display a message if the selection is not valid for equation and san_rdpm_js_apply_equation_on_list to remove old UA SAN_RDPM_UA_B_FILT_EQU_BATCH (PC-5341)
//
//  v1.4 - 2021/12/02 - David
//  Modify san_common_PeApplyEquation to force cost field computation (PC-5096)
//
//  v1.3 - 2021/07/08 - David 
//  Add san_rdpm_js_init_cost_field to force computation of cost field during batch and modify san_rdpm_js_apply_equation_on_list to use it (PC-4234)
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
  var i=0;
  var vNbSelect=0;
  for(var item in selection){
      vNbSelect++;
    // filter added
    if (vType!=undefined && vType==\"costandload\")
    {
	    // go to activity
	    var vAct=item.activity;
	    if (vAct!=undefined && vAct instanceof plc.workstructure && vAct.SAN_RDPM_UF_B_EQUA_FILTER==true)
		{
		    // recompute CF
			if (i==0) vAct.san_rdpm_js_init_cost_field();
			i++;
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
		    if (i==0) item.san_rdpm_js_init_cost_field();
			i++;
			selectionvector.push(item);
			// apply equations on planned hours and expenditures
			var vector vAllocExp=item.san_rdpm_js_get_ph_pe_to_vector();
			if (vAllocExp.length>0) selectionvector=selectionvector+vAllocExp;
		}
    }
  }
  // selected activities contains data on which equations run 
  if(selectionvector.length>0){
    selectionvector.Applyequations(undefined);
  }
  // selected activities does not contain any data on which equations should run -> display message PC-5341
  else if(vNbSelect>0){
      plw.alert(\"Equations cannot be applied as the selected activity is either finished or not associated to any equation. Please select other activities.\");
  }
  // nothing selected, ask to run on whole project
  else
  {
    if(plw.Question(plw.write_text_key(\"PE.apply_equation_on_everything\"))){
      with(CurrentProject.fromobject()){
        // filter added
        i=0;
        for(var Activity in plc.workstructure where Activity.SAN_RDPM_UF_B_EQUA_FILTER==true)
		 {
		    // recompute CF
			if (i==0) Activity.san_rdpm_js_init_cost_field();
			i++;
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

// method to compute cost fields
method san_rdpm_js_init_cost_field on plc.workstructure()
{
	var vAct=this;
	if (vAct instanceof plc.workstructure)
	{
		// list of cost fields to initialise
		var string vListCC=context.SAN_RDPM_CS_COST_FIELDS_BATCH;
		for (var vCCid in vListCC.parsevector())
		{
			// check if the cost field exists
			var vCC=plc._L1_PT_COST_FIELDS.get(vCCid);
			if (vCC!=undefined)
			{
			    plw.writetolog(\" - CF : \"+vCCid);
				// just initialise a variable to compute the cost field
				var init_value=vAct.get(vCCid)+1;
			}
		}
	}
}

// apply equation in a list of projects (call in the multiple intranet batch)
function san_rdpm_js_apply_equation_on_list(vVect)
{
	context.SAN_RDPM_UA_OC_B_EQUATIONS_RUNNING=true;
	plw.writetolog(\"Starting ApplyEquations on projects\");
	var SelectionVector=new vector();
	for(var o_projname in vVect)
	{
		var o_proj=plc.ordo_project.get(o_projname);
		if (o_proj!=undefined)
		{
			SelectionVector.clear();
			SelectionVector=new vector();
			plw.writetolog(\"Starting : \"+ o_proj.NAME);
			
			// PC-4234 : initialize cost fields : just need to compute on 1 activity so taking level 1 or 2 (indication)
			plw.writetolog(\" -- Computing CF\");
			for(var plc.workstructure vCompCC in o_proj.ACTIVITIES where vCompCC.level<=2)
			{
				vCompCC.san_rdpm_js_init_cost_field();
				plw.writetolog(\" -- End of Computing CF\");
				break;
			}

			// browse all project's activities and select only not leaf activities
			// PC-2851 : force study also
			for(var plc.workstructure vAct in o_proj.ACTIVITIES where vAct.SAN_RDPM_UF_B_EQUA_FILTER==true)
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
 :VERSION 6
 :_US_AA_D_CREATION_DATE 20220407000000
 :_US_AA_S_OWNER "E0476882"
)