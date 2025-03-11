
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 258986551174
 :DATASET 118081000141
 :SCRIPT-CODE "// Finalize block creation
namespace _rdpm;

function san_rdpm_finalize_project_block(project)
{
	var project_block;
	var project_block_name;
	var top_level_act;
	//var msg = \"Creating project blocks...\";
	//var length = 10;

	with(project.fromobject())
	{
		//with (plw.monitoring(title: msg, steps: length))
		//{
			for (var plc.network vAct in plc.network where vAct.SAN_RDPM_UA_ACT_S_BLOCK_PROJECT_NAME!=\"\" &&  vAct.SAN_RDPM_UA_B_BLOCK_FINALIZED==false order by ['LEVEL'])
			{
				//msg.monitor(length);
				project_block_name = vAct.PROJECT.SAN_RDPM_UA_PRJ_S_ROOT_PROJECT + \"_\" +vAct.SAN_RDPM_UA_ACT_S_BLOCK_PROJECT_NAME;
				//var message = \"Creating project  :  \" + project_block_name;
				//message.monitor(i);
				
				var parent_project = vAct.project;
				
				project_block = new plc.ordo_project(name : project_block_name,
												comment : vAct.comment,
												Project_Type : vAct.SAN_RDPM_UA_ACT_DC_BLOCK,
												parent: parent_project,
												list_of_providers : parent_project.list_of_providers
												 );
												 
				with(project_block.fromobject()){
					for (var each in plc.network where each.IS_TOP_LEVEL){
						top_level_act=each;break;
					}
				}
				with(plw.no_locking){top_level_act.network=vAct.network;}
				vAct.network = top_level_act;
				
				with(plw.no_locking){vAct.SAN_RDPM_UA_B_BLOCK_FINALIZED=true;}

			}
		//}
	}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 0
 :VERSION 0
 :_US_AA_D_CREATION_DATE 20200903000000
 :_US_AA_S_OWNER "E0296878"
)