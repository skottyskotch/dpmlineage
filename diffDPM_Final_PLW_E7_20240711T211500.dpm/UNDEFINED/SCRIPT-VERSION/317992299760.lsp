
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 317992299760
 :DATASET 143484010274
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_CONTINUUM_JS2_RDD_BATCH
//  RDD functions for Continuum success rate and weigthing
//
//  v1.0 - 2021/06/16 - William
//
//***************************************************************************/
namespace _san_rdd_success_rate_weigthing_macro_on_dataset;
var modify_object = true;

var list = new vector();
with([plw.no_locking,plw.no_alerts]) {
	for (var prj in plc.project where prj.OPEN) {
		plw.writeln(\"Project : \"+ prj);
		with(prj.out()) {
			for (var act in plc.work_structure) {
				if (act.SAN_RDPM_UA_N_SR != 0) {
					if(act.SAN_RDPM_UA_B_OLD_BRANCH_FILTER_F) {
						if (modify_object) {
							act.SAN_RDPM_UA_N_SR =0;
						}
					}
					else if (act.SAN_RDPM_UA_ACT_S_INDICATION != \"\" && act.SAN_RDPM_UA_PHASE_ONB != 0 && act._PAC_NF_B_PHASE == false) {
						var phase = plc.workstructure.get(act.SAN_RDPM_UA_PHASE_ONB);
						if (modify_object) {
							act.SAN_RDPM_UA_N_SR =0;
						}
						if (phase instanceof plc.workstructure && act.WEIGHT != phase.WEIGHT) {
							if (modify_object) {
								act.COST_WEIGHT =phase.WEIGHT;
							}							
						}
					}
				}
				if (act.WEIGHT != 1) {
					if(act.SAN_RDPM_UA_B_OLD_BRANCH_FILTER_F) {
						if (modify_object) {
							act.COST_WEIGHT =1;
						}
					}
					else if (act.SAN_RDPM_UA_ACT_S_INDICATION != \"\" && act.SAN_RDPM_UA_PHASE_ONB != 0 && act._PAC_NF_B_PHASE == false) {
						var phase = plc.workstructure.get(act.SAN_RDPM_UA_PHASE_ONB);
						if (phase instanceof plc.workstructure && act.WEIGHT != phase.WEIGHT) {
							if (modify_object) {
								act.COST_WEIGHT =phase.WEIGHT;
							}							
						}
					}
				}
				if (act.WBS_TYPE.NAME == \"OTHER\") {
					plw.writeln(\"OTHER :\" + act);
					list.push(act.ONB);
				}
			}
			for (var onb in list) {
				var act_other = plc.workstructure.get(onb);
				if (act_other instanceof plc.workstructure) {
					with(act_other.fromobject()) {
						for (var act in plc.work_structure) {
							if(act.SAN_RDPM_UA_N_SR != 0) {
								if (modify_object) {
									act.SAN_RDPM_UA_N_SR =0;
								}						
							}
							if(act.WEIGHT != 1) {
								if (modify_object) {
									act.COST_WEIGHT =1;
								}
							}
						}
					}
				}
			}
		}
	}
}
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 317703832660
 :VERSION 0
 :_US_AA_D_CREATION_DATE 20211104000000
 :_US_AA_S_OWNER "E0477351"
)