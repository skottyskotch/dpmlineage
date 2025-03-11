
(JAVASCRIPT::USER-SCRIPT
 :OBJECT-NUMBER 317241664441
 :NAME "SAN_RDPM_JS2_REMOVE_OLD_BRANCH"
 :COMMENT "Script used to remove the OLD_BRANCH in Pharma projects"
 :ACTIVE T
 :DATASET 118081000141
 :LOAD-ORDER 0
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


plw.writetolog(\" --------------- Start macro on dataset ---------\");
var n_nbe_updated_projects = 0;
var n_nbe_complete_errors  = 0;
var n_nbe_partial_errors   = 0;

// in a macro on dataset the available project are only the one set on the batch properties
// we get only the parent project for running the OLD_BRANCH (but indication are also load)
for (var o_prj in plc.ordo_project where o_prj.LOADED && o_prj.VERSION_NUMBER == 0 && o_prj.SAN_RDPM_B_RND_PHARMA_PROJECT && o_prj.PARENT.printattribute()==\"\" && o_prj._INF_NF_S_PRJ_STATE_INTERNAL  == \"ACTIVE\" && o_prj._INF_NF_B_IS_TEMPLATE != true && o_prj._WZD_AA_B_PERMANENT != true){ 

    n_nbe_updated_projects++;
    
    try {
        plw.writetolog(\"[DEBUG] - o_prj = ~a\".format(o_prj.printattribute()));
        
        // récupération de l'activité racine du projet
        var o_root_act = o_prj.san_rdpm_js_get_unique_top_level();
        plw.writetolog(\"[DEBUG][~a] - o_root_act = ~a\".format(o_prj.printattribute(), o_root_act));
        
        
        // on s'assure qu'on parvient bien à récupérer l'activité racine de notre projet
        if(o_root_act instanceof plc.workstructure){
            var o_old_branch = plc.workstructure.get(\"~a/OLD_BRANCH\".format(o_root_act.printattribute()));
            plw.writetolog(\"[DEBUG][~a] - o_old_branch = ~a\".format(o_prj.printattribute(), o_old_branch));
            
            if(o_old_branch instanceof plc.workstructure){
                with([o_old_branch.fromObject(), plw.no_locking, plw.no_alerts]){
                    if(o_old_branch instanceof plc.network){
                        // Suppression custom data
                        plw.writetolog(\"[INFO][~a] - Start of deletion of custom objects\".format(o_prj.printattribute()));
                        var n_nbe_act = 0;
                        var n_nbe_err = 0;
                        for(var o_act in plc.workstructure) {
                            n_nbe_act++;
                            if(o_act.san_rdpm_js_delete_custom_objects() != 0) n_nbe_err++;
                        }
                        if(n_nbe_err == 0) plw.writetolog(\"[INFO][~a] - Summary of deleted custom objects ==> n_nbe_act = ~a (aucune erreur)\".format(o_prj.printattribute(), n_nbe_act));
                        else {
                            plw.writetolog(\"[WARN][~a] - Summary of deleted custom objects ==> n_nbe_act = ~a, n_nbe_err = ~a\".format(o_prj.printattribute(), n_nbe_act, n_nbe_err));
                            n_nbe_partial_errors++;
                        }
                        
                        // suppression OLD_BRANCH
                        plw.writetolog(\"[INFO][~a] - Deletion of the OLD_BRANCH = ~a\".format(o_prj.printattribute(), o_old_branch.printattribute()));
                        o_old_branch.callmacro(\"REMOVE\");
                        plw.writetolog(\"[INFO][~a] - OLD_BRANCH deleted\".format(o_prj.printattribute()));
                    }
                    else if(o_old_branch instanceof plc.task){
                        plw.writetolog(\"[WARN][~a] - The OLD_BRANCH is a TASK !!\".format(o_prj.printattribute()));
                        plw.writetolog(\"[INFO][~a] - Deletion of the OLD_BRANCH = ~a\".format(o_prj.printattribute(), o_old_branch.printattribute()));
                        o_old_branch.callmacro(\"REMOVE\");
                        plw.writetolog(\"[INFO][~a] - OLD_BRANCH deleted\".format(o_prj.printattribute()));
                    }
                    else plw.writetolog(\"[ERROR][~a] - la OLD_BRANCH est un objet non identifie !!!\".format(o_prj.printattribute()));
                }
            }
            else {
                plw.writetolog(\"[WARN][~a] - Impossible to retrieve the OLD_BRANCH of the project\".format(o_prj.printattribute()));
            }
        }
        else {
            plw.writetolog(\"[WARN][~a] - Impossible to retrieve the root activity of the project\".format(o_prj.printattribute()));
        }
    }
    catch(error e){
        plw.writetolog(\"[ERROR][~a] - unexpected error catched ... ==> ~a\".format(o_prj.printattribute(), e));
        e.printStacktrace()
        n_nbe_complete_errors++;
    }
    
}


plw.writetolog(\" ==================================================================================== \");
plw.writetolog(\"           n_nbe_updated_projects = ~a\".format(n_nbe_updated_projects));
plw.writetolog(\"           n_nbe_complete_errors  = ~a\".format(n_nbe_complete_errors));
plw.writetolog(\"           n_nbe_partial_errors   = ~a\".format(n_nbe_partial_errors));
plw.writetolog(\" ==================================================================================== \");
plw.writetolog(\" --------------- End macro on dataset ---------\");
"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :VERSION 1
 :_US_AA_B_BATCH_SCRIPT "1"
 :_US_AA_D_CREATION_DATE 20211028000000
 :_US_AA_S_OWNER "intranet"
)