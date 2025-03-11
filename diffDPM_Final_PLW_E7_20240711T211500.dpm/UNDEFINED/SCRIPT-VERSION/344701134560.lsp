
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 344701134560
 :DATASET 118081000141
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
 
if (vAct.SAN_RDPM_UA_LOU_CATEGORY==\"CATEGORY 3\" && vAct.DU!=\"\" && vAct.PS<start_date && vAct.PF>start_date) {
			vAct.AS = vAct.PS;
		}
else if (vAct.SAN_RDPM_UA_LOU_CATEGORY==\"CATEGORY 3\" && vAct.DU!=\"\" && vAct.PS<start_date && vAct.PF<start_date) {
			vAct.AS = vAct.PS;
		}
 
if (vAct.SAN_RDPM_UA_LOU_CATEGORY==\"CATEGORY 3\" && vAct.DU!=\"\" && vAct.PS<start_date && vAct.PF<start_date && vAct.AS!=-1 && vAct.AF!=-1) {
			vAct.AF = vAct.PF;
		}
else if (vAct.SAN_RDPM_UA_LOU_CATEGORY==\"CATEGORY 3\" && vAct.DU!=\"\" && vAct.PS<start_date && vAct.PF<start_date) {
			vAct.AF = vAct.PF;
		}
}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 340178950341
 :VERSION 0
 :_US_AA_D_CREATION_DATE 20240704000000
 :_US_AA_S_OWNER "U1005481"
)