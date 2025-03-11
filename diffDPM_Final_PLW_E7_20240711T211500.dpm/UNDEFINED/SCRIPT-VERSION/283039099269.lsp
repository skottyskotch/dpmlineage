
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 283039099269
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_APPLY_EQUATIONS
//  call on batch SAN_RDPM_BA_APPLY_EQUATION_PROJECT
// 
//  Revision 0.2 2021/01/28 David
//  Modification to clear the vector on each project and apply only on PARENT project
//
//  Revision 0.1 2021/01/18 David 
//  Creation : replace v1 script san_rdpm_script_apply_equa_vaccine_pharma, fix PC-2851 to always apply on studies
//
//***************************************************************************/
namespace _san_rdpm_equation;

//Create a vector to store activities 
var vector SelectionVector = new vector();
plw.writetolog(\"Starting ApplyEquations_For_RND_Project\");
for (var o_proj in plc.ordo_project where ( (o_proj.SAN_RDPM_B_RND_VACCINES_PROJECT || o_proj.SAN_RDPM_B_RND_PHARMA_PROJECT ) && o_proj.PARENT.printattribute()==\"\" && o_proj._INF_NF_S_PRJ_STATE_INTERNAL == \"ACTIVE\" && o_proj._INF_NF_B_IS_TEMPLATE != true && o_proj._WZD_AA_B_PERMANENT != true )) 
{
    SelectionVector.clear();
	SelectionVector=new vector();
	plw.writetolog(\"Starting : \"+ o_proj.NAME);
	// browse all project's activities and select only not leaf activities
	// PC-2851 : force study also
	for(var plc.workstructure vAct in o_proj.ACTIVITIES where vAct.IS_A_LEAF==true || vAct.SAN_UA_RDPM_B_IS_A_STUDY==true)
	{
		selectionvector.push(vAct);
		
	}
	// apply equation function on activities vector
	plw.writeln(selectionvector);
	SelectionVector.Applyequations(undefined);
}

"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 282806032569
 :VERSION 4
 :_US_AA_D_CREATION_DATE 20210130000000
 :_US_AA_S_OWNER "E0296878"
)