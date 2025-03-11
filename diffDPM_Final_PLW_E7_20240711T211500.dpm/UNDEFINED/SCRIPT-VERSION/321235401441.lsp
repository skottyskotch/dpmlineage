
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321235401441
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_UPDATE_TC_ACCESS
//
//  v1.1 - 2021/03/16 - David
//  Convert to JS2 and add the frequency check (PC3436)
//
//  v1.0 - 28-JUL-20 HRA 
//  Creation of script
//
//***************************************************************************/
namespace _san_tc;

// Frequency : the 1 day of every month
var boolean vCheqF=_san_continuum.san_js_check_run_batch(\"monthly\",arg2:1,arg3:[1]);
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
 :USER-SCRIPT 296635527869
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20220629000000
 :_US_AA_S_OWNER "E0477351"
)