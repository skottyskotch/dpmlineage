
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 296635531669
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_TC_INT
// 
//  AUTHOR  : S. AKAAYOUS
//
//
//  Creation : 2020/09/11 SAK
//  Script used for PC 216 :  Integrate only timesheets of the last month that have been validated
//  Modification : 2020/10/20 SAK : PC-2043
//***************************************************************************/

namespace _san_rdpm_tc;
plw.writeln(\"RDPM - START BATCH : SAN_RDPM_BA_INTEGRATE_TC\");
var vDate=new date();
var vStart_Month =  \"PERIOD_START\".callmacro(vDate,\"MONTH\",-1);  // \"PERIOD_START\".call(vDate,\"MONTH\",-1);
var vEnd_Month =  \"PERIOD_START\".callmacro(vDate,\"MONTH\",0);     // \"PERIOD_START\".call(vDate,\"MONTH\",0); 
plw.writeln(\"RDPM - Integration timesheets of the month : \"+vStart_Month);
for (var TC in plc.Time_Card where TC.getinternalvalue(\"STATUS\").tostring()==\"V\" && tc.START_DATE >= vStart_Month && tc.START_DATE < vEnd_Month  )
{   
	TC.callmacro(\"INTEGRATE-TIME-CARD-USER-TOOL\");
	plw.writeln(\"RDPM - Integration timesheet  : \"+TC);
}
plw.writeln(\"RDPM - END OF THE BATCH : SAN_RDPM_BA_INTEGRATE_TC\");"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260070060572
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20210316000000
 :_US_AA_S_OWNER "E0296878"
)