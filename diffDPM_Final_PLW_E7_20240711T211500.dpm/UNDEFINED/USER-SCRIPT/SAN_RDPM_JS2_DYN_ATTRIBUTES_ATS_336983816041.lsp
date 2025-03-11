
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 336983816041
 :NAME "SAN_RDPM_JS2_DYN_ATTRIBUTES_ATS"
 :COMMENT "Dyn attributes & relation for activity tracking statistics report"
 :ACTIVE T
 :DATASET 118081000141
 :EVAL-ON-LOAD T
 :LOAD-ORDER 0
 :SCRIPT-CODE "// PC-6800
namespace _ats;

// Dynamic relation to map all children resources (using native ALL-CHILDREN relation is too consuming and leads to some errors
var Objectrelation = plw.Getslotbyid(this : plc.resource , \"SAN_DR_ALL_CHILD_RESOURCE\");
if(!(Objectrelation instanceof objectrelation)){
	Objectrelation = new ObjectRelation(plc.resource,\"SAN_DR_ALL_CHILD_RESOURCE\");
	Objectrelation.comment=\"All children resources\";
	Objectrelation.connectedtoclass = plc.resource;
	Objectrelation.Mapmethod = function (f) {
		var mother=this;
		with(mother.fromobject()) {
			for (var child_res in plc.resource where child_res!=mother) {
				f.call(child_res);
			}
		}
	};
}

// Dynamic attribute returning the number of validated+integrated tc for the resource or all of its children
// previously user attribute :
// IF _INF_AA_B_GENERIC_RES THEN  ITER_NUMBER_SUM(\"ALL_CHILDREN\",\"NOT _INF_AA_B_GENERIC_RES\",\"SAN_RDPM_UA_N_ATS_NB_TC_VALIDATED\") ELSE  ITER_NUMBER_SUM(\"VALIDATED-TIME-CARDS \",\"SAN_RDPM_UA_B_ATS_TC_FILTER\",\"1\") + ITER_NUMBER_SUM(\"INTEGRATED-TIME-CARDS\",\"SAN_RDPM_UA_B_ATS_TC_FILTER\",\"1\") FI
function san_get_nb_tc_validated_slot_reader() {
	var result=0;
	var res=this;
	
	if (res!=undefined) {
		with(res.fromobject()) {
			for (var child in plc.resource where child.SAN_RDPM_UA_B_ATS_IND_RES_FILTER) {
				for (var tc in child.time_cards) {
					if (tc instanceOf plc.timecard && (tc.status==\"Validated\" || tc.status==\"Integrated\") && tc.SAN_RDPM_UA_B_ATS_TC_IN_PERIOD) {
						result++;
					}
					
				}
			}
		}
	}
	return result;
}

function san_create_nb_tc_validated_dynamic_attribute(){
	try{
		var slot = new objectAttribute(plc.resource,\"SAN_DA_NB_TC_VALIDATED\",\"NUMBER\");
		slot.Comment = \"[DA] Nb TC validated in period\";
		slot.Reader = san_get_nb_tc_validated_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
	slot.connecting = false;
}
catch(error e){
	plw.writeln(\"Could not create slot SAN_DA_NB_TC_VALIDATED due to error: \" + e);
}
}

try{
	with(plw.no_locking){
		san_create_nb_tc_validated_dynamic_attribute();
	}
}
catch (error e){
	plw.writeToLog(\"Failed to create SAN_DA_NB_TC_VALIDATED\");
	plw.writeln(e);
}

// Dynamic attribute returning the number of integrated tc for the resource or all of its children
// previously user attribute :
// IF _INF_AA_B_GENERIC_RES THEN 	ITER_NUMBER_SUM(\"ALL_CHILDREN\",\"NOT _INF_AA_B_GENERIC_RES\",\"SAN_RDPM_UA_N_ATS_NB_TC_INTEGRATED\") ELSE 	ITER_NUMBER_SUM(\"INTEGRATED-TIME-CARDS\",\"SAN_RDPM_UA_B_ATS_TC_FILTER\",\"1\")  FI

function san_get_nb_tc_integrated_slot_reader() {
	var result=0;
	var res=this;
	
	if (res!=undefined) {
		with(res.fromobject()) {
			for (var child in plc.resource where child.SAN_RDPM_UA_B_ATS_IND_RES_FILTER) {
				for (var tc in child.time_cards) {
					if (tc instanceOf plc.timecard && tc.status==\"Integrated\" && tc.SAN_RDPM_UA_B_ATS_TC_IN_PERIOD) {
						result++;
					}
					
				}
			}
		}
	}
	return result;
}

function san_create_nb_tc_integrated_dynamic_attribute(){
	try{
		var slot = new objectAttribute(plc.resource,\"SAN_DA_NB_TC_INTEGRATED\",\"NUMBER\");
		slot.Comment = \"[DA] Nb TC integrated in period\";
		slot.Reader = san_get_nb_tc_integrated_slot_reader;
		slot.Locker = true;
		slot.hiddenInIntranetServer = true;
		slot.connecting = false;
	}
	catch(error e){
		plw.writeln(\"Could not create slot SAN_DA_NB_TC_INTEGRATED due to error: \" + e);
	}
}

try{
	with(plw.no_locking){
		san_create_nb_tc_integrated_dynamic_attribute();
	}
}
catch (error e){
	plw.writeToLog(\"Failed to create SAN_DA_NB_TC_INTEGRATED\");
	plw.writeln(e);
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 1
 :_US_AA_B_BATCH_SCRIPT "0"
 :_US_AA_D_CREATION_DATE 20230713000000
 :_US_AA_S_OWNER "intranet"
)