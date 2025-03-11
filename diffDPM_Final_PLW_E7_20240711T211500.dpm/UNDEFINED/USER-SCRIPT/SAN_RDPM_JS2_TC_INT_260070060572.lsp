
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 260070060572
 :NAME "SAN_RDPM_JS2_TC_INT"
 :COMMENT "RDPM Integration of Timecards"
 :ACTIVE T
 :DATASET 118081000141
 :LOAD-ORDER 1
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_TC_INT
// 
//  AUTHOR  : S. AKAAYOUS
//  v1.2 - 2021/06/29 ep
//  PC-4146 : improve execution time using a vector to store timesheets to be integrated, instead of integrate one by one
//
//  v1.1 - 2021/03/16 David
//  Add the frequency check (PC3436)
//
//  Creation : 2020/09/11 SAK
//  Script used for PC 216 :  Integrate only timesheets of the last month that have been validated
//  Modification : 2020/10/20 SAK : PC-2043
//***************************************************************************/

namespace _san_rdpm_tc;

/*
var boolean vCheqF=_san_continuum.san_js_check_run_batch(\"monthly\",arg2:1,arg3:[1]);
if (vCheqF==true)
{
    plw.writeln(\"RDPM - START BATCH : SAN_RDPM_BA_INTEGRATE_TC\");
    var vDate=new date();
    var vStart_Month =  \"PERIOD_START\".callmacro(vDate,\"MONTH\",-1);  // \"PERIOD_START\".call(vDate,\"MONTH\",-1);
    var vEnd_Month =  \"PERIOD_START\".callmacro(vDate,\"MONTH\",0);     // \"PERIOD_START\".call(vDate,\"MONTH\",0); 
    plw.writeln(\"RDPM - Integration timesheets of the month : \"+vStart_Month);
	var tc_vect=new vector();
    for (var TC in plc.Time_Card where TC.getinternalvalue(\"STATUS\").tostring()==\"V\" && tc.START_DATE >= vStart_Month && tc.START_DATE < vEnd_Month)
    {   
    	tc_vect.push(TC);
		//TC.callmacro(\"INTEGRATE-TIME-CARD-USER-TOOL\");
    	//plw.writeln(\"RDPM - Integration timesheet  : \"+TC);
    }
	plw.writeln(\"##########   INTEGRATING TC ###############\");
	plw.writeln(\"##########   \"+tc_vect.length+\" timesheets will be integrated ###############\");
	
	tc_vect.callmacro(\"INTEGRATE-TIME-CARD-USER-TOOL\");
	
	plw.writeln(\"##########  END INTEGRATING TC ###############\");
    plw.writeln(\"RDPM - END OF THE BATCH : SAN_RDPM_BA_INTEGRATE_TC\");
}
*/

var boolean vCheqF=_san_continuum.san_js_check_run_batch(\"monthly\",arg2:1,arg3:[1]);
//var boolean vCheqF=true;
if (vCheqF==true) {
	_san_batch_int.san_pjs_launch_tc_integration_subbatches(true);
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 4
 :_US_AA_B_BATCH_SCRIPT "1"
 :_US_AA_D_CREATION_DATE 20201016000000
 :_US_AA_S_OWNER "intranet"
)