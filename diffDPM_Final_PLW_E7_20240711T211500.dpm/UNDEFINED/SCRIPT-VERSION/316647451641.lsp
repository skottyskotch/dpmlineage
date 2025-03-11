
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 316647451641
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_APPLY_EQUATIONS
//  call on batch SAN_RDPM_BA_APPLY_EQUATION_PROJECT
//
//  Revision 1.0 2021/06/16 David
//  Use multiple batchs in // to improve performance, comment old version (PC-3947)
//
//  Revision 0.4 2021/05/31 David
//  Add filter to apply equations (PC-3957)
//
//  Revision 0.3 2021/03/16 Islam
//  SAN_RDPM_UA_OC_B_EQUATIONS_RUNNING added to manage trigger on alerts on modification (PC-2908)
//
//  Revision 0.2 2021/01/28 David
//  Modification to clear the vector on each project and apply only on PARENT project (PC-2851)
//
//  Revision 0.1 2021/01/18 David 
//  Creation : replace v1 script san_rdpm_script_apply_equa_vaccine_pharma, fix PC-2851 to always apply on studies
//
//***************************************************************************/
namespace _san_rdpm_equation;

// get the number of batch from the user formula (depending on database)
var vSettingVal=context.SAN_RDPM_UF_N_EQUA_BATCH_NB;
var number vNbofBatch=(vSettingVal!=undefined && vSettingVal instanceof number && vSettingVal>0) ? vSettingVal : 4;
//end of line character
var string vNewLine=\"GET_CHAR\".callmacro(10);

var vVectList=new vector();
var number i=1;
var number j=0;
// splitting projects by number of objects and to generate as much lists as the number of batchs to run in //
for (var o_proj in plc.ordo_project where ( (o_proj.SAN_RDPM_B_RND_VACCINES_PROJECT || o_proj.SAN_RDPM_B_RND_PHARMA_PROJECT ) && o_proj.PARENT.printattribute()==\"\" && o_proj._INF_NF_S_PRJ_STATE_INTERNAL  == \"ACTIVE\" && o_proj._INF_NF_B_IS_TEMPLATE != true && o_proj._WZD_AA_B_PERMANENT != true ) order by [['INVERSE','NUMBER_OF_OBJECTS']])
{
	// change to avoid having the biggest projects always on the 1st list
	// if pair, projects are set first in list 1 then 2,3,4... else they are set first in list n,...,3,2,1
	var number k=(j%2==0) ? i : math.round(vNbofBatch-i+1);
	if (vVectList[k]!=undefined) vVectList[k]+=\",\\\"\"+o_proj.printattribute()+\"\\\"\";
	else vVectList[k]=\"\\\"\"+o_proj.printattribute()+\"\\\"\";
	// reaching the latest list (number of batchs), restart
	if (i>=vNbofBatch)
	{
		i=1;
		j++;
	}
	else i++;
}
plw.writetolog(\" -- For database \"+context.callstringformula(\"$DATABASE_NAME\")+\",this batch will generate \"+vNbofBatch.tostring(\"####\")+\" batchs and associated user scripts\");

for (var i=1;i<=vNbofBatch;i++)
{
	var string iStr=i.tostring(\"####\");
	var string vListofProj=vVectList[i];
	// code for the user script of the batch i 
	var vCode=\"// ******* Do not modify, automatically generated and updated by the main script batch for equations SAN_RDPM_JS2_APPLY_EQUATIONS *****\"+vNewLine;
	vCode=vCode+\"namespace _san_rdpm_equation;\"+vNewLine+\"var vVect=new vector(\"+vListofProj+\");\"+vNewLine+\"_san_equa.san_rdpm_js_apply_equation_on_list(vVect);\";
	// if the user script already exists, just update the code, else create it
	var vScript=plc.USER_SCRIPT.get(\"SAN_RDPM_JS2_APPLY_EQUATIONS_\"+iStr);
	if (vScript!=undefined)
	{
		vScript.SCRIPT_CODE=vCode;
	}
	else
	{
		// store it in a \"real\" file else it is not load in the batch (because not present in the master)
		var vArg=new vector(\"NAME\",\"SAN_RDPM_JS2_APPLY_EQUATIONS_\"+iStr,\"DESC\",\"SAN_RDPM_JS2_APPLY_EQUATIONS_\"+iStr,\"ACTIVE\",true,\"_US_AA_B_BATCH_SCRIPT\",true,\"EVAL_ON_LOAD\",false,\"SCRIPT_CODE\",vCode,\"FILE\",\"SAN_CF_RDPM_CONFIG_L1\");
		vScript=plc.USER_SCRIPT.makeopx2objectwithplist(vArg);
	}

	// if the batch already exists, just update the user script, else create it
	var vBatch=plc._BA_PT_BATCH.get(\"SAN_RDPM_BA_APPLY_EQUATION_PROJECT_\"+iStr);
	if (vBatch!=undefined)
	{
		vBatch._INF_RA_USER_SCRIPT=vScript;
	}
	else
	{
		var vArg=new vector(\"NAME\",\"SAN_RDPM_BA_APPLY_EQUATION_PROJECT_\"+iStr,\"DESC\",\"SAN_RDPM_BA_APPLY_EQUATION_PROJECT_\"+iStr,\"_BA_AA_N_BATCH_TYPE\",\"User script\",\"_INF_RA_USER_SCRIPT\",vScript,\"_INF_AA_AT_FREQ\",\"Never\",\"_INF_AA_N_END_AFTNB_DAILY\",1000000,\"FILE\",\"SAN_CF_RDPM_BATCH\");
		vBatch=plc._BA_PT_BATCH.makeopx2objectwithplist(vArg);
	}
	var vBatchReq=plc._INF_PT_REQ.get(\"SAN_RDPM_BA_APPLY_EQUATION_PROJECT_\"+iStr);
	plw.writetolog(\"Run batch \"+iStr+\" on \"+vListofProj);
	// simulate click on Execute for the batch
	vBatchReq.callmacro(\"_BA_TO_EXEC_BATCH\");
}

// ********************** Old version with only one batch ***************************
/*
//Set context.SAN_RDPM_UA_OC_B_EQUATIONS_RUNNING to true to not trigger alerts on modification
context.SAN_RDPM_UA_OC_B_EQUATIONS_RUNNING=true;

//Create a vector to store activities 
var vector SelectionVector = new vector();
plw.writetolog(\"Starting ApplyEquations_For_RND_Project\");
for (var o_proj in plc.ordo_project where ( (o_proj.SAN_RDPM_B_RND_VACCINES_PROJECT || o_proj.SAN_RDPM_B_RND_PHARMA_PROJECT ) && o_proj.PARENT.printattribute()==\"\" && o_proj._INF_NF_S_PRJ_STATE_INTERNAL  == \"ACTIVE\" && o_proj._INF_NF_B_IS_TEMPLATE != true && o_proj._WZD_AA_B_PERMANENT != true )) 
{
	SelectionVector.clear();
	SelectionVector=new vector();
	plw.writetolog(\"Starting : \"+ o_proj.NAME);
	// browse all project's activities and select only not leaf activities
	// PC-2851 : force study also
	for(var plc.workstructure vAct in o_proj.ACTIVITIES where (vAct.IS_A_LEAF==true || vAct.SAN_UA_RDPM_B_IS_A_STUDY==true) && vAct.SAN_RDPM_UF_B_EQUA_FILTER==true)
	{
		selectionvector.push(vAct);
	}
	// apply equation function on activities vector
	SelectionVector.Applyequations(undefined);
}

//Clear context.SAN_RDPM_UA_OC_B_EQUATIONS_RUNNING after equations application
context.SAN_RDPM_UA_OC_B_EQUATIONS_RUNNING=false;
*/"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 282806032569
 :VERSION 11
 :_US_AA_D_CREATION_DATE 20210929000000
 :_US_AA_S_OWNER "E0476882"
)