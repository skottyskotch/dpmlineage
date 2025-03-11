
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321202996041
 :DATASET 118081000141
 :SCRIPT-CODE "/*
* Script V2
* Autor : Ludovic FAVRE
* JIRA : PC-2468  (Baselines)
* Date Creation 04/01/2021
* JIRA : PC-1417 & PC-4001 ('Vaccine Project Category' and \"Vaccine Project Sub-category\" manual values are set back to the calculated value after the Monthly Baseline has runned). 
* JIRA : PC-4543 - Change file & dataset class for _L1_PT_REF_ADMIN (SAN_CF_RDPM_COMMON_DATA_VACCINES/Continuum.RDPM.Pasteur for Vaccines & SAN_CF_RDPM_COMMON_DATA_PHARMA/Continuum.RDPM.Pharma for Pharma)
* JIRA : PC-4692 - Limit Study baselines to Pharma Projects
* Date Modification : 19/09/2021 by Ludovic FAVRE
* JIRA : PC-470 - Modification YEARLY to YEARLY_VACCINES
* Date Modification : 28/10/2021 by Amine Bekkal
* JIRA : PC-1820 - Create/update a simulation (Limit the study baseline to be applied only to active projects)
* Date Modification : 20/12/2021 by Amine Bekkal
* JIRA : PC-5556 - Store the study baseline date on study at study baseline creation
* Date Modification : 31/01/2022 by Ludovic FAVRE
* JIRA : PC-746 - Modification Vaccine Monthly Baseline
* Date Modification : 14/03/2022 by Amine Bekkal
*/

namespace _rdpm_baseline;

function san_rdpm_js2_create_monthly_baseline()
{
	var ref_name=context.SAN_RDPM_UA_OC_S_MONTHLY_BASELINE_NAME;
	var ref_obj = plc._L1_PT_REF_ADMIN.get(ref_name);
	var date_of_day = new date();
	
	if (ref_obj instanceof plc._L1_PT_REF_ADMIN)
	{
		plw.writeln(\"Reference already exist! : \"+ref_obj);
	}
	else
	{
	    //PC-746: Add SAN_RDPM_UA_D_CREATION_DATE=date of the day for the creation of the new baseline
		ref_obj = new plc._L1_PT_REF_ADMIN (NAME : ref_name,DESC : ref_name,_L1_AA_S_REF_TEMPLATE : \"SAN_RDPM_MONTHLY_BASELINE\",_L1_AA_B_REF_IS_LOADED : true,_L1_AA_S_REF_PRJTYP : \"Continuum.RDPM.Pasteur\",FILE : \"SAN_CF_RDPM_COMMON_DATA_VACCINES\", SAN_RDPM_UA_D_CREATION_DATE : date_of_day);	
		plw.writeln(\"Creation a new Reference : \"+ref_obj);
	} 
	
	return ref_name;
}

function san_rdpm_js2_create_yearly_baseline_name()
{
	var ref_name = context.SAN_RDPM_UA_OC_S_YEARLY_BASELINE_NAME;
	var ref_obj = plc._L1_PT_REF_ADMIN.get(ref_name);


	if (ref_obj instanceof plc._L1_PT_REF_ADMIN)
	{
		plw.writeln(\"Reference already exist! : \"+ref_obj);
	}
	else
	{
	    //PC-746: Do not load backup yearly baseline [_L1_AA_B_REF_IS_LOADED =fasle]
		ref_obj = new plc._L1_PT_REF_ADMIN (NAME : ref_name,DESC : ref_name,_L1_AA_S_REF_TEMPLATE : \"SAN_RDPM_YEARLY_BASELINE\",_L1_AA_B_REF_IS_LOADED : false,_L1_AA_S_REF_PRJTYP : \"Continuum.RDPM.Pasteur\",FILE : \"SAN_CF_RDPM_COMMON_DATA_VACCINES\");	
		plw.writeln(\"Creation a new Reference : \"+ref_obj);

	}
    // PC-470 :  Modification YEARLY to YEARLY_VACCINES
	var ybase = plc._L1_PT_REF_ADMIN.get(\"YEARLY_VACCINES\"); 
	if (ybase instanceof plc._L1_PT_REF_ADMIN)
	{
		ybase._L1_AA_S_REF_BKUP_NAME=ref_name;
	}	
	else
	{
		plw.writeln(\"YEARLY_VACCINES Baseline does not exist!\");
	}
	
	return \"YEARLY_VACCINES\";
}

var date = new date();

/*
*** PHARMA *****
*/

// Monthly Baseline
if (context.SAN_RDPM_UA_OC_D_PHARMA_BASELINE_DATE!=undefined && \"PRINT_DATE\".call(date,\"DD-MM-YYYY\")==\"PRINT_DATE\".call(context.SAN_RDPM_UA_OC_D_PHARMA_BASELINE_DATE,\"DD-MM-YYYY\"))
{
	//var month_number = 12;
	var month_number = \"MONTH_NUMBER\".call(date);
	var month_number_string = month_number.tostring();
	//var year_number =2020;
	var year_number = \"YEAR_NUMBER\".call(date);
	var year_number_string = year_number.tostring();

	// Baseline name
	var baseline_name_template = new hashtable(\"STRING\");
	baseline_name_template.set(\"1\",\"MONTHLY_\"+year_number_string+\"_01_PHARMA\");
	baseline_name_template.set(\"2\",\"MONTHLY_\"+year_number_string+\"_02_PHARMA\");
	baseline_name_template.set(\"3\",\"QUARTERLY_\"+year_number_string+\"_03_PHARMA\");
	baseline_name_template.set(\"4\",\"MONTHLY_\"+year_number_string+\"_04_PHARMA\");
	baseline_name_template.set(\"5\",\"MONTHLY_\"+year_number_string+\"_05_PHARMA\");
	baseline_name_template.set(\"6\",\"QUARTERLY_\"+year_number_string+\"_06_PHARMA\");
	baseline_name_template.set(\"7\",\"MONTHLY_\"+year_number_string+\"_07_PHARMA\");
	baseline_name_template.set(\"8\",\"MONTHLY_\"+year_number_string+\"_08_PHARMA\");
	baseline_name_template.set(\"9\",\"QUARTERLY_\"+year_number_string+\"_09_PHARMA\");
	baseline_name_template.set(\"10\",\"MONTHLY_\"+year_number_string+\"_10_PHARMA\");
	baseline_name_template.set(\"11\",\"MONTHLY_\"+year_number_string+\"_11_PHARMA\");
	baseline_name_template.set(\"12\",\"YEARLY_\"+year_number_string+\"_12_PHARMA\");
	var Ref_Name =baseline_name_template.get(month_number_string);
	// Baseline desc
	var baseline_desc_template = new hashtable(\"STRING\");
	baseline_desc_template.set(\"1\",\"Monthly \"+year_number_string+\" January Pharma Baseline\");
	baseline_desc_template.set(\"2\",\"Monthly \"+year_number_string+\" February Pharma Baseline\");
	baseline_desc_template.set(\"3\",\"Quarterly \"+year_number_string+\" March Pharma Baseline (F1 preparation)\");
	baseline_desc_template.set(\"4\",\"Monthly \"+year_number_string+\" April Pharma Baseline\");
	baseline_desc_template.set(\"5\",\"Monthly \"+year_number_string+\" May Pharma Baseline\");
	baseline_desc_template.set(\"6\",\"Quarterly \"+year_number_string+\" June Pharma Baseline\");
	baseline_desc_template.set(\"7\",\"Monthly \"+year_number_string+\" July Pharma Baseline\");
	baseline_desc_template.set(\"8\",\"Monthly \"+year_number_string+\" August Pharma Baseline\");
	baseline_desc_template.set(\"9\",\"Quarterly \"+year_number_string+\" September Pharma Baseline (F2 / Budget preparation)\");
	baseline_desc_template.set(\"10\",\"Monthly \"+year_number_string+\" October Pharma Baseline\");
	baseline_desc_template.set(\"11\",\"Monthly \"+year_number_string+\" November Pharma Baseline\");
	baseline_desc_template.set(\"12\",\"Yearly \"+year_number_string+\" Pharma Baseline\");
	var Ref_Desc = baseline_desc_template.get(month_number_string);
	//Baseline type
	var baseline_type=\"Monthly\";
	if (month_number==12) baseline_type=\"Yearly\";
	if (month_number==3 || month_number==6 || month_number==9) baseline_type=\"Quaterly\";

	// Creation of the baseline
	var ref_obj = plc._L1_PT_REF_ADMIN.get(Ref_Name);
	if (ref_obj instanceof plc._L1_PT_REF_ADMIN)
	{
		plw.writeln(\"Reference already exist! : \"+ref_obj);
	}
	else
	{
		ref_obj = new plc._L1_PT_REF_ADMIN (NAME : ref_name,
											DESC : Ref_Desc,
											_L1_AA_S_REF_TEMPLATE : \"SAN_RDPM_MONTHLY_BASELINE\",
											SAN_RDPM_UA_D_CREATION_DATE : date, 
											SAN_RDPM_UA_S_BASELINE_TYPE : baseline_type,
											_L1_AA_B_REF_IS_LOADED : true,
											_L1_AA_B_REF_IN_FORM : true,
											SAN_RDPM_UA_B_EXPIRABLE : true,
											_L1_AA_S_REF_PRJTYP : \"Continuum.RDPM.Pharma\",
											FILE : \"SAN_CF_RDPM_COMMON_DATA_PHARMA\");	
											
		plw.writeln(\"Creation a new Reference : \"+ref_obj);
	} 
		
	// Creation of the reference on project
	var Project_Filter=context.SAN_RDPM_CS_S_PHARMA_BASELINE_PROJECT_FILTER;
	plw.writeln(\"Generate pharma monthly baseline : \" + Ref_Name);
	context._write_transactions_in_log_=false;
	plw.take_Reference_with_parameter_in_batch_ext(Ref_Name,Project_Filter,\"\",true);
	context._write_transactions_in_log_=true;
	
	// Update description of baseline
	for (var ref in plc.Reference where ref.name==Ref_Name)
	{
		ref.desc=Ref_Desc;
	}
	
	// Update customer setting & deactivate loading of old baselines
	// Deactivate loading of previous monthly and update last monthly baseline
	var previous_monthly_baseline_name = context.SAN_RDPM_CS_LAST_MONTHLY_PHARMA;
	var previous_monthly_baseline_obj = plc._L1_PT_REF_ADMIN.get(previous_monthly_baseline_name);
	if (previous_monthly_baseline_obj instanceof plc._L1_PT_REF_ADMIN && previous_monthly_baseline_obj.SAN_RDPM_UA_S_BASELINE_TYPE==\"Monthly\")previous_monthly_baseline_obj._L1_AA_B_REF_IS_LOADED=false;
	context.SAN_RDPM_CS_LAST_MONTHLY_PHARMA = Ref_Name;
	// Deactivate loading of previous yearly and update last yearly baseline
	if (month_number==12)
	{
		var previous_yearly_baseline_name = context.SAN_RDPM_CS_LAST_YEARLY_PHARMA;
		var previous_yearly_baseline_obj = plc._L1_PT_REF_ADMIN.get(previous_yearly_baseline_name);
		if (previous_yearly_baseline_obj instanceof plc._L1_PT_REF_ADMIN) previous_yearly_baseline_obj._L1_AA_B_REF_IS_LOADED=false;
		context.SAN_RDPM_CS_LAST_YEARLY_PHARMA = Ref_Name;
	}
	// Deactivate loading of previous quaterly and update last quaterly baseline
	if (month_number==3 || month_number==6 || month_number==9 || month_number==12)
	{
		var previous_quaterly_baseline_name = context.SAN_RDPM_CS_LAST_QUATERLY_PHARMA;
		var previous_quaterly_baseline_obj = plc._L1_PT_REF_ADMIN.get(previous_quaterly_baseline_name);
		if (previous_quaterly_baseline_obj instanceof plc._L1_PT_REF_ADMIN && previous_quaterly_baseline_obj.SAN_RDPM_UA_S_BASELINE_TYPE==\"Quaterly\") previous_quaterly_baseline_obj._L1_AA_B_REF_IS_LOADED=false;
		context.SAN_RDPM_CS_LAST_QUATERLY_PHARMA = Ref_Name;
	}
	
}

// Vaccines


/*
VACCINES
*/

// Monthly Baseline
if (context.SAN_RDPM_UA_OC_D_VACCINES_MONTHLY_BASELINE_DATE!=undefined && \"PRINT_DATE\".call(date,\"DD-MM-YYYY\")==\"PRINT_DATE\".call(context.SAN_RDPM_UA_OC_D_VACCINES_MONTHLY_BASELINE_DATE,\"DD-MM-YYYY\"))
{
	var Ref_Name=san_rdpm_js2_create_monthly_baseline();
	var Ref_Obj =  plc._L1_PT_REF_ADMIN.get(Ref_Name);
	var Project_Filter=context.SAN_RDPM_CS_S_VACCINES_BASELINE_PROJECT_FILTER;
	plw.writeln(\"Generate vaccines monthly baseline : \" + Ref_Name);
	context._write_transactions_in_log_=false;
	plw.take_Reference_with_parameter_in_batch_ext(Ref_Name,Project_Filter,\"\",true);
	context._write_transactions_in_log_=true;
	
	// Deactivate loading for previous baselines
		for (var reference in plc._L1_PT_REF_ADMIN)
	{
		reference.SAN_RDPM_UA_B_VACCINES_LOADED_BASELINE=false;	
		
	}
	Ref_Obj.SAN_RDPM_UA_B_VACCINES_LOADED_BASELINE=true;
	
	//PC-746 : At the end of the creation of new monthly baseline, untick _L1_AA_B_REF_IS_LOADED on all previous vaccines baselines
	for (var ref_vacc_monthly in plc._L1_PT_REF_ADMIN where ref_vacc_monthly.SAN_RDPM_UA_B_BASELINE_ADMIN_VACC_MONTHLY)
	{
		ref_vacc_monthly._L1_AA_B_REF_IS_LOADED =false;	
		
	}
	Ref_Obj._L1_AA_B_REF_IS_LOADED=true;
	
	
	
	// PC-1417 & PC-4001 : 'Vaccine Project Category' and \"Vaccine Project Sub-category\" manual values are set back to the calculated value after the Monthly Baseline has runned. 
	for(var o_project in plc.project where o_project.callbooleanformula(Project_Filter) )
    {
		if (o_project.SAN_RDPM_UA_PROJECT_PHASE != \"\" ) {
		    o_project.SAN_RDPM_UA_VACC_PROJ_CAT = o_project.SAN_RDPM_UA_PROJECT_PHASE.SAN_RDPM_UA_VACC_PROJ_CAT;
		    o_project.SAN_RDPM_UA_VACC_PROJ_SUB_CAT = o_project.SAN_RDPM_UA_PROJECT_PHASE.SAN_RDPM_UA_VACC_PROJ_SUB_CAT;
		}
		else { 
			o_project.SAN_RDPM_UA_VACC_PROJ_CAT=\"\";
		    o_project.SAN_RDPM_UA_VACC_PROJ_SUB_CAT = \"\";
	    }
    }
}

// Yearly Baseline
if (context.SAN_RDPM_UA_OC_D_VACCINES_YEARLY_BASELINE_DATE!=undefined && \"PRINT_DATE\".call(date,\"DD-MM-YYYY\")==\"PRINT_DATE\".call(context.SAN_RDPM_UA_OC_D_VACCINES_YEARLY_BASELINE_DATE,\"DD-MM-YYYY\"))
{
	var Ref_Name=san_rdpm_js2_create_yearly_baseline_name();
	var Project_Filter=context.SAN_RDPM_CS_S_VACCINES_BASELINE_PROJECT_FILTER;
	plw.writeln(\"Generate vaccines yearly baseline.\");
	context._write_transactions_in_log_=false;
	plw.take_Reference_with_parameter_in_batch_ext(Ref_Name,Project_Filter,\"\",true);
	context._write_transactions_in_log_=true;
}


/*
STUDY BASELINES
*/
function san_rdpm_take_automatic_study_baseline(refName,refDesc,relation_name)
{
	
	var vHash = new hashtable();
	var parent_project=\"\";
	var vHash_Obj=\"\";
	var exception_formula=\"\";
	var exception_formula = \"\";
	var baseline = plc._L1_PT_REF_ADMIN.get(refName);
	var study = \"\";
	var date = new date();
	
	// Get the list of project with the exception formula
	for (var vact in baseline.get(relation_name) where vact.PROJECT.STATE==\"Active\")
	{
	    if (vAct.SAN_RDPM_UA_B_STUDY_BASELINE_TAKEN)
	    {
	        vAct.SAN_RDPM_UA_S_AUTO_STUDY_BASELINE=\"\";
	    }
	    else
	    {
    	    if (refName!=\"STUDY_BASELINE_2\" || vact.SAN_UA_RDPM_B_STUDY_HAS_COUNTRY)
    	    {
    	        plw.writetolog(\"Processing baseline \" + refName + \" for activity \"+vact);
        		parent_project=plc.project.get(vAct.project.SAN_RDPM_UA_PRJ_S_ROOT_PROJECT);
        		vHash_Obj=vHash.get(parent_project);
        		if (vHash_Obj!=undefined)
        		{
        			exception_formula=\"LIST_MERGE\".call(vHash_Obj,vact.SAN_UA_RDPM_ACT_S_STUDY_ID);
        		}
        		else
        		{
        			exception_formula=vact.SAN_UA_RDPM_ACT_S_STUDY_ID;
        		}
        		vHash.set(parent_project,exception_formula);
        		with(plw.no_locking){
        		    vAct.SAN_RDPM_UA_B_STUDY_BASELINE_TAKEN=true;
            		if (refName==\"MANUAL_STUDY_BASELINE\")
            		    vAct.SAN_RDPM_UA_B_TAKE_STUDY_BASELINE=false;
            		    
        		}
    			
    			// PC-5556 - Set baseline creation date on study
    			study = plc.workstructure.get(vact.SAN_UA_RDPM_ACT_S_STUDY_ID);
    			if (study instanceof plc.workstructure)
    			{
    				with(plw.no_locking){
    					switch(refName)
    					{
    						case \"STUDY_BASELINE_1\" :
    						study.SAN_UA_RDPM_D_STUDY_BASELINE1_DATE=date;
    						break;
    						
    						case \"STUDY_BASELINE_2\" :
    						study.SAN_UA_RDPM_D_STUDY_BASELINE2_DATE=date;
    						break;
    						
    						case \"STUDY_BASELINE_3\" :
    						study.SAN_UA_RDPM_D_STUDY_BASELINE3_DATE=date;
    						break;
    						
    						case \"MANUAL_STUDY_BASELINE\" :
    						study.SAN_UA_RDPM_D_STUDY_BASELINE4_DATE=date;
    						break;						
    						
    					}					
    				}
    			}
    			
    	    }
    	}
	}
	
	// Take baseline with the exception formula for identified projects
	for (var prjObj in vHash)
	{
		exception_formula=plw.compile_reference_activity_filter(refName,prjObj,vHash.get(prjObj));
		// Check baseleine exist
		var plc.reference baseline_to_update = plw._PM_Getreference(prjObj,refName);
		var boolean update = ( baseline_to_update instanceof plc.reference ) ? true : false;
		if (update)
			 plw._pm_updateReference(prjObj,baseline_to_update,exception_formula);
		// Create baseline if it does not exist
		else
		   plw.create_reference_with_parameter(refName,refDesc,prjObj,false,exception_formula);
	}
}

// Automatic beselines
san_rdpm_take_automatic_study_baseline(\"STUDY_BASELINE_1\",\"Study Baseline 1\",\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_AUTO_STUDY_BASELINE.WORK-STRUCTURE\");
san_rdpm_take_automatic_study_baseline(\"STUDY_BASELINE_2\",\"Study Baseline 2\",\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_AUTO_STUDY_BASELINE.WORK-STRUCTURE\");
san_rdpm_take_automatic_study_baseline(\"STUDY_BASELINE_3\",\"Study Baseline 3\",\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_AUTO_STUDY_BASELINE.WORK-STRUCTURE\");
// Manual Baseline
san_rdpm_take_automatic_study_baseline(\"MANUAL_STUDY_BASELINE\",\"Manual Study Baseline\",\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_S_MANUAL_STUDY_BASELINE.WORK-STRUCTURE\");

// Delete old Pharma baselines
 with ( plw.no_alerts){
    for (var vRef in plc.Reference where vRef.SAN_RDPM_UA_B_PHARMA_BASELINE && vRef.SAN_RDPM_UA_B_EXPIRABLE && vRef.SAN_RDPM_UA_D_EXPIRATION_DATE<=date)
    {
    	vRef.delete();
    }
    for (var vBaseline in plc._L1_PT_REF_ADMIN where vBaseline.SAN_RDPM_UA_B_EXPIRABLE && vBaseline.SAN_RDPM_UA_D_EXPIRATION_DATE<=date)
    {
    	vBaseline.delete();
    }
}
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 282705872274
 :VERSION 27
 :_US_AA_D_CREATION_DATE 20220323000000
 :_US_AA_S_OWNER "E0476882"
)