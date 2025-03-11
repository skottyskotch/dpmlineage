
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 283130866141
 :NAME "SAN_CONTINUUM_JS2_USER_LAST_CON"
 :COMMENT "User last connection batch"
 :ACTIVE T
 :DATASET 118081000141
 :LOAD-ORDER 0
 :SCRIPT-CODE "// PLWSCRIPT : updateuser
namespace _updateuser;

function LastConnectionDate(){
	
	// Compute where condition to retrieve all user connected yesterday
	var string s_date = context.callstringformula(\"PRINT_DATE(DATE_ADDTIMEUNIT($DATE_OF_THE_DAY,-1,\\\"DAY\\\"),\\\"DD-MM-YYYY\\\")\");
	var date d_date = new date(s_date,\"DD-MM-YYYY\");
	var string s_whereclause = \"whatnoun = 'starting new session' and opx2_when like '\"+s_date+\"T%'\";
	plw.writeln(\"Date of the SAN_BA_USR_LAST_CON batch executing - \"+d_date);
	plw.writeln(\"w7_log whereclause - \"+s_whereclause);

	// Fetch the w7_log table to retrieve all user connected yesterday
	var v_vector = new vector();
	v_vector = plw.SqlSelect(\"w7_log\",[\"distinct(whorealname)\"],[\"string\"],s_whereclause);

	// Update user table with last connection date
	for (var v_user in v_vector){
		var o_user = \"OpxUser\".get(v_user[0]);
		if( o_user instanceof plc.Opx2_User){
			
			plw.writeln(\"Last Connection Date of \" +o_user.NAME+\" : \"+d_date); //example
			//create a user attribute on user class to store the last connection date
			with(plw.no_locking){o_user.SAN_UA_D_USR_LAST_CON = d_date;}
		}
	}
	return true;
}

_updateuser.LastConnectionDate();

// Frequency : 15 day of every month
var boolean vCheqF=_san_continuum.san_js_check_run_batch(\"monthly\",arg2:1,arg3:[15]);
if (vCheqF==true)
{
	var vListProj=new vector();
	var string vIdPort=\"NV\";
	var vPortfolio=plc._FF_PT_FAVOR_FILTERS.get(vIdPort);
	for(var o_Proj in vPortfolio.get(\"PROJECTS\") where o_Proj.LEVEL==1 && o_Proj._INF_NF_S_PRJ_STATE_INTERNAL==\"ACTIVE\" && o_Proj.SAN_RDPM_UA_PRJ_RND_PRJ_VAC) {vListProj.push(o_Proj);}
	for (var proj in vListProj) {
		with(proj.fromobject()) {
			for (var vAct in plc.workstructure )
			{
				if (vAct.SAN_RDPM_UA_ACT_S_REPORT_MILE_TYPE != \"\") {
					plw.writetolog(vAct.printattribute()+\" Milestone comment emptied, OLD value: \"+vAct.SAN_RDPM_UA_KMS_COMMENTS);
					with(plw.no_locking){vAct.SAN_RDPM_UA_KMS_COMMENTS = \"\";}
				}		
			}
		}
	}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 1
 :_US_AA_B_BATCH_SCRIPT "1"
 :_US_AA_D_CREATION_DATE 20210226000000
 :_US_AA_S_OWNER "intranet"
)