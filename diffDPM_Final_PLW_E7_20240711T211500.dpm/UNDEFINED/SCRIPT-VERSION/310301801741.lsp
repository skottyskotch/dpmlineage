
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 310301801741
 :DATASET 118081000141
 :SCRIPT-CODE "/*
* Script V2
* Autor : Bekkal Amine
* PC-1531 : Update TimeCard Manager by Networ Id for the resource Pharma ( Functional + no open + simu )
* Condition : Networ Id is not empty and Networ Id existe in user tabel and TimeCard Manager is empty
* Date Creation : 09/10/2020 
* PC-2175 : Update Script name - 07/12/2020 
// 24/12/2020 : SAS - PC-2784  : Remove resource simulation objets.
*/
namespace _san_rdpm_resource_update;

function san_rdpm_res_update_TimeCard_Manager_By_NetworkID(){
    plw.writeln(\"Appel san_rdpm_res_update_TimeCard_Manager_By_NetworkID\");
   
    //var o_simu_res_file = plc.common_dataset.get(\"SAN_CF_SIMU_RES_DATA\");

    for (var res in plc.resource where res.SAN_UA_RDPM_RES_TYP_PHAR == true &&
             res.SAN_UA_RDPM_RES_OPEN == false &&
             //res.file != o_simu_res_file &&
             res.SAN_UA_RDPM_RES_OPER != \"Functional\" &&
             res.SAN_UA_RDPM_NETWORK_ID.stringIsNotNull() &&
             res.MANAGER == \"\")
    {
        plw.writeln(\"res = \" + res);
        var o_user = plc.opx2_user.get(res.SAN_UA_RDPM_NETWORK_ID);
        plw.writeln(\"o_user = \" + o_user);
        if(o_user != undefined) {
            res.MANAGER=res.SAN_UA_RDPM_NETWORK_ID;
            plw.writeln(\"Update Resource Name : \"+ res.name + \" Network id : \"+res.SAN_UA_RDPM_NETWORK_ID + \" TimeCard Manager : \"+res.MANAGER);
            plw.writeln(\"Details : SAN_UA_RDPM_RES_TYP_PHAR = \"+ res.SAN_UA_RDPM_RES_TYP_PHAR + \" SAN_UA_RDPM_RES_OPEN : \"+res.SAN_UA_RDPM_RES_OPEN + \" SAN_RDPM_B_RES_SIMU : \"+res.callbooleanformula(\"SAN_RDPM_B_RES_SIMU\") + \" SAN_UA_RDPM_RES_OPER : \"+res.SAN_UA_RDPM_RES_OPER);
        }
    }
}
san_rdpm_res_update_TimeCard_Manager_By_NetworkID();"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260052552676
 :VERSION 5
 :_US_AA_D_CREATION_DATE 20210810000000
 :_US_AA_S_OWNER "E0455451"
)