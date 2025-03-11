
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 316631411141
 :DATASET 118081000141
 :SCRIPT-CODE "namespace _sourcing_tool;

function _san_rdpm_new_insourcing_request()
{
    var Selection = new Symbol(\"SELECTION-ATOM\",\"TOOL-BAR\");
    var parent = \"\";
    for (var object in Selection)
    {
    	parent=object;
    	break;
    }
    
    var form_type=\"Standard\";
    var operationnality=\"\";
    
    if (parent!=\"\" && parent.SAN_RDPM_UA_B_PARENT_SOURCING_REQ)
    {	
    	if (parent.SAN_UA_RDPM_RES_TYP_PHAR)
    	{
    		form_type=\"R&D Pharma\";
    	}
    	else
    	{
    		if (parent.SAN_UA_RDPM_RES_TYP_PAST)
    		{
    			form_type=\"R&D Pasteur\";
    			operationnality=\"Direct\";
    		}
    	}	
    	var name = parent.SAN_RDPM_UA_S_SOURCING_REQUEST_PREFIX+\"XXXXX\";
    	var link = new Hyperlink(\"CreationForm\",
    	\"Class\",\"RESOURCE\",
    	\"EditorType\",\"SAN_RDPM_POPUP_SOURCING_FORM\"
    	,\"DefaultA1\",\"ELEMENT-OF\"
    	,\"DefaultV1\",parent
    	,\"DefaultA2\",\"NAME\"
    	,\"DefaultV2\",name
    	,\"DefaultA3\",\"SAN_RDPM_UA_S_SOURCING_NAME_REQUEST\"
    	,\"DefaultV3\",name
    	,\"DefaultA4\",\"SAN_UA_RDPM_RES_OPER\"
    	,\"DefaultV4\",operationnality
    	,\"DefaultA5\",\"SAN_RDPM_UA_B_INSOURCING_REQUEST\"
    	,\"DefaultV5\",true
    	,\"DefaultA6\",\"SAN_RDPM_UA_S_SOURCING_STATUS\"
    	,\"DefaultV6\",\"New\"
    	,\"DefaultA7\",\"SAN_RDPM_RO_SOURCING_REQUESTOR\"
    	,\"DefaultV7\",context.callstringformula(\"$CURRENT_USER \")
    	,\"DefaultA8\",\"FILE\"
    	,\"DefaultV8\",\"SAN_CF_DEFAULT_RES_DATA\"
    	);
    	link.go();
    }
    else
    {
    	plw.alert(\"Please select a service or a team to create a new insourcing request!\");
    }
}

// Initiate fees from rate card
function san_rdpm_sourcing_tool_initiate_fees(resource)
{
	var rate_card_code = resource.SAN_RDPM_UA_S_RATE_CARD_ID;
	var rate_card = plc.__USER_TABLE_SAN_RDPM_UT_SOURCING_RATE_CARD.get(rate_card_code);
	if (rate_card instanceof plc.__USER_TABLE_SAN_RDPM_UT_SOURCING_RATE_CARD)
	{
		var process = true;
		if (Resource.SAN_RDPM_UA_N_SOURCING_PROF_FEES!=0 || Resource.SAN_RDPM_UA_N_SOURCING_TRAVEL_FEES!=0 || Resource.SAN_RDPM_UA_N_SOURCING_IT_FEES!=0 || Resource.SAN_RDPM_UA_N_SOURCING_MANAGEMENT_FEES!=0)
		{
			process = plw.question(\"Fees have already been defined for this request. Do you want to replace them with fees from the rate card?\");
		}
		
		if (process)
		{
			Resource.SAN_RDPM_UA_N_SOURCING_PROF_FEES=rate_card.SAN_RDPM_UA_N_RATE_CARD_PROF_FEE;
			Resource.SAN_RDPM_UA_N_SOURCING_TRAVEL_FEES=rate_card.SAN_RDPM_UA_N_RATE_CARD_TRAVEL_FEE;
			Resource.SAN_RDPM_UA_N_SOURCING_IT_FEES=rate_card.SAN_RDPM_UA_N_RATE_CARD_IT_FEES;
			Resource.SAN_RDPM_UA_N_SOURCING_MANAGEMENT_FEES=rate_card.SAN_RDPM_UA_N_RATE_CARD_MANAGEMENT_FEE;
			Resource.SAN_RDPM_UA_S_SOURCING_CURRENCY=rate_card.SAN_RDPM_UA_S_RATE_CARD_CURRENCY;
		}
	}
	else
	{
		plw.alert(\"There is no rate card defined for this request.\");
	}
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 310382167474
 :VERSION 3
 :_US_AA_D_CREATION_DATE 20210913000000
 :_US_AA_S_OWNER "E0296878"
)