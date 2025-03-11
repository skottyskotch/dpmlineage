
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 310228939770
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_MAIL_WORKBOX_RES_NETWORK_EMPTY
//
//  2021/06/22 - bno
//  Exclude Open position and Simulation from the notification: Timecard manager missing (PC-3792)
//
//***************************************************************************/

namespace _san_workbox;

// Frequency : 1 day (Monday) of every week
var boolean vCheqF=_san_continuum.san_js_check_run_batch(\"weekly\",arg2:1,arg3:[1]);
if (vCheqF==true)
{
	var string vMacro=\"MAIL_MACRO_WORKBOX_SAN_WA_RDPM_RES_NETWORK_EMPTY\";
	plw.writetolog(\" -- Start \"+vMacro);
	context.callmacro(vMacro);
	plw.writetolog(\" -- End \"+vMacro);
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 0
 :VERSION 0
 :_US_AA_D_CREATION_DATE 20210624000000
 :_US_AA_S_OWNER "E0296878"
)