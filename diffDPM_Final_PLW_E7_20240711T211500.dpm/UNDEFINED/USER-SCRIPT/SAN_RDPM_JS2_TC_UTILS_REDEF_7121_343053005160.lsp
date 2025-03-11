
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 343053005160
 :NAME "SAN_RDPM_JS2_TC_UTILS_REDEF_7121"
 :COMMENT "SAN_RDPM_JS2_TC_UTILS_REDEF_7121"
 :ACTIVE T
 :DATASET 118081000141
 :EVAL-ON-LOAD T
 :LOAD-ORDER 0
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_TC_UTILS_REDEF_7121
// 
//  AUTHOR  : A. HENRY
//
//  
//  Creation V0 2024/05/15 AHENRY
//  Creation of the script to readapt the resource filter after 7121. function used in updated san_rdpm_tc_js_list_resources
//
//***************************************************************************/
namespace _san_rdpm_tc_search;

function san_getResourcesOfUser( plc.grouporuser _grouporuser , HashTable _ht , Date _tcDate , Boolean _allResourceInactive ) {
	if( san_isAdminResource( _grouporuser ) ) {
		with( false.fromObject() ) {
			for( var plc.Resource res in plc.Resource ) {
				if( san_resourceAvailable( res , _tcDate , _allResourceInactive ) ) {
					_ht.set( res , #MANAGER_AND_CONTROLLER# );
				}
			}
		}
	}
	else {
	// MANAGED
		for( var plc.Resource res in _grouporuser.managed_resources ) {
			if( san_resourceAvailable( res , _tcDate , _allResourceInactive ) ) {
				_ht.set( res , #MANAGER# );
			}
			with( res.fromObject() ) {
				for ( var plc.Resource res_child in plc.Resource ) {
					if( res != res_child && san_resourceAvailable( res_child , _tcDate , _allResourceInactive ) ) {
						_ht.set( res_child , ( res.san_getTimecardParameter( #VALIDATION-MODE# ) == #RBS# ) ? #MANAGER_AND_CONTROLLER# :  #MANAGER# );
					}
				}
			}
		}
		// RECURSIVE FOR USER'S GROUP
		if( _grouporuser instanceof plc.opx2user ) {
			for( var plc.UserGroup gr in _grouporuser.getInternalValue( #GROUPS_LIST# ) ) {
				san_getResourcesOfUser( gr , _ht , _tcDate , _allResourceInactive );
			}
		}
	}
	return _ht;
}

function san_profileAllowToViewAllResources( plc.opx2user _user ) {
	if( _user && _user.san_getTimeCardParameter( #ALLOW-ADMINISTRATOR-TO-VIEW-ALL-RESOURCES# ) != #NO-ACCES# ) {
		return true;
	}
	return false;
}

function san_isAdminResource( plc.grouporuser _groupOrUser ) {
	if( _groupOrUser instanceof plc.opx2user) {
		var plc.opx2user user = _groupOrUser as plc.opx2user;
		if( user.admin && context._INF_NF_B_SUPERUSER_MODE && context._TC_AA_B_ACCES_TO_ALL_RESOURCE && san_profileAllowToViewAllResources( user ) ) {
			return true;
		}
	}
	return false;
}

function san_resourceAvailable ( plc.Resource _res , Date _tcDate , Boolean _allResourceInactive ) {
	if( _res ) {
	// if( _res && _res.isTCResource() ) { // isTCResource kernel function not Processes API
		if( _res.inactive == false ) return true;
		else if( _allResourceInactive ) return true;
		else if( _tcDate && _res.CONTRACT_END_DATE && _res.CONTRACT_END_DATE > _tcDate ) return true;
	}
	return false;
}

method san_getTimeCardProfile on plc.Resource() {
	var plc.TimeCardProfile profile = tcklib.getResourceTimecardProfile( this );
	if ( profile ) {
		return profile;
	}
	return plc.TimeCardProfile.get(context._TC_ST_S_STANDARD_PROFILE);
}

method san_getTimeCardProfile on plc.opx2User() {
	var plc.Resource resource = plc.Resource.get( context._tc_aa_s_resource ); // dont call _tc_da_resource
	if( resource ) {
		return resource.san_getTimeCardProfile();
	}
	return undefined;
}

method san_getTimeCardParameter on plc.opx2user( Symbol _slot ) {
	var plc.TimeCardParameter profile = this.san_getTimeCardProfile();
	if( profile ) {
		return profile.san_getTimeCardParameter( _slot );
	}
	return undefined;
}

method san_getTimeCardParameter on plc.Resource( Symbol _slot ) {
	var plc.TimeCardParameter profile = this.san_getTimeCardProfile();
	if( profile ) {
		return profile.san_getTimeCardParameter( _slot );
	}
	return undefined;
}

method san_getTimeCardParameter on plc.TimeCardProfile( Symbol _slot ) {
	//var plc.TimeCardParameter profile = this.getTimeCardProfile();
	var plc.TimeCardParameter tcp = ( this != plc.TimeCardProfile.get(context._TC_ST_S_STANDARD_PROFILE)) ? this : function() {with( plw.map_shadowed_objects ) {return plc.TimeCardParameter.get( 1 );}}.call();
	if( tcp && _slot ) {
		return tcp.getInternalValue( _slot );
	} else if( tcp ) {
		return tcp;
	}
	return undefined;
}"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 0
 :_US_AA_B_BATCH_SCRIPT "0"
 :_US_AA_D_CREATION_DATE 20240522000000
 :_US_AA_S_OWNER "intranet"
)