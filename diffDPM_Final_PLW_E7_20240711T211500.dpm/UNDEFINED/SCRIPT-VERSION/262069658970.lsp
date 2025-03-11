
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 262069658970
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _san_rdpm_dyn_attribute;

// dynamic attribute will be used to retrieve corresponding date and type on each Indication project

function san_next_milestone_prj_slot_reader()
{
	var result=0;
	var prj=this;
	var wbs_ind=undefined;
	
	// retrieve top level activity
	var tlws = prj.getlistofrootws();
    if ( tlws instanceof list && 
		tlws.length > 0 && 
		tlws[0] instanceof plc.workstructure){
		wbs_ind = tlws[0];
	}
	
	if (wbs_ind.SAN_UA_B_ACT_IS_LEAD_INDICATION) {
		// WBS_TYPE are project objective type if its reporting milestone type is \"Project Objective\"
		var o_proj_obj = plc.__USER_TABLE_SAN_RDPM_UT_REPORT_MILE_TYPE.get(plc._L1_PT_SETTINGS.get(\"SAN_RDPM_CS_PROJECT_OBJECTIVE\").get(\"_L1_AA_S_CUST_SETTING \"));
			for (var o_wbstype in o_proj_obj.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_AT_REPORT_MILE_TYPE\")) {
			with (o_wbstype.fromobject()) {
				for (var ms in plc.task where (ms.PROJECT==prj && ms.AF==undefined) order by [\"PS\"]) {
				return ms.onb;
				}
			}
		}
	}
	return result;
}

function san_next_milestone_create_prj_dynamic_attribute(){
	try{
		var slot = new objectAttribute(plc.project,\"SAN_RDPM_DA_PRJ_NEXT_MILESTONE_ONB\",\"NUMBER\");
		slot.Comment = \"[DynAtt project] Next milestone ONB\";
		slot.Reader = san_next_milestone_prj_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot due to error: \" + e);
	}
}

try{
	with(plw.no_locking){
		san_next_milestone_create_prj_dynamic_attribute();
	}
}
catch (error e){
	plw.writeToLog(\"Failed to create SAN_RDPM_DA_PRJ_NEXT_MILESTONE_ONB\");
	plw.writeln(e);
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 262044406270
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20201211000000
 :_US_AA_S_OWNER "E0431201"
)