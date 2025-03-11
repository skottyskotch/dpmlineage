
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260006931641
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_TC_INPUT
// 
//  AUTHOR  : S. AKAAYOUS
//
//  
//  Creation  2020/08/29 SAK
//  Script used to return the audit trail of timecard.
//  Modification - 2020/06/08 - SAK : PC 208, add the function san_rdpm_link_to_timesheet.
//
//***************************************************************************/

namespace san_rdpm_tc_func;

/**
	Function called in _RB_ADM_CUR_REPORT_4964385499 report
*/
function san_rdpm_audit_trail_fun(useless)
{
var tc = context._tc_da_current_tc; 
 if (! (tc instanceof plc.TimeCard)) {return \"\";} 
 var my_string = tc.STATUS_MODIFICATION_TRACE; 
 if (! (my_string instanceof String))  	 {return \"\";} 
  else if (my_string!=\"\") {        return my_string ;    }   
  else {        return plw.write_text_key(\"RDPM.SAN_RDPM_TK_TC_AUDIT_TRAIL\")  ;  }  
}
san_rdpm_audit_trail_fun.exportfunction([\"String\"],\"String\",\"\");

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
 :USER-SCRIPT 0
 :VERSION 0
 :_US_AA_D_CREATION_DATE 20200929000000
 :_US_AA_S_OWNER "E0448344"
)