
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 262018868676
 :DATASET 118081000141
 :SCRIPT-CODE "/*
* Script V2
* Autor : 
* JIRA : PC-2473  (SAN_RDPM_BA_AUTO_SYNC_RULE batch is crashing)
* Date Creation 26/10/2020
* Date Modification 04/12/2020
*/

namespace _san_rdpm_batch_sync;
// List all activities 
var v_act_vect = new vector();
plw.writeln(\"Start of batch SAN_RDPM_BA_AUTO_SYNC_RULE (synchronization rule)\");
for(var o_act_type in plc.wbs_type where o_act_type.SAN_UA_RDPM_B_BATCH_SYNCHRO)
{
	// Restrict loop to Active & Simulation projects only
	for(var o_act in o_act_type.get(\"r.WBS_TYPE.WORK-STRUCTURE\") where o_act.SYNCHRONIZE_WITH!=undefined && o_act.PROJECT.DELETED==false  && (o_act.PROJECT.STATE==\"Active\" || o_act.PROJECT.STATE==\"Simulation\"))
	{
	    plw.writeln(\"Synchronization of the activity : \"+o_act.id + \" with activity : \"+ o_act.SYNCHRONIZE_WITH.id);
		o_act.callmacro(\"synchronize\");
	}

}
plw.writeln(\"End of batch SAN_RDPM_BA_AUTO_SYNC_RULE (synchronization rule)\");"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260076057674
 :VERSION 3
 :_US_AA_D_CREATION_DATE 20201207000000
 :_US_AA_S_OWNER "E0455451"
)