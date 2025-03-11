
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260073380874
 :DATASET 118081000141
 :SCRIPT-CODE "/* Recreate synchro links inside building block
Activity 
	- Synchro_with (Template activity) --> Activity Type
	- Building block
From (Building block, Activity type) --> New activity to synchronize_with */

namespace _rdpm;
function san_rdpm_pjs_recreate_building_block_sync_links(selection)
{
	var building_block;
	var sync_act_type;
	var act_target;

	with(selection.fromobject()){
		for (var vAct in plc.workstructure where vAct.SYNCHRONIZE_WITH!=\"\")
		{
			act_target=\"\";
			sync_act_type = vAct.SYNCHRONIZE_WITH.WBS_TYPE;
			building_block = plc.workstructure.get(vAct.SAN_UA_RDPM_ACT_S_BUILD_BLOCK_ID);
			if (building_block instanceof plc.workstructure)
			{
				// Search of activities from Building Block and sync activity type
				var list = [];
				list.push(sync_act_type);
				list.push(building_block);
				var filter = plw.objectset(list);
				with(filter.fromobject()){
					for (var vAct_bb in plc.workstructure){
						act_target=vAct_bb;
					}
				}
			}
		}
	}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 0
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20201026000000
 :_US_AA_S_OWNER "E0296878"
)