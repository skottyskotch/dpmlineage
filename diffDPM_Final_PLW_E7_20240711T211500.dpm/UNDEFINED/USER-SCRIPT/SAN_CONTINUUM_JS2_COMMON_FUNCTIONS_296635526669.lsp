
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 296635526669
 :NAME "SAN_CONTINUUM_JS2_COMMON_FUNCTIONS"
 :COMMENT "Common functions for Continuum"
 :ACTIVE T
 :DATASET 118057330253
 :EVAL-ON-LOAD T
 :LOAD-ORDER 0
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_CONTINUUM_JS2_COMMON_FUNCTIONS
//  Common functions for Continuum
//
//  v1.0 - 2021/03/16 - David
//  Add to define if a batch must be run or not (PC3436)
//
//***************************************************************************/
namespace _san_continuum;

// PC3436 : for PLW monitoring all batches are set to daily and the periodicity is defined when calling this function
// the function return true if the batch have to run today or false if not. Les 1st arg is mandatory, not the others
// vPeriod : periodicity of the batch 
// - vPeriod=daily or \"\"
// other arguments are useless
// - vPeriod=weekly
// arg2 : number of period between 2 batches (every X weeks)
// arg3 : list of days of the week the batch must run (0=SUN,1=MON,2=TUE,...,6=SAT)
// ex: san_js_check_run_batch(\"weekly\",2,[1]) -> every 2 weeks on Monday
// - vPeriod=monthly
// arg2 : number of period between 2 batches (every X months)
// arg3 : List of 1 element defining the day of the month the batch must run (between 1 to 31, the first element only is taken into account)
// ex : san_js_check_run_batch(\"monthly\",1,[15]) -> the 15th of every month
function san_js_check_run_batch(string vPeriod, arg2 : 1, arg3 : [1])
{
	var boolean vResult=false;
	var date vToday=new date();
	var string vLog=\" -- BATCH TO RUN -- \";
	plw.writetolog(vLog+\"arguments : \"+vPeriod+\" / \"+arg2+\" / \"+arg3);
	if (vPeriod==\"\" || vPeriod==\"daily\")
	{
		vResult=true;
		plw.writetolog(vLog+\"Freq : daily \"); 
	}
	else if (vPeriod==\"weekly\")
	{
		if (arg2 instanceof number && arg2>0 && arg3.length>0)
		{
			plw.writetolog(vLog+\"Freq : every \"+arg2.tostring(\"####\")+\" week(s), day numbers : \"+arg3.join(\",\") );
			var vWeekNumber=\"WEEK_NUMBER\".CallMacro(vToday);
			plw.writetolog(vLog+\"Today's week number : \"+vWeekNumber.tostring(\"####\"));
			// check if the rest of division by arg2 is 0
			if (vWeekNumber instanceof number && vWeekNumber%arg2==0)
			{
				//check the day number
				for (var vDayNum in arg3)
				{
					var vDayOK=\"DAY_OF_WEEK\".callmacro(vToday,vDayNum);
					if (vDayOK.tostring(\"DD-MM-YYYY\")==vToday.tostring(\"DD-MM-YYYY\"))
					{
						vResult=true;
						break;
					}
				}
			}
		}
	}
	else if (vPeriod==\"monthly\")
	{
		if (arg2 instanceof number && arg2>0 && arg3.length>0 && arg3[0] instanceof number)
		{
			plw.writetolog(vLog+\"Freq : every \"+arg2+\" month(s), day number : \"+arg3[0].tostring(\"####\") );
			var vMonthNumber=vToday.getmonth();
			plw.writetolog(vLog+\"Today's month number : \"+vMonthNumber.tostring(\"####\"));
			// check if the rest of division by arg2 is 0
			if (vMonthNumber instanceof number && vMonthNumber%arg2==0)
			{
				//check the day
				var vDay=vToday.getdate();
				if (vDay==arg3[0])
					vResult=true;	
			}
		}
	}
	var vToRun=(vResult==true) ? \"YES\" : \"NO\";
	plw.writetolog(vLog+\"TO RUN : \"+vToRun);
	return vResult;
}

"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 1
 :_US_AA_B_BATCH_SCRIPT "0"
 :_US_AA_D_CREATION_DATE 20210316000000
 :_US_AA_S_OWNER "intranet"
)