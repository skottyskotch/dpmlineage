
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 334587567941
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _san_launch_batch;
function launch_batch_macro_export_pex(batch_identifier_customer_settings,min_rest_duration_before_launch){

	//Initilisation du o_main_batch qui est l'identifiant du batch à lancer. A partir de son ONB stocké dans les customer setttings. 
	var batch_onb = plc._L1_PT_SETTINGS.get(batch_identifier_customer_settings)._L1_AA_N_CUST_SETTING;
	var plc._INF_PT_REQ o_main_batch = plc._INF_PT_REQ.get(batch_onb); 
	var o_current_user = context.callstringformula(\"$CURRENT_USER\");
	if (o_main_batch instanceof plc._INF_PT_REQ){
		//Récupération du status du batch o_main_batch et de sa dernière date/heure/minutes de lancement.
		var batch_last_running_date = o_main_batch._BA_NF_D_LAST_RUN;
		//On regarde si la dernière date de lancement est récente relativement au temps minimal d'attente avant de pouvoir le relancer. 
		var b_is_recent_batch = (batch_last_running_date + (min_rest_duration_before_launch*60)) > new date();
		//we stop if the batch is already in progress or launched recently
		if (b_is_recent_batch == true || o_main_batch._BA_AA_B_RUN_BATCH == true) {
			plw.alert(\"The batch \"+o_main_batch.name+\" is already running or has been launched too recently : less than \"+min_rest_duration_before_launch+\" minutes ago.\");
		} else {
			// cas de l'environnement non cluster, on récupére l'objet batch WPA dans la variable mainbatch, et on lance.
			//with(plw.no_locking);
			var b_confirm = plw.question(\"Are you sure you want to launch the export \" +o_main_batch.name+ \" ?\");	
			if (b_confirm == true) {
				with(plw.no_locking){
					delete_old_impex_events(impex_target_name,retention_duration_days);
					o_main_batch._BA_AA_B_RUN_BATCH = true;
					plw.alert(\"The export have been launched, it will be available in a few minutes.\"); 
					plw.writetolog(o_current_user+ \" has launched the batch \" +o_main_batch);
				}
			}
		}
	}else {
		plw.alert(\"Error the batch ONB is not correct : \"+batch_onb+\". There might be an issue with th ecustomer setting configuration. Please contact your administrator.\"); 
	}
}

function delete_old_impex_events(impex_target_name,retention_duration_days){

	var retention_duration_seconds = (retention_duration_days*60*60*24);
	var plc.IMPEX_TARGET o_impex_target = plc.IMPEX_TARGET.get(impex_target_name); 
	if (o_impex_target instanceof plc.IMPEX_TARGET){
			with (plw.no_locking){
				with (o_impex_target.fromObject()){
     				for (var each in plc.impex_event where each.DATE + retention_duration_seconds < new date() 
     													&& each.TARGET == o_impex_target ) {
    					plw.writetolog(\"Deleting : \"+each);
      	 	 			each.delete();
     				}
   				}
			}
	} else {
		plw.alert(\"The old file cleaning could not be done. The impex target \"+impex_target_name+\" could not be found.\");
	}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 321303458582
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20230607000000
 :_US_AA_S_OWNER "I0260387"
)