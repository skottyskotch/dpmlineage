
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 262016228476
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _san_rdpm_batch_sync;
// List all activities 
var v_act_vect = new vector();
for(var o_act_type in plc.wbs_type where o_act_type.SAN_UA_RDPM_B_BATCH_SYNCHRO)
{
	// Restrict loop to Active & Simulation projects only
	for(var o_act in o_act_type.get(\"r.WBS_TYPE.WORK-STRUCTURE\") where o_act.SYNCHRONIZE_WITH!=undefined && o_act.PROJECT.DELETED==false  && (o_act.PROJECT.STATE==\"Active\" || o_act.PROJECT.STATE==\"Simulation\"))
	{
		o_act.callmacro(\"synchronize\");
	}

}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260076057674
 :VERSION 2
 :_US_AA_D_CREATION_DATE 20201204000000
 :_US_AA_S_OWNER "E0455451"
)