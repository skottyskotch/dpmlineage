
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 310206785441
 :DATASET 118081000141
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_RDPM_JS2_CSO_FTE_COSTS
//
//  AUTHOR  : Islam GUEROUI
//
//  Creation : 2021/05/03 IGU
//  Script contaitning the functions to export and import CSO FTE costs (PC-807)
//
//***************************************************************************/

namespace _rdpm_cso_fte_costs;

function san_rdpm_cso_fte_costs_export()
{
	/*// The time window is the current year + next year
	var d_current_date = new date();
	var n_start_year = d_current_date.getYear();
	var n_end_year = d_current_date.getYear()+1;
	var d_start_horizon_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",0)\");
	var d_end_horizon_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",2)\");
	
	// Used curve
	var curvename = cost.findCurveName('AEAC');

	// CSV Export Variables
	var s_filepath = context.SAN_CS_CSO_FTE_COSTS_PATH;
	var s_cso_fte_costs_filename = 'CSO_FTE_COSTS_EXPORT.csv';
	var o_cso_fte_costs_filepath = new plw.pathname(s_filepath+s_cso_fte_costs_filename);

	if(o_cso_fte_costs_filepath.probefile())
	{
		if (plw.question('The file \"CSO_FTE_COSTS_EXPORT.csv\" already exists! Do you want to replace it?')) {o_cso_fte_costs_filepath.deletefile();}
		else {return 0;}
	}

	var o_cso_fte_costs_file = new plw.fileOutputStream(o_cso_fte_costs_filepath,'overwrite');
	o_cso_fte_costs_file.writeln('Service;Resource;Team;Primary Skill;Planned hours Type;Site;Project Code;Study Code;Planned Start Activity;Planned Finish Activity;Sourcing;Provider;Activity type;WBS Element Activity;Q1-'+n_start_year+';Q2-'+n_start_year+';Q3-'+n_start_year+';Q4-'+n_start_year+';Q1-'+n_end_year+';Q2-'+n_end_year+';Q3-'+n_end_year+';Q4-'+n_end_year);

	// Init monitoring
	var s_monitor_message = \"Exporting CSO FTE costs...\";
	
	// Build a vector of project from which the CSO FTE costs will be exported (only root projects)
	var v_projects = new vector();
	for(var o_project in plc.ordo_project where o_project.SAN_RDPM_UA_RD_PROJECT == true && o_project.SAN_UA_RWE_PROJECT_CODE_PRIME!='' && o_project.PARENT.printattribute()=='') {v_projects.push(o_project);}

	with(plw.monitoring (title: s_monitor_message, steps: v_projects.length)){
		// Loop on each project to export
		for (var o_project in v_projects){
			plw.writetolog(\"Processing CSO FTE costs export from project: \"+o_project.name);
			with(o_project.fromobject()){
				for(var o_hes in plc.TIME_SYNTHESIS where o_hes._PM_NF_B_BASIC_TYPE_HOURS==true && o_hes.FD instanceof Date && o_hes.FD>d_start_horizon_date && o_hes.SD instanceof Date && o_hes.SD<d_end_horizon_date && o_hes.RES instanceof plc.resource && o_hes.RES.OBS_ELEMENT instanceof plc.obs_node && o_hes.RES.OBS_ELEMENT.SAN_RDPM_UA_B_OBS_CSO==true && o_hes.TYPE in ['AUTO','MANUAL']){
					var v_hes_string = '';
					
					//Check that each printed column is of the expected instance else print ''
					v_hes_string += o_hes.RES.SAN_UA_RDPM_RES_SERV+';'+o_hes.RES.printattribute()+';'+o_hes.RES.SAN_RDPM_UA_S_RES_TEAM+';'; //Service, Resource and Team
					if (o_hes.PRIMARY_SKILL instanceof plc.resource_skill) {v_hes_string += o_hes.PRIMARY_SKILL.printattribute()+';';} else {v_hes_string += ';';} //Primary Skill
					v_hes_string += o_hes.TYPE+';'; //Planned hours Type
					if (o_hes._RM_REVIEW_RA_LOCATION instanceof plc._RM_REVIEW_PT_LOCATIONS) {v_hes_string += o_hes._RM_REVIEW_RA_LOCATION.printattribute()+';';} else {v_hes_string += ';';} //Site
					v_hes_string += o_hes.PROJECT.SAN_UA_RWE_PROJECT_CODE_PRIME.printattribute()+';'; //Project code
					if (o_hes.ACTIVITY instanceof plc.work_structure) {v_hes_string += o_hes.ACTIVITY.SAN_RDPM_UA_ACT_S_CALCULATED_STUDY_CODE+';';} else {v_hes_string += ';';} //Study code
					if (o_hes.ACTIVITY instanceof plc.work_structure) {v_hes_string += o_hes.ACTIVITY.PS.toString(\"DD-MM-YYYY HH:MM\")+';';} else {v_hes_string += ';';} //Planned Start (Activity)
					if (o_hes.ACTIVITY instanceof plc.work_structure) {v_hes_string += o_hes.ACTIVITY.PF.toString(\"DD-MM-YYYY HH:MM\")+';';} else {v_hes_string += ';';} //Planned Finish (Activity)
					if (o_hes._INF_RA_CBS2 instanceof plc._INF_PT_CBS2) {v_hes_string += o_hes._INF_RA_CBS2.printattribute()+';';} else {v_hes_string += ';';} //Sourcing
					if (o_hes._INF_RA_CBS3 instanceof plc._INF_PT_CBS3) {v_hes_string += o_hes._INF_RA_CBS3.printattribute()+';';} else {v_hes_string += ';';} //Provider
					if (o_hes.ACTIVITY instanceof plc.work_structure && o_hes.ACTIVITY.WBS_TYPE instanceof plc.wbs_type) {v_hes_string += o_hes.ACTIVITY.WBS_TYPE.printattribute()+';';} else {v_hes_string += ';';} //Activity Type
					if (o_hes.ACTIVITY instanceof plc.work_structure) {v_hes_string += o_hes.ACTIVITY.printattribute()+';';} else {v_hes_string += ';';} //Activity
					
					// Build a Date Vector to parse 
					var v_DateVect = new plw.datevector(\"QUARTER\",d_start_horizon_date,d_end_horizon_date);
					// Remove last value as it will return 0 (Last date of last year)
					v_DateVect.pop();
						
					// Build EAC curves on 'Hours and expenditures' object
					var o_curve_eac_fte = cost.computecurves(curvename, \"FTE (Full Time Equivalent)\", \"QUARTER\", false, d_start_horizon_date, d_end_horizon_date, o_hes);

					// Loop on all dates
					for(var d_date in v_DateVect){
						// Calculate curves
						var n_eac_fte = o_curve_eac_fte.get(d_date);
						//Add curve values
						v_hes_string += n_eac_fte.toString(\"####.0000\")+';';	
					}
					o_cso_fte_costs_file.writeln(v_hes_string);
					
					// Warning: carefully destroy the curves object after their usage to insure that memory used to compute this curves is reallocated correctly.
					o_curve_eac_fte.delete();
				}
			}
			s_monitor_message.monitor(v_projects.length);
		}
	}
	// Close file
	o_cso_fte_costs_file.close();*/
}

function san_rdpm_cso_fte_costs_import()
{
	/*// The time window is the current quarter + next year
	var d_start_horizon_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"QUARTER\\\",0)\");
	var d_end_horizon_date = Context.CallDateFormula(\"period_start($DATE_OF_THE_DAY,\\\"YEAR\\\",2)\");
	var v_DateVect = new plw.datevector(\"QUARTER\",d_start_horizon_date,d_end_horizon_date);
	
	//Starting column from which loads are read
	var n_starting_column = 23-v_DateVect.length;
	
	// CSV Import Variables
	var s_filepath = context.SAN_CS_CSO_FTE_COSTS_PATH;
	var s_cso_fte_costs_filename = 'CSO_FTE_COSTS_IMPORT.csv';
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
			var v_columns = s_line.split(';');
			if(b_first_line==false){
				var o_project = plc.ordo_project.get(v_columns[6]);

				//Planned hours deletion
				if (o_project instanceof plc.ordo_project && !(o_project in v_deleted_cso_cost_projects)){
					v_deleted_cso_cost_projects.push(o_project);
					with(o_project.fromobject()){
						for(var o_ph in plc.task_alloc where o_ph.FD instanceof Date && o_ph.FD>d_start_horizon_date && o_ph.SD instanceof Date && o_ph.SD<d_end_horizon_date && o_ph.RES instanceof plc.resource && o_ph.RES.OBS_ELEMENT instanceof plc.obs_node && o_ph.RES.OBS_ELEMENT.SAN_RDPM_UA_B_OBS_CSO==true && o_ph.TYPE == 'MANUAL' && o_ph.EQUATION_OBJECT==''){
							with([plw.no_locking,plw.no_alerts]){o_ph.delete();}
						}
					}
				}
				
				//Planned hours creation
				var o_res = plc.resource.get(v_columns[1]);
				var o_skill = plc.resource_skill.get(v_columns[3]);
				var o_site = plc._RM_REVIEW_PT_LOCATIONS.get(v_columns[5]);
				var o_sourcing = plc._INF_PT_CBS2.get(v_columns[10]);
				var o_provider = plc._INF_PT_CBS3.get(v_columns[11]);
				var o_activity = plc.work_structure.get(v_columns[13]);
				
				for(var i=0 ; i<v_DateVect.length-1 ; i++){
					var s_fte_load = v_columns[n_starting_column+i];
					var n_load = plw.fte_SwitchLoadFte(o_res, s_fte_load.parseNumber(\"####.0000\"), v_DateVect[i], v_DateVect[i+1], o_res.CAL, 'LOAD');
					//Check mandatory attributes
					if (n_load!=0 && o_activity instanceof plc.work_structure && o_res instanceof plc.resource && o_skill instanceof plc.resource_skill){
						//Create a planned hour in Lag-during so it will shift with its activity
						var o_ph = new plc.task_alloc (ACTIVITY : o_activity,
													   RES : o_res,
													   PRIMARY_SKILL : o_skill,
													   _RM_REVIEW_RA_LOCATION : o_site,
													   _INF_RA_CBS2 : o_sourcing,
													   _INF_RA_CBS3 : o_provider,
													   DURATION_COMPUTATION : 'Lag-during',
													   SD : v_DateVect[i],
													   FD : v_DateVect[i+1],
													   TOTAL_LOAD : n_load);
					}				
				}
			}
			s_line = o_cso_fte_costs_file.readline();
			b_first_line = false;
		}
	}*/
}

function san_rdpm_cso_fte_costs_download()
{
	/*var s_filepath = context.SAN_CS_CSO_FTE_COSTS_PATH+context.SAN_RDPM_UA_OC_S_CSO_FILE_DOWNLOAD;
	var o_cso_fte_costs_filepath = new plw.pathname(s_filepath);
	if(o_cso_fte_costs_filepath.probefile()){
		plw.downloadFileFromServer(s_filepath,context.SAN_RDPM_UA_OC_S_CSO_FILE_DOWNLOAD);
	}
	else{plw.alert('Please select a file to download!');}*/
}


function san_rdpm_cso_fte_costs_upload()
{
	/*var fileToImport = plw.selectfile(\"Select a file to upload...\");

	if (fileToImport instanceof string && fileToImport != \"\") {
		var files = new vector(fileToImport);
		files = fileToImport.parselist().getserverfiles();
		fileToImport = files[0][0];
	}

	if (fileToImport!=undefined && fileToImport!=\"\") {
		//Retrieve the full path of the file
		var vTempPath = new plw.pathname(fileToImport);
		var vPath = new plw.pathname(context.SAN_CS_CSO_FTE_COSTS_PATH+'CSO_FTE_COSTS_IMPORT.csv');
		vTempPath.copyfile(vPath);
		vTempPath.DeleteFile();
	}*/
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 310191331773
 :VERSION 3
 :_US_AA_D_CREATION_DATE 20210527000000
 :_US_AA_S_OWNER "E0448344"
)