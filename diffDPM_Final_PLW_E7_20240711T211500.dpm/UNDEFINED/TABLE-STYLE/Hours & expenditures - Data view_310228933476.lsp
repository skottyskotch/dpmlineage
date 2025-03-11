
(GRID::TABLE-STYLE
 :OBJECT-NUMBER 310228933476
 :NAME "Hours & expenditures - Data view"
 :CONTEXT-DEPENDENCIES ((:CURVE-TYPE10 :ARCHIVE-PREDICTED-COST)
                        (:CURVE-TYPE9 :ESTIMATE-TO-COMPLETE)
                        (:CURVE-TYPE8 :EXPENDITURE)
                        (:CURVE-TYPE7 :BUDGET)
                        (:CURVE-TYPE6 :PREDICTED-COST)
                        (:TIME-UNIT-FORM5 OBJECT:UNBOUND)
                        (:TIME-UNIT-FORM4 #.(:ORF'^TUF"DAY:2CWEEK"))
                        (:TIME-UNIT-FORM3 #.(:ORF'^TUF"WEEK:2C"))
                        (:TIME-UNIT-FORM2 #.(:ORF'^TUF"MONTH:3C"))
                        (:TIME-UNIT-FORM1 #.(:ORF'^TUF"YEAR:4C"))
                        (:DATE-FORMAT5
                         #.(:ORF'^DFT"JJ-MM-AAAA HH:II:SS"))
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
                        (:NUMBER-FORMAT1 #.(:ORF'^NFT"#,###"))
                        (:DATE5 OBJECT:UNBOUND) (:DATE4 OBJECT:UNBOUND)
                        (:DATE3 OBJECT:UNBOUND) (:DATE2 OBJECT:UNBOUND)
                        (:DATE1 OBJECT:UNBOUND)
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
                        (:GEN_ACT_FILTER "")
                        (:_GS_AA_S_USER_SETTINGS_FILE "GLOBALSETTINGS")
                        (:GEN_HEADER_FILT_RES "")
                        (:_GUI_AA_S_LEFT_PANEL_VALUE "TREEVIEW")
                        (:_GUI_AA_B_HIDE_TREEVIEW NIL)
                        (:_INF_AA_B_ADMIN_MODE T)
                        (:_GUI_AA_S_SEARCH_TREEVIEW ""))
 :DATASET 118081000141
 :FILTER "RES._INF_AA_B_GENERIC_RES"
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
 :ON-CLASS DOD::TIME-SYNTHESIS
 :OTHER-DATA (:OBJECT-GRID (:COLUMN-GROUPS NIL)
              (:ATTRIBUTES
               (:WORK-STRUCTURE :COMMENT :RESOURCE :EFFECTIVE-LOAD
                :REMAINING-LOAD :INPUT-UNIT :TYPE :START-DATE :END-DATE
                :CBS :DISTRIBUTION :PREDICTED-COST :BUDGET))
              (:SORT (:START-DATE))
              (:GROUP-BY
               (#{ARBO:ARBO@^NTWK} #.(:gc ':_GPL1 ':_GPF1)
                #.(:gc ':_GPL2 ':_GPF2) #.(:gc ':_GPL3 ':_GPF3)
                #.(:gc ':_GPL4 ':_GPF4) #.(:gc ':_GPL5 ':_GPF5)))
              (:REPORT-MODE-NUMBER-OF-COLUMNS 1)
              (:DISPLAY-SUM-AT-END 0)
              (:DISPLAY-REPORT-GROUP-AND-SORT 1) (:INDENT-CELLS 1)
              (:NUMBER-OF-REPORTS-PER-PAGE 50)
              (:REPORT-DISPLAYED-RW NIL) (:REPORT-DISPLAYED-RO NIL)
              (:REPORT-MODE 0) (:THUMBNAIL-LABEL-POSITION :TOP)
              (:THUMBNAIL-TOOLTIP-FORMULA
               #.(:F"MC_AA_T_NOTEPAD":STRING'#%DOD:TIME-SYNTHESIS:))
              (:THUMBNAIL-LABEL-FORMULA
               #.(:F"ID":STRING'#%DOD:TIME-SYNTHESIS:))
              (:THUMBNAIL-IMAGE-FIELD NIL) (:THUMBNAIL-SIZE :64X64)
              (:THUMBNAIL-MODE 0) (:DISPLAY-IMAGE-FIELDS 0)
              (:MAX-LINE-HEIGHT 100) (:DISPLAY-RICH-TEXT 1)
              (:ADJUST-LINE-HEIGHT-TO-CONTENT 0) (:SHELL-HEIGHT 754)
              (:SHELL-WIDTH 1536) (:READ-WRITE-COLOR :|16777215|)
              (:READ-ONLY-COLOR :GREY90) (:LABEL-SUPRESSED-COLOR :GREY)
              (:LABEL-MODIFIED-COLOR :DARK-GREEN)
              (:LABEL-DEFAULT-COLOR |0|) (:LABEL-COLOR :|255|)
              (:LABEL-FORMULA
               #.(:F"FALSE":BOOLEAN'#%DOD:TIME-SYNTHESIS:))
              (:GROUP-LEVEL 0) (:GROUP-LEVEL-OPERATOR >=)
              (:LEVEL-LIMITATION-NUMBER 0)
              (:LEVEL-LIMITATION-OPERATION >=) (:DRAW-COLUMNS 0)
              (:DRAW-LINES 0)
              (:FONT #{GRAPHIC-TYPES:STANDARD-FONT@FONT9.9})
              (:SHOW-OBJECT-ICONS 0) (:SHOW-HIDDEN-OBJECTS 0)
              (:SPACE-BETWEEN-GROUP 12)
              (:OBJECT-CLASS DOD::TIME-SYNTHESIS)
              (:FOLLOW-SUBCLASSES T)
              (:LABEL-FONT #{GRAPHIC-TYPES:STANDARD-FONT@FONT9.9})
              (:GROUP-FONT #{GRAPHIC-TYPES:STANDARD-FONT@FONT10.8})
              (:MERGE-GROUP-BARS 1) (:INITIAL-GROUP-LEVEL NIL)
              (:COLOR1 :LINEV) (:COLOR2 :LINOD) (:ALTERNATE-COLORS 1)
              (:ALTERNATE-BACKGROUND :REPBK)
              (:DISPLAY-PARENTS-OF-FILTERED-OBJECTS 0)
              (:FORCE-GROUP-MERGE 0) (:DISPLAY-GROUP-OBJECTS 0)
              (:ATTRIBUTE-WIDTH-PLIST
               (:COMMENT 24 :DATASET 10 :BUDGET 15 :DISTRIBUTION 10
                :END-DATE 10 :UNIT 5 :REMAINING-LOAD 10 :EFFECTIVE-LOAD
                10 :TYPE 10 :RESOURCE 15 :WORK-STRUCTURE 15 :CBS 15))
              (:SUMAV-TO-DO NIL) (:SPLIT-INFO NIL)
              (:FIXED-WIDTH-ATTRIBUTES NIL) (:CHANGED-FORMATS NIL)
              (:SHORTCUT-HIDDEN-IN-INTRANET-PAGES ("")))
 :OWNER 5625
 :PTYPES (:|Continuum.RDPM.Pharma|)
 :TABLE-WIDTH 0
 :_IHM_AA_B_BYPASS_ADV_ST "0"
 :_IHM_DA_CARDSSTYLE-ONB 0
 :_IHM_P6_AA_N_ORDER 0.0d0
)