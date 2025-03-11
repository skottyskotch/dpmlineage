
(GRID::TABLE-STYLE
 :OBJECT-NUMBER 282806044572
 :NAME "Clinical Study Costs"
 :ADVANCED-STYLE T
 :CONTEXT-DEPENDENCIES ((:CURVE-TYPE10 :ARCHIVE-PREDICTED-COST)
                        (:CURVE-TYPE9 :ESTIMATE-TO-COMPLETE)
                        (:CURVE-TYPE8 :EXPENDITURE)
                        (:CURVE-TYPE7 :BUDGET)
                        (:CURVE-TYPE6 :PREDICTED-COST)
                        (:TIME-UNIT-FORM5 NIL) (:TIME-UNIT-FORM4 NIL)
                        (:TIME-UNIT-FORM3 #.(:ORF'^TUF"WEEK:2C"))
                        (:TIME-UNIT-FORM2 #.(:ORF'^TUF"MONTH:3C"))
                        (:TIME-UNIT-FORM1 #.(:ORF'^TUF"YEAR:4C"))
                        (:DATE-FORMAT5
                         #.(:ORF'^DFT"JJ-MMM-AAAA:HHhIImSSs"))
                        (:DATE-FORMAT4
                         #.(:ORF'^DFT"JJ/MM/AA:HHhIImSSs"))
                        (:DATE-FORMAT3
                         #.(:ORF'^DFT"JJ/MM/AA:HHhIImSSs"))
                        (:DATE-FORMAT2
                         #.(:ORF'^DFT"JJ/MM/AA:HHhIImSSs"))
                        (:DATE-FORMAT1 #.(:ORF'^DFT"JJ-MMM-AA"))
                        (:DURATION-FORMAT5 #.(:ORF'^DUFT"JHMS"))
                        (:DURATION-FORMAT4 #.(:ORF'^DUFT"JHMS"))
                        (:DURATION-FORMAT3 #.(:ORF'^DUFT"JHMS"))
                        (:DURATION-FORMAT2 #.(:ORF'^DUFT"JHMS"))
                        (:DURATION-FORMAT1 #.(:ORF'^DUFT"D"))
                        (:NUMBER-FORMAT5 #.(:ORF'^NFT"standard+"))
                        (:NUMBER-FORMAT4 #.(:ORF'^NFT"standard+"))
                        (:NUMBER-FORMAT3 #.(:ORF'^NFT"#,###.00"))
                        (:NUMBER-FORMAT2 #.(:ORF'^NFT"#,###.0"))
                        (:NUMBER-FORMAT1 #.(:ORF'^NFT"#,###.00"))
                        (:DATE5 NIL)
                        (:DATE4
                         (KERNEL-ORDO:FIND-TYPE-DATE-FROM-NAME
                           :BUDGET))
                        (:DATE3 NIL) (:DATE2 NIL) (:DATE1 NIL)
                        (:CURVE-TYPE5 :PREDICTED-COST)
                        (:CURVE-TYPE4 :BUDGET)
                        (:CURVE-TYPE3 :EXPENDITURE)
                        (:CURVE-TYPE2 :PREDICTED-COST)
                        (:CURVE-TYPE1 :BUDGET)
                        (:TIME-UNIT5
                         #.(:ORF'#%TIME-TYPES:TIME-UNIT:"DAY"))
                        (:TIME-UNIT4
                         #.(:ORF'#%TIME-TYPES:TIME-UNIT:"WEEK"))
                        (:TIME-UNIT3
                         #.(:ORF'#%TIME-TYPES:TIME-UNIT:"MONTH"))
                        (:TIME-UNIT2
                         #.(:ORF'#%TIME-TYPES:TIME-UNIT:"QUARTER"))
                        (:TIME-UNIT1
                         #.(:ORF'#%TIME-TYPES:TIME-UNIT:"MONTH"))
                        (:UNIT5 #.(:ORF'#%TIME-TYPES:TIME-UNIT:"HOUR"))
                        (:UNIT4
                         #.(:cft'DOD:COST-UNIT "Default cost unit" 0))
                        (:UNIT3 #.(:ORF'#%TIME-TYPES:TIME-UNIT:"DAY"))
                        (:UNIT2 #.(:ORF'#%TIME-TYPES:TIME-UNIT:"DAY"))
                        (:UNIT1 #.(:ORF'#%TIME-TYPES:TIME-UNIT:"DAY"))
                        (:_FF_AA_B_PORTFOLIO NIL)
                        (:_PM_AA_S_OBS_PM_FILTER "")
                        (:_PM_AA_S_BS1_FILTER "")
                        (:_PM_AA_S_BS0_FILTER "")
                        (:_INF_AA_B_DO_NOT_DISP_EMPTY_LINES T)
                        (:_PM_AA_S_BS2_PM_FILTER "")
                        (:_PM_AA_S_BS3_PM_FILTER "")
                        (:_PM_AA_S_BS4_PM_FILTER "")
                        (:_PM_AA_S_PM_WBSTYPE_FILTER "")
                        (:_PM_AA_S_PM_COST_ACC_FILTER "")
                        (:_PM_AA_S_BS5_PM_FILTER "")
                        (:GEN_ACT_FILTER "")
                        (:_INF_AA_DISPLAY_SLIDING_SCALE NIL)
                        (:_INF_AA_S_FTE_CAL "Resource calendar")
                        (:_INF_AA_B_OC_SET_FTE NIL)
                        (:_PM_AA_S_WORKFLOW_LEGEND_FILTER_ATTRIBUTE "")
                        (:_INF_AA_D_FIRST_PERIOD_DISPLAYED 29979360)
                        (:_INF_AA_B_FILTER_ACTIVITIES_RBS NIL)
                        (:_PM_AA_S_DATE_STY "")
                        (:_PM_AA_B_DISPLAY_RESOURCE_LOAD NIL)
                        (:_GS_AA_S_USER_SETTINGS_FILE "GLOBALSETTINGS")
                        (:_PRES_AA_B_FORCE_DATES NIL)
                        (:GEN_CHART_DD 27262080)
                        (:USER_ATTRIBUTE_SAN_RDPM_UA_CO_STUDY_CODE "")
                        (:*APPLY-63-LOOK-AND-FEEL-AT-STARTUP* T)
                        (:_INF_AA_B_ADMIN_MODE T)
                        (:GEN_HEADER_FILT_RES NIL))
 :DATASET 118081000141
 :FILTER "( SUM<>0 )"
 :GROUP-READ-ONLY (#.(:UNFINALIZED 'GENERIC-IO:GROUP-OR-USER '"O_GSF_RND" NIL))
 :GROUP-READ-WRITE (#.(:UNFINALIZED 'GENERIC-IO:GROUP-OR-USER '"R_ITS_ADMIN" NIL))
 :IGNORE-DEPENDENCIES T
 :IGNORED-DEPENDENCIES (:UNIT1 :UNIT2 :UNIT3 :UNIT4 :UNIT5 :TIME-UNIT1
                        :TIME-UNIT2 :TIME-UNIT3 :TIME-UNIT4 :TIME-UNIT5
                        :DATE1 :DATE2 :DATE3 :DATE4 :DATE5
                        :NUMBER-FORMAT1 :NUMBER-FORMAT2 :NUMBER-FORMAT3
                        :NUMBER-FORMAT4 :NUMBER-FORMAT5
                        :DURATION-FORMAT1 :DURATION-FORMAT2
                        :DURATION-FORMAT3 :DURATION-FORMAT4
                        :DURATION-FORMAT5 :DATE-FORMAT1 :DATE-FORMAT2
                        :DATE-FORMAT3 :DATE-FORMAT4 :DATE-FORMAT5
                        :TIME-UNIT-FORM1 :TIME-UNIT-FORM2
                        :TIME-UNIT-FORM3 :TIME-UNIT-FORM4
                        :TIME-UNIT-FORM5)
 :ON-CLASS MULTI-CURVE:CURVE
 :OTHER-DATA (:REGION-MANAGER :REGION-DEFINITION
              ((DOD-ARRAY:DOD-ARRAY :REGION-CLASS
                #.(:ORF'#%DOD-ARRAY:DOD-ARRAY-CLASS:"DOD-ARRAY")
                :TOP-POSITION 0 :BOTTOM-POSITION 100 :SCROLLABLE T
                :CURVE-UNIT
                #.(:ORF'^CUNIT"SAN_CF_CONTINUUM_COMMON_DATA:k€")
                :REGROUPEMENT NIL :TABLE-ATTRIBUTES
                (:WORK-STRUCTURE.USER_ATTRIBUTE_SAN_RDPM_UA_ROOT_PROJECT_CODE_F
                 :|#F.Indication%20Description@STRING@STRING_VALUE(%22ACTIVITY%22%2CACTIVITY.SAN_RDPM_UA_ACT_S_INDICATION_ID%2C%22DESC%22)|
                 :WORK-STRUCTURE.USER_ATTRIBUTE_SAN_UA_S_ACT_CALCULATED_STUDY_PHASE
                 :WORK-STRUCTURE.USER_ATTRIBUTE_SAN_RDPM_UA_ACT_S_CALCULATED_STUDY_CODE
                 :WORK-STRUCTURE.USER_ATTRIBUTE_SAN_RDPM_UA_ACT_B_DESAC_COST_ALGO
                 :RESOURCE :CBS-NODE :TIME-SYNTHESIS.TYPE
                 :|#F.Number%20of%20Sites@NUMBER@ACTIVITY.WBS_ELEMENT.SAN_RDPM_CF_SITES|
                 :|#F.Number%20of%20Subjects@NUMBER@ACTIVITY.WBS_ELEMENT.SAN_RDPM_CF_SUBJECTS|
                 :WORK-STRUCTURE.USER_ATTRIBUTE_SAN_RDPM_UF_ACT_D_FPI_PS_F
                 :WORK-STRUCTURE.USER_ATTRIBUTE_SAN_RDPM_UF_ACT_D_LPI_PS_F
                 :WORK-STRUCTURE.USER_ATTRIBUTE_SAN_RDPM_UF_ACT_D_LPLV_PS_F
                 :TIME-SYNTHESIS._INF_AA_NP_PL_EXP_NOTEPAD :TOTAL)
                :FILTER
                #.(:FILT'^CBS'NIL'()"Clinical Costs"^NM'(^RES#.(:F"name=\"TO\"":BOOLEAN'^RES)^DATASET#.(:F"FROM(\"Pharma Project\")":BOOLEAN'^DATASET)#%TEMP-TABLE:WBS_TYPE:#.(:F"BELONGS(\"WBS_TYPE\",OC.SAN_RDPM_CS_AT_CLINICAL_COST_STUDY)":BOOLEAN'#%OBJECT:EMPTY-CLASS:)^WS#.(:F"SAN_RDPM_UA_B_ACT_FILTER":BOOLEAN'^WS))'^$= T)
                :NOTITLE T :TYPE-LIST
                (#.(:ORF'^CCT"SAN_RDPM_CC_AEAC_AUTO")
                 #.(:ETYPE :SAN_ET_RDPM_MANUAL :ARCHIVE-PREDICTED-COST))
                :CUMULATIVE NIL :NON-CUMULATIVE T :SELECTOR
                #.(:F"[TRUE]   and ( SUM<>0 )":BOOLEAN'^CV)
                :SELECTION-START-FORMULA #.(:F"DATE_DEBUT":DATE'^CV)
                :SELECTION-END-FORMULA #.(:F"DATE_FIN":DATE'^CV)
                :USER-LENGTH
                (:TIME-SYNTHESIS._INF_AA_NP_PL_EXP_NOTEPAD 35
                 :|#F.Number%20of%20Subjects@NUMBER@ACTIVITY.WBS_ELEMENT.SAN_RDPM_CF_SUBJECTS|
                 17
                 :|#F.Number%20of%20Sites@NUMBER@ACTIVITY.WBS_ELEMENT.SAN_RDPM_CF_SITES|
                 14 :TIME-SYNTHESIS.TYPE 10
                 :|#F.Indication%20Description@STRING@STRING_VALUE(%22ACTIVITY%22%2CACTIVITY.SAN_RDPM_UA_ACT_S_INDICATION_ID%2C%22DESC%22)|
                 15 :TYPE 6 :CBS-NODE 12
                 :WORK-STRUCTURE.USER_ATTRIBUTE_SAN_RDPM_UA_ACT_B_DESAC_COST_ALGO
                 10 :TIME-SYNTHESIS.COMMENT 23
                 :WORK-STRUCTURE.USER_ATTRIBUTE_SAN_RDPM_UF_ACT_D_LPLV_PS_F
                 17
                 :WORK-STRUCTURE.USER_ATTRIBUTE_SAN_RDPM_UF_ACT_D_LPI_PS_F
                 15
                 :WORK-STRUCTURE.USER_ATTRIBUTE_SAN_RDPM_UF_ACT_D_FPI_PS_F
                 15
                 :WORK-STRUCTURE.USER_ATTRIBUTE_SAN_RDPM_UA_ACT_S_CALCULATED_STUDY_CODE
                 12
                 :WORK-STRUCTURE.USER_ATTRIBUTE_SAN_UA_S_ACT_CALCULATED_STUDY_PHASE
                 19 :|#F.Indication%20Description@STRING@PROJECT.DESC|
                 21
                 :|#F.Project%20Code@STRING@STRING_VALUE(%22PROJECT%22%2CPROJECT.SAN_RDPM_UA_PRJ_S_ROOT_PROJECT%2C%22SAN_UA_RWE_PROJECT_CODE_PRIME%22)|
                 13)
                :CURVE-TYPE-FILTER "*" :TIME-UNIT
                #.(:ORF'#%TIME-TYPES:TIME-UNIT:"YEAR") :SCALE 1.0d0
                :TABLE-FONT #.(:ORF'^STDF"FONT9.8") :GROUPEMENT-FONT
                #.(:ORF'^STDF"FONT10.8") :NUMBER-FORMAT
                #.(:ORF'^NFT"[Nb format #1]") :ORDER
                (:WORK-STRUCTURE.USER_ATTRIBUTE_SAN_RDPM_UA_ROOT_PROJECT_CODE_F
                 :|#F.Indication%20Description@STRING@STRING_VALUE(%22ACTIVITY%22%2CACTIVITY.SAN_RDPM_UA_ACT_S_INDICATION_ID%2C%22DESC%22)|
                 :WORK-STRUCTURE.USER_ATTRIBUTE_SAN_UA_S_ACT_CALCULATED_STUDY_PHASE
                 :WORK-STRUCTURE.USER_ATTRIBUTE_SAN_RDPM_UA_ACT_S_CALCULATED_STUDY_CODE)
                :SPACE-BETWEEN-GROUP 12 :DRAW-LINES T :DRAW-COLUMNS T
                :ITERATION DOD::TIME-SYNTHESIS :CLASS3
                KERNEL-ORDO:RESOURCE :CLASS4 NIL :CLASS5 NIL
                :SELECTION-FORMULA #.(:F"":BOOLEAN'^CTC)
                :SELECTION-CUMULATIVE NIL :SELECTION-BACKGROUND-COLOR
                :|65535| :SELECTION-FOREGROUND-COLOR :|255|
                :ITERATION-FILTER-STRING "*"
                :ITERATION-FILTER-ATTRIBUTE :ID :ITERATION-OPERATOR
                OBJECT-CHOOSER:$= :ITERATION-ALL-SELECTED NIL
                :ITERATION-LIST NIL :SUM NIL :SUM-OPERATOR :SUM
                :SHOW-UNHIGHLIGHTED-CURVES T :SUM-IF >= :SUM-LEVEL 0
                :GROUP-LEVEL 0 :GROUP-LEVEL-OPERATOR >=
                :READ-ONLY-COLOR :GREY91 :READ-WRITE-COLOR :|16777215|
                :TITLE #/F"Tableau de charge"G"Wert-/Zeittabelle"/
                :START-DATE
                #.(:F"'01/01/1980'":DATE'#%ORDO-REQUEST:CONTEXT-OPX2:)
                :END-DATE
                #.(:F"'31/12/2060'":DATE'#%ORDO-REQUEST:CONTEXT-OPX2:)
                :LOAD-CALENDAR "" :DO-NOT-DISPLAY-EMPTY-LINES 1
                :INPUT-MODE T :ALLOW-INPUT-BEFORE T :ALLOW-INPUT-AFTER
                T :INPUT-FIXED-DATES T :MERGE-GROUP-BARS T
                :ALTERNATE-COLORS 0 :COLOR1 :GREY91 :COLOR2 :|14480885|
                :ALTERNATE-BACKGROUND :REPBK :TOPLEVEL-SUMATION-LINE
                NIL :INDENT-CELLS T :SHOW-OBJECT-ICONS NIL
                :CONTOUR-COLOR :GREY :IMPROVED-RENDERING T)))
 :OWNER 5625
 :PTYPES (:|Continuum.RDPM.Pharma|)
 :TABLE-WIDTH 1507
 :_IHM_AA_B_BYPASS_ADV_ST "0"
 :_IHM_DA_CARDSSTYLE-ONB 0
 :_IHM_P6_AA_N_ORDER 0.0d0
)