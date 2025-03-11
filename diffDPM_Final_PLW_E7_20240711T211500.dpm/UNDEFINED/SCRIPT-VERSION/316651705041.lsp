
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 316651705041
 :DATASET 118081000141
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_RDPM_BA_NOTIFICATION_MAIL
//
//  v1.0 - 2021/07/07 - BNO
//  Group notification batches + Manage e-mail notifications on non-production environments (PC-3894)
//
//***************************************************************************/
namespace _san_workbox;

if(context.SAN_UA_B_SEND_EMAIL==true)
{
	var string vMacro=\"MAIL_MACRO_WORKBOX_SAN_WA_RDPM_EMAILING_TC_VALIDATION\";
	plw.writetolog(\" -- Start \"+vMacro);
	context.callmacro(vMacro);
	plw.writetolog(\" -- End \"+vMacro);

	// Frequency : the 15 day of every month
	var boolean vCheqF=_san_continuum.san_js_check_run_batch(\"monthly\",arg2:1,arg3:[15]);
	if (vCheqF==true)
	{
		var string vMacro=\"MAIL_MACRO_WORKBOX_SAN_RDPM_WA_CRITIC_PATH_REF\";
		plw.writetolog(\" -- Start \"+vMacro);
		context.callmacro(vMacro);
		plw.writetolog(\" -- End \"+vMacro);
	}

	// Frequency : monday and friday every 2 weeks
	var boolean vCheqF=_san_continuum.san_js_check_run_batch(\"weekly\",arg2:2,arg3:[1,5]);
	if (vCheqF==true)
	{
		var string vMacro=\"MAIL_MACRO_WORKBOX_SAN_RDPM_WA_NEW_PROJ_CREAT_ASSIG_TO_ME\";
		plw.writetolog(\" -- Start \"+vMacro);
		context.callmacro(vMacro);
		plw.writetolog(\" -- End \"+vMacro);
	}

	// Frequency : 15 day of every moth
	var boolean vCheqF=_san_continuum.san_js_check_run_batch(\"monthly\",arg2:1,arg3:[15]);
	if (vCheqF==true)
	{
		var string vMacro=\"MAIL_MACRO_WORKBOX_SAN_RDPM_WA_PROJ_OBJECTIVES_NOTIF\";
		plw.writetolog(\" -- Start \"+vMacro);
		context.callmacro(vMacro);
		plw.writetolog(\" -- End \"+vMacro);
	}


	// Frequency : 1 day (Monday) of every week
	var boolean vCheqF=_san_continuum.san_js_check_run_batch(\"weekly\",arg2:1,arg3:[1]);
	if (vCheqF==true)
	{
		var string vMacro=\"MAIL_MACRO_WORKBOX_SAN_WA_RDPM_RES_NETWORK_EMPTY\";
		plw.writetolog(\" -- Start \"+vMacro);
		context.callmacro(vMacro);
		plw.writetolog(\" -- End \"+vMacro);
	}
	
	// Frequency : Daily monday to friday
	var boolean vCheqF=_san_continuum.san_js_check_run_batch(\"weekly\",arg2:1,arg3:[1,2,3,4,5]);
	if (vCheqF==true)
	{
		var string vMacro=\"MAIL_MACRO_WORKBOX_SAN_RDPM_WA_SOURCING_REQUEST\";
		plw.writetolog(\" -- Start \"+vMacro);
		context.callmacro(vMacro);
		plw.writetolog(\" -- End \"+vMacro);
	}
}
else{
	plw.writetolog(\"Unauthorized e-mails for non-production environment have been set on users, notifications are disabled.\");
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 310233214470
 :VERSION 3
 :_US_AA_D_CREATION_DATE 20211006000000
 :_US_AA_S_OWNER "E0455451"
)