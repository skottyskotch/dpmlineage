
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321257831341
 :DATASET 118081000141
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

_updateuser.LastConnectionDate();"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 283130866141
 :VERSION 0
 :_US_AA_D_CREATION_DATE 20220909000000
 :_US_AA_S_OWNER "E0477351"
)