
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 317241664741
 :DATASET 118081000141
 :SCRIPT-CODE "// 
//  PLWSCRIPT : SAN_RDPM_JS2_REMOVE_OLD_BRANCH
//  call on intranet batch SAN_RDPM_BA_REMOVE_OLD_BRANCH
//
//  Revision 0.1 2021/10/28 wbenredjeb 
//  Creation to automate the deletion of the OLD_BRANCH (https://snfimce.atlassian.net/browse/PC-4836)
//
//***************************************************************************/
namespace _san_rdpm_remove_old_branch;

/**
 * methode permettant de recuperer l'unique toplevel-ws d'un projet. Elle se base sur la fonction processes _UtilsGetTopLevel
 * et retourne un élément uniquement si le vecteur retournée par cette denière contient un seul élément
 *
 * ATTENTION : Valeur récupérée par copie et non par référence
 */
method san_rdpm_js_get_unique_top_level on plc.ordo_project(){
    var v_root = plw._UtilsGetTopLevel(this);
    if(v_root instanceof vector && v_root.length == 1) return v_root[0];
    else return false;
}

/**
 * method implémantant la partie custom de la suppression d'une activité
 * pour ce faire, 
 *   - on supprime les éventuels \"WBS Form Data\" ainsi que les \"GCI Information\"
 *   - on vide le champ \"SAN_RDPM_UA_LINKED_TO_KMS\" en cas de besoin
 */
method san_rdpm_js_delete_custom_objects on plc.workstructure() {
    // construction de la nom de la fonction pour les log
    var string _sLogName = \"san_rdpm_js_delete_custom_objects\";

    // debug
    plw.writetolog(\"[DEBUG] - [~a] - Entrée dans la fonction ==> o_act = ~s\".format(_sLogName, this.printattribute()));
    
    // init des variables 
    var plc.workstructure o_act = this;
    var n_return_code = 0;
    var n_deleted_wbsform  = 0;
    var n_deleted_gci_info = 0;
    var n_updated_link_kms = 0;
    
    try {
        for(var o_wbs_form_data in o_act.get(\"USER_ATTRIBUTE_INVERSE_SAN_UA_WBS_FORM_DATA_ACTIVITY.__USER_TABLE_SAN_RDPM_UT_WBS_FORM_DATA\")){
            try {
                o_wbs_form_data.callmacro(\"REMOVE\");
                n_deleted_wbsform++;
            }
            catch(error e){
                plw.writetolog(\"[ERROR] - [~a] - unexpected error catched when deleting WBS Form data ~a ... ==> ~a\".format(_sLogName, o_wbs_form_data.printattribute(), e));
                e.printStacktrace();
                n_return_code++;
            }
        }
        for(var o_gci_assay_inf in o_act.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_GCI_ASSAY_ACTIVITY.__USER_TABLE_SAN_RDPM_UT_CGI_ASSAY_ACTIVITY\")){
            try {
                o_gci_assay_inf.callmacro(\"REMOVE\");
                n_deleted_gci_info++;
            }
            catch(error e){
                plw.writetolog(\"[ERROR] - [~a] - unexpected error catched when deleting GCI Information ~a ... ==> ~a\".format(_sLogName, o_wbs_form_data.OBJECT_NUMBER, e));
                e.printStacktrace();
                n_return_code++;
            }
        }
        
        for(var o_linked_to_kms in o_act.get(\"USER_ATTRIBUTE_INVERSE_SAN_RDPM_UA_LINKED_TO_KMS.WORK-STRUCTURE\")){
            try {
                o_linked_to_kms.SAN_RDPM_UA_LINKED_TO_KMS = undefined;
                n_updated_link_kms++;
            }
            catch(error e){
                plw.writetolog(\"[ERROR] - [~a] - unexpected error catched when updating Linked KMS ~a ... ==> ~a\".format(_sLogName, o_linked_to_kms.printattribute(), e));
                e.printStacktrace();
                n_return_code++;
            }
        }
    }
    catch(error e) {
        plw.writetolog(\"[ERROR] - [~a] - unexpected error catched ... ==> ~a\".format(_sLogName, e));
        e.printStacktrace();
        n_return_code = -1;
    }
    
    plw.writetolog(\"[INFO] - [~a] - n_deleted_wbsform = ~a, n_deleted_gci_info = ~a, n_updated_link_kms = ~a\".format(_sLogName, n_deleted_wbsform, n_deleted_gci_info, n_updated_link_kms));
    return n_return_code;
}
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 317241664441
 :VERSION 0
 :_US_AA_D_CREATION_DATE 20211028000000
 :_US_AA_S_OWNER "E0447620"
)