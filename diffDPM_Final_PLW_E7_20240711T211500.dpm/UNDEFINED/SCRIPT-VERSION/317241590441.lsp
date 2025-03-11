
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 317241590441
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_J2S_COUNTRY_FORM
// 
//  v1.1 - 2021/09/03 - David 
//  Add san_js_country_form_links_modifier the manage dyn attributes that update delay on links, new dyn attr Local set up Expected and Actual Start (PC-4183) and add some try catch
//
//***************************************************************************/
namespace _rdpm_country_form;

function country_form_reader(act_type,field)
{
	var act = this;
	var result = \"\";
	var count=0;
	if (act.WBS_TYPE.printattribute()==context.SAN_RDPM_CS_AT_STUDY)
	{
		with(act.fromObject())
		{
			for (var vAct in plc.work_structure where vAct.WBS_TYPE.printattribute()==act_type)
			{
				result=vAct.get(field);
				count++;
			}
		}
	}
	if (count>1)
		result=\"\";
	
	return result;
}

function country_form_modifier(act_type,field,fvalue)
{
	var result = \"\";
	var count=0;
	var act_target;
	var act=this;
	if (act.WBS_TYPE.printattribute()==context.SAN_RDPM_CS_AT_STUDY)
	{
		with(act.fromObject())
		{
			for (var vAct in plc.work_structure where vAct.WBS_TYPE.printattribute()==act_type)
			{
				act_target=vAct;
				count++;
			}
		}
		if (count==1)
			result=act_target.set(field,fvalue);
		else
			plw.alert(\"There should be only one activity with activity type :\"+act_type+ \". Impossible to update the value!\");
	}
}

function san_js_country_form_links_modifier(act_type,fvalue)
{
	var act=this;
	var vAct_Type=plc.WBS_TYPE.get(act_type);
	
	if (vAct_Type!=undefined)
	{
		if (act.WBS_TYPE.printattribute()==context.SAN_RDPM_CS_AT_STUDY)
		{
			var vList = [];
			vList.push(act);
			vList.push(vAct_Type);
			var vFilter = plw.objectset(vList);
			with(vFilter.fromobject())
			{   
				for (var vAct in plc.work_structure where vAct.WBS_TYPE==vAct_Type)
				{
					if (fvalue!=undefined && fvalue instanceof date && vAct.PS instanceof date)
					{
						// compute the delay to add
						var vCal=(vAct.CAL!=undefined && vAct.CAL!=\"\" && vAct.CAL.printattribute()!=undefined && vAct.CAL.printattribute()!=\"\") ? vAct.CAL.printattribute() : \"\";
						var vDelay=\"DIFF_DATE\".callmacro(vAct.PS,fvalue,vCal);
						if (vDelay!=undefined && vDelay!=0)
						{
							// Manage predecessors links
							for (var vLink in vAct.get(\"PLINKS\"))
							{
								vLink.LAG=vLink.LAG+vDelay;
							}
						}
					}
				}
			}
		}
	}
}

function country_form_locker()
{
	var result = true;
	var act=this;
	if (act.WBS_TYPE.printattribute()==context.SAN_RDPM_CS_AT_STUDY)
			result=false;
	return result;
}

//\"Local set-up\"
function san_country_form_loc_setup_pf_reader(){return country_form_reader(\"Local set-up\",\"EXPECTED_FINISH\");}
function san_country_form_loc_setup_pf_modifier(fvalue){country_form_modifier(\"Local set-up\",\"EXPECTED_FINISH\",fvalue);}
function san_country_form_loc_setup_pf_locker(){return country_form_locker();}

function san_country_form_loc_setup_af_reader(){return country_form_reader(\"Local set-up\",\"AF\");}
function san_country_form_loc_setup_af_modifier(fvalue){country_form_modifier(\"Local set-up\",\"AF\",fvalue);}
function san_country_form_loc_setup_af_locker(){return country_form_locker();}

try{
	var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_LOC_SETUP_EF\",\"END-DATE\");
	slot.Comment = \"Local set-up Expected Finish\";
	slot.Reader = san_country_form_loc_setup_pf_reader;
	slot.Modifier=san_country_form_loc_setup_pf_modifier;
	slot.Locker = san_country_form_loc_setup_pf_locker;
	slot.hiddenInIntranetServer = false;
	slot.connecting = false;

	var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_LOC_SETUP_AF\",\"END-DATE\");
	slot.Comment = \"Local set-up Actual Finish\";
	slot.Reader = san_country_form_loc_setup_af_reader;
	slot.Modifier=san_country_form_loc_setup_af_modifier;
	slot.Locker = san_country_form_loc_setup_af_locker;
	slot.hiddenInIntranetServer = false;
	slot.connecting = false;

	var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_LOC_SETUP_EXP_START\",\"DATE\");
	slot.Comment = \"Local set-up Expected Start\";
	slot.Reader = function(){ return country_form_reader(\"Local set-up\",\"PS\"); };
	slot.Modifier=function(fvalue){ return san_js_country_form_links_modifier(\"Local set-up\",fvalue); };
	slot.Locker = country_form_locker;
	slot.hiddenInIntranetServer = false;
	slot.connecting = false;
	
	var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_LOC_SETUP_AS\",\"DATE\");
	slot.Comment = \"Local set-up Actual Start\";
	slot.Reader = function(){ return country_form_reader(\"Local set-up\",\"AS\"); };
	slot.Modifier=function(fvalue){ return country_form_modifier(\"Local set-up\",\"AS\",fvalue); };
	slot.Locker = country_form_locker;
	slot.hiddenInIntranetServer = false;
	slot.connecting = false;
}catch(error){
plw.writetolog(error);
}

//\"Recruitment\"
function san_country_form_recruitment_pf_reader(){return country_form_reader(\"Recruitment\",\"EXPECTED_FINISH\");}
function san_country_form_recruitment_pf_modifier(fvalue){country_form_modifier(\"Recruitment\",\"EXPECTED_FINISH\",fvalue);}
function san_country_form_recruitment_pf_locker(){return country_form_locker();}

function san_country_form_recruitment_af_reader(){return country_form_reader(\"Recruitment\",\"AF\");}
function san_country_form_recruitment_af_modifier(fvalue){country_form_modifier(\"Recruitment\",\"AF\",fvalue);}
function san_country_form_recruitment_af_locker(){return country_form_locker();}

try{
	var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_RECRUITMENT_EF\",\"END-DATE\");
	slot.Comment = \"Recruitment Expected Finish\";
	slot.Reader = san_country_form_recruitment_pf_reader;
	slot.Modifier=san_country_form_recruitment_pf_modifier;
	slot.Locker = san_country_form_recruitment_pf_locker;
	slot.hiddenInIntranetServer = false;
	slot.connecting = false;

	var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_RECRUITMENT_AF\",\"END-DATE\");
	slot.Comment = \"Recruitment Actual Finish\";
	slot.Reader = san_country_form_recruitment_af_reader;
	slot.Modifier=san_country_form_recruitment_af_modifier;
	slot.Locker = san_country_form_recruitment_af_locker;
	slot.hiddenInIntranetServer = false;
	slot.connecting = false;
}catch(error){
plw.writetolog(error);
}

//\"Treatment\"
function san_country_form_treatment_pf_reader(){return country_form_reader(\"Treatment\",\"EXPECTED_FINISH\");}
function san_country_form_treatment_pf_modifier(fvalue){country_form_modifier(\"Treatment\",\"EXPECTED_FINISH\",fvalue);}
function san_country_form_treatment_pf_locker(){return country_form_locker();}

function san_country_form_treatment_af_reader(){return country_form_reader(\"Treatment\",\"AF\");}
function san_country_form_treatment_af_modifier(fvalue){country_form_modifier(\"Treatment\",\"AF\",fvalue);}
function san_country_form_treatment_af_locker(){return country_form_locker();}

try{
	var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_TREATMENT_EF\",\"END-DATE\");
	slot.Comment = \"Treatment Expected Finish\";
	slot.Reader = san_country_form_treatment_pf_reader;
	slot.Modifier=san_country_form_treatment_pf_modifier;
	slot.Locker = san_country_form_treatment_pf_locker;
	slot.hiddenInIntranetServer = false;
	slot.connecting = false;

	var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_TREATMENT_AF\",\"END-DATE\");
	slot.Comment = \"Treatment Actual Finish\";
	slot.Reader = san_country_form_treatment_af_reader;
	slot.Modifier=san_country_form_treatment_af_modifier;
	slot.Locker = san_country_form_treatment_af_locker;
	slot.hiddenInIntranetServer = false;
	slot.connecting = false;
}catch(error){
plw.writetolog(error);
}

//FUP/Extension\"
function san_country_form_fup_pf_reader(){return country_form_reader(\"FUP/Extension\",\"EXPECTED_FINISH\");}
function san_country_form_fup_pf_modifier(fvalue){country_form_modifier(\"FUP/Extension\",\"EXPECTED_FINISH\",fvalue);}
function san_country_form_fup_pf_locker(){return country_form_locker();}

function san_country_form_fup_af_reader(){return country_form_reader(\"FUP/Extension\",\"AF\");}
function san_country_form_fup_af_modifier(fvalue){country_form_modifier(\"FUP/Extension\",\"AF\",fvalue);}
function san_country_form_fup_af_locker(){return country_form_locker();}

try{
	var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_FUP_EF\",\"END-DATE\");
	slot.Comment = \"FUP Expected Finish\";
	slot.Reader = san_country_form_fup_pf_reader;
	slot.Modifier=san_country_form_fup_pf_modifier;
	slot.Locker = san_country_form_fup_pf_locker;
	slot.hiddenInIntranetServer = false;
	slot.connecting = false;

	var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_FUP_AF\",\"END-DATE\");
	slot.Comment = \"FUP Actual Finish\";
	slot.Reader = san_country_form_fup_af_reader;
	slot.Modifier=san_country_form_fup_af_modifier;
	slot.Locker = san_country_form_fup_af_locker;
	slot.hiddenInIntranetServer = false;
	slot.connecting = false;
}catch(error){
plw.writetolog(error);
}


//\"Local closure\"
function san_country_form_loc_closure_pf_reader(){return country_form_reader(\"Local closure\",\"EXPECTED_FINISH\");}
function san_country_form_loc_closure_pf_modifier(fvalue){country_form_modifier(\"Local closure\",\"EXPECTED_FINISH\",fvalue);}
function san_country_form_loc_closure_pf_locker(){return country_form_locker();}

function san_country_form_loc_closure_af_reader(){return country_form_reader(\"Local closure\",\"AF\");}
function san_country_form_loc_closure_af_modifier(fvalue){country_form_modifier(\"Local closure\",\"AF\",fvalue);}
function san_country_form_loc_closure_af_locker(){return country_form_locker();}

try{
	var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_LOC_CLOSURE_EF\",\"END-DATE\");
	slot.Comment = \"Local closure Expected Finish\";
	slot.Reader = san_country_form_loc_closure_pf_reader;
	slot.Modifier=san_country_form_loc_closure_pf_modifier;
	slot.Locker = san_country_form_loc_closure_pf_locker;
	slot.hiddenInIntranetServer = false;
	slot.connecting = false;

	var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_LOC_CLOSURE_AF\",\"END-DATE\");
	slot.Comment = \"Local closure Actual Finish\";
	slot.Reader = san_country_form_loc_closure_af_reader;
	slot.Modifier=san_country_form_loc_closure_af_modifier;
	slot.Locker = san_country_form_loc_closure_af_locker;
	slot.hiddenInIntranetServer = false;
	slot.connecting = false;
}catch(error){
plw.writetolog(error);
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260076087074
 :VERSION 4
 :_US_AA_D_CREATION_DATE 20211027000000
 :_US_AA_S_OWNER "E0447620"
)