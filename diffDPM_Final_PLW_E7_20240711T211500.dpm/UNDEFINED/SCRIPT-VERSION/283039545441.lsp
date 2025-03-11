
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 283039545441
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_HYPERLINK
// 
//  AUTHOR  : S. AKAAYOUS
//
//  
//  Creation  2020/10/13 SAK
//  Script used for PC 208, add the function resource link to timecard input.
//
//***************************************************************************/

namespace _san_rdpm_hyperlink;
/**
	Function called in the Hyperlinks : 142732436341-142732436941
*/
function san_rdpm_link_to_timesheet(res) {
  if(res instanceof plc.Resource) {
    var dateNumber = plw._tc_find_first_sd (res);
    var tc = plw._GetOrCreateTimeCard(res.onb,dateNumber,false);
    plw._tc_set_current_tc(tc);
    if(tc instanceof plc.TimeCard) {
      plw.user_rights(tc);
      plw._get_tc_on_new_applet();
    }
  var d_date = new date();  
  context._TC_AA_D_TC_SD_TO_DISPLAY = d_date;  
  plw._tc_change_date();
  }
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260067207572
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20210201000000
 :_US_AA_S_OWNER "E0323871"
)