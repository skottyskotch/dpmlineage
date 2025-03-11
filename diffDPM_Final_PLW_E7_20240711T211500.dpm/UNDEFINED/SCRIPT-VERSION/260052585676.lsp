
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260052585676
 :DATASET 118081000141
 :SCRIPT-CODE "/*
* Script V2
* Autor : Bekkal Amine
* PC-1531 : Update TimeCard Manager by Networ Id for the resource Pharma ( Functional + no open + simu )
* Condition : Networ Id is not empty and Networ Id existe in user tabel and TimeCard Manager is empty
*/
namespace _san_rdpm_resource_update;

function san_rdpm_res_update_TimeCard_Manger_By_NetworkID(){
	
   plw.writeln(\"Appel san_rdpm_res_update_TimeCard_Manger_By_NetworkID\");
   for (var res in plc.resource where res.callbooleanformula(\"SAN_UA_RDPM_RES_TYP_PHAR and not SAN_UA_RDPM_RES_OPEN and not SAN_RDPM_B_RES_SIMU and SAN_UA_RDPM_RES_OPER <> \\\"Functional\\\"\")  )
    {
        
    	plw.writeln(\"res = \"+res);
    	if (res.SAN_UA_RDPM_NETWORK_ID !=\"\" && res.callbooleanformula(\"?OBJECT_EXISTS(\\\"USER\\\",SAN_UA_RDPM_NETWORK_ID)\") && res.MANAGER ==\"\") {
    		res.MANAGER=res.SAN_UA_RDPM_NETWORK_ID;
    		plw.writeln(\"Update Resource Name : \"+ res.name + \" Network id : \"+res.SAN_UA_RDPM_NETWORK_ID + \" TimeCard Manager : \"+res.MANAGER); 
    		plw.writeln(\"Details : SAN_UA_RDPM_RES_TYP_PHAR = \"+ res.SAN_UA_RDPM_RES_TYP_PHAR + \" SAN_UA_RDPM_RES_OPEN : \"+res.SAN_UA_RDPM_RES_OPEN + \" SAN_RDPM_B_RES_SIMU : \"+res.callbooleanformula(\"SAN_RDPM_B_RES_SIM\") + \" SAN_UA_RDPM_RES_OPER : \"+res.SAN_UA_RDPM_RES_OPER); 
    	
    
    
    	}
    }
}
san_rdpm_res_update_TimeCard_Manger_By_NetworkID();"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260052552676
 :VERSION 2
 :_US_AA_D_CREATION_DATE 20201009000000
 :_US_AA_S_OWNER "E0455451"
)