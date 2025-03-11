
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 321207057810
 :DATASET 118081000141
 :SCRIPT-CODE "


// Split absences
namespace _split_abs;

function san_redpm_res_split_abs(res)
{
	var abs_sd;
	var abs_fd;
	var split_abs;
	var split_sd;
	var split_fd;
	
	// Get absences
	for (var abs in res.get(\"Availabilities\") where abs.TYPE==\"Absence\")
	{
		split_abs = false;
		abs_sd=abs.SD;
		abs_fd=abs.FD;
		
		// Get all standard avaibilities in the period of the absence
		for (var disp in res.get(\"Availabilities\") where disp.TYPE==\"\" && (disp.SD==undefined || disp.SD<abs_fd) && (disp.FD==undefined || disp.FD>abs_sd))
		{
			// There is an avaibility that cover the whole absence
			if ((disp.SD==undefined || disp.SD<=abs_sd) && (disp.FD==undefined || disp.FD>=abs_fd))
			{
				// We check if we have the same percentage
				if (abs.PCT!=disp.PCT)
				{
					abs.PCT=disp.PCT;
					plw.writetolog(\"Update percentage for absence \" + abs.ONB + \" for resource \"+ res.printattribute()+\" [Start date : \" +abs.SD + \" - End date : \" +abs.FD+\" - Percentage :\"+abs.PCT+\"].\");
				}
				break;
			}
			// There is a partial avaibility
			else
			{
				// Start date of the new absence
				if (disp.SD==undefined || disp.SD<abs.SD)
					split_sd=abs.SD;
				else
					split_sd=disp.SD;
				
				// End date of the new absence
				if (disp.FD==undefined || disp.FD>abs.FD)
					split_fd=abs.FD;
				else
					split_fd=disp.FD;

				
				var plist = new vector();
				plist.push(\"SD\");
				plist.push(split_sd);
				plist.push(\"FD\");
				plist.push(split_fd);
				plist.push(\"TYPE\");
				plist.push(\"Absence\");
				plist.push(\"PCT\");
				plist.push(disp.PCT);
				
				var new_abs=disp.CopywithPlist(plist);
				new_abs.positiveonb();
				plw.writetolog(\"Creation of new absence \" + new_abs.ONB + \" for resource \"+ res.printattribute()+\" [Start date : \" +new_abs.SD + \" - End date : \" +new_abs.FD+\" - Percentage :\"+new_abs.PCT+\"].\");
				
				
				split_abs=true;
			}
		}
		
		if (split_abs)
		{
			plw.writetolog(\"Deletion of absence \" + abs.ONB + \" for resource \"+ res.printattribute()+\" [Start date : \" +abs.SD + \" - End date : \" +abs.FD+\" - Percentage :\"+abs.PCT+\"].\");
			abs.delete();			
		}
	}	
}

//san_redpm_res_split_abs(res);
for (var res in plc.resource)
{
	san_redpm_res_split_abs(res);
}
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 0
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20220330000000
 :_US_AA_S_OWNER "E0499298"
)