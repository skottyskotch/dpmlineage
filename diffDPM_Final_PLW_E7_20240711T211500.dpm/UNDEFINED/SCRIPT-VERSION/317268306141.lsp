
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 317268306141
 :DATASET 118081000141
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
function san_rdpm_link_to_timesheet(res) {
	if(res instanceof plc.Resource) {
		res.timecard_goToFirstNotHandled(false);
		var d_date=new date();
		d_date.timecard_setDisplayDate();
	}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260067207572
 :VERSION 3
 :_US_AA_D_CREATION_DATE 20211123000000
 :_US_AA_S_OWNER "E0046087"
)