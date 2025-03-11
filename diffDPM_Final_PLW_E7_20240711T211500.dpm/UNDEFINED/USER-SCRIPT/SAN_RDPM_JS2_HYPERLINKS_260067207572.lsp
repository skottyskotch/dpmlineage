
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 260067207572
 :NAME "SAN_RDPM_JS2_HYPERLINKS"
 :COMMENT "RDPM Hyperlinks"
 :ACTIVE T
 :DATASET 118081000141
 :EVAL-ON-LOAD T
 :LOAD-ORDER 0
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_HYPERLINK
// 
//  AUTHOR  : S. AKAAYOUS
//
//  
//  Creation  2020/10/13 SAK
//  Script used for PC-208, add the function resource link to timecard input
//  
//  2021/02/05 EP update to E7 compliancy
//***************************************************************************/

namespace _san_rdpm_hyperlink;
/**
	Function called in the Hyperlinks : 142732436341-142732436941
*/
//
function san_rdpm_link_to_timesheet(res) {
	if(res instanceof plc.Resource) {
		res.timecard_goToFirstNotHandled(false);
		var d_date=new date();
		d_date.timecard_setDisplayDate();
	}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 4
 :_US_AA_B_BATCH_SCRIPT "0"
 :_US_AA_D_CREATION_DATE 20201013000000
 :_US_AA_S_OWNER "intranet"
)