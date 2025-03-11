
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260103620241
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _rdpm_country_form;

function country_form_reader(act_type,field)
{
	var act = this;
	var result = \"\";
	var count=0;
	if (act.WBS_TYPE.printattribute()==\"STUDY\")
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
	if (act.WBS_TYPE.printattribute()==\"STUDY\")
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

function country_form_locker()
{
	var result = true;
	var act=this;
	if (act.WBS_TYPE.printattribute()==\"STUDY\")
			result=false;
	return result;
}

//\"Local set-up\"
function san_country_form_loc_setup_pf_reader(){return country_form_reader(\"Local set-up\",\"EXPECTED_FINISH\");}
function san_country_form_loc_setup_pf_modifier(fvalue){country_form_modifier(\"Local set-up\",\"EXPECTED_FINISH\",fvalue);}
function san_country_form_loc_setup_pf_locker(){return country_form_locker();}
var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_LOC_SETUP_EF\",\"END-DATE\");
slot.Comment = \"Local set-up Expected Finish\";
slot.Reader = san_country_form_loc_setup_pf_reader;
slot.Modifier=san_country_form_loc_setup_pf_modifier;
slot.Locker = san_country_form_loc_setup_pf_locker;
slot.hiddenInIntranetServer = false;
slot.connecting = false;

function san_country_form_loc_setup_af_reader(){return country_form_reader(\"Local set-up\",\"AF\");}
function san_country_form_loc_setup_af_modifier(fvalue){country_form_modifier(\"Local set-up\",\"AF\",fvalue);}
function san_country_form_loc_setup_af_locker(){return country_form_locker();}
var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_LOC_SETUP_AF\",\"END-DATE\");
slot.Comment = \"Local set-up Actual Finish\";
slot.Reader = san_country_form_loc_setup_af_reader;
slot.Modifier=san_country_form_loc_setup_af_modifier;
slot.Locker = san_country_form_loc_setup_af_locker;
slot.hiddenInIntranetServer = false;
slot.connecting = false;

//\"Recruitment\"
function san_country_form_recruitment_pf_reader(){return country_form_reader(\"Recruitment\",\"EXPECTED_FINISH\");}
function san_country_form_recruitment_pf_modifier(fvalue){country_form_modifier(\"Recruitment\",\"EXPECTED_FINISH\",fvalue);}
function san_country_form_recruitment_pf_locker(){return country_form_locker();}
var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_RECRUITMENT_EF\",\"END-DATE\");
slot.Comment = \"Recruitment Expected Finish\";
slot.Reader = san_country_form_recruitment_pf_reader;
slot.Modifier=san_country_form_recruitment_pf_modifier;
slot.Locker = san_country_form_recruitment_pf_locker;
slot.hiddenInIntranetServer = false;
slot.connecting = false;

function san_country_form_recruitment_af_reader(){return country_form_reader(\"Recruitment\",\"AF\");}
function san_country_form_recruitment_af_modifier(fvalue){country_form_modifier(\"Recruitment\",\"AF\",fvalue);}
function san_country_form_recruitment_af_locker(){return country_form_locker();}
var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_RECRUITMENT_AF\",\"END-DATE\");
slot.Comment = \"Recruitment Actual Finish\";
slot.Reader = san_country_form_recruitment_af_reader;
slot.Modifier=san_country_form_recruitment_af_modifier;
slot.Locker = san_country_form_recruitment_af_locker;
slot.hiddenInIntranetServer = false;
slot.connecting = false;

//\"Treatment\"
function san_country_form_treatment_pf_reader(){return country_form_reader(\"Treatment\",\"EXPECTED_FINISH\");}
function san_country_form_treatment_pf_modifier(fvalue){country_form_modifier(\"Treatment\",\"EXPECTED_FINISH\",fvalue);}
function san_country_form_treatment_pf_locker(){return country_form_locker();}
var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_TREATMENT_EF\",\"END-DATE\");
slot.Comment = \"Treatment Expected Finish\";
slot.Reader = san_country_form_treatment_pf_reader;
slot.Modifier=san_country_form_treatment_pf_modifier;
slot.Locker = san_country_form_treatment_pf_locker;
slot.hiddenInIntranetServer = false;
slot.connecting = false;

function san_country_form_treatment_af_reader(){return country_form_reader(\"Treatment\",\"AF\");}
function san_country_form_treatment_af_modifier(fvalue){country_form_modifier(\"Treatment\",\"AF\",fvalue);}
function san_country_form_treatment_af_locker(){return country_form_locker();}
var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_TREATMENT_AF\",\"END-DATE\");
slot.Comment = \"Treatment Actual Finish\";
slot.Reader = san_country_form_treatment_af_reader;
slot.Modifier=san_country_form_treatment_af_modifier;
slot.Locker = san_country_form_treatment_af_locker;
slot.hiddenInIntranetServer = false;
slot.connecting = false;

//FUP/Extension\"
function san_country_form_fup_pf_reader(){return country_form_reader(\"FUP/Extension\",\"EXPECTED_FINISH\");}
function san_country_form_fup_pf_modifier(fvalue){country_form_modifier(\"FUP/Extension\",\"EXPECTED_FINISH\",fvalue);}
function san_country_form_fup_pf_locker(){return country_form_locker();}
var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_FUP_EF\",\"END-DATE\");
slot.Comment = \"FUP Expected Finish\";
slot.Reader = san_country_form_fup_pf_reader;
slot.Modifier=san_country_form_fup_pf_modifier;
slot.Locker = san_country_form_fup_pf_locker;
slot.hiddenInIntranetServer = false;
slot.connecting = false;

function san_country_form_fup_af_reader(){return country_form_reader(\"FUP/Extension\",\"AF\");}
function san_country_form_fup_af_modifier(fvalue){country_form_modifier(\"FUP/Extension\",\"AF\",fvalue);}
function san_country_form_fup_af_locker(){return country_form_locker();}
var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_FUP_AF\",\"END-DATE\");
slot.Comment = \"FUP Actual Finish\";
slot.Reader = san_country_form_fup_af_reader;
slot.Modifier=san_country_form_fup_af_modifier;
slot.Locker = san_country_form_fup_af_locker;
slot.hiddenInIntranetServer = false;
slot.connecting = false;


//\"Local closure\"
function san_country_form_loc_closure_pf_reader(){return country_form_reader(\"Local closure\",\"EXPECTED_FINISH\");}
function san_country_form_loc_closure_pf_modifier(fvalue){country_form_modifier(\"Local closure\",\"EXPECTED_FINISH\",fvalue);}
function san_country_form_loc_closure_pf_locker(){return country_form_locker();}
var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_LOC_CLOSURE_EF\",\"END-DATE\");
slot.Comment = \"Local closure Expected Finish\";
slot.Reader = san_country_form_loc_closure_pf_reader;
slot.Modifier=san_country_form_loc_closure_pf_modifier;
slot.Locker = san_country_form_loc_closure_pf_locker;
slot.hiddenInIntranetServer = false;
slot.connecting = false;

function san_country_form_loc_closure_af_reader(){return country_form_reader(\"Local closure\",\"AF\");}
function san_country_form_loc_closure_af_modifier(fvalue){country_form_modifier(\"Local closure\",\"AF\",fvalue);}
function san_country_form_loc_closure_af_locker(){return country_form_locker();}
var slot = new objectAttribute(plc.work_structure,\"SAN_RDPM_DA_D_LOC_CLOSURE_AF\",\"END-DATE\");
slot.Comment = \"Local closure Actual Finish\";
slot.Reader = san_country_form_loc_closure_af_reader;
slot.Modifier=san_country_form_loc_closure_af_modifier;
slot.Locker = san_country_form_loc_closure_af_locker;
slot.hiddenInIntranetServer = false;
slot.connecting = false;"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260076087074
 :VERSION 0
 :_US_AA_D_CREATION_DATE 20201104000000
 :_US_AA_S_OWNER "E0296878"
)