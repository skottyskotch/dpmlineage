
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 340178950341
 :NAME "SAN_RDPM_JS2_UPDATE_ACTUALS"
 :COMMENT "Update Actuals of Activities"
 :ACTIVE T
 :DATASET 118081000141
 :LOAD-ORDER 0
 :SCRIPT-CODE "namespace _san_rdpm_activity_lou_update;
var start_date = context.calldateformula(\"$DATE_OF_THE_DAY\");
var list = new vector();
var o_project_type_filter = plw.objectset(plc.project_type.get(\"Continuum.RDPM\"));
with(o_project_type_filter.fromobject())
{
	// Loop on Projects: restrict loop to Active Pharma projects only and exclude non relevant projects from the treatment (permanent projects, templates, Simulation)
    for(var o_project in plc.project where o_project.DELETED==false && o_project.STATE==\"Active\"  && o_project._WZD_AA_B_PERMANENT != true && o_project._INF_NF_B_IS_TEMPLATE != true && o_project.PARENT.printattribute()==\"\")
    {
        list.push(o_project);
    }
}
var filter = plw.objectset(list);
with(filter.fromobject())
{
    for (var vAct in plc.workstructure )
    {

if (vAct.SAN_RDPM_UA_LOU_CATEGORY==\"CATEGORY 3\" && vAct.DU!=\"\" && vAct.PS<start_date && vAct.PF<start_date && vAct.AS==undefined) {
 
plw.writeln(\"IN2\");
			plw.writeln(vAct.PS);
			plw.writeln(vAct.PF);
			with (plw.no_locking) vAct.AS = vAct.PS;
			plw.writeln(vAct.AS);
			plw.writeln(vAct.AF);
			plw.writeln(vAct.NAME);
			plw.writeln(vAct.SAN_UA_RDPM_S_PROJECT_TC);
 
		}
		

if (vAct.SAN_RDPM_UA_LOU_CATEGORY==\"CATEGORY 3\" && vAct.DU!=\"\" && vAct.PS<start_date && vAct.PF<start_date && vAct.AF==undefined) {
    plw.writeln(\"IN3\");
			plw.writeln(vAct.PS);
			plw.writeln(vAct.PF);
			with (plw.no_locking) vAct.AF = vAct.PF;
			plw.writeln(vAct.AS);
			plw.writeln(vAct.AF);
			plw.writeln(vAct.NAME);
			plw.writeln(vAct.SAN_UA_RDPM_S_PROJECT_TC);
 
		}
	else	if (vAct.SAN_RDPM_UA_LOU_CATEGORY==\"CATEGORY 3\" && vAct.DU!=\"\" && vAct.PS<start_date && vAct.PF>start_date && vAct.AS==undefined) {
      plw.writeln(\"IN1\");
			plw.writeln(vAct.PS);
			plw.writeln(vAct.PF);
			with (plw.no_locking) vAct.AS = vAct.PS;
			plw.writeln(vAct.AS);
			plw.writeln(vAct.AF);
			plw.writeln(vAct.NAME);
			plw.writeln(vAct.SAN_UA_RDPM_S_PROJECT_TC);
 
		}
}


}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 1
 :_US_AA_B_BATCH_SCRIPT "1"
 :_US_AA_D_CREATION_DATE 20240209000000
 :_US_AA_S_OWNER "E0554391"
)