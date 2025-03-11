
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 316647452141
 :NAME "SAN_RDPM_JS2_APPLY_EQUATIONS_SUBBATCH"
 :COMMENT "Script used by the sub-batches in equation batch"
 :ACTIVE T
 :DATASET 118081000141
 :LOAD-ORDER 0
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_APPLY_EQUATIONS_SUBBATCH
//  call on sub-batches SAN_RDPM_BA_APPLY_EQUATION_PROJECT_X
//
//  Revision 0.3 2022/01 ep 
//  Add counting functions to investigate duplicates issue (PC-4757) [detect_duplicates_expenditures] [detect_duplicates_expenditures]
//
//  Revision 0.2 2021/10/06 David 
//  Modify filter on projects (PC-4661 / PC-4662)
//
//  Revision 0.1 2021/09/22 David 
//  Creation to manage equation batch with macro on dataset (PC-4563)
//
//***************************************************************************/
namespace _san_rdpm_equation;

// PC-4757
/*function detect_duplicates_expenditures(vProj) {
	plw.writetolog(\" ######################################################################\");
	plw.writetolog(\" ############  DUPLICATE EXPENDITURES CHECKINGS FOR PROJECT: \"+vProj);
	var vListOfEquationToExclude=new vector(\"SAN_RDPM_EQ_EXONA_CSO\",\"SAN_RDPM_EQ_EXONA_CQL\",\"SAN_RDPM_EQ_EXONA_CTAM\",\"SAN_EQ_PH_IPSO_DIST\",\"SAN_EQ_PH_IPSO_DIST_EXT\",\"EQ_CSO_CR_PH_CS_TSOM_FIRST_IP_TO_LPI_PERIOD_PER_COUNTRY\",\"EQ_CSO_CR_PH_CS_TSOM_LPI_TO_LPLV_PERIOD_PER_COUNTRY\",\"EQ_CSO_CR_PH_CS_TSOM_LPLV_CLOSURE_PERIOD_PER_COUNTRY\",\"EQT_CSO_CR_PH_CS_TSOM_LPLV_CLOSURE_PERIOD_PER_COUNTRY\",\"EQT_CSO_CR_PH_CS_TSOM_CS_SETUP_COUNTRY\",\"EQT_CSO_CR_PH_CS_TSOM_CS_FEASIBILITY_COUNTRY\");
	
	var vTot=0;
	var vGlobal=0;
	var vToday=new date();
	var vRefDate=\"PERIOD_START\".callmacro(vToday,\"Month\",-1);
	
	var vHash=new hashtable(\"STRING\");
	var VprojObj=plc.ordo_project.get(VProj);
	if (VprojObj!=undefined && VprojObj InstanceOf plc.ordo_project) {
		with(VprojObj.fromobject())
		{
			for (var vExpend in plc.expenditure where vExpend.equation_object!=undefined && vExpend.equation_object!=\"\" && vExpend.equation_object.printattribute()!=\"\" && vExpend.CREATOR_OBJECT!=undefined && vExpend.CREATOR_OBJECT!=\"\" && vListOfEquationToExclude.position(vExpend.equation_object.printattribute())==undefined && vExpend.ED instanceof date && vExpend.ED>=vRefDate && vExpend.EQUATION_OVERRIDE!=true)
			{
				var vCreaClass=\"\";
				var vCreaObj=\"\";
				if (vExpend.CREATOR_OBJECT!=undefined && vExpend.CREATOR_OBJECT!=\"\")
				{
					vCreaClass=vExpend.CREATOR_OBJECT.class;
					vCreaObj=vExpend.CREATOR_OBJECT.printattribute();
				}
				var vDateD=(vExpend.SD instanceof date) ? \"PRINT_DATE\".callmacro(vExpend.SD,\"DD/MM/YYYY\") : \"\";
				var vDateF=(vExpend.ED instanceof date) ? \"PRINT_END_DATE\".callmacro(vExpend.ED,\"DD/MM/YYYY\") : \"\";
				vGlobal++;
				var vId=vCreaClass+\";\"+vCreaObj+\";\"+vExpend.project.printattribute()+\";\"+vExpend.activity.printattribute()+\";\"+vExpend.RES.printattribute()+\";\"+vExpend._RM_REVIEW_RA_LOCATION.printattribute()+\";\"+vExpend._INF_RA_CBS2.printattribute()+\";\"+vExpend._INF_RA_CBS3.printattribute()+\";\"+vExpend.equation_object.printattribute()+\";\"+\"PRINT_NUMBER\".callmacro(vExpend.QUANTITY,\"####,00\")+\";\"+vExpend.UNIT.printattribute()+\";\"+vExpend.COST_ACCOUNT.printattribute()+\";\"+vDateD+\";\"+vDateF;
				var vDupli=vHash.get(vId);
				if (vDupli!=undefined)
				{
					var vExpendIni=plc.expenditure.get(vDupli);
					if (vExpendIni!=undefined)
					{
						var vONB=\"PRINT_NUMBER\".callmacro(vExpend.ONB,\"####\");
						var vPrevONB=\"PRINT_NUMBER\".callmacro(vDupli,\"####\");
						var vStudyCode=vExpend.activity.SAN_RDPM_UA_ACT_S_CALCULATED_STUDY_CODE;
						plw.writetolog(vId+\";\"+vStudyCode+\";\"+vPrevONB+\";\"+vExpendIni.EQUATION_OVERRIDE+\";\"+vExpendIni.LAST_MODIFICATION_USER+\";\"+\"PRINT_DATE\".callmacro(vExpendIni.LAST_MODIFICATION_DATE,\"DD/MM/YYYY\")+\";\"+vONB+\";\"+vExpend.EQUATION_OVERRIDE+\";\"+vExpend.LAST_MODIFICATION_USER+\";\"+\"PRINT_DATE\".callmacro(vExpend.LAST_MODIFICATION_DATE,\"DD/MM/YYYY\"));
						vTot++;
					}
					else plw.writetolog(\" Check duplicate expenditure : error when getting the expenditure with ONB \"+vDupli);
				}
				else 
				{
					vHash.set(vId,vExpend.ONB);
				}
			}
		}
	}
	vHash.clear();
	
	var vPerc=(vGlobal>0) ? math.round((vTot*100)/vGlobal) : 0;
	plw.writetolog(\".\");
	plw.writetolog(\"DUPLICATE RESULTS Expenditures on projects \"+vTot+\" / \"+vGlobal+\" : \"+vPerc+\"%\");
	if (vTot>0) {
		plw.writetolog(\" !!! DUPLICATES EXP detected !!! \"+vTot+\" on project \"+VProj);
	}
	plw.writetolog(\" ######################################################################\");
}

function detect_duplicates_alloc(vProj) {
	plw.writetolog(\" ######################################################################\");
	plw.writetolog(\" ############  DUPLICATE ALLOCS CHECKINGS FOR PROJECT: \"+vProj);
	
	var vListOfEquationToExclude=new vector(\"SAN_EQ_PH_IPSO_DIST\",\"SAN_EQ_PH_IPSO_DIST_EXT\",\"EQ_CSO_CR_PH_CS_TSOM_FIRST_IP_TO_LPI_PERIOD_PER_COUNTRY\",\"EQ_CSO_CR_PH_CS_TSOM_LPI_TO_LPLV_PERIOD_PER_COUNTRY\",\"EQ_CSO_CR_PH_CS_TSOM_LPLV_CLOSURE_PERIOD_PER_COUNTRY\",\"EQT_CSO_CR_PH_CS_TSOM_LPLV_CLOSURE_PERIOD_PER_COUNTRY\",\"EQT_CSO_CR_PH_CS_TSOM_CS_SETUP_COUNTRY\",\"EQT_CSO_CR_PH_CS_TSOM_CS_FEASIBILITY_COUNTRY\");
	var s_monitor_message=\"Exporting duplicate allocations\";
	var vTot=0;
	var vGlobal=0;
	var vToday=new date();
	var vRefDate=\"PERIOD_START\".callmacro(vToday,\"Month\",-1);
	var VprojObj=plc.ordo_project.get(VProj);
	if (VprojObj!=undefined && VprojObj InstanceOf plc.ordo_project) {
		var vHash=new hashtable(\"STRING\");
		with(VprojObj.fromobject())
		{
			for (var vAlloc in plc.task_alloc where vAlloc.equation_object!=undefined && vAlloc.equation_object!=\"\" && vAlloc.equation_object.printattribute()!=\"\" && vAlloc.CREATOR_OBJECT!=undefined && vAlloc.CREATOR_OBJECT!=\"\" && vListOfEquationToExclude.position(vAlloc.equation_object.printattribute())==undefined && vAlloc.FD instanceof date && vAlloc.FD>=vRefDate && vAlloc.EQUATION_OVERRIDE!=true)
			{
				var vCreaClass=\"\";
				var vCreaObj=\"\";
				if (vAlloc.CREATOR_OBJECT!=undefined && vAlloc.CREATOR_OBJECT!=\"\")
				{
					vCreaClass=vAlloc.CREATOR_OBJECT.class;
					vCreaObj=vAlloc.CREATOR_OBJECT.printattribute();
				}
				var vDateD=(vAlloc.SD instanceof date) ? \"PRINT_DATE\".callmacro(vAlloc.SD,\"DD/MM/YYYY\") : \"\";
				var vDateF=(vAlloc.FD instanceof date) ? \"PRINT_END_DATE\".callmacro(vAlloc.FD,\"DD/MM/YYYY\") : \"\";
				vGlobal++;
				var vId=vCreaClass+\";\"+vCreaObj+\";\"+vAlloc.project.printattribute()+\";\"+vAlloc.activity.printattribute()+\";\"+vAlloc.RES.printattribute()+\";\"+vAlloc._RM_REVIEW_RA_LOCATION.printattribute()+\";\"+vAlloc._INF_RA_CBS2.printattribute()+\";\"+vAlloc._INF_RA_CBS3.printattribute()+\";\"+vAlloc.PRIMARY_SKILL.printattribute()+\";\"+vAlloc._RM_REVIEW_RA_ROLE.printattribute()+\";\"+vAlloc.equation_object.printattribute()+\";\"+\"PRINT_NUMBER\".callmacro(vAlloc.TOTAL_LOAD,\"####,00\")+\";\"+vDateD+\";\"+vDateF;
				var vDupli=vHash.get(vId);
				if (vDupli!=undefined)
				{
					var vAllocIni=plc.task_alloc.get(vDupli);
					if (vAllocIni!=undefined)
					{
						var vONB=\"PRINT_NUMBER\".callmacro(vAlloc.ONB,\"####\");
						var vPrevONB=\"PRINT_NUMBER\".callmacro(vDupli,\"####\");
						var vStudyCode=vAlloc.activity.SAN_RDPM_UA_ACT_S_CALCULATED_STUDY_CODE;
						//vFile.writeln(vId+\";\"+vStudyCode+\";\"+vPrevONB+\";\"+vAllocIni.EQUATION_OVERRIDE+\";\"+vAllocIni.LAST_MODIFICATION_USER+\";\"+\"PRINT_DATE\".callmacro(vAllocIni.LAST_MODIFICATION_DATE,\"DD/MM/YYYY\")+\";\"+vONB+\";\"+vAlloc.EQUATION_OVERRIDE+\";\"+vAlloc.LAST_MODIFICATION_USER+\";\"+\"PRINT_DATE\".callmacro(vAlloc.LAST_MODIFICATION_DATE,\"DD/MM/YYYY\"));
						plw.writetolog(vId+\";\"+vStudyCode+\";\"+vPrevONB+\";\"+vAllocIni.EQUATION_OVERRIDE+\";\"+vAllocIni.LAST_MODIFICATION_USER+\";\"+\"PRINT_DATE\".callmacro(vAllocIni.LAST_MODIFICATION_DATE,\"DD/MM/YYYY\")+\";\"+vONB+\";\"+vAlloc.EQUATION_OVERRIDE+\";\"+vAlloc.LAST_MODIFICATION_USER+\";\"+\"PRINT_DATE\".callmacro(vAlloc.LAST_MODIFICATION_DATE,\"DD/MM/YYYY\"));
						vTot++;
					}
					//else plw.alert(\" Check duplicate allocation : error when getting the allocation with ONB \"+vDupli);
					else plw.writetolog(\" Check duplicate allocation : error when getting the allocation with ONB \"+vDupli);
				}
				else 
				{
					vHash.set(vId,vAlloc.ONB);
				}
			}
		}
		vHash.clear();
		//s_monitor_message.monitor(vGlobal,false,1);
	//}
//}
}
var vPerc=(vGlobal>0) ? math.round((vTot*100)/vGlobal) : 0;
plw.writetolog(\".\");
plw.writetolog(\"DUPLICATE RESULTS Allocations on projects \"+VProj+\"  : \"+vTot+\" / \"+vGlobal+\" : \"+vPerc+\"%\");
if (vTot>0) {
	plw.writetolog(\" !!! DUPLICATES ALLOC detected !!! \"+vTot+\" on project \"+VProj);
}
plw.writetolog(\" ######################################################################\");
}
// PC-4757
*/

plw.writetolog(\" --------------- Start macro on dataset ---------\");
// in a macro on dataset the available project are only the one set on the batch properties
var vVect=new vector();
// we get only the parent project for running the equation (but indication are also load)
for (var vProj in plc.ordo_project where (((vProj.SAN_RDPM_B_RND_VACCINES_PROJECT && vProj.SAN_RDPM_UA_B_EQUATION_FILTER_PASTEUR) || (vProj.SAN_RDPM_B_RND_PHARMA_PROJECT && vProj.SAN_RDPM_UA_B_EQUATION_FILTER_PHARMA)) && vProj.PARENT.printattribute()==\"\" && vProj._INF_NF_S_PRJ_STATE_INTERNAL  == \"ACTIVE\" && vProj._INF_NF_B_IS_TEMPLATE != true && vProj._WZD_AA_B_PERMANENT != true )) 
    vVect.push(vProj.printattribute());
    
if (vVect.length>0)
{
    plw.writetolog(\" -- List of projects : \"+vVect.join(\",\"));
    
    // PC-4757
    //_san_rdpm_equation.detect_duplicates_expenditures(vVect[0]);
    //_san_rdpm_equation.detect_duplicates_alloc(vVect[0]);
    // PC-4757
    
    _san_equa.san_rdpm_js_apply_equation_on_list(vVect);
    
    // PC-4757
    //_san_rdpm_equation.detect_duplicates_expenditures(vVect[0]);
    //_san_rdpm_equation.detect_duplicates_alloc(vVect[0]);
    // PC-4757
}
else plw.writetolog(\" -- No project!\");

plw.writetolog(\" --------------- End macro on dataset ---------\");"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 4
 :_US_AA_B_BATCH_SCRIPT "1"
 :_US_AA_D_CREATION_DATE 20210929000000
 :_US_AA_S_OWNER "intranet"
)