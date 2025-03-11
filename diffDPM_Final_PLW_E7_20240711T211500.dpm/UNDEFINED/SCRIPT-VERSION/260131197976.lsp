
(JAVASCRIPT::SCRIPT-VERSION
 :OBJECT-NUMBER 260131197976
 :DATASET 118081000141
 :SCRIPT-CODE "/*
* Script V2
* Autor : Bekkal Amine
* JIRA : PC-387  (Monthly baseline taken on entire Pharma project for P, R, C)
* Date Creation 29/10/2020
*/

Namespace _baselineBatch;
plw.writeln(\"Ref names\");
for (var ref in plc._L1_PT_REF_ADMIN)
{
	plw.writeln(ref.NAME);
}

plw.take_Reference_with_parameter_in_batch_ext(plw._admin_us_refGenerateRefName(),plw._admin_us_refGenerateProjectFilter(),plw._admin_us_refGeneratePortfolioFilter(),plw._admin_us_refBatchIsInBulkMode());


"
 :SOURCE-DCR-SYNC-OBJECTS 0
 :USER-SCRIPT 0
 :VERSION 1
 :_US_AA_D_CREATION_DATE 20201103000000
 :_US_AA_S_OWNER "E0455451"
)