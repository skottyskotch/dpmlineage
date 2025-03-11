
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 296635605569
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_MAIL_WORKBOX_PROJ_OBJECTIVES_NOTIF
//
//  v1.0 - 2021/03/16 - David
//  Creation and add the frequency check (PC3436)
//
//***************************************************************************/
namespace _san_workbox;

// Frequency : 15 day of every moth
//var boolean vCheqF=_san_continuum.san_js_check_run_batch(\"monthly\",arg2:1,arg3:[15]);
//if (vCheqF==true)
//{
	var string vMacro=\"MAIL_MACRO_WORKBOX_SAN_RDPM_WA_PROJ_OBJECTIVES_NOTIF\";
	plw.writetolog(\" -- Start \"+vMacro);
	context.callmacro(vMacro);
	plw.writetolog(\" -- End \"+vMacro);
//}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 0
 :VERSION 2
 :_US_AA_D_CREATION_DATE 20210316000000
 :_US_AA_S_OWNER "E0296878"
)