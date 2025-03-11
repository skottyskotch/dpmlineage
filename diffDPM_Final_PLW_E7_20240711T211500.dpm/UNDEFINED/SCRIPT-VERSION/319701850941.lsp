
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 319701850941
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_APPLY_EQUATIONS_SUBBATCH
//  call on sub-batches SAN_RDPM_BA_APPLY_EQUATION_PROJECT_X
//
//  Revision 0.2 2021/10/06 David 
//  Modify filter on projects (PC-4661 / PC-4662)
//
//  Revision 0.1 2021/09/22 David 
//  Creation to manage equation batch with macro on dataset (PC-4563)
//
//***************************************************************************/
namespace _san_rdpm_equation;

plw.writetolog(\" --------------- Start macro on dataset ---------\");
// in a macro on dataset the available project are only the one set on the batch properties
var vVect=new vector();
// we get only the parent project for running the equation (but indication are also load)
for (var vProj in plc.ordo_project where ( ((vProj.SAN_RDPM_B_RND_VACCINES_PROJECT && vProj.SAN_RDPM_UA_B_EQUATION_FILTER_PASTEUR) || (vProj.SAN_RDPM_B_RND_PHARMA_PROJECT && vProj.SAN_RDPM_UA_B_EQUATION_FILTER_PHARMA)) && vProj.PARENT.printattribute()==\"\" && vProj._INF_NF_S_PRJ_STATE_INTERNAL  == \"ACTIVE\" && vProj._INF_NF_B_IS_TEMPLATE != true && vProj._WZD_AA_B_PERMANENT != true )) 
    vVect.push(vProj.printattribute());
    
if (vVect.length>0)
{
    plw.writetolog(\" -- List of projects : \"+vVect.join(\",\"));
    _san_equa.san_rdpm_js_apply_equation_on_list(vVect);
}
else plw.writetolog(\" -- No project!\");

plw.writetolog(\" --------------- End macro on dataset ---------\");
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 316647452141
 :VERSION 2
 :_US_AA_D_CREATION_DATE 20220127000000
 :_US_AA_S_OWNER "E0046087"
)