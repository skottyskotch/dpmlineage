
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 260019705671
 :NAME "SAN_GENERIC_DA_FCT"
 :COMMENT "Generic DA functions"
 :ACTIVE T
 :DATASET 118081000141
 :EVAL-ON-LOAD T
 :LOAD-ORDER 0
 :SCRIPT-CODE "//
//  PLWSCRIPT : SAN_GENERIC_DA_FCT
//
//  AUTHOR  : Manuel DOUILLET
//
//
//  Creation : 2020/09/21 MDO
//  Script used for dynamic attributes
//
//***************************************************************************/

//*************************
namespace _san_rdpm_dyn_attribute;
//**************************

var string BOOLEAN_TYPE = 'BOOLEAN';
var string DATE_TYPE = 'DATE';
var string STRING_TYPE = 'STRING';
var string NUMBER_TYPE = 'NUMBER';
 
var vector DA_DEFAULT_VALUE = [false,-1,0,\"\"];

//Default value by type
function MyDefaultValueByType (type)
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
}

//Generic reader
function san_wbs_cascading_slot_reader(string field, string storage_field,type)
{
    if(this instanceof plc.work_structure && this!=undefined)
    {
        // Depending on field type, set the default value
        var default_value;
		
		default_value = MyDefaultValueByType(type);
		
        // Look on 'storage_field'
		if (default_value != undefined)
		{
			if(this.get(storage_field)==default_value)
			{
				if(this.wbs_element instanceof plc.work_structure && this.wbs_element!=undefined)
				{
					return this.wbs_element.get(field);
				}
				else
				{
					return default_value;
				}
			}
			else
			{
				return this.get(storage_field);
			}
		}
    } 
	return undefined;
}

//Generic modifier
function san_wbs_cascading_slot_modifier(string storage_field, value)
{
    if(this instanceof plc.work_structure && this!=undefined)
    {
        this.set(storage_field,value);
    }
}

//Generic locker
function san_field_slot_locker()
{
    return false;
}

//Generic DA creation
function san_create_dynamic_attribute(plwclass, string newDA, string type, string newComment, reader, modifier, locker)
{
    try
	{
        var slot = new objectAttribute(plwclass, newDA, type);
        slot.Comment = newComment;
        slot.Reader = reader;
        slot.Modifier = modifier;
        slot.Locker = locker;
        slot.hiddenInIntranetServer = false;
        slot.connecting = false;
    }
    catch(error e)
	{
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 4
 :_US_AA_B_BATCH_SCRIPT "0"
 :_US_AA_D_CREATION_DATE 20200922000000
 :_US_AA_S_OWNER "intranet"
)