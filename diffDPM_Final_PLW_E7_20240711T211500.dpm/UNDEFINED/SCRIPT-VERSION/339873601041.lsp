
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 339873601041
 :DATASET 118081000141
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_RDPM_JS2_CSO_FTE_IMP_EXP
//
//  AUTHOR  : Islam GUEROUI
//
//  Modification 0.4: 2022/07/12 GSE
//  Extension of import scope with Current Year + next Year instead of Current Quarter + next Year for san_rdpm_cso_fte_import function
//
//  Modification 0.3 : 2021/09/06 IGU
//  Add role import (PC-4461)
//
//  Modification 0.2 : 2021/08/23 IGU
//  Fix dates export (PC-4385), upload cancellation (PC-4411) and add filters to export active pharma projects only (PC-4384)
//
//  Modification 0.1 : 2021/07/01 IGU
//  Various bug fixes and evolutions (PC-4067)
//
//  Creation : 2021/05/03 IGU
//  Script contaitning the functions to export and import CSO FTEs (PC-807)
//
//***************************************************************************/

namespace _rdpm_cso_fte;

function san_rdpm_cso_fte_export()
{
	// The time window is the current year + next year
	var d_current_date = new date();
	var n_start_year = d_current_date.getYear();
	var n_end_year = d_current_date.getYear()+1;
	var d_start_horizon_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",0)\");
	var d_end_horizon_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",2)\");
	
	// Used curve
	var curvename = cost.findCurveName('AEAC');

	// CSV Export Variables
	var s_filepath = context.SAN_CS_CSO_FTE_COSTS_PATH;
	var s_cso_fte_costs_filename = 'CSO_FTEs_EXPORT.csv';
	var o_cso_fte_costs_filepath = new plw.pathname(s_filepath+s_cso_fte_costs_filename);

	var o_cso_fte_costs_file = new plw.fileOutputStream(o_cso_fte_costs_filepath,'overwrite');
	o_cso_fte_costs_file.writeln('Service;Resource;Team;Primary Skill;Role;Planned hours Type;Site;Project Code;Study Code;Planned Start Activity;Planned Finish Activity;Sourcing;Provider;Activity type;WBS Element Activity;Q1-'+n_start_year+';Q2-'+n_start_year+';Q3-'+n_start_year+';Q4-'+n_start_year+';Q1-'+n_end_year+';Q2-'+n_end_year+';Q3-'+n_end_year+';Q4-'+n_end_year+';');

	// Init monitoring
	var s_monitor_message = \"Exporting CSO FTEs ...\";
	
	// Build a vector of project from which the CSO FTEs will be exported (only root projects)
	var v_projects = new vector();
	for(var o_project in plc.ordo_project where o_project.SAN_RDPM_B_RND_PHARMA_PROJECT == true && o_project.SAN_UA_RWE_PROJECT_CODE_PRIME!='' && o_project.PARENT.printattribute()=='' && o_project.getinternalvalue(\"STATE\").toString()=='ACTIVE' && o_project._PM_NF_B_IS_A_VERSION==false) {v_projects.push(o_project);}

	with(plw.monitoring (title: s_monitor_message, steps: v_projects.length)){
		// Loop on each project to export
		for (var o_project in v_projects){
			plw.writetolog(\"Processing CSO FTEs export from project: \"+o_project.name);
			with(o_project.fromobject()){
				for(var o_hes in plc.TIME_SYNTHESIS where o_hes._PM_NF_B_BASIC_TYPE_HOURS==true && o_hes.FD instanceof Date && o_hes.FD>d_start_horizon_date && o_hes.SD instanceof Date && o_hes.SD<d_end_horizon_date && o_hes.RES instanceof plc.resource && o_hes.RES.OBS_ELEMENT instanceof plc.obs_node && o_hes.RES.OBS_ELEMENT.SAN_RDPM_UA_B_OBS_CSO==true && o_hes.TYPE in ['AUTO','MANUAL'] && o_hes.remaining!=0){
					var v_hes_string = '';
					// Build EAC curves on 'Hours and expenditures' object
					var o_curve_eac_fte = cost.computecurves(curvename, \"FTE (Full Time Equivalent)\", \"QUARTER\", false, d_start_horizon_date, d_end_horizon_date, o_hes);
					
					try{
						//Check that each printed column is of the expected instance else print ''
						v_hes_string += o_hes.RES.SAN_UA_RDPM_RES_SERV+';'+o_hes.RES.printattribute()+';'; //Service and Resource
						if (o_hes.RES.SAN_RDPM_UA_B_IS_A_TEAM){v_hes_string += o_hes.RES.printattribute()+';';} else {v_hes_string += ';';} //Team
						if (o_hes.PRIMARY_SKILL instanceof plc.resource_skill) {v_hes_string += o_hes.PRIMARY_SKILL.printattribute()+';';} else {v_hes_string += ';';} //Primary Skill
						if (o_hes._RM_REVIEW_RA_ROLE instanceof plc._RM_REVIEW_PT_ROLE) {v_hes_string += o_hes._RM_REVIEW_RA_ROLE.printattribute()+';';} else {v_hes_string += ';';} //Role
						v_hes_string += o_hes.TYPE+';'; //Planned hours Type
						if (o_hes._RM_REVIEW_RA_LOCATION instanceof plc._RM_REVIEW_PT_LOCATIONS) {v_hes_string += o_hes._RM_REVIEW_RA_LOCATION.printattribute()+';';} else {v_hes_string += ';';} //Site
						v_hes_string += o_project.SAN_UA_RWE_PROJECT_CODE_PRIME.printattribute()+';'; //Project code
						if (o_hes.ACTIVITY instanceof plc.work_structure) {v_hes_string += o_hes.ACTIVITY.SAN_RDPM_UA_ACT_S_CALCULATED_STUDY_CODE+';';} else {v_hes_string += ';';} //Study code
						if (o_hes.ACTIVITY instanceof plc.work_structure) {v_hes_string += o_hes.ACTIVITY.callstringformula(\"PRINT_DATE(PS,\\\"DD-MM-YYYY HH:MM\\\")\")+';';} else {v_hes_string += ';';} //Planned Start (Activity)
						if (o_hes.ACTIVITY instanceof plc.work_structure) {v_hes_string += o_hes.ACTIVITY.callstringformula(\"PRINT_END_DATE(PF,\\\"DD-MM-YYYY HH:MM\\\")\")+';';} else {v_hes_string += ';';} //Planned Finish (Activity)
						if (o_hes._INF_RA_CBS2 instanceof plc._INF_PT_CBS2) {v_hes_string += o_hes._INF_RA_CBS2.printattribute()+';';} else {v_hes_string += ';';} //Sourcing
						if (o_hes._INF_RA_CBS3 instanceof plc._INF_PT_CBS3) {v_hes_string += o_hes._INF_RA_CBS3.printattribute()+';';} else {v_hes_string += ';';} //Provider
						if (o_hes.ACTIVITY instanceof plc.work_structure && o_hes.ACTIVITY.WBS_TYPE instanceof plc.wbs_type) {v_hes_string += o_hes.ACTIVITY.WBS_TYPE.printattribute()+';';} else {v_hes_string += ';';} //Activity Type
						if (o_hes.ACTIVITY instanceof plc.work_structure) {v_hes_string += o_hes.ACTIVITY.printattribute()+';';} else {v_hes_string += ';';} //Activity
						
						// Build a Date Vector to parse 
						var v_DateVect = new plw.datevector(\"QUARTER\",d_start_horizon_date,d_end_horizon_date);
						// Remove last value as it will return 0 (Last date of last year)
						v_DateVect.pop();

						// Loop on all dates
						for(var d_date in v_DateVect){
							// Calculate curves
							var n_eac_fte = o_curve_eac_fte.get(d_date);
							//Add curve values
							v_hes_string += n_eac_fte.toString(\"####.0000\")+';';	
						}
					}
					catch(error e){
						plw.alert('An error occured during the export of the hours and expendutures summary: '+o_hes);
						plw.alert(e);
					}
					finally{
						o_cso_fte_costs_file.writeln(v_hes_string);
						
						// Warning: carefully destroy the curves object after their usage to insure that memory used to compute this curves is reallocated correctly.
						o_curve_eac_fte.delete();
					}
				}
			}
			s_monitor_message.monitor(v_projects.length);
		}
	}
	// Close file
	o_cso_fte_costs_file.close();
}

function san_rdpm_cso_fte_import()
{
	// The time window is the current quarter + next year
	var d_start_horizon_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",0)\");
	var d_end_horizon_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",2)\");
	var v_DateVect = new plw.datevector(\"QUARTER\",d_start_horizon_date,d_end_horizon_date);
	
	//Starting column from which loads are read
	var n_starting_column = 24-v_DateVect.length;
	
	// CSV Import Variables
	var s_filepath = context.SAN_CS_CSO_FTE_COSTS_PATH;
	var s_cso_fte_costs_filename = 'CSO_FTEs_IMPORT.csv';
	var o_cso_fte_costs_filepath = new plw.pathname(s_filepath+s_cso_fte_costs_filename);
	var o_cso_fte_costs_file = undefined;
	var v_deleted_cso_cost_projects = new vector();
	
	
	if(o_cso_fte_costs_filepath.probefile()){
		o_cso_fte_costs_file = new plw.fileinputstream(o_cso_fte_costs_filepath);
	}
	else{plw.alert('File not found!');}

	if (o_cso_fte_costs_file instanceof plw.fileinputstream){
		var s_line = o_cso_fte_costs_file.readline();
		var b_first_line = true;

        while(s_line != undefined){
			s_line = s_line.rtrim(\"\\n\");
			s_line = s_line.rtrim(\"\\r\");
			var v_columns = s_line.split(';');
			if(b_first_line==false){
				//Planned hours creation
				var o_res = plc.resource.get(v_columns[1]);
				var o_skill = plc.resource_skill.get(v_columns[3]);
				var o_role = plc._RM_REVIEW_PT_ROLE.get(v_columns[4]);
				var o_site = plc._RM_REVIEW_PT_LOCATIONS.get(v_columns[6]);
				var o_sourcing = plc._INF_PT_CBS2.get(v_columns[11]);
				var o_provider = plc._INF_PT_CBS3.get(v_columns[12]);
				var o_activity = plc.work_structure.get(v_columns[14]);
				
				for(var i=0 ; i<v_DateVect.length-1 ; i++){
					var s_fte_load = v_columns[n_starting_column+i];
					var d_start = v_DateVect[i];
					var d_end = v_DateVect[i+1];
					
					var n_load = plw.fte_SwitchLoadFte(o_res, s_fte_load.parseNumber(\"####.0000\"), d_start, d_end, o_res.CAL, 'LOAD');
					//Check mandatory attributes
					if (n_load!=0 && o_activity instanceof plc.work_structure && o_res instanceof plc.resource && o_skill instanceof plc.resource_skill && (o_role instanceof plc._RM_REVIEW_PT_ROLE || v_columns[4]=='')){
						if(d_start<o_activity.PS && d_end<=o_activity.PS){d_start=-1;} else if(d_start<o_activity.PS){d_start=o_activity.PS;}
						if(d_end>o_activity.PF && d_start>=o_activity.PF){d_end=-1;} else if(d_end>o_activity.PF){d_end=o_activity.PF;}

						if(d_start!=-1 && d_end!=-1){
							//Create a planned hour in Lag-during so it will shift with its activity
							var o_ph = new plc.task_alloc (ACTIVITY : o_activity,
														   RES : o_res,
														   _RM_REVIEW_RA_ROLE : o_role,
														   PRIMARY_SKILL : o_skill,
														   _RM_REVIEW_RA_LOCATION : o_site,
														   _INF_RA_CBS2 : o_sourcing,
														   _INF_RA_CBS3 : o_provider,
														   DURATION_COMPUTATION : 'Lag-during',
														   SD : d_start,
														   FD : d_end,
														   TOTAL_LOAD : n_load);
							//In some cases the ph is not directly created with the correct start and end dates
							o_ph.SD = d_start;
							o_ph.FD = d_end;
						}
					}				
				}
			}
			s_line = o_cso_fte_costs_file.readline();
			b_first_line = false;
		}
		// Close file
	    o_cso_fte_costs_file.close();
		plw.alert('CSO FTEs import complete!');
	}
}

function san_rdpm_cso_fte_download_last_exported_file()
{
	var s_filepath = context.SAN_CS_CSO_FTE_COSTS_PATH+'CSO_FTEs_EXPORT.csv';
	var o_cso_fte_costs_filepath = new plw.pathname(s_filepath);
	if(o_cso_fte_costs_filepath.probefile()){
		plw.downloadFileFromServer(s_filepath,'CSO_FTEs_EXPORT.csv');
	}
	else{plw.alert('File not found!');}
}


function san_rdpm_cso_fte_upload()
{
	var fileToImport = plw.selectfile(\"Select a file to upload...\");

	if (fileToImport instanceof string && fileToImport != \"\") {
		var files = new vector(fileToImport);
		files = fileToImport.parselist().getserverfiles();
		fileToImport = files[0][0];
	}

	if (fileToImport!=undefined && fileToImport!=\"\") {
		//Retrieve the full path of the file
		var vTempPath = new plw.pathname(fileToImport);
		var vPath = new plw.pathname(context.SAN_CS_CSO_FTE_COSTS_PATH+'CSO_FTEs_IMPORT.csv');
		if(vPath.probefile()){
			vPath.DeleteFile();
		}
		vTempPath.copyfile(vPath);
		vTempPath.DeleteFile();
		
		return true;
	}
	else {
		return false;
	}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 310191331773
 :VERSION 14
 :_US_AA_D_CREATION_DATE 20240108000000
 :_US_AA_S_OWNER "I0260387"
)