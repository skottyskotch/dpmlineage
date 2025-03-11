
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260019719871
 :DATASET 118081000141
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_RDPM_DA_CLINICAL_TAB_STUDY
//
//  AUTHOR  : Manuel DOUILLET
//
//
//  Creation : 2020/09/22 MDO
//  Script used to create dynamic attributes for fields of the clinical tab in the study pop-up
//
//***************************************************************************/

//*************************
namespace _san_rdpm_dyn_attribute;
//**************************

//Create specific DA using generic creator
try{
    with(plw.no_locking){
        san_create_dynamic_attribute(plc.work_structure, \"SAN_RDPM_DA_DATA_CAPTURE\", \"plc.__USER_TABLE_SAN_RDPM_UT_DATA_CAPTURE\", \"Data Capture\", san_wbs_cascading_datacapture_slot_reader, san_wbs_cascading_datacapture_slot_modifier, san_field_slot_locker);
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create Data Capture\");
    plw.writeln(e);
}

// 

//Reader for spec field
//san_wbs_cascading_myfield_slot_reader
function san_wbs_cascading_datacapture_slot_reader() {
    return san_wbs_cascading_slot_reader(\"SAN_RDPM_DA_DATA_CAPTURE\",\"SAN_RDPM_UA_DATA_CAPTURE_DASTORE\",\"plc.__USER_TABLE_SAN_RDPM_UT_DATA_CAPTURE\");
}

//Modifier for spec field
//san_wbs_cascading_myfield_slot_modifier
function san_wbs_cascading_datacapture_slot_modifier(value) {
    san_wbs_cascading_slot_modifier(\"SAN_RDPM_UA_DATA_CAPTURE_DASTORE\", value);
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 0
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20200922000000
 :_US_AA_S_OWNER "E0431101"
)