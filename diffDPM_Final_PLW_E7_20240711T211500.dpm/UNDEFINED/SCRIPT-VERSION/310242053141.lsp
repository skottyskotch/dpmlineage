
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 310242053141
 :DATASET 118081000141
 :SCRIPT-CODE "/*
* Script V2
* Autor : 
* Date Creation 26/10/2020
* JIRA : PC-4306/PC-4165 (Problem with WBS Form Data in Version) 
* Date modification 29-JUL-2021
* Add a treatement to link WBS Form data to version activities
* JIRA : PC-2473 (SAN_RDPM_BA_AUTO_SYNC_RULE batch is crashing) 
* Date modification 01-FEB-2021
* Replace (o_act.synchronize_with != undefined) by (o_act.SYNCHRONIZE_WITH instanceof plc.work_structure) in the loop to controlling if synchronize_with activity is existing and loaded
* Replace the use of inverse relation 'r.WBS_TYPE.WORK-STRUCTURE' with objectset & 'filter.fromobject()' to comply with JS2 best practices
* 
*/

namespace _san_rdpm_batch_sync;

plw.writeln(\"Start of batch SAN_RDPM_BA_AUTO_SYNC_RULE (synchronization rule)\");

// Loop on Activity types to synchronize
var list = [];
for(var o_wbstype in plc.wbs_type where o_wbstype.SAN_UA_RDPM_B_BATCH_SYNCHRO)
{
	list.push(o_wbstype);
}
// Loop on Projects: restrict loop to Active & Simulation projects only
for(var o_project in plc.project where o_project.DELETED==false  && (o_project.STATE==\"Active\" || o_project.STATE==\"Simulation\"))
{
	list.push(o_project);
}

var filter = plw.objectset(list);
with(filter.fromobject()){
	
	// Replace (o_act.synchronize_with != undefined) by (o_act.SYNCHRONIZE_WITH instanceof plc.work_structure) in the loop to controlling if synchronize_with activity is existing and loaded
	for(var o_act in plc.work_structure where o_act.SYNCHRONIZE_WITH instanceof plc.work_structure)
	{
		plw.writeln(\"Synchronization of the activity : \"+o_act.id + \" with activity : \"+ o_act.SYNCHRONIZE_WITH.id);
		o_act.callmacro(\"synchronize\");
	}
}

// Fix problem on WBS Form activities for project versions
var hash_version = new hashtable(\"STRING\");
var hash_activity =  new hashtable(\"STRING\");
var key_act;
var version_act;
var file;
// Loop on WBS Form data for which the activity is not is the same file as the WBS Form data object
for (var wbs_form_data in plc.__USER_TABLE_SAN_RDPM_UT_WBS_FORM_DATA where wbs_form_data.FILE._PM_NF_B_IS_A_VERSION && wbs_form_data.SAN_UA_WBS_FORM_DATA_ACTIVITY!=\"\" && wbs_form_data.SAN_UA_WBS_FORM_DATA_ACTIVITY.FILE!=wbs_form_data.file)
{
	file = wbs_form_data.file;
	// If the activity of the version have not been entered in the hashtable, we add it
	if (hash_version.get(file.NAME)==undefined)
	{
		with(file.fromObject())
		{
			for (var vAct in plc.workstructure)
			{
				hash_activity.set(file.NAME+\"_\"+vAct.ORIGIN_ACTIVITY.printattribute(),VAct);
			}
		}
		hash_version.set(file.NAME,\"1\");
	}
	// Calculate the key to retrieve the activity in the hashtable --> Return the activity of the version
	key_act =  file.NAME+\"_\"+wbs_form_data.SAN_UA_WBS_FORM_DATA_ACTIVITY.printattribute();
	version_act = hash_activity.get(key_act);
	// Update the activity to have the activity of the version
	if (version_act instanceof plc.workstructure)
	{
		with (plw.no_locking){
			wbs_form_data.SAN_UA_WBS_FORM_DATA_ACTIVITY=version_act;
		}
	}
}

plw.writeln(\"End of batch SAN_RDPM_BA_AUTO_SYNC_RULE (synchronization rule)\");"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260076057674
 :VERSION 7
 :_US_AA_D_CREATION_DATE 20210730000000
 :_US_AA_S_OWNER "E0296878"
)