
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321293569882
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _rdpm_pack_load_ext;
var res = plc.resource.get(\"CSC_EXT\");
var skill = plc.resourceskill.get(\"PACK\");
var vact = \"\";
var ph_exist=false;
var old_pack_load = 0;
for (var data in plc.__USER_TABLE_SAN_RDPM_UT_PACK_LOAD_IMPORT where data.SAN_RDPM_UA_S_PACK_LOAD_IMPORT_ERROR==\"\")
{
	vact = plc.workstructure.get(data.name.parsenumber(\"####\"));
	
	if (vAct instanceof plc.workstructure)
	{
		ph_exist=false;
		for(var pack_load in vAct.get(\"ALLOCATED_RESOURCES\") where pack_load.RES==res && pack_load.PRIMARY_SKILL==skill)
		{
		    old_pack_load = pack_load.TOTAL_LOAD;
			pack_load.TOTAL_LOAD=data.SAN_RDPM_UA_N_PACK_LOAD_EXT;
			ph_exist=true;
			plw.writetolog(\"Update of packload for the activity \"+ vAct.printattribute() +\" - Old value : \"+old_pack_load+\" New value : \" +pack_load.TOTAL_LOAD+ \".\");
			data.delete();
		}
		
		if (ph_exist==false)
		{
			data.SAN_RDPM_UA_S_PACK_LOAD_EXT_IMPORT_ERROR=\"There is no pack load planned hour for this activity.\";
			plw.writetolog(\"There is no pack load planned hour for the activity \"+ vAct.printattribute() +\".\");
		}
	}
	else
	{
		data.SAN_RDPM_UA_S_PACK_LOAD_EXT_IMPORT_ERROR=\"There is no activity for this ONB.\";
		plw.writetolog(\"There is no matching activity for ONB \"+ data.name +\".\");
	}	
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 321293120682
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20230119000000
 :_US_AA_S_OWNER "I0260387"
)