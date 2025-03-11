
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 283115672670
 :DATASET 118081000141
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_RDPM_SCRIPT_EXPORT_SHINE
//
//  AUTHOR  : Harilanto RAKOTOVAO
//	Object: export Pharma Planned expenditures, planned hours, Links, Activities and project to SHINE
//
//  Creation : 2021/01/21
//  
//  script to use in the batch SAN_RDPM_BA_EXPORT_TO_SHINE
//
//***************************************************************************/

namespace _shine_impexTarget;
plw.writeln(\"Starting export to shine script\");

function SanExport (string argTarget, string argFormat)
{	
    plw.writeln(\"Starting export of \"+argTarget);
    var plc.impextarget Target = plc.impextarget.get(argTarget);
    
    if(Target instanceOf plc.ImpexTarget){
        
        var plc.impexformat Format = plc.impexformat.get(argFormat);
        
        if(Target._IMPEX_AA_B_TRUNCATE){
            plw._Impex_TruncateTable(Target,Format);
        }
        
        Format.DoExportWithFormatAndTarget(Target);
		plw.writeln(\"Exporting: \"+argFormat+\"_\"+argTarget);
    }
    
}

//SanExport 
// Planned expenditure
SanExport(\"SAN_RDPM_IMPEX_TARGET_SHINE_PLANNED_EXPENDITURE:CSV file format\", \"Planned expenditure:SAN_RDPM_IMPEX_FORMAT_SHINE_PLANNED_EXPENDITURE\");
// Planned hours
SanExport(\"SAN_RDPM_IMPEX_TARGET_SHINE_PLANNED_HOURS:CSV file format\", \"Planned hours:SAN_RDPM_IMPEX_FORMAT_SHINE_PLANNED_HOURS\");
// Activities
SanExport(\"SAN_RDPM_IMPEX_TARGET_SHINE_ACTIVITY:CSV file format\", \"Activity:SAN_RDPM_IMPEX_FORMAT_SHINE_ACTIVITYSAN_RDPM_IMPEX_FORMAT_SHINE_ACTIVITY\");
// Links
SanExport(\"SAN_RDPM_IMPEX_TARGET_SHINE_LINK:CSV file format\", \"Link:SAN_RDPM_IMPEX_FORMAT_SHINE_LINK\");
//Projects
SanExport(\"SAN_RDPM_IMPEX_TARGET_SHINE_PROJECT:CSV file format\", \"Project:SAN_RDPM_IMPEX_FORMAT_SHINE_PROJECT\");
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 282808872670
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20210210000000
 :_US_AA_S_OWNER "E0431201"
)