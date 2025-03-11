
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321260788241
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _RDPM_PM;

// LFA - PC-1983 - Fix on e-mail notifications
// ABO - PC-1983 - Creation of function san_rdpm_js2_send_vaccines_project_notifications
// LFA - PC-3557 - Creation of function san_rdpm_vac_copy_baselines_to_version
// AHI - 09/12/2021 - PC-410 - Add a control on o_prj (o_prj.FILE) to make the field study code in toolbar work in workpackages module
// LFA PC-4595 - Modification of filter on study code in PM Toolbar to avoid global map on study code table
// Used in Toolbar SAN_RDPM_TB_GANTT_ACT

function san_rdpm_list_study_code()
{
    var v_current_prj_codes = new vector();
    var v_study_codes = new vector();
	var o_prj = undefined;

    for(var oCurPageObject in plw.currentpageobject()){
		
    	if(oCurPageObject instanceof plc.work_structure){
			// Case of oCurPageObject being a work_structure (ex. in workpackage module)
			// we retrieve the project of the work_structure
			o_prj = oCurPageObject.FILE;
		}else{
			o_prj = oCurPageObject;
		}

		if(o_prj instanceof plc.ordo_project){
			if(o_prj.SAN_UA_RWE_PROJECT_CODE_PRIME!=''){
				v_current_prj_codes.push(o_prj.SAN_UA_RWE_PROJECT_CODE_PRIME);
			}
		}
    }
    v_current_prj_codes = v_current_prj_codes.removeduplicates();
    
    
    for (var prj_code in v_current_prj_codes)
    {
    	for(var o_study_code in prj_code.get(\"USER_ATTRIBUTE_INVERSE_SAN_UA_RWE_PROJ_CODE.__USER_TABLE_SAN_RWE_PRIME_CODES\"))
    	{	
    		v_study_codes.push(o_study_code);
    	}
    }
    this.possiblevalues=v_study_codes;
}


// PC-3557 - Function do copy baselines in version
function san_rdpm_vac_copy_baselines_to_version(version)
{
	var origin_project;
	var hash_ref_to_copy = new hashtable(\"STRING\");
	var hash_ref_version = new hashtable(\"STRING\");
	var nb_monthly=0;
	var nb_yearly=0;
	var reference;
	if (version instanceof plc.project && version._PM_NF_B_IS_A_VERSION && version.SAN_RDPM_B_RND_VACCINES_PROJECT)
	{
		// List references of the version
		for (var ref in version.get(\"REFERENCES\") where ref.TEMPLATE.printattribute()==\"SAN_RDPM_YEARLY_BASELINE\" || ref.TEMPLATE.printattribute()==\"SAN_RDPM_MONTHLY_BASELINE\")
		{
			hash_ref_version.set(ref.NAME,ref);
		}
		
		origin_project=version.ORIGIN_PROJECT;
		
		if (origin_project instanceof plc.project)
		{
			for (var ref in origin_project.get(\"REFERENCES\") order by [['INVERSE','AD']])
			{
				if (ref.TEMPLATE.printattribute()==\"SAN_RDPM_YEARLY_BASELINE\" && nb_yearly<1)
				{
					hash_ref_to_copy.set(ref.NAME,ref);;
					nb_yearly++;
				}
				else
				{
					if (ref.TEMPLATE.printattribute()==\"SAN_RDPM_MONTHLY_BASELINE\" && nb_monthly<2)
					{
						hash_ref_to_copy.set(ref.NAME,ref);;
						nb_monthly++;
					}
				}
			}
			// Clean previous reference 
			for (var ref_name in hash_ref_version)
			{
				// The reference is not part of references to copy
				if (hash_ref_to_copy.get(ref_name) == undefined)
				{
					reference=hash_ref_version.get(ref_name);
					plw.writetolog(\"Delete reference \"+ref_name+\" for project version \"+version.printattribute());
					reference.delete();
				}
			}
			// Copy baselines to version
			for (var Ref_Name in hash_ref_to_copy)
			{
				// Check the baseline is not already in the version
				if (hash_ref_version.get(ref_name) == undefined)
				{
					reference=hash_ref_to_copy.get(ref_name);
					plw.writetolog(\"Copy \"+ref_name+\" in project version \"+version.printattribute());
					reference.COPY_TO_DATASET=version;
				}
			}
		}		
	}
}


// PC-1983 - Function to send emails to specific users

function san_rdpm_js2_send_vaccines_project_notifications()
{	
	var o_project_type_filter = plw.objectset(plc.project_type.get(\"Continuum.RDPM.Pasteur\"));
	with(o_project_type_filter.fromobject())
	{
		for(var o_project in plc.project where o_project.DELETED==false  && (o_project.STATE==\"Active\" || o_project.STATE==\"Simulation\") && o_project._PM_NF_B_IS_A_VERSION==false && o_project.SAN_RDPM_UA_B_NEW_PROJECT && o_project.SAN_RDPM_UA_PM_PRJ_PORT!=undefined && o_project.SAN_RDPM_UA_PM_PRJ_PORT instanceof plc.__USER_TABLE_SAN_RDPM_UT_PM_PRJ_PORT)
		{
			var body = \"\";
			var email_recipient=\"\";
			var subject = \"\";
			//e-mail recipient
			email_recipient = o_project.SAN_RDPM_UA_PM_PRJ_PORT.SAN_RDPM_UA_S_PORTFOLIO_NOTIFICATION_EMAILS;

			if (email_recipient!=\"\")
			{
				//e-mail body & subject
				if (o_project.SAN_RDPM_UA_PRJ_RND_PRJ_VAC)
				{
					subject = \"A new project has been created in RDPM\";

					body=body+\"<html><p>Dear user,</p><p>Please be informed that a new \"+ o_project.SAN_RDPM_UA_PM_PRJ_PORT.name +\" project has been created with the following information:</p>\";
					body=body+\"<p>Portfolio : \" +o_project.SAN_RDPM_UA_PM_PRJ_PORT.printattribute()+ \"<br>\";
					body=body+\"Project code : \" +o_project.SAN_UA_RWE_PROJECT_CODE_PRIME.printattribute()+ \"<br>\";
					body=body+\"Name : \" +o_project.NAME + \"<br>\";
					body=body+\"Description : \" +o_project.DESC+ \"<br>\";
					body=body+\"Project site : \" +o_project.SAN_RDPM_UA_PROJECT_SITE.printattribute()+ \"<br>\";
					body=body+\"Franchise : \" +o_project.SAN_RDPM_UA_FRANCHISE.printattribute()+ \"<br>\";
					body=body+\"Vaccines project category : \" +o_project.SAN_RDPM_UA_VACC_PROJ_CAT+ \"<br>\";
					body=body+\"Project stage : \" +o_project.SAN_RDPM_UA_VACC_PROJ_SUB_CAT + \"<br>\";
					body=body+\"Objective : \" +o_project.SAN_RDPM_UA_OBJECTIVE + \"<br>\";
					body=body+\"Global Project Head : \" +o_project._PO_DA_S_PROJECT_ROLE_262005439940  + \"<br>\";
					body=body+\"Global Project Manager : \" +o_project._PO_DA_S_PROJECT_ROLE_262033882840 + \"</p>\";
					body=body+\"<p>Thank you!\"+ \"<br>\";
					body=body+\"This email is generated automatically, please do not reply!</p></html>\";
				}
				else
				{
					if (o_project.SAN_RDPM_UA_PRJ_RND_IND_VAC)
					{
						subject = \"A new indication has been created in RDPM for the project \"+ o_project.SAN_UA_RWE_PROJECT_CODE_PRIME.printattribute() +\" - \"+o_project.PARENT.NAME;

						body=body+\"<html><p>Dear user,</p><p>Please be informed that for the project \"+ o_project.SAN_UA_RWE_PROJECT_CODE_PRIME.printattribute() +\" - \"+o_project.PARENT.NAME+ \" a new indication has been created with the following information: </p>\";
						body=body+\"<p>Portfolio : \" +o_project.SAN_RDPM_UA_PM_PRJ_PORT.printattribute()+ \"<br>\";
						body=body+\"Project code : \" +o_project.SAN_UA_RWE_PROJECT_CODE_PRIME.printattribute()+ \"<br>\";
						body=body+\"Name : \" +o_project.parent.NAME + \"<br>\";
						body=body+\"Description : \" +o_project.parent.DESC+ \"<br>\";
						body=body+\"Indication code : \" +o_project.NAME + \"<br>\";
						body=body+\"Indication description : \" +o_project.DESC+ \"</p>\";
						body=body+\"<p>Thank you!\"+ \"<br>\";
						body=body+\"This email is generated automatically, please do not reply!</p></html>\";
					}
				}
				
				if (body!=\"\")
				{
					var plist = new vector();
					plist.setplist(\"from\",context._ADM_ST_S_NOTIF_CHGLOG_EMAIL_FROM);
					plist.setplist(\"to\",email_recipient);
					plist.setplist(\"subject\",subject);
					plist.setplist(\"body\",body);
					plist.setplist(\"Content-Type\",\"text/html\");
					plw.mail_send(plist);
				}
			}
			
			o_project.SAN_RDPM_UA_B_NEW_PROJECT = false;
		}
	}	
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 316646123941
 :VERSION 13
 :_US_AA_D_CREATION_DATE 20221005000000
 :_US_AA_S_OWNER "E0477351"
)