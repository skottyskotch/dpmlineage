
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 336983920741
 :NAME "SAN_RDPM_JS2_TC_UTILS_BATCH"
 :COMMENT "Functions for TC integration batch"
 :ACTIVE T
 :DATASET 118081000141
 :EVAL-ON-LOAD T
 :LOAD-ORDER 0
 :SCRIPT-CODE "namespace _san_batch_int;

function san_pjs_generic_send_mail_continuum_env(email_recipient,subject,body) {
	var env=context.CallStringFormula(\"$DATABASE_NAME\");
	var on_prod=context.CallBooleanFormula(\"\\\"\"+env+\"\\\"=\\\"*_PROD*\\\"\");
	if (on_prod) {
	    plw.writetolog(\"san_pjs_generic_send_mail_continuum_env...\");
		var plist = new vector();
		plist.setplist(\"from\",context._ADM_ST_S_NOTIF_CHGLOG_EMAIL_FROM);
		plist.setplist(\"to\",email_recipient);
		plist.setplist(\"subject\",\"[Continuum \"+env+\"] \"+subject);
		plist.setplist(\"body\",body);
		plist.setplist(\"Content-Type\",\"text/plain\");
		plw.mail_send(plist);
	}
	else {
	    plw.writetolog(\"NOT ON PROD: san_pjs_generic_send_mail_continuum_env inactivated!\");
	}
}

function san_pjs_launch_tc_integration_subbatches(run_batch) {
	var integer vNbofBatch=10;
	var body_vect=new vector();
	
	var vDate=new date();
	// \"PERIOD_START\".call(vDate,\"MONTH\",-1);
	var vStart_Month =  \"PERIOD_START\".callmacro(vDate,\"MONTH\",-1);
	// \"PERIOD_START\".call(vDate,\"MONTH\",0); 
	var vEnd_Month =  \"PERIOD_START\".callmacro(vDate,\"MONTH\",0);     
	
	body_vect.push(\"Start integration batch...\");
	body_vect.push(\"From \"+vStart_Month.tostring(\"DD/MMM/YYYY\"));
	body_vect.push(\"To \"+vEnd_Month.tostring(\"DD/MMM/YYYY\"));
	
	var test_subbatch=true;
	plw.writetolog(\"\");
	body_vect.push(\"\");
	plw.writetolog(\"\");
	plw.writetolog(\"Checking existence of required subbatches...\");
	body_vect.push(\"Checking existence of required subbatches...\");
	for (var i=1;i<=vNbofBatch;i++)
	{
		var string iStr=(i<vNbofBatch) ? \"0\"+i.tostring(\"####\") : i.tostring(\"####\");
		var oBatch=plc._BA_PT_BATCH.get(\"SAN_RDPM_BA_TC_INT_SUBBATCH_\"+iStr);
		if (oBatch!=undefined) {
			plw.writetolog(\"SAN_RDPM_BA_TC_INT_SUBBATCH_\"+iStr+\" found, OK!!\");
			body_vect.push(\"SAN_RDPM_BA_TC_INT_SUBBATCH_\"+iStr+\" found, OK!!\");
		}
		else { 
			test_subbatch=false;
			plw.writetolog(\"SAN_RDPM_BA_TC_INT_SUBBATCH_\"+iStr+\" NOT found, KO!!\");
			body_vect.push(\"SAN_RDPM_BA_TC_INT_SUBBATCH_\"+iStr+\" NOT found, KO!!\");
		}
	}
	
	if (test_subbatch)
	{
		plw.writetolog(\"-----------------\");
		body_vect.push(\"-----------------\");
		plw.writetolog(\"--->   All required subbatches were found, starting integration process...\");
		body_vect.push(\"--->   All required subbatches were found, starting integration process...\");
		plw.writetolog(\"\");
		plw.writetolog(\"-- Resetting batch instance number on resources\");
		body_vect.push(\"-- Resetting batch instance number on resources...\");
		for (var int_res in plc.resource where int_res.SAN_UA_RDPM_B_IS_RD_RES)
		{
			with(plw.no_locking) {
				if (int_res!=undefined) int_res.SAN_UA_N_INTEGRATION_TC_BATCH_INSTANCE=0;
			}
		}
		body_vect.push(\"-- Resetting batch instance number on resources, DONE!\");
		plw.writetolog(\"-----------------\");
		body_vect.push(\"-----------------\");
		
		var vVectList=new vector();
		var number i=1;
		var number j=0;
		// splitting resources to generate as much lists as the number of batchs to run in //
		for (var int_res in plc.resource where int_res.SAN_UA_RDPM_B_IS_RD_RES && !int_res._INF_AA_B_GENERIC_RES)
		{
			var has_val_tc=false;
			with(int_res.fromobject()) {
				for (var TC in plc.Time_Card where TC.getinternalvalue(\"STATUS\").tostring()==\"V\" && tc.START_DATE >= vStart_Month && tc.START_DATE < vEnd_Month) {
					has_val_tc=true;
					break;
				}
			}
			
			if (has_val_tc) {
				var number k=(j%2==0) ? i : math.round(vNbofBatch-i+1);
				if (vVectList[k]!=undefined) vVectList[k]+=\",\"+int_res.printattribute();
				else vVectList[k]=int_res.printattribute();
				// reaching the latest list (number of batchs), restart
				if (i>=vNbofBatch)
				{
					i=1;
					j++;
				}
				else i++;
			}
		}
		
		for (var i=1;i<=vNbofBatch;i++)
		{
			var string iStr=(i<10) ? \"0\"+i.tostring(\"####\") : i.tostring(\"####\");
			var string vListofRes=vVectList[i];
			if (vListofRes!=\"\" && vListofRes!=undefined) {
				for (var res_str in vListofRes.parselist()) {
					plw.writetolog(\"iteration \"+i+\" : \"+res_str);
					var res_it=plc.resource.get(res_str);
					with(plw.no_locking) {
						if (res_it!=undefined) res_it.SAN_UA_N_INTEGRATION_TC_BATCH_INSTANCE=i;
					}
				}
			}
			
			var vBatch=plc._BA_PT_BATCH.get(\"SAN_RDPM_BA_TC_INT_SUBBATCH_\"+iStr);
			if (vBatch!=undefined)
			{
				if (run_batch) {
					plw.writetolog(\"Starting subbatch \"+\"SAN_RDPM_BA_TC_INT_SUBBATCH_\"+iStr+\"...\");
					body_vect.push(\"Starting subbatch \"+\"SAN_RDPM_BA_TC_INT_SUBBATCH_\"+iStr+\"...\");
					vBatch.callmacro(\"_BA_TO_EXEC_BATCH\");
				}
			}
			else
			{
				plw.writetolog(\"SAN_RDPM_BA_TC_INT_SUBBATCH_\"+iStr+\" IS MISSING!!!!!\");
				body_vect.push(\"SAN_RDPM_BA_TC_INT_SUBBATCH_\"+iStr+\" IS MISSING!!!!!\");
			}
	}
	body_vect.push(\"-----------------\");
}
else
{
	plw.writetolog(\" -- Error : At least one required subbatch is missing, TC integration cancelled\");
	body_vect.push(\" -- Error : At least one required subbatch is missing, TC integration cancelled\");
}

var body_st=body_vect.join(plw.char(10));
_san_batch_int.san_pjs_generic_send_mail_continuum_env(context.EMAIL_NOTIFICATION_RECEPIENT_TC_BATCH,\"Integration batch is starting...\",body_st);
}

function san_pjs_launch_tc_integration_subbatch_for_instance(integer instance_nb) {
	var string ibatchStr=(instance_nb<10) ? \"0\"+instance_nb.tostring(\"####\") : instance_nb.tostring(\"####\");
	plw.writetolog(\"RDPM - START BATCH : SAN_RDPM_JS2_TC_INT_SUBBATCH_\"+ibatchStr);
	_san_batch_int.san_pjs_generic_send_mail_continuum_env(context.EMAIL_NOTIFICATION_RECEPIENT_TC_BATCH,\"SAN_RDPM_JS2_TC_INT_SUBBATCH_\"+ibatchStr+\" starting...\",\"RDPM - START BATCH : SAN_RDPM_JS2_TC_INT_SUBBATCH_\"+ibatchStr);
	var vDate=new date();
	var vStart_Month =  \"PERIOD_START\".callmacro(vDate,\"MONTH\",-1);
	var vEnd_Month =  \"PERIOD_START\".callmacro(vDate,\"MONTH\",0);
	plw.writetolog(\"RDPM - Integration timesheets of the month : \"+vStart_Month);
	var tc_vect=new vector();
	var integer count_res;
	for (var res in plc.resource where res.SAN_UA_N_INTEGRATION_TC_BATCH_INSTANCE==instance_nb) {
		count_res++;
		with(res.fromobject()) {
			for (var TC in plc.Time_Card where TC.getinternalvalue(\"STATUS\").tostring()==\"V\" && tc.START_DATE >= vStart_Month && tc.START_DATE < vEnd_Month)
			{   
				tc_vect.push(TC);
			}
		}
	}
	plw.writetolog(\"##########   INTEGRATING TC in SUBBATCH \"+instance_nb+\" ###############\");
	plw.writetolog(\"##########   \"+tc_vect.length+\" timesheets on \"+count_res+\" resources will be integrated in instance \"+instance_nb+\" ###############\");
	
	tc_vect.callmacro(\"INTEGRATE-TIME-CARD-USER-TOOL\");
	
	plw.writetolog(\"##########  END INTEGRATING TC in subbatch \"+instance_nb+\" ###############\");
	plw.writetolog(\"RDPM - END OF THE SUBBATCH SAN_RDPM_JS2_TC_INT_SUBBATCH_\"+ibatchStr);
	_san_batch_int.san_pjs_generic_send_mail_continuum_env(context.EMAIL_NOTIFICATION_RECEPIENT_TC_BATCH,\"SAN_RDPM_JS2_TC_INT_SUBBATCH_\"+ibatchStr+\" finished!\",tc_vect.length+\" integrated timesheets on \"+count_res+\" resources in instance \"+instance_nb);
	}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 4
 :_US_AA_B_BATCH_SCRIPT "0"
 :_US_AA_D_CREATION_DATE 20230719000000
 :_US_AA_S_OWNER "intranet"
)