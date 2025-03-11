
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 321210354776
 :NAME "SAN_RDPM_JS2_ACCESS_RIGHT_USER"
 :COMMENT "Script used by batch to configurate access rights for non-Prod & non-Pre-Prod environments"
 :ACTIVE T
 :DATASET 118081000141
 :LOAD-ORDER 0
 :SCRIPT-CODE "/*
* Script V2
* Autor : Amine Bekkal
* JIRA : PC-5935  Automate configuration access rights for non-Prod & non-Pre-Prod environments
*				  The script add the tick Admin and the group R_ITS_ADMIN on users that are ticked “Grant Admin Rights”
*           
* Date Creation 05/04/2022
*/
namespace _san_access_rgight_user;
 

plw.writeln(\"Start _san_access_rgight_user .... \");
try{
	if( ! Context.SAN_RDPM_UA_B_OC_PREPROD_PROD_ENV){
		plw.writeln(\"The environment is Pre Prod / Prod: \"  + Context.SAN_RDPM_UA_B_OC_PREPROD_PROD_ENV);
		var Group_List = new vector();
		for (var o_user in plc.opx2_user where o_user.SAN_RDPM_UA_B_USER_ADMIN_NON_PROD_ENV && o_user.get(\"?ADMIN\")!=true && o_user.INACTIVE!=true  && o_user.GROUPS_LIST !=\"\")
		{					
				Group_List.clear();
				Group_List=o_user.GROUPS_LIST.parselist(\",\");
				plw.writeln(\"Before update user : \"+ o_user.name + \"is Admin ? : \"+ o_user.get(\"?ADMIN\") + \" with User group ! \"+o_user.GROUPS_LIST);
				if(Group_List.position(\"R_ITS_ADMIN\")==undefined) {
						Group_List.push(\"R_ITS_ADMIN\");		
						o_user.GROUPS_LIST=Group_List.removeduplicates().join(\",\");
				}
				o_user.set(\"?ADMIN\",true);
				plw.writeln(\"After update user : \"+ o_user.name + \"is Admin ? : \"+ o_user.get(\"?ADMIN\") + \" with User group ! \"+o_user.GROUPS_LIST);
		}
				
	}else {
		plw.writeln(\"The environment is PreProd / Prod: \"  + Context.SAN_RDPM_UA_B_OC_PREPROD_PROD_ENV);
		
	}
plw.writeln(\"End _san_access_rgight_user .... \");
}
catch(error e) { 
	
		plw.writeln(\"Exception catched.... ==> ~s\"+e);
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 4
 :_US_AA_B_BATCH_SCRIPT "1"
 :_US_AA_D_CREATION_DATE 20220405000000
 :_US_AA_S_OWNER "E0455451"
)