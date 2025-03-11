
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 310233214470
 :NAME "SAN_RDPM_BA_NOTIFICATION_MAIL_SCRIPT"
 :COMMENT "Group notification batches and Manage email "
 :ACTIVE T
 :DATASET 118081000141
 :LOAD-ORDER 0
 :SCRIPT-CODE "//
//  PLWSCRIPT : MAIL_MACRO_WORKBOX_SAN_RDPM_WA_NEW_VACCINES_PROJECT_CODE
//
//  v2.1 - 2021/03/17 - LFA
//  Deactivate notification for sourcing request  (PC-5876)
//
//  v2.0 - 2021/02/16 - ABO
//  Manage e-mail notifications on creation of new projects and indications  (PC-1983)
//
//***************************************************************************/
//  PLWSCRIPT : MAIL_MACRO_WORKBOX_SAN_RDPM_BA_NOTIFICATION_MAIL_SCRIPT
//
//  v2.0 - 2021/09/27 - ABO
//  Merge content of script SAN_RDPM_JS2_MAIL_WORKBOX_IND_STATUS with script SAN_RDPM_BA_NOTIFICATION_MAIL_SCRIPT (PC-4577)
//
//***************************************************************************/

//
//  PLWSCRIPT : MAIL_MACRO_WORKBOX_SAN_RDPM_BA_NOTIFICATION_MAIL_SCRIPT
//
//  v1.0 - 2021/06/09 - AKAAYOUS
//  Creation and add the frequency check (PC-2068)
//
//***************************************************************************/

//
//  PLWSCRIPT : SAN_RDPM_BA_NOTIFICATION_MAIL
//
//  v1.0 - 2021/07/07 - BNO
//  Group notification batches + Manage e-mail notifications on non-production environments (PC-3894)
//
//***************************************************************************/
namespace _san_workbox;

if(context.SAN_UA_B_SEND_EMAIL==true)
{
    // Frequency : monday  every 2 weeks
    var boolean vCheqF=_san_continuum.san_js_check_run_batch(\"weekly\",arg2:2,arg3:[1]);
    if (vCheqF==true)
    {
    	var string vMacro=\"MAIL_MACRO_WORKBOX_SAN_RDPM_WA_IND_STATUS\";
    	plw.writetolog(\" -- Start \"+vMacro);
    	context.callmacro(vMacro);
    	plw.writetolog(\" -- End \"+vMacro);
    }

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
	/*var boolean vCheqF=_san_continuum.san_js_check_run_batch(\"weekly\",arg2:1,arg3:[1,2,3,4,5]);
	if (vCheqF==true)
	{
		var string vMacro=\"MAIL_MACRO_WORKBOX_SAN_RDPM_WA_SOURCING_REQUEST\";
		plw.writetolog(\" -- Start \"+vMacro);
		context.callmacro(vMacro);
		plw.writetolog(\" -- End \"+vMacro);
	}*/
	
	// Frequency : Daily (every day)
	var boolean vCheqF=_san_continuum.san_js_check_run_batch(\"weekly\",arg2:1,arg3:[1,2,3,4,5,6,7]);
	if (vCheqF==true)
	{
	    plw.alert(\"OK!!\");
		var string vMacro=\"MAIL_MACRO_WORKBOX_SAN_RDPM_WA_NEW_VACCINES_PROJECT_CODE\";
		plw.writetolog(\" -- Start \"+vMacro);
		context.callmacro(vMacro);
		plw.writetolog(\" -- End \"+vMacro);
	}
	
	// Send e-mail for vaccines project and indication
	_RDPM_PM.san_rdpm_js2_send_vaccines_project_notifications();
	
}
else{
	plw.writetolog(\"Unauthorized e-mails for non-production environment have been set on users, notifications are disabled.\");
}

"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 9
 :_US_AA_B_BATCH_SCRIPT "1"
 :_US_AA_D_CREATION_DATE 20210707000000
 :_US_AA_S_OWNER "intranet"
)