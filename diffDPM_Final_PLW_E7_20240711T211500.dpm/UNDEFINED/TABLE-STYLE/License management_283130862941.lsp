
(GRID::TABLE-STYLE
 :OBJECT-NUMBER 283130862941
 :NAME "License management"
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
                         #.(:ORF'^DFT"JJ/MM/AA:HHhIImSSs"))
                        (:DATE-FORMAT4
                         #.(:ORF'^DFT"JJ/MM/AA:HHhIImSSs"))
                        (:DATE-FORMAT3
                         #.(:ORF'^DFT"JJ/MM/AA:HHhIImSSs"))
                        (:DATE-FORMAT2
                         #.(:ORF'^DFT"JJ/MM/AA:HHhIImSSs"))
                        (:DATE-FORMAT1 #.(:ORF'^DFT"MM/JJ/AA"))
                        (:DURATION-FORMAT5 #.(:ORF'^DUFT"JHMS"))
                        (:DURATION-FORMAT4 #.(:ORF'^DUFT"JHMS"))
                        (:DURATION-FORMAT3 #.(:ORF'^DUFT"JHMS"))
                        (:DURATION-FORMAT2 #.(:ORF'^DUFT"JHMS"))
                        (:DURATION-FORMAT1 #.(:ORF'^DUFT"D"))
                        (:NUMBER-FORMAT5 #.(:ORF'^NFT"standard+"))
                        (:NUMBER-FORMAT4 #.(:ORF'^NFT"standard+"))
                        (:NUMBER-FORMAT3 #.(:ORF'^NFT"#,###.00"))
                        (:NUMBER-FORMAT2 #.(:ORF'^NFT"#,###.0"))
                        (:NUMBER-FORMAT1 #.(:ORF'^NFT"#,###"))
                        (:DATE5 NIL) (:DATE4 NIL) (:DATE3 NIL)
                        (:DATE2 NIL) (:DATE1 NIL)
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
                         #.(:ORF'#%TIME-TYPES:TIME-UNIT:"YEAR"))
                        (:UNIT5 #.(:ORF'#%TIME-TYPES:TIME-UNIT:"HOUR"))
                        (:UNIT4
                         #.(:cft'DOD:COST-UNIT "Default cost unit" 0))
                        (:UNIT3 #.(:ORF'#%TIME-TYPES:TIME-UNIT:"DAY"))
                        (:UNIT2 #.(:ORF'#%TIME-TYPES:TIME-UNIT:"DAY"))
                        (:UNIT1
                         #.(:cft'DOD:COST-UNIT "Default cost unit" 0))
                        (:*APPLY-63-LOOK-AND-FEEL-AT-STARTUP* T)
                        (:_INF_AA_B_ADMIN_MODE T)
                        (:_FF_AA_B_ONLY_FAVORITES NIL)
                        (:_RE_AA_B_MENU_CLOSED NIL)
                        (:_ADM_AA_S_DM_CREATED_OBJECT "")
                        (:_ADM_AA_S_OC_CONF_DATASET_CLASS "")
                        (:_GS_AA_S_USER_SETTINGS_FILE "GLOBALSETTINGS")
                        (:_GUI_AA_B_P6_NAVIGATION_MODE T))
 :DATASET 118057330253
 :FILTER "OPX2_INTRANET_ACCESS and (SAN_UA_D_USR_CRE_CON =\"\" or DIFF_DATE(SAN_UA_D_USR_CRE_CON ,$DATE_OF_THE_DAY,\"\")>='180d') and (SAN_UA_D_USR_LAST_CON = \"\" or DIFF_DATE(SAN_UA_D_USR_LAST_CON,$DATE_OF_THE_DAY,\"\")>='180d')"
 :GROUP-READ-ONLY (#.(:UNFINALIZED 'GENERIC-IO:GROUP-OR-USER '"P_ADM" NIL))
 :GROUP-READ-WRITE (#.(:UNFINALIZED 'GENERIC-IO:GROUP-OR-USER '"P_ADM" NIL))
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
 :ON-CLASS GENERIC-IO:OPX2-USER
 :OTHER-DATA (:OBJECT-GRID (:COLUMN-GROUPS NIL)
              (:ATTRIBUTES
               (:INACTIVE :NAME :COMMENT :MAIL-ADDRESS
                :USER_ATTRIBUTE_SAN_CHC_UA_D_USR_CRE_CON
                :USER_ATTRIBUTE_SAN_CHC_UA_D_USR_LAST_CON
                :OPX2-INTRANET-ACCESS :ADMIN :POWER-USER
                :LIST-OF-GROUPS :PROXY
                :USER_ATTRIBUTE_SAN_UA_CHC_B_IRIS_USER
                :USER_ATTRIBUTE_SAN_UA_CHC_B_TEAM_MEMBER
                :LAST-TRANSACTION-DATE))
              (:SORT (:NAME)) (:GROUP-BY NIL)
              (:REPORT-MODE-NUMBER-OF-COLUMNS 1)
              (:DISPLAY-SUM-AT-END 0)
              (:DISPLAY-REPORT-GROUP-AND-SORT 1) (:INDENT-CELLS 1)
              (:NUMBER-OF-REPORTS-PER-PAGE 50)
              (:REPORT-DISPLAYED-RW NIL) (:REPORT-DISPLAYED-RO NIL)
              (:REPORT-MODE 0) (:THUMBNAIL-LABEL-POSITION :TOP)
              (:THUMBNAIL-TOOLTIP-FORMULA
               #.(:F"DOCUMENTATION":STRING'^OPUS))
              (:THUMBNAIL-LABEL-FORMULA #.(:F"ID":STRING'^OPUS))
              (:THUMBNAIL-IMAGE-FIELD NIL) (:THUMBNAIL-SIZE :64X64)
              (:THUMBNAIL-MODE 0) (:DISPLAY-IMAGE-FIELDS 0)
              (:MAX-LINE-HEIGHT 100) (:DISPLAY-RICH-TEXT 0)
              (:ADJUST-LINE-HEIGHT-TO-CONTENT 0) (:SHELL-HEIGHT 520)
              (:SHELL-WIDTH 1278) (:READ-WRITE-COLOR :|16777215|)
              (:READ-ONLY-COLOR :ROCC) (:LABEL-SUPRESSED-COLOR :GREY)
              (:LABEL-MODIFIED-COLOR :DARK-GREEN)
              (:LABEL-DEFAULT-COLOR :LABEL) (:LABEL-COLOR :LABHI)
              (:LABEL-FORMULA #.(:F"FALSE":BOOLEAN'^OPUS))
              (:GROUP-LEVEL 0) (:GROUP-LEVEL-OPERATOR >=)
              (:LEVEL-LIMITATION-NUMBER 0)
              (:LEVEL-LIMITATION-OPERATION >=) (:DRAW-COLUMNS 0)
              (:DRAW-LINES 1)
              (:FONT #{GRAPHIC-TYPES:STANDARD-FONT@FONT8.10.B})
              (:SHOW-OBJECT-ICONS 0) (:SHOW-HIDDEN-OBJECTS 0)
              (:SPACE-BETWEEN-GROUP 12)
              (:OBJECT-CLASS GENERIC-IO:OPX2-USER)
              (:FOLLOW-SUBCLASSES T)
              (:LABEL-FONT #{GRAPHIC-TYPES:STANDARD-FONT@FONT9.9})
              (:GROUP-FONT #{GRAPHIC-TYPES:STANDARD-FONT@FONT9.8})
              (:MERGE-GROUP-BARS 1) (:INITIAL-GROUP-LEVEL NIL)
              (:COLOR1 :LINEV) (:COLOR2 :LINOD) (:ALTERNATE-COLORS 0)
              (:ALTERNATE-BACKGROUND :REPBK)
              (:DISPLAY-PARENTS-OF-FILTERED-OBJECTS 0)
              (:FORCE-GROUP-MERGE 0) (:DISPLAY-GROUP-OBJECTS 0)
              (:ATTRIBUTE-WIDTH-PLIST
               (:MAIL-ADDRESS 10 :READ-ONLY-ACCESS 10 :TIME-CARD-ONLY
                10 :SHAREPOINT-ACCESS 10 :EXPLORER-ACCESS 10
                :TEAM-MEMBER 10 :POWER-USER 9 :LIST-OF-GROUPS 20
                :OPX2-INTRANET-ACCESS 19 :OPX2-TIME-CARD-ACCESS 5
                :OPX2-PRO-ACCESS 13 :COMMENT 20 :ADMIN 15 :NAME 15))
              (:SUMAV-TO-DO NIL) (:SPLIT-INFO NIL)
              (:FIXED-WIDTH-ATTRIBUTES
               (:OPX2-PRO-ACCESS T :ADMIN T :OPX2-INTRANET-ACCESS T))
              (:CHANGED-FORMATS NIL))
 :OWNER 117954015159
 :TABLE-WIDTH 0
 :_IHM_AA_B_BYPASS_ADV_ST "0"
 :_IHM_DA_CARDSSTYLE-ONB 0
 :_IHM_P6_AA_N_ORDER 0.0d0
)