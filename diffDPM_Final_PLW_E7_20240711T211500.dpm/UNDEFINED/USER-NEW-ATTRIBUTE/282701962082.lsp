
(NEW-ATTRIBUTE::USER-NEW-ATTRIBUTE
 :OBJECT-NUMBER 282701962082
 :NAME :SAN_RDPM_UA_S_PLANNED_SUBMISSION
 :COMMENT "Planned Submission"
 :DATASET 118081000141
 :DEFAULT-VALUE -1
 :FORMULA "IF NOT SAN_UA_S_ACT_STUDY_TYPE IN(\"CTD\",\"CTDCV\") THEN ITER_DATE_MAX(\"ALL_CHILDREN\",\"BELONGS(\\\"WBS_TYPE\\\",\\\"AME Submission,IND AMDT submission,CAC package submission,1st CTA submission,US submission,CN submission,EU submission,JP submission,Submission,US submission OL Technical Milestone,EU submission OL Technical Milestone,CTI submission,CTN submission,IND CN submission,Submission CN,DSUR submission (D60),IND Filing,MEU Submission,Package submission for Meeting country,MJP Submission,Package submission for Presubm Meeting JP,MUS Submission,FDA EOP2 meeting Package submission,EU Orphan Package submission,JP Final Package Submission,EMA Scientific Advice EOP2 Package submission,US Orphan Package submission,PIP Submission,EU PIP Package submission,US PSP Package submission\\\")\",\"PF-'1d'\") ELSE IF SAN_UA_S_ACT_STUDY_TYPE IN(\"CTD\",\"CTDCV\") AND WBS_TYPE IN(\"EU submission\",\"US submission\",\"US submission OL Technical Milestone\",\"EU submission OL Technical Milestone\",\"Submission\") THEN PF-'1d' FI FI"
 :NCLASS KERNEL-ORDO:WORK-STRUCTURE
 :PTYPES (:|Continuum.RDPM.Pharma|)
 :SOURCE-DCR-SYNC-OBJECTS 0
 :TYPE TIME-TYPES:DATE+
)