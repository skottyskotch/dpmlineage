
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 296635527869
 :NAME "SAN_RDPM_JS2_UPDATE_TC_ACCESS"
 :COMMENT "RDPM TimeCard access deactivation"
 :ACTIVE T
 :DATASET 118081000141
 :LOAD-ORDER 1
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_UPDATE_TC_ACCESS
//
//  v1.2 - 2022/06/29 - WST
//  Update the date to be trigger the 15 of the month(PC-6181)
//
//  v1.1 - 2021/03/16 - David
//  Convert to JS2 and add the frequency check (PC3436)
//
//  v1.0 - 28-JUL-20 HRA 
//  Creation of script
//
//***************************************************************************/
namespace _san_tc;

// Frequency : the 15 day of every month
var boolean vCheqF=_san_continuum.san_js_check_run_batch(\"monthly\",arg2:1,arg3:[15]);
if (vCheqF==true)
{
	// RDPM TimeCard access deactivation
	// Browse all users
	for (var usr in plc.opx2_user where usr.SAN_UA_RDPM_B_DEACTIVE_TC_ACCESS==true) {
		with(plw.no_locking) {
			usr.OPX2_INTRANET_ACCESS = false;
			plw.writeln(\"Timecard intranet access deactivated :\"+usr.NAME);
		}		
	}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 2
 :_US_AA_B_BATCH_SCRIPT "1"
 :_US_AA_D_CREATION_DATE 20210316000000
 :_US_AA_S_OWNER "intranet"
)