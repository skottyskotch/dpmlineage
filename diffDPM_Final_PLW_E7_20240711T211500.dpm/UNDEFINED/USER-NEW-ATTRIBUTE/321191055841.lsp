
(NEW-ATTRIBUTE::USER-NEW-ATTRIBUTE
 :OBJECT-NUMBER 321191055841
 :NAME :SAN_RDPM_UA_B_ISSUE_CHECK
 :COMMENT "Issues check"
 :DATASET 118081000141
 :FORMULA "(DU <>0) OR ((TASK_TYPE = \"End milestone\" OR TASK_TYPE =\"Task\" ) AND  MONTH_NUMBER(PF) = MONTH_NUMBER($DATE_OF_THE_DAY ) AND  YEAR_NUMBER(PF) = YEAR_NUMBER($DATE_OF_THE_DAY ) AND NOT ?FINISHED ) OR (TASK_TYPE = \"Start milestone\" AND  MONTH_NUMBER(PS) = MONTH_NUMBER($DATE_OF_THE_DAY ) AND YEAR_NUMBER(PS) = YEAR_NUMBER($DATE_OF_THE_DAY ) AND NOT ?FINISHED ) OR (SAN_RDPM_SF_MS_ACH = \"NOT ACHIEVED WITHIN THE YEAR\" AND SAN_RDPM_UA_DEVIATION_ROOT_CAUSE =\"\") OR (IF BELONGS(\"WBS_TYPE\",\"First Approval,Other Approvals,First Submission,Other Submissions,Start Ph03,Start Ph02\") THEN ( PF < EVALUATE_DATE_ON_OBJECT(\"Activity\",SAN_RDPM_UA_ACT_S_INDICATION_ID,\"ITER_DATE_MAX(\\\"ALL_CHILDREN\\\", \\\"?TASK AND Belongs(\\\\\\\"WBS_TYPE\\\\\\\",\\\\\\\"Start Ph01,\" +(IF NOT BELONGS(\"WBS_TYPE\",\"Start Ph02\") THEN \"Start Ph02,\" FI) +(IF NOT BELONGS(\"WBS_TYPE\",\"Start Ph02,Start Ph03\") THEN \"Start Ph03,\" FI) +\"\\Lead Selection - M1,Start Development - M2\\\\\\\")\\\" ,\\\"PF\\\")\") ) FI) OR (IF BELONGS(\"WBS_TYPE\",\"First Launch,Other Launch\") THEN ( PS < EVALUATE_DATE_ON_OBJECT(\"Activity\",SAN_RDPM_UA_ACT_S_INDICATION_ID,\"ITER_DATE_MAX(\\\"ALL_CHILDREN\\\", \\\"?TASK AND Belongs(\\\\\\\"WBS_TYPE\\\\\\\", \\\\\\\"Start Ph01,Start Ph02,Start Ph03,Lead Selection - M1,Start Development - M2\\\\\\\")\\\" ,\\\"pf\\\")\") ) FI) "
 :NCLASS KERNEL-ORDO:WORK-STRUCTURE
 :PTYPES (:|Continuum.RDPM.Pasteur|)
 :SOURCE-DCR-SYNC-OBJECTS 0
 :TYPE OBJECT:YES-OR-NO
)