
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 334587606741
 :NAME "SAN_RDPM_JS2_DELIVERY_UTILS"
 :COMMENT "Utils for delivery operations (deliverymanager)"
 :ACTIVE T
 :DATASET 118057330253
 :EVAL-ON-LOAD T
 :LOAD-ORDER 0
 :SCRIPT-CODE "// PART 1
namespace _rdpm_delivery;

function san_pjs_delivery_backup_access_and_deactivate_users() {
	if (context.CallStringFormula(\"$CURRENT_USER\")==\"deliverymanager\") {
		var n_nb_user=0;
		var count=0;
		var active_users=new vector();
		var s_monitor_message=\" Archiving intranet access on users, and deactivate them... \";
		var curus=plc.opx2_user.get(context.CallStringFormula(\"$CURRENT_USER\"));
		with([plw.no_locking, plw.no_alerts]){ 
			// Resetting attribute SAN_UA_RWE_ACTIVE_USER on all users 
			plw.writetolog(\"Reset of backup values...\");
			for (var usr in plc.opx2_user where usr!=curus) {
				n_nb_user++;
				usr.SAN_UA_RWE_ACTIVE_USER=false;
			}
			plw.writetolog(\"Reset of backup values DONE! (\"+n_nb_user+\" users resetted)\");
			// Counting users with OPX2_INTRANET_ACCESS  
			n_nb_user=0;
			for (var usr in plc.opx2_user where usr!=curus && usr.OPX2_INTRANET_ACCESS)	{ 
				n_nb_user ++;
				active_users.push(usr);
			}   
			// Backuping value on users with OPX2_INTRANET_ACCESS  
			with(plw.monitoring (title: s_monitor_message, steps:n_nb_user)){   
				context._do_not_check_user_keys_=true;
				for (var usr in active_users) {
					count++;
					//plw.writetolog(\"Backuping \"+count+\"/\"+n_nb_user+\": \"+usr);
					usr.SAN_UA_RWE_ACTIVE_USER=usr.OPX2_INTRANET_ACCESS;   
					usr.OPX2_INTRANET_ACCESS=false;   
					s_monitor_message.monitor(n_nb_user);   
				}
				plw.writetolog(\"Deactivated \"+count+\"/\"+n_nb_user+\" active users\");
				context._do_not_check_user_keys_=false;
			}   
		}  
		plw.alert(\"******************\");
		plw.alert(\"Backuped \"+n_nb_user+\" users.\");
		plw.alert(\"Deactivated \"+count+\"/\"+n_nb_user+\" active users\");
		plw.alert(\"******************\");
	}
	else {
		plw.alert(\"Only deliverymanager is allowed to perform that action.\");
	}
}


// PART 2
function san_pjs_delivery_reactivate_funct_admin_users() {
	if (context.CallStringFormula(\"$CURRENT_USER\")==\"deliverymanager\") {
		var n_nb_user=0;
		var count=0;
		var active_users=new vector();
		var s_monitor_message=\" Reactivating intranet access on R_ITS_ADMIN and functional admin users... \";  
		var curus=plc.opx2_user.get(context.CallStringFormula(\"$CURRENT_USER\"));  
		for (var usr in plc.opx2_user where usr!=curus && usr.CallBooleanFormula(\"SAN_UA_RWE_ACTIVE_USER AND USER_IN_GROUP(ID,\\\"R_ITS_ADMIN,OR_FUNCT_ADM_CHC,OR_FUNCT_ADM_CONTINUUM,OR_FUNCT_ADM_MSP,OR_FUNCT_ADM_PHARMA,OR_FUNCT_ADM_RWE,OR_FUNCT_ADM_VACCINES\\\")\")) {  
			n_nb_user ++;
			active_users.push(usr);
		}
		with([plw.no_locking, plw.no_alerts]){
			context._do_not_check_user_keys_=true;
			with(plw.monitoring (title: s_monitor_message, steps:n_nb_user)){  
				for (var usr in active_users) {
					count++; 
					usr.OPX2_INTRANET_ACCESS=usr.SAN_UA_RWE_ACTIVE_USER;
					s_monitor_message.monitor(n_nb_user);  
				}  
			}
			context._do_not_check_user_keys_=false;
		}
		plw.alert(\"Restored \"+count+\"/\"+n_nb_user+\" users\");
		return n_nb_user;
	}
	else {
		plw.alert(\"Only deliverymanager is allowed to perform that action.\");
	}
}


// PART 3
function san_pjs_delivery_reactivate_all_users() {  
	if (context.CallStringFormula(\"$CURRENT_USER\")==\"deliverymanager\") {
		var n_nb_user=0;
		var count=0;
		var active_users=new vector();
		var s_monitor_message=\" Restoring intranet access on all users... \";  
		var curus=plc.opx2_user.get(context.CallStringFormula(\"$CURRENT_USER\"));  
		for (var usr in plc.opx2_user where usr!=curus && usr.SAN_UA_RWE_ACTIVE_USER){  
			n_nb_user ++;
			active_users.push(usr);
		} 
		with([plw.no_locking, plw.no_alerts]){
			context._do_not_check_user_keys_=true;
			with(plw.monitoring (title: s_monitor_message, steps:n_nb_user)){  
				for (var usr in active_users) {
					count++;
					usr.OPX2_INTRANET_ACCESS=usr.SAN_UA_RWE_ACTIVE_USER;  
					s_monitor_message.monitor(n_nb_user);  
				}  
			} 
			context._do_not_check_user_keys_=false;
		} 
		plw.alert(\"Restored \"+count+\"/\"+n_nb_user+\" users\");
		return n_nb_user;
	}
	else {
		plw.alert(\"Only deliverymanager is allowed to perform that action.\");
	}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 2
 :_US_AA_B_BATCH_SCRIPT "0"
 :_US_AA_D_CREATION_DATE 20230614000000
 :_US_AA_S_OWNER "E0046087"
)