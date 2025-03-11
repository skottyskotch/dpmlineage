
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321319706382
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _rdpm_recreate_links_gci;
function _rdpm_auto_link_gci_assay_gci_lab_tasks_batch(){
	
	var oProjectTypeParent = plc.project_type.Get(\"Continuum.RDPM.Pasteur\");
	var vPrj = [];
	with(oProjectTypeParent.fromobject()){
		for (var oProjectType in plc.project_type) {
			if (oProjectType.projects != undefined) vPrj += oProjectType.projects.parsevector();
		}
	}
	

	with (plw.monitoring(title: \"Identify GCI tasks for links creation\", steps: vPrj.length)){
		for (var oPrj in vPrj){
			with (oPrj.fromobject()){
				for (var o_gcilab in plc.workstructure) {
					if 	(o_gcilab instanceof plc.work_structure && o_gcilab.SAN_RDPM_UA_B_IS_THERE_V_S_GCI_LAB==true){
							var b_contains_gci_assay_task = false;
							with(o_gcilab.fromObject()){
							for (var o_act in plc.work_structure){
							if(o_act.WBS_TYPE.printattribute() in ['V_S_SAMP-E','V_SAMP-S','V_ASSAY','V_ASSAY_EXT','Release date']){b_contains_gci_assay_task = true;}
							}
							}
							if(o_gcilab.SAN_RDPM_UA_ACT_B_PRJL==false && b_contains_gci_assay_task){
								for (var o_link_template in plc.__USER_TABLE_SAN_RDPM_UT_AUTO_LINKS){
								_rdpm_recreate_links_gci(o_gcilab, o_link_template);
								}
							plw.alert('Links successfully created');
							}
						else{
						plw.alert('Link between GCI Assay Tasks and samples cannot be performed');
						}
					}
				}
			}		
		}
	}	
}

namespace _rdpm_recreate_links_gci_batch;
_rdpm_recreate_links_gci._rdpm_auto_link_gci_assay_gci_lab_tasks_batch();"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 321319666982
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20240208000000
 :_US_AA_S_OWNER "E0434229"
)