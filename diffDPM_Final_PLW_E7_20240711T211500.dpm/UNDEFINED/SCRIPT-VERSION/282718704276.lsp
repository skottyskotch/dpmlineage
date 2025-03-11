
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 282718704276
 :DATASET 118081000141
 :SCRIPT-CODE "/*
* Script V2 Name : SAN_RDPM_JS2_ACTIVITY_STATE_UPDATE

* 28-DEC-20 ABE V2.00  PC-2469 : Update filter to exclude non relevant projects from the treatment (permanent projects, templates, Simulation)
* 02-OCT-20 MDO V1.02 Update filter testing pharma project type
* 15-SEP-20 MDO V1.01 Update for filter with new datasets
* 03-MAR-20 HRA V1.00 Creation of script(RDPM Update Activity STATE for time tracking)
*/
namespace _san_rdpm_activity_state_update;

for (var act in plc.work_structure where act.callbooleanformula(\"PROJECT.SAN_RDPM_B_RND_PHARMA_PROJECT AND PROJECT._INF_NF_S_PRJ_STATE_INTERNAL  =\\\"ACTIVE\\\" AND PROJECT._INF_NF_B_IS_TEMPLATE <> TRUE AND PROJECT._WZD_AA_B_PERMANENT <> TRUE \")) {
	//Pharma activity state update script
	plw.writetolog(\"Pharma activity state update script on :\"+act.name);
	if (act.SAN_UA_RDPM_B_UPDATE_ACTIVITY_STATE_TO_OPEN) {
		act.state = \"Open\";
		plw.writetolog(act.name+\" updated to Open\");
	}
	if (act.SAN_UA_RDPM_B_UPDATE_ACTIVITY_STATE_TO_CLOSED) {
		act.state = \"Closed\";
		plw.writetolog(act.name+\" updated to Closed\");
	}		
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 282704454676
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20210202000000
 :_US_AA_S_OWNER "E0455451"
)