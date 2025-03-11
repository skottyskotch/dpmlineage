
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 283042501069
 :DATASET 118081000141
 :SCRIPT-CODE "//
// 
//  PLWSCRIPT : SAN_RDPM_JS2_DYN_RELATION
// 
//  AUTHOR  : S. AKAAYOUS
//
//
//  Creation : 2020/10/12 SAK
//  Script used for PC 140 : Traces set up: Record modifications on Resources & availabilities 
//
//***************************************************************************/
namespace _san_rdpm_res;

function san_rdpm_func_res_trace(f){
	var res = this;
	var result = new vector();
	if ( res instanceof plc.resource){
		for (var trace in res.get(\"TRACE-LOGS\"))
		{
			result.push(trace);
		}
		for (var dispo in res.get(\"Availabilities\"))
		{
			for (var trace in dispo.get(\"TRACE-LOGS\"))
			{
				result.push(trace);
			}
		}  
		for (var trace in result)
		{
			f.call(trace);
		}
	}
}


//dynamic relation between resources and traces resources & availability
function san_rdpm_dyn_rel_res_traces(){
  var SAN_RDPM_REL_RES_TRACES = new ObjectRelation(plc.Resource,\"SAN_RDPM_RES_AVAIL_TRACES\");
  SAN_RDPM_REL_RES_TRACES.Mapmethod = san_rdpm_func_res_trace;
  SAN_RDPM_REL_RES_TRACES.ConnectedToClass = plc.trace_log;
  SAN_RDPM_REL_RES_TRACES.Comment = \"RDPM RESOURCE AND AVAILABILITIES TRACES\";
}
// ## Declaration of the dynamic relation ##
try{
with(plw.no_locking){
san_rdpm_dyn_rel_res_traces();
}
}
catch (error e){
 plw.writeToLog(\"Failed to create SAN_RDPM_RES_AVAIL_TRACES\");
 plw.writeln(e);
}
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260067159772
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20210202000000
 :_US_AA_S_OWNER "E0296878"
)