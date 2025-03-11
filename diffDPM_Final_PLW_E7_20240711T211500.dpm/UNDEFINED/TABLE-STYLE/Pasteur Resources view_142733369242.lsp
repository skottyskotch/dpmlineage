
(GRID::TABLE-STYLE
 :OBJECT-NUMBER 142733369242
 :NAME "Pasteur Resources view"
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
                        (:DATE-FORMAT1 #.(:ORF'^DFT"JJ/MM/AAAA"))
                        (:DURATION-FORMAT5 #.(:ORF'^DUFT"JHMS"))
                        (:DURATION-FORMAT4 #.(:ORF'^DUFT"JHMS"))
                        (:DURATION-FORMAT3 #.(:ORF'^DUFT"JHMS"))
                        (:DURATION-FORMAT2 #.(:ORF'^DUFT"JHMS"))
                        (:DURATION-FORMAT1 #.(:ORF'^DUFT"D"))
                        (:NUMBER-FORMAT5 #.(:ORF'^NFT"#,###"))
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
                        (:_RE_AA_B_MENU_CLOSED NIL)
                        (:_INF_AA_B_ADMIN_MODE T)
                        (:_GS_AA_S_USER_SETTINGS_FILE "GLOBALSETTINGS"))
 :DATASET 118081000141
 :FILTER "( ( _TC_DA_S_TC_PROFILE IN (\"PASTEUR\")  ) )"
 :GROUP-READ-WRITE (#.(:UNFINALIZED 'GENERIC-IO:GROUP-OR-USER '"P_ADM" NIL))
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
 :ON-CLASS KERNEL-ORDO:RESOURCE
 :OTHER-DATA (:OBJECT-GRID (:COLUMN-GROUPS NIL)
              (:ATTRIBUTES
               (:INACTIVE :NAME :COMMENT :COST-VALUE :TIME-UNIT
                :_INF_AA_B_GENERIC_RES :CALENDAR :OVERTIME-CALENDAR
                :OBS :_RM_REVIEW_RA_LOCATION :RSKILLS :|Res_manager|
                :USER-MANAGER :USER-MANAGERS :CONTROLLER :HIRING-DATE
                :CONTRACT-END-DATE :_TC_DA_S_TC_PROFILE :DATASET
                :RESOURCE_COLOR))
              (:SORT NIL)
              (:GROUP-BY
               (#{ARBO:ARBO@^RES} #.(:gc ':_GPL1 ':_GPF1)
                #.(:gc ':_GPL2 ':_GPF2) #.(:gc ':_GPL3 ':_GPF3)
                #.(:gc ':_GPL4 ':_GPF4) #.(:gc ':_GPL5 ':_GPF5)))
              (:REPORT-MODE-NUMBER-OF-COLUMNS 1)
              (:DISPLAY-SUM-AT-END 0)
              (:DISPLAY-REPORT-GROUP-AND-SORT 1) (:INDENT-CELLS 1)
              (:NUMBER-OF-REPORTS-PER-PAGE 50)
              (:REPORT-DISPLAYED-RW NIL) (:REPORT-DISPLAYED-RO NIL)
              (:REPORT-MODE 0) (:THUMBNAIL-LABEL-POSITION :TOP)
              (:THUMBNAIL-TOOLTIP-FORMULA #.(:F"NOTE_PAD":STRING'^RES))
              (:THUMBNAIL-LABEL-FORMULA #.(:F"ID":STRING'^RES))
              (:THUMBNAIL-IMAGE-FIELD NIL) (:THUMBNAIL-SIZE :64X64)
              (:THUMBNAIL-MODE 0) (:DISPLAY-IMAGE-FIELDS 0)
              (:MAX-LINE-HEIGHT 100) (:DISPLAY-RICH-TEXT 1)
              (:ADJUST-LINE-HEIGHT-TO-CONTENT 0) (:SHELL-HEIGHT 956)
              (:SHELL-WIDTH 1920) (:READ-WRITE-COLOR :|16777215|)
              (:READ-ONLY-COLOR :ROCC) (:LABEL-SUPRESSED-COLOR :GREY)
              (:LABEL-MODIFIED-COLOR :DARK-GREEN)
              (:LABEL-DEFAULT-COLOR :LABEL) (:LABEL-COLOR :LABHI)
              (:LABEL-FORMULA #.(:F"FAUX":BOOLEAN'^RES))
              (:GROUP-LEVEL 0) (:GROUP-LEVEL-OPERATOR >=)
              (:LEVEL-LIMITATION-NUMBER 0)
              (:LEVEL-LIMITATION-OPERATION >=) (:DRAW-COLUMNS 0)
              (:DRAW-LINES 1)
              (:FONT #{GRAPHIC-TYPES:STANDARD-FONT@FONT8.10.B})
              (:SHOW-OBJECT-ICONS 0) (:SHOW-HIDDEN-OBJECTS 0)
              (:SPACE-BETWEEN-GROUP 12)
              (:OBJECT-CLASS KERNEL-ORDO:RESOURCE)
              (:FOLLOW-SUBCLASSES T)
              (:LABEL-FONT #{GRAPHIC-TYPES:STANDARD-FONT@FONT10.8})
              (:GROUP-FONT #{GRAPHIC-TYPES:STANDARD-FONT@FONT10.8})
              (:MERGE-GROUP-BARS 1) (:INITIAL-GROUP-LEVEL NIL)
              (:COLOR1 :LINEV) (:COLOR2 :LINOD) (:ALTERNATE-COLORS 0)
              (:ALTERNATE-BACKGROUND :REPBK)
              (:DISPLAY-PARENTS-OF-FILTERED-OBJECTS 0)
              (:FORCE-GROUP-MERGE 0) (:DISPLAY-GROUP-OBJECTS 0)
              (:ATTRIBUTE-WIDTH-PLIST
               (:USER-MANAGERS 33 :INACTIVE 8 :RESOURCE_COLOR 5
                :|Res_manager| 16 :_TC_DA_S_TC_PROFILE 15 :CALENDAR 16
                :_INF_AA_B_GENERIC_RES 6 :TIME-UNIT 7 :COST-VALUE 5
                :_TC_DA_S_TC_PORTFOLIO 23 :CURRENT-TIME-CARD-PROFILE 21
                :_TCM_NF_S_CURRENT_PORT 24 :USER-MANAGER 15 :CONTROLLER
                15 :DATASET 10 :_INF_SF_RES_COLOR 4 :RESOURCE_FILE 6
                :RSKILLS 15 :COMMENT 20 :NAME 15 :OBS 11 :ELEMENT-OF
                14))
              (:SUMAV-TO-DO NIL) (:SPLIT-INFO NIL)
              (:FIXED-WIDTH-ATTRIBUTES
               (:USER-MANAGERS T :INACTIVE T :CALENDAR T :|Res_manager|
                T))
              (:CHANGED-FORMATS NIL)
              (:SHORTCUT-HIDDEN-IN-INTRANET-PAGES ("")))
 :OWNER 5625
 :TABLE-WIDTH 0
 :_IHM_AA_B_BYPASS_ADV_ST "0"
 :_IHM_DA_CARDSSTYLE-ONB 0
 :_IHM_P6_AA_N_ORDER 0.0d0
)