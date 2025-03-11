
(TEMP-TABLE::_AL_PT_AL
 :OBJECT-NUMBER 321222050510
 :NAME "SAN_RDPM_AL_ENTRY_OF_AVAILABILITY"
 :DATASET 118081000141
 :EXTERNAL-ID 0
 :ORIGIN-NUMBER 0
 :ORIGIN-PROJECT 0
 :PARENT 0
 :_AL_AA_AL_B_IS_ACTIVE "1"
 :_AL_AA_AL_B_ON_ALL_MODIF "0"
 :_AL_AA_AL_B_ON_CREATION "1"
 :_AL_AA_AL_B_ON_DELETE "0"
 :_AL_AA_AL_B_ON_LOAD "0"
 :_AL_AA_AL_B_ON_SAVE "0"
 :_AL_AA_AL_N_PRIORITY 0.0d0
 :_AL_AA_AL_S_CLASS "Resource availability"
 :_AL_AA_AL_S_FILTER "TYPE = \"Absence\" AND (EVALUATE_BOOLEAN_ON_OBJECT(\"Resource\", RES, \"ITER_BOOLEAN_THERE_IS_ONE(\\\"AVAILABILITIES\\\", \\\"(TYPE = \\\\\\\"Absence\\\\\\\" or TYPE = \\\\\\\"Standard\\\\\\\") AND (SD<=\\\\\\'\\\"+\\\"\"+(FD-1440)+\"\\\"+\\\"\\\\\\' OR \\\\\\'\\\"+\\\"\"+FD+\"\\\"+\\\"\\\\\\'=-1) AND (FD-1440>=\\\\\\'\\\"+\\\"\"+SD+\"\\\"+\\\"\\\\\\' OR FD=-1) AND NOT ((SD=-1 OR SD<=\\\\\\'\\\"+\\\"\"+SD+\"\\\"+\\\"\\\\\\') AND (FD=-1 OR FD-1440>=\\\\\\'\\\"+\\\"\"+(FD-1440)+\"\\\"+\\\"\\\\\\'))\\\")\") OR EVALUATE_NUMBER_ON_OBJECT(\"Resource\", RES, \"ITER_NUMBER_SUM(\\\"AVAILABILITIES\\\", \\\"(TYPE = \\\\\\\"Absence\\\\\\\" or TYPE = \\\\\\\"Standard\\\\\\\") AND (SD=-1 OR SD<=\\\\\\'\\\"+\\\"\"+SD+\"\\\"+\\\"\\\\\\') AND (FD=-1 OR FD-1440>=\\\\\\'\\\"+\\\"\"+(FD-1440)+\"\\\"+\\\"\\\\\\')\\\", \\\"QTY*PCT\\\")\") <> 0)"
 :_AL_AA_AL_S_LABEL "Absence entry alert"
 :_AL_AA_AL_S_MSG_LABEL "\"Net availability is not stable or different from 0 during the absence period. Please go to availability pop-up to adjust the absence definition.\""
 :_AL_AA_AL_S_MSG_TYPE "WARNING"
 :_AL_AA_B_CREA_FI "0"
 :_AL_AA_N_ALERT_ONB 0
 :_AL_AA_S_NAME "AVAIBILITY"
 :_AL_SEND_EMAIL "0"
 :_NTF_AA_B_GEN_NOTIF "0"
 :_NTF_RA_REPORTING 0
 :_TALK_RA_SHOUTOUT_MODULE 0
 :_TALK_RA_SHOUTOUT_REPORT 0
)