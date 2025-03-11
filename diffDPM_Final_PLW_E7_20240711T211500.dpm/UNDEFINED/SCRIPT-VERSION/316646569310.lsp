
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 316646569310
 :DATASET 118081000141
 :SCRIPT-CODE "//
//  PLWSCRIPT : MAIL_MACRO_WORKBOX_SAN_RDPM_WA_IND_STATUS
//
//  v1.0 - 2021/06/09 - AKAAYOUS
//  Creation and add the frequency check (PC-2068)
//
//***************************************************************************/
namespace _san_workbox;

// Frequency : monday  every 2 weeks
var boolean vCheqF=_san_continuum.san_js_check_run_batch(\"weekly\",arg2:2,arg3:[1]);
if (vCheqF==true)
{
	var string vMacro=\"MAIL_MACRO_WORKBOX_SAN_RDPM_WA_IND_STATUS\";
	plw.writetolog(\" -- Start \"+vMacro);
	context.callmacro(vMacro);
	plw.writetolog(\" -- End \"+vMacro);
}

"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 0
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20210927000000
 :_US_AA_S_OWNER "E0296878"
)