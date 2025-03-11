
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260025645671
 :DATASET 118081000141
 :SCRIPT-CODE "//script to use in the batch
Namespace _impexTarget;

function SanExport (string argTarget, string argFormat)
{
    
    var plc.impextarget Target = plc.impextarget.get(argTarget);
    
    if(Target instanceOf plc.ImpexTarget){
        
        var plc.impexformat Format = plc.impexformat.get(argFormat);
        
        if(Target._IMPEX_AA_B_TRUNCATE){
            plw._Impex_TruncateTable(Target,Format);
        }
        
        Format.DoExportWithFormatAndTarget(Target);
    }
    
}

SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PROJECT:Json file format\", \"Project:DATAHUB\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_INDICATION:Json file format\", \"Activity:DATAHUBINDICATION\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PHASE:Json file format\", \"Activity:DATAHUBPHASE\");
SanExport(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_MILESTONE:Json file format\", \"Activity:DATAHUBMILESTONE\");"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260025536771
 :VERSION 6
 :_US_AA_D_CREATION_DATE 20201013000000
 :_US_AA_S_OWNER "E0431101"
)