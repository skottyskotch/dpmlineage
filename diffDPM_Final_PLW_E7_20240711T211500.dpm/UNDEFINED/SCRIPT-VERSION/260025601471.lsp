
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260025601471
 :DATASET 118081000141
 :SCRIPT-CODE "//script to use in the batch
Namespace _impexTarget;

var plc.impextarget Target = plc.impextarget.get(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_PROJECT:Json file format\");

if(Target instanceOf plc.ImpexTarget){
    
    var plc.impexformat Format = plc.impexformat.get(\"Project:DATAHUB\");
    
    if(Target._IMPEX_AA_B_TRUNCATE){
        plw._Impex_TruncateTable(Target,Format);
    }
    
    Format.DoExportWithFormatAndTarget(Target);
}

plc.impextarget Target = plc.impextarget.get(\"SAN_RDPM_IMPEX_TARGET_DATAHUB_INDICATION:Json file format\");

if(Target instanceOf plc.ImpexTarget){
    
    plc.impexformat Format = plc.impexformat.get(\"Activity:DATAHUBINDICATION\");
    
    if(Target._IMPEX_AA_B_TRUNCATE){
        plw._Impex_TruncateTable(Target,Format);
    }
    
    Format.DoExportWithFormatAndTarget(Target);
}

/*
function SanExport (type)
{
	switch(type)
	{
		case BOOLEAN_TYPE :
		return DA_DEFAULT_VALUE[0];
		break;

		case DATE_TYPE :
		return DA_DEFAULT_VALUE[1];
		break;

		case NUMBER_TYPE :
		return DA_DEFAULT_VALUE[2];
		break;

		case STRING_TYPE :
		return DA_DEFAULT_VALUE[3];
		break;
		
		default:
		return undefined;
		break;
	}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260025536771
 :VERSION 4
 :_US_AA_D_CREATION_DATE 20201013000000
 :_US_AA_S_OWNER "E0431101"
)