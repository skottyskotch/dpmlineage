
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260019829871
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
        san_create_dynamic_attribute(plc.work_structure, \"SAN_RDPM_DA_DATA_CAPTURE\", plc.__USER_TABLE_SAN_RDPM_UT_DATA_CAPTURE, \"Data Capture\", san_wbs_cascading_datacapture_slot_reader, san_wbs_cascading_datacapture_slot_modifier, san_field_slot_locker);
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
    return san_wbs_cascading_slot_reader(\"SAN_RDPM_DA_DATA_CAPTURE\",\"SAN_RDPM_UA_DATA_CAPTURE_DASTORE\",\"STRING\");
}

//Modifier for spec field
//san_wbs_cascading_myfield_slot_modifier
function san_wbs_cascading_datacapture_slot_modifier(value) {
    san_wbs_cascading_slot_modifier(\"SAN_RDPM_UA_DATA_CAPTURE_DASTORE\", value);
}

//*******************Sourcing Model

function san_wbs_cascading_sourcingmodel_slot_reader() {
    return san_wbs_cascading_slot_reader(\"SAN_RDPM_DA_SOURCING_MODEL\",\"SAN_RDPM_UA_SOURCING_MODEL_DASTORE\",\"STRING\");
}

function san_wbs_cascading_sourcingmodel_slot_modifier(value) {
    san_wbs_cascading_slot_modifier(\"SAN_RDPM_UA_SOURCING_MODEL_DASTORE\", value);
}

try{
    with(plw.no_locking){
        san_create_dynamic_attribute(plc.work_structure, \"SAN_RDPM_DA_SOURCING_MODEL\", plc.__USER_TABLE_SAN_RDPM_UT_SOURCING_MODEL, \"Sourcing Model\", san_wbs_cascading_sourcingmodel_slot_reader, san_wbs_cascading_sourcingmodel_slot_modifier, san_field_slot_locker);
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create Sourcing Model\");
    plw.writeln(e);
}

//*******************Study Scope

function san_wbs_cascading_studyscope_slot_reader() {
    return san_wbs_cascading_slot_reader(\"SAN_RDPM_DA_STUDY_SCOPE\",\"SAN_RDPM_UA_STUDY_SCOPE_DASTORE\",\"STRING\");
}

function san_wbs_cascading_studyscope_slot_modifier(value) {
    san_wbs_cascading_slot_modifier(\"SAN_RDPM_UA_STUDY_SCOPE_DASTORE\", value);
}

try{
    with(plw.no_locking){
        san_create_dynamic_attribute(plc.work_structure, \"SAN_RDPM_DA_STUDY_SCOPE\", plc.__USER_TABLE_SAN_RDPM_UT_STUDY_SCOPE, \"Study Scope\", san_wbs_cascading_studyscope_slot_reader, san_wbs_cascading_studyscope_slot_modifier, san_field_slot_locker);
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create Study Scope\");
    plw.writeln(e);
}

//*******************Average Visits

function san_wbs_cascading_averagevisits_slot_reader() {
    return san_wbs_cascading_slot_reader(\"SAN_RDPM_DA_AVERAGE_VISITS\",\"SAN_RDPM_UA_AVERAGE_VISITS_DASTORE\",\"NUMBER\");
}

function san_wbs_cascading_averagevisits_slot_modifier(value) {
    san_wbs_cascading_slot_modifier(\"SAN_RDPM_UA_AVERAGE_VISITS_DASTORE\", value);
}

try{
    with(plw.no_locking){
        san_create_dynamic_attribute(plc.work_structure, \"SAN_RDPM_DA_AVERAGE_VISITS\", \"NUMBER\", \"Average number of visists\", san_wbs_cascading_averagevisits_slot_reader, san_wbs_cascading_averagevisits_slot_modifier, san_field_slot_locker);
    }
}
catch (error e){
    plw.writeToLog(\"Failed to create Average number of visists\");
    plw.writeln(e);
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 0
 :VERSION 2
 :_US_AA_D_CREATION_DATE 20200923000000
 :_US_AA_S_OWNER "E0431101"
)