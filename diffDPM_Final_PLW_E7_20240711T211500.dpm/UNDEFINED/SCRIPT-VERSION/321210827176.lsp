
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321210827176
 :DATASET 118081000141
 :SCRIPT-CODE "/*
* Script V2
* Autor : Amine Bekkal
* JIRA : PC-5935  (Automate configuration access rights for non-Prod & non-Pre-Prod environments)
* Date Creation 05/04/2022
*/
namespace _san_access_rgight_user;

// The script add the tick Admin and the group R_ITS_ADMIN on users that are ticked “Grant Admin Rights”

plw.writeln(\"Start _san_access_rgight_user .... \");
try{
	if( ! Context.SAN_RDPM_UA_B_OC_PREPROD_PROD_ENV){
		plw.writeln(\"The environment is not Pre Prod / Prod: \"  + Context.SAN_RDPM_UA_B_OC_PREPROD_PROD_ENV);

		for (var o_user in plc.opx2_user where o_user.callbooleanformula(\"?ADMIN = FALSE AND INACTIVE =FALSE \") && o_user.GROUPS_LIST !=\"\")
		{	
				var Group_List = new vector();
				Group_List.clear();
				Group_List=o_user.GROUPS_LIST.parselist(\",\");			
				if(Group_List.position(\"R_ITS_ADMIN\")==undefined) {
						Group_List.push(\"R_ITS_ADMIN\");				
				}
				o_user.set(\"?ADMIN\",true);
				o_user.GROUPS_LIST=Group_List.removeduplicates().join(\",\");
				plw.writeln(o_user.name + \"=> Admin ? : \"+ o_user.get(\"?ADMIN\") + \" User group ! \"+o_user.GROUPS_LIST);
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
 :USER-SCRIPT 321210354776
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20220405000000
 :_US_AA_S_OWNER "E0455451"
)