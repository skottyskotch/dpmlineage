
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321221621441
 :DATASET 118081000141
 :SCRIPT-CODE "/*
* Script V2
* Autor : Bekkal Amine
* PC-1531 : Update TimeCard Manager by Networ Id for the resource Pharma ( Functional + no open + simu )
* Condition : Networ Id is not empty and Networ Id existe in user tabel and TimeCard Manager is empty
* Date Creation : 09/10/2020 
* PC-2175 : Update Script name - 07/12/2020 
// 24/12/2020 : SAS - PC-2784  : Remove resource simulation objets.
* ABE: 09/08/2021: PC-4210 - Add additional conditions in the User & Resource association mechanism (TimeCard Manager field) Pharma + Vaccine
*                            Replace filter \"where res.SAN_UA_RDPM_RES_TYP_PHAR == true &....)\" in loop for by res.SAN_RDPM_UA_B_UPDATE_TC_MANAGER
* ABO: 30/03/2022: PC-1965 - Call the function san_redpm_res_split_abs(res) to be launched by the daily batch SAN_RDPM_BA_RES_NETWORK_ID_TC_MANAGER
*/
namespace _san_rdpm_resource_update;

function san_rdpm_res_update_TimeCard_Manager_By_NetworkID(){
    plw.writeln(\"Appel san_rdpm_res_update_TimeCard_Manager_By_NetworkID\");
   
    //var o_simu_res_file = plc.common_dataset.get(\"SAN_CF_SIMU_RES_DATA\");
    
   //* PC-4210
   /* for (var res in plc.resource where res.SAN_UA_RDPM_RES_TYP_PHAR == true &&
             res.SAN_UA_RDPM_RES_OPEN == false &&
             //res.file != o_simu_res_file &&
             res.SAN_UA_RDPM_RES_OPER != \"Functional\" &&
             res.SAN_UA_RDPM_NETWORK_ID.stringIsNotNull() &&
             res.MANAGER == \"\")
    */
    for (var res in plc.resource where res.SAN_RDPM_UA_B_UPDATE_TC_MANAGER)
    {
        var o_user = plc.opx2_user.get(res.SAN_UA_RDPM_NETWORK_ID);
        var resource_type = res.SAN_UA_RDPM_RES_TYP_PHAR ? \"PHARMA\" : \"PASTEUR\" ;
        if(o_user != undefined) {
            res.MANAGER=res.SAN_UA_RDPM_NETWORK_ID;
            plw.writeln(\"Update Resource Name : \"+ res.NAME + \"| Network ID : \"+res.SAN_UA_RDPM_NETWORK_ID + \"| TimeCard Manager : \"+res.MANAGER.NAME);
            plw.writeln(\"Details Resource => Resource Type : \"+ resource_type + \"| Open? : \"+res.SAN_UA_RDPM_RES_OPEN + \"| Simulation? : \"+res.callbooleanformula(\"SAN_RDPM_B_RES_SIMU\") + \"| Operationality : \"+res.SAN_UA_RDPM_RES_OPER
                        +\"| Availability : \"+RES.SAN_UA_RDPM_RES_PERC_AVAIL +\"| Contrat Type : \"+RES.SAN_UA_RDPM_RES_CTR_TYP.NAME); 

        }else plw.writeln(\"Impossible to update Resource Name : \" + res.NAME +\" => The User corresponding to Network ID Don't exit : \" + o_user);
    }
}
san_rdpm_res_update_TimeCard_Manager_By_NetworkID();

// Update absenses on vaccines resources
for (var res in plc.resource where res.SAN_UA_RDPM_RES_TYP_PAST && res.INACTIVE==false)
{
  _split_abs.san_redpm_res_split_abs(res);
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260052552676
 :VERSION 7
 :_US_AA_D_CREATION_DATE 20220421000000
 :_US_AA_S_OWNER "E0499298"
)