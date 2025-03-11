
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260025572371
 :DATASET 118081000141
 :SCRIPT-CODE "//script to use in the batch
Namespace _impexTarget;
var plc.impextarget target = plc.impextarget.get(\"SAN_RDPM_IMPEX_TARGET_DATAHUB:Json file format\");
if(Target instanceOf plc.ImpexTarget){
var plc.impexformat format = plc.impexformat.get(\"Project:DATAHUB\");
if(Target._IMPEX_AA_B_TRUNCATE){
plw._Impex_TruncateTable(Target,Format);
}
plw.DoExportWithFormatAndTarget(this : Format,Target);
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260025536771
 :VERSION 0
 :_US_AA_D_CREATION_DATE 20201013000000
 :_US_AA_S_OWNER "E0431101"
)