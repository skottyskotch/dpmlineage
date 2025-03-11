
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260019717871
 :DATASET 118081000141
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
	switch(type) {
		case BOOLEAN_TYPE :
		return DA_DEFAULT_VALUE[0];

		case DATE_TYPE :
		return DA_DEFAULT_VALUE[1];

		case NUMBER_TYPE :
		return DA_DEFAULT_VALUE[2];

		case STRING_TYPE :
		return DA_DEFAULT_VALUE[3];
	}
}

//Generic reader
function san_wbs_cascading_slot_reader(string field, string storage_field,type) {
    if(this instanceof plc.work_structure && this!=undefined)
    {
        // Depending on field type, set the default value
        var default_value;
        if(type==NUMBER_TYPE)
        {
            default_value = MyDefaultValueByType(NUMBER_TYPE);
        } else if(type==STRING_TYPE)
        {
            default_value = MyDefaultValueByType(STRING_TYPE);
        } else if(type==BOOLEAN_TYPE)
        {
            default_value = MyDefaultValueByType(BOOLEAN_TYPE);
        } else if(type==DATE_TYPE)
        {
            default_value = MyDefaultValueByType(DATE_TYPE);
        } else {
		
            default_value = undefined;
        }
        // Look on 'storage_field'
        if(this.get(storage_field)==default_value)
        {
            if(this.wbs_element instanceof plc.work_structure && this.wbs_element!=undefined)
            {
                return this.wbs_element.get(field);
            } else {
                return default_value;
            }
        } else {
            return this.get(storage_field);
        }
    } else {
        return undefined;
    }
}

//Generic modifier
function san_wbs_cascading_slot_modifier(string storage_field, value) {
    if(this instanceof plc.work_structure && this!=undefined)
    {
        this.set(storage_field,value);
    }
}

//Generic locker
function san_field_slot_locker() {
    return false;
}

//Generic DA creation
function san_create_dynamic_attribute(plwclass, string newDA, string type, reader, modifier, locker){
    try{
        var slot = new objectAttribute(plwclass, newDA, type);
        slot.Comment = newDA;
        slot.Reader = reader;
        slot.Modifier = modifier;
        slot.Locker = locker;
        slot.hiddenInIntranetServer = false;
        slot.connecting = false;
    }
    catch(error e){
        plw.writeln(\"Could not create slot due to error: \" + e);
    }
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 260019705671
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20200922000000
 :_US_AA_S_OWNER "E0431101"
)