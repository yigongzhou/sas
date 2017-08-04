

DATA other_a;
  set parent.new_parent;


if famno ne 'D79356';

xfamno=1*famno;

if xfamno in (750451,
              750553,
              760510,
              770349,
              770374,
              770580,
              790204,
              790494,
              790739,
              800492,
              810376,
              810451,
              810534,
              820151,
              820224,
              830063,
              830063,
              830393,
              830622,
              830730,
              850646,
              860490,
              860752);

other=1;
xparidno=1*idno;


keep xfamno xparidno other;

proc sort; 
  by xfamno;


DATA other;
  set other_a; 
  by xfamno;
  if first.xfamno;


DATA mom;
  set parent.new_parent;

if famno ne 'D79356';

if idno='003';
mom=1;
xparidno=1*idno;
xfamno=1*famno;


keep xfamno xparidno mom;

proc sort;
  by xfamno;
run;


DATA dad_a;
  set parent.new_parent;

if famno ne 'D79356';

if idno='004';
dad=1;

xparidno=1*idno;
xfamno=1*famno;


keep xfamno xparidno dad;

proc sort;
   by xfamno;
run;


DATA dad;
  merge mom dad_a; 
   by xfamno;

if dad=1 and mom=.;


DATA parentmerge;
  merge mom dad other;
    by xfamno;

if mom ne 1 then mom=0;
if dad ne 1 then dad=0;
if other ne 1 then other=0;

proc sort;
   by xfamno xparidno;
run;


DATA test;
  set parent.new_parent;

if famno ne 'D79356';

xfamno=1*famno;
xparidno=1*idno;
drop famno idno;

proc sort; 
  by xfamno xparidno;
run;


DATA oneparent;
  merge parentmerge (in=a) test (in=b);
    by xfamno xparidno;
    if a;

parentint=1;

keep xfamno xparidno mom dad other parentint;

proc sort;
  by xfamno;
run;





*------------------------------------------*;
****WAVE 1 (BASELINE DATA) (From Alexis)****;
*------------------------------------------*;

****Baseline data from the younger twin cohort - ages 13-15 (i.e., "baby twin" data)****;
DATA yadol;
  set baseline.new_yadoltwn;

***This variable will enable you to subset on the younger cohort after merging is complete;
yadol=1;



**************************************;
****BASELINE ALCOHOL- YOUNGER ADOL****;
**************************************;
if g4 ne '  ' then bl_alcuse=1;
  else bl_alcuse=0;


**************************************;
****BASELINE SMOKING- YOUNGER ADOL****;
**************************************;

***Ever Smoker***;
if (f1a_you eq '5' or f1a1_you eq '5') then bl_smkev=1;
  else if f1a1_you ne '9' and (f1a_you eq '1' or f1a1_you eq '1') then bl_smkev=0;

if bl_smkev=1 then bl_agesmk=1*f1c_you;
  label bl_agesmk='age at first cigarette - baseline';

***Regular Smoker (at least once a week for 3 weeks)***;
if bl_smkev ne . then do;
if f3 in ('3','4','5') and f3a in ('V','Z','Y') then do; bl_smkreg=1;
  bl_agsmkreg=1*f3b; end;
else do; bl_smkreg=0; end;

***Daily Smoking***;
if f3 eq '5' then do; bl_smkdaily=1;
  bl_agsmkdaily=1*f3c; end;
  else if f3 ne '5' then do; bl_smkdaily=0; end;

***100+ Cigarettes***;
if f3a in ('V','Z','Y') then bl_cig100=1;
  else bl_cig100=0;

if f4='5' and f4b in ('3','4','5') then bl_cursmk=0;
  else if f4='1' or (f4=5 and f4b in ('0','1','2')) then bl_cursmk=1;
  else if bl_smkev ne . then bl_cursmk=0;

if f6 in ('S','T','U','W','X') then bl_11cigf6 = 1;
  else if f6 in ('Q','R') then bl_11cigf6=0;
label bl_11cigf6='baseline f6: currently smoke 11+ cigs';

if f10 in ('S','T','U','W','X') then bl_11cigf10=1;
  else if f10 in ('Q','R') then bl_11cigf10=0;
label bl_11cigf10='baseline f10: smoked 11+ cigs when smoked most';

if bl_cursmk=1 then do;
if bl_11cigf6=1 or bl_11cigf10=1 then bl_cur11cig=1;
end;
end;

if f1_1=5 or f1=4 then bl_clfrsmk=1;
  else if f1_1=1 or f1=1 then bl_clfrsmk=0;
label bl_clfrsmk='any of closest friends smoke - baseline';


***********************************************************;
****BASELINE GENERALIZED ANXIETY DISORDER- YOUNGER ADOL****;
***********************************************************;

**Criterion A loose (sympt for 1 mo) & strict (sympt for 6 mo)**;
**Any symptoms; 
if k1="5" or k1a="5" or k1b="5" or k1c="5" then blgadA=1;
  else if k1="1" or k1a="1" or k1b="1" or k1c="1" then blgadA=0;

if k4a="5" then blgad1mo=1;
  else if k4a="1" then blgad1mo=0;

if k5_mth ne '99' and k5_mth ne ' ' then do;
if k5_mth ge '06' then blgad6mo=1;
  else if k5_mth lt '06' then blgad6mo=0;
end; 

if blgadA ne ' ' and blgad1mo ne ' ' then do;
if blgadA=1 and blgad1mo=1 then blgadA1mo=1;
  else blgadA1mo=0;
end;

if blgadA ne ' ' and blgad6mo ne ' ' then do;
if blgadA=1 and blgad6mo=1 then blgadA6mo=1;
  else blgadA6mo=0;
end; 

**Criterion B, difficult to control worry**;
if k6="5" then blgadB=1;
  else if k6="1" then blgadB=0;

**Criterion C, number of symptoms**;
if blgadA ne ' ' and blgadA ne 0 then do; 
if k3a1="5" or k3a2="5" then blgadC1=1; else if k3a1="1" or k3a2="1" then blgadC1=0;
if k3b1="5" then blgadC2=1; else if k3b1="1" then blgadC2=0;
if k3c1="5" then blgadC3=1; else if k3c1="1" then blgadC3=0;
if k3d1="5" then blgadC4=1; else if k3d1="1" then blgadC4=0;
if k3e1="5" then blgadC5=1; else if k3e1="1" then blgadC5=0;
if k3f1="5" then blgadC6=1; else if k3f1="1" then blgadC6=0;
end; 

blgadsum=sum(blgadC1, blgadC2, blgadC3, blgadC4, blgadC5, blgadC6); 

if blgadsum ne ' ' then do; 
if blgadsum ge 1 then blgadC=1; 
  else if blgadsum=0 then blgadC=0;
end; 

**Criterion D not assessed (worry not attributable to other disorder)**;

**Criterion E, anxiety causes impairment in social or occupational situations**;
if k8="5" or k8a="5" or k8b="5" then blgadE=1;
  else if k8="1" and  k8a="1" and  k8b="1" then blgadE=0;

**Criterion F, anxiety not due to substance or medical problem**;
if (k9="1" or k9a="1") and (k10="1" or k10a="1" or k10b="1") then blgadF=1;
  else if k9a="5" or k10a="5" or k10b="5" then blgadF=0; 

**Presence of any GAD symptoms;
if blgadA ne ' ' then do;
if blgadA=0 or blgadC=0 then bl_yagad1=0;
  else if blgadA=1 and blgadC=1 then bl_yagad1=1;
end;
label bl_yagad1='baseline yadol 1+ GAD symptom';

**GAD assessment;
if blgadA ne ' ' then do; 
if blgadA1mo=1 and blgadA6mo=0 and blgadB=1 and blgadC=1 and blgadE=1 and blgadF=1 then bl_yagad=1;
  else if blgadA6mo=1 and blgadB=1 and blgadC=1 and blgadE=1 and blgadF=1 then bl_yagad=2;
  else bl_yagad=0;
end; 
label bl_yagad='baseline yadol GAD, 1=1-6 months, 2=6+months';

if blgadA ne ' ' then do;
if blgadA=1 and blgadsum ge 3 then bl_yagad3=1;
  else if blgadA=0 or 0 le blgadsum le 2 then bl_yagad3=0;
end; 
label bl_yagad3='baseline yadol 3+ GAD symptoms';


******************************************;
****BASELINE CHILD ABUSE- YOUNGER ADOL****;
******************************************;

**Physical Abuse**;

if a25you_f = '1' then bl_hitd = 1;
if a25you_f in ('2', '3', '4', '5') then bl_hitd = 0;
label bl_hitd = 'hit by dad';

if a25you_m = '1' then bl_hitm = 1;
if a25you_m in ('2', '3', '4', '5') then bl_hitm = 0;
label bl_hitm = 'hit by mom';

if (bl_hitm = 1) or (bl_hitd = 1) then bl_hit = 1;
if (bl_hitm = 0) and (bl_hitd ne 1) then bl_hit = 0;
label bl_hit = 'baseline - hit by mom or dad';

if a26you_f = '4' then bl_hrphyd = 1;
if a26you_f in ('1', '2', '3', '5') then bl_hrphyd = 0;
if a26you_f = '3' then bl_negdisd = 1;
if a26you_f in ('1', '2', '4', '5') then bl_negdisd = 0;

if a26you_m = '4' then bl_hrphym = 1;
if a26you_m in ('1', '2', '3', '5') then bl_hrphym = 0;
if a26you_m = '3' then negdism1 = 1;
if a26you_m in ('1', '2', '4', '5') then bl_negdism = 0;

if (bl_hrphym = 1) or (bl_hrphyd = 1) then bl_hrphy = 1;
if (bl_hrphym = 0) and (bl_hrphyd ne 1) then bl_hrphy = 0;
if (bl_negdism = 1) or (bl_negdisd = 1) then bl_negdis = 1;
if (bl_negdism = 0) and (bl_negdisd ne 1) then bl_negdis = 0;

if a27 = '5' then bl_hurtad = 1;
if a27 = '1' then bl_hurtad = 0;

if (bl_hit = 1) or (bl_hrphy = 1) or (bl_negdis = 1) or (bl_hurtad = 1) then bl_cpa = 1;
if (bl_hit = 0) and (bl_hrphy = 0) and (bl_negdis = 0) and (bl_hurtad = 0) then bl_cpa = 0;

bl_chaslt = 1*bl_cpa;


/*
** No sexual abuse questions in health section (or early childhood) **;
* Estimate age onset physical abuse (6-12) - NO EXACT AGE REPORTED FOR ANY ABUSE *;
if cpa_1 = 1 then agtrm1 = 9;
anytrm1 = 1*cpa_1;
*/


*Endorsed only hit or hurt by adult *;
if bl_hit = 1 and bl_negdis ne 1 and bl_hurtad ne 1 and bl_hrphy ne 1 then bl_hitonly = 1;
  else bl_hitonly = 0;

if bl_hurtad = 1 and bl_negdis ne 1 and bl_hit ne 1 and bl_hrphy ne 1 then bl_hrtonly = 1; 
  else bl_hrtonly = 0;




***Baseline data from the older twins - ages 16-23 (i.e., "big twin" data)***;
DATA adol;
  set baseline.new_adoltwin;




***Variable for later subsetting of older twins***;
adol=1;

if g4 ne '  ' then bl_alcuse=1;
  else bl_alcuse=0;


************************************;
****BASELINE SMOKING- OLDER ADOL****;
************************************;

***Ever Smoker***;

if (f1a_you eq '5' or f1a1_you eq '5') then bl_smkev=1;
  else if f1a1_you ne '9' and (f1a_you eq '1' or f1a1_you eq '1') then bl_smkev=0;

if bl_smkev=1 then bl_agesmk=1*f1c_you;
label bl_agesmk='age at first cigarette - baseline';

***Regular Smoker (at least once a week for 3 weeks)***;
if bl_smkev ne . then do;
if f3 in ('3','4','5') and f3a in ('V','Z','Y') then do; bl_smkreg=1;
  bl_agsmkreg=1*f3b; end;
  else do; bl_smkreg=0; end;

***Daily Smoking***;
if f3 eq '5' then do; bl_smkdaily=1;
  bl_agsmkdaily=1*f3c; end;
  else if f3 ne '5' then do; bl_smkdaily=0; end;

***100+ Cigarettes***;
if f3a in ('V','Z','Y') then bl_cig100=1;
  else bl_cig100=0;

if f4='5' and f4b in ('3','4','5') then bl_cursmk=0;
  else if f4='1' or (f4=5 and f4b in ('0','1','2')) then bl_cursmk=1;
  else if bl_smkev ne . then bl_cursmk=0;

if f6 in ('S','T','U','W','X') then bl_11cigf6 = 1;
  else if f6 in ('Q','R') then bl_11cigf6=0;
label bl_11cigf6='baseline f6: currently smoke 11+ cigs';

if f10 in ('S','T','U','W','X') then bl_11cigf10=1;
  else if f10 in ('Q','R') then bl_11cigf10=0;
label bl_11cigf10='baseline f10: smoked 11+ cigs when smoked most';

if bl_cursmk=1 then do;
if bl_11cigf6=1 or bl_11cigf10=1 then bl_cur11cig=1;
end;
end;

if f1_1=5 or f1=4 then bl_clfrsmk=1;
  else if f1_1=1 or f1=1 then bl_clfrsmk=0;
label bl_clfrsmk='any of closest friends smoke - baseline';


*********************************************************;
****BASELINE GENERALIZED ANXIETY DISORDER- OLDER ADOL****;
*********************************************************;

**Criterion A, excessive anxiety for 6 months**;
**Any Symptoms; 
if k1="5" or k1a="5" or k1b="5" or k1c="5" then oblgadA=1;
  else if k1="1" or k1a="1" or k1b="1" or k1c="1" then oblgadA=0;

if k4a="5" then oblgad6mo=1;
  else if k4="1" or k4a="1" then oblgad6mo=0;

if oblgadA ne ' ' and oblgad6mo ne ' ' then do;
if oblgadA=1 and oblgad6mo=1 then oblgadA6mo=1;
  else oblgadA6mo=0;
end; 

**Criterion B, difficult to control worry**;
if k6="5" then oblgadB=1;
  else if k6="1" then oblgadB=0;

**Criterion C, number of symptoms**;
if oblgadA ne ' ' and oblgadA ne 0 then do; 
if k3a1="5" or k3a2="5" then oblgadC1=1; else if k3a1="1" or k3a2="1" then oblgadC1=0;
if k3b1="5" then oblgadC2=1; else if k3b1="1" then oblgadC2=0;
if k3c1="5" then oblgadC3=1; else if k3c1="1" then oblgadC3=0;
if k3d1="5" then oblgadC4=1; else if k3d1="1" then oblgadC4=0;
if k3e1="5" then oblgadC5=1; else if k3e1="1" then oblgadC5=0;
if k3f1="5" then oblgadC6=1; else if k3f1="1" then oblgadC6=0;
end; 

oblgadsum=sum(oblgadC1, oblgadC2, oblgadC3, oblgadC4, oblgadC5, oblgadC6); 

if oblgadsum ne ' ' and a1 ne ' ' then do; 
if (a1 le 17 and oblgadsum ge 1) or (a1 ge 18 and oblgadsum ge 3) then oblgadC=1;
  else oblgadC=0;
end; 

**Criterion D not assessed (worry not attributable to other disorder)**;

**Criterion E, anxiety causes impairment in social or occupational situations**;
if k8="5" or k8a="5" or k8b="5" then oblgadE=1;
  else if k8="1" and  k8a="1" and  k8b="1" then oblgadE=0;

**Criterion F, anxiety not due to substance or medical problem**;
if (k9="1" or k9a="1") and (k10="1" or k10a="1" or k10b="1") then oblgadF=1;
  else if k9a="5" or k10a="5" or k10b="5" then oblgadF=0; 


**Presence of Any GAD Symptoms**;
if oblgadA ne ' ' then do;
if oblgadA=0 or oblgadC=0 then bl_oldgad1=0;
  else if oblgadA=1 and oblgadC=1 then bl_oldgad1=1;
end;
label bl_oldgad1='baseline older 1+ GAD symptom';

**GAD Assessment**;
if oblgadA ne ' ' then do; 
if oblgadA6mo=1 and oblgadB=1 and oblgadC=1 and oblgadE=1 and oblgadF=1 then bl_oldgad=1;
  else bl_oldgad=0;
end; 
label bl_oldgad='baseline older GAD';

if oblgadA ne ' ' then do;
if oblgadA=1 and oblgadsum ge 3 then bl_oldgad3=1;
  else if oblgadA=0 or 0 le oblgadsum le 2 then bl_oldgad3=0;
end; 
label bl_oldgad3='baseline older 3+ GAD symptoms';


***********************************;
****BASELINE TRAUMA- OLDER ADOL****;
***********************************;

**Endorsement on Trauma Checklist - can endorse multiple events**;

if n2 = '5' then bl_natdis = 1;
if n2 = '1' then bl_natdis = 0; 
if bl_natdis = 1 and n2_ons ne '00' and n2_ons ne '01' and n2_ons ne 'MM' and n2_ons ne 'RR' then blagnatd = 1*n2_ons;

if n1 = '5' then bl_accident = 1;
if n1 = '1' then bl_accident = 0;
if bl_accident = 1 and n1_ons ne '00' and n1_ons ne '01' and n1_ons ne '99' and n1_ons ne 'MM' and n1_ons ne 'RR' then blagacc = 1* n1_ons;

if n3 = '5' then bl_witness = 1;
if n3 = '1' then bl_witness = 0;
if bl_witness = 1 and n3_ons ne 'MM' and n3_ons ne 'RR' then blagwit = 1* n3_ons;


/*
if n7 = '5' then phab_1a = '1';
if n7 = '1' then phab_1a = '0';
if phab_1a = '1' and n7_ons ne '00' and n7_ons ne '01' and n7_ons ne '99' then agphab1a = 1*n7_ons;
if agphab1a ne . and agphab1a le 15 then phab_1 = 1; 
if phab_1a = '0' then phab_1 = 0;
if agphab1a ge 16 then phab_1 = 0; 
if phab_1 = 1 then agphab_1 = 1*agphab1a;

if phab_1a = '1' and agphab1a ge 16 then phas_1a = 1; 
if (phab_1a = '0') or (agphab1a le 15) then phas_1a = 0;
if phas_1a = 1 then agphas1a = 1*agphab1a;

if n6 = '5' then phas_1b = 1;
if n6 = '1' then phas_1b = 0;
if phas_1b = 1 then agphas1b = 1*n6_ons;
if (phas_1a = 1) or (phas_1b = 1) then phas_1 = 1;
if phas_1a = 0 and phas_1b = 0 then phas_1 = 0;
if phas_1 = 1 then agphas_1 = min(agphas1a, agphas1b); 
if (phas_1 = 1) then recphas1 = 1*n6_rec;
if recphas1 gt agphas_1 then phas2_1 = 1;
if (phas2_1 = 1) and (recphas1 ge 16) and (agphas_1 le 15) then pabthag1 = 1;
if (agphas_1 ne .) and (agphas_1 le 15) then pachld_1 = 1;
if (phas_1 = 0) or (agphas_1 ge 16) then pachld_1 = 0;
if (agphas_1 ge 16) or (pabthag1 = 1) then paadlt_1 = 1;
if (phas_1 = 0) or ((agphas_1 ne .) and (agphas_1 le 15) and (pabthag1 ne 1)) then paadlt_1 = 0;
*/


if n9 = '5' then bl_weapon = 1;
if n9 = '1' then bl_weapon = 0;
if bl_weapon = 1 and n9_ons ne '1' then blagweap = 1*n9_ons;
if (bl_weapon = 1) then blrecweap = 1*n9_rec;

if n8='5' then bl_neglect=1;
  else if n8='1' then bl_neglect=0;


/*
if n11 = '5' then oth_1 = 1;
if n11 = '1' then oth_1 = 0;
if oth_1 = 1 and n11a_ons ne '00' and n11a_ons ne '01' and n11a_ons ne 'MM' and n11a_ons ne 'RR' then agoth_1 = 1*n11a_ons;

**Any items endorsed**;
chklt1 = max(oth_1, natdis_1, acc_1, rape_1, mol_1, phab_1, phas_1, NEg_1, weap_1, wit_1);

**Calculate earliest age exposure any event on checklist**;
agchklt1 = min(agoth_1, agnatd_1, agacc_1, agrape_1, agmol_1, agphab_1, agphas_1, agneg_1, agweap_1, agwit_1);
*/


****************************************;
****BASELINE CHILD ABUSE- OLDER ADOL****;
****************************************;
**Physical Abuse AGES 6-12 - no onset age for any questions**;

if n7 = '5' then cpa_cl = 1;
if n7 = '1' then cpa_cl = 0;
if cpa_cl = 1 and n7_ons ne '00' and n7_ons ne '01' and n7_ons ne '99' then cpaclons = 1*n7_ons;
if cpaclons ne . and agphab1a le 15 then bl_cpa1 = 1; 
if cpa_cl = 0 then bl_cpa1 = 0;
label bl_cpa1 = 'baseline cpa from trauma checklist';

if cpa_cl = '1' and n7_ons ne '00' and n7_ons ne '01' and n7_ons ne '99' then agphab1a = 1*n7_ons;
if agphab1a ne . and agphab1a le 15 then phab_1 = 1; 
if cpa_cl = '0' then phab_1 = 0;
if agphab1a ge 16 then phab_1 = 0; 
if phab_1 = 1 then agphab_1 = 1*agphab1a;

if a25you_f = '1' then bl_hitd = 1;
if a25you_f in ('2', '3', '4', '5') then bl_hitd = 0;
if a25you_m = '1' then bl_hitm = 1;
if a25you_m in ('2', '3', '4', '5') then bl_hitm = 0;
if (bl_hitm = 1) or (bl_hitd = 1) then bl_hit = 1;
if (bl_hitm = 0) and (bl_hitd ne 1) then bl_hit = 0;

if a26you_f = '4' then bl_hrphyd = 1;
if a26you_f in ('1', '2', '3', '5') then bl_hrphyd = 0;
label bl_hrphyd='baseline - harsh physical discipline by father';

if a26you_f = '3' then bl_negdisd = 1;
if a26you_f in ('1', '2', '4', '5') then bl_negdisd = 0;
label bl_negdisd='baseline - neglect as discipline by father';

if a26you_m = '4' then bl_hrphym = 1;
if a26you_m in ('1', '2', '3', '5') then bl_hrphym = 0;
label bl_hrphym = 'baseline - harsh physical discipline by mother';

if a26you_m = '3' then bl_negdism = 1;
if a26you_m in ('1', '2', '4', '5') then bl_negdism = 0;
label bl_negdism = 'baseline - neglect as discipline by mother';

if (bl_hrphym = 1) or (bl_hrphyd = 1) then bl_hrphy = 1;
if (bl_hrphym = 0) and (bl_hrphyd ne 1) then bl_hrphy = 0;
label bl_hrphy = 'baseline harsh physical discipline';

if (bl_negdism = 1) or (bl_negdisd = 1) then bl_negdis = 1;
if (bl_negdism = 0) and (bl_negdisd ne 1) then bl_negdis = 0; 
label bl_negdis = 'baseline neglect as discipline';

if a27 = '5' then bl_hurtad = 1;
if a27 = '1' then bl_hurtad = 0;

if (bl_hit = 1) or (bl_hrphy = 1) or (bl_negdis = 1) or (bl_hurtad = 1) then bl_cpa2 = 1;
if (bl_hit = 0) and (bl_hrphy = 0) and (bl_negdis = 0) and (bl_hurtad = 0) then bl_cpa2 = 0;
label bl_cpa2 = 'baseline CPA from the home environment section'; 

if bl_cpa2 = 1 or bl_cpa1=1 then bl_cpa=1;
  else if bl_cpa2=0 and bl_cpa1=0 then bl_cpa=0;
label bl_cpa = 'baseline CPA';


/*
* Estimate onset age for home envir ques as 9. Use only if phys abuse not endorsed in checklist*;
if phab_1 ne 1 and ((hit_1 = 1) or (hurtad_1 = 1) or (hrphy_1 = 1)) then agcpahe1 = 9; 
if neg_1 ne 1 and negdis_1 = 1 then agneghe1 = 9;
*/


**Sexual Trauma Variables**;
if e3='5' then bl_forcedsex=1;
  else if e3='1' then bl_forcedsex=0;

bl_ageforcedsex=1*e3a;

if e3='R' or e3='5' and bl_ageforcedsex=. then bl_adultfs=.;
  else if bl_ageforcedsex ge 16 then bl_adultfs=1;
  else bl_adultfs=0;
label bl_adultfs='forced sex ge 16 reported at baseline';

if n5='5' then bl_molest=1;
  else if n5='1' then bl_molest=0;

if n5_ons ne 99 then bl_agemolest=n5_ons*1;
if n5_rec ne 99 then bl_recmolest=n5_rec*1;

if bl_molest=. or (bl_molest=1 and bl_recmolest=.) then bl_adultmol=.;
  else if bl_molest=1 and bl_recmolest ge 16 then bl_adultmol=1;
  else bl_adultmol=0;

if n4='5' then bl_rape=1;
  else if n4='1' then bl_rape=0;

bl_agerape=n4_ons*1;
bl_recrape=n4_rec*1;

if bl_rape=. or (bl_rape=1 and bl_recrape=.) then bl_adultrape=.;
  else if bl_rape=1 and bl_recrape ge 16 then bl_adultrape=1;
  else bl_adultrape=0;
label bl_adultrape='rape ge 16 reported at baseline';

if 1 le bl_agerape lt 16 or 1 le bl_agemolest lt 16 or 1 le bl_ageforcedsex lt 16 then bl_csa=1;
  else if bl_rape ne . and bl_molest ne . and bl_forcedsex ne . then bl_csa=0;
label bl_csa='CSA reported at baseline';

if bl_rape=1 or bl_forcedsex=1 or bl_molest=1 then bl_sexvic=1;
   else if bl_rape=0 and bl_forcedsex=0 and bl_molest=0 then bl_sexvic=0;
label bl_sexvic='any sexual victimization reported at baseline';

bl_csaons=min(of bl_agerape bl_agemolest bl_ageforcedsex);
label bl_csaons='age onset CSA reported at baseline';




***MERGING the baseline data for younger and older cohorts (i.e., "baby twin" and "big twin")***;
DATA allbase;
  set yadol adol;

***For future subsetting on women with baseline data;
baseline=1;

if adol=. then adol=0;
label adol='older cohort';

if famno ne 'D79356';

***The following lines of code transform character variables to numeric;
xfamno=famno*1;
xidno=idno*1;

blage=a1*1;


********************************;
****BASELINE FAMILY DRINKING****;
********************************;

if h2=5 or h2a='5' then bl_twdrkprob=1;
  else if h2 in ('R','M','7','9') or h2a in ('R','M','7','9') then bl_twdrkprob=.;
  else if (h2 in (1,8)) or (h2a in ('1','8')) then bl_twdrkprob=0;
label bl_twdrkprob='twin has problem or is excessive drinker';

if h2b='5' or h2b1='5' then bl_momdrkprob=1;
  else if h2b='9' or h2b1='9' then bl_momdrkprob=.;
  else if (h2b in ('1','8')) or (h2b1 in ('1','8')) then bl_momdrkprob=0;
label bl_momdrkprob='mom has problem or is excessive drinker';

if h2c='5' or h2c1='5' then bl_daddrkprob=1;
  else if h2c='9' or h2c1='9' then bl_daddrkprob=.;
  else if (h2c in ('1','8')) or (h2c1 in ('1','8')) then bl_daddrkprob=0;
label bl_daddrkprob='dad has problem or is excessive drinker';

if bl_momdrkprob=1 or bl_daddrkprob=1 then bl_pardrkprob=1;
  else if bl_momdrkprob=0 and bl_daddrkprob=0 then bl_pardrkprob=0;
label bl_pardrkprob='parent has problem or is excessive drinker';


********************;
****BASELINE BMI****;
********************;

if a10_ft not in ('2','9') then bl_htft=a10_ft*1;

if a10_in*1 lt 12 then bl_htin=a10_in;

bl_tothtin=(bl_htft*12)+bl_htin;
label bl_tothtin='total BASELINE height in inches';

if a10b not in ('M', 'R','820','035','999') then bl_weight=1*a10b;

Bl_bmi=703*(bl_weight/(bl_tothtin*bl_tothtin));
label bl_bmi='BASELINE BMI';


if bl_bmi ne . then do;
 
if (blage ge 20 and bl_bmi lt 18.5) or
  (blage=19 and bl_bmi lt 18.4) or
  (blage=18 and bl_bmi lt 18.2) or
  (blage=17 and bl_bmi lt 17.8) or
  (blage=16 and bl_bmi lt 17.4) or 
  (blage=15 and bl_bmi lt 16.9) or 
  (blage=14 and bl_bmi lt 16.4) or 
  (blage=13 and bl_bmi lt 15.9) or
  (blage=12 and bl_bmi lt 15.4) then bl_bmicat4=1;  

else if (blage ge 20 and 18.5 le bl_bmi lt 25) or 
  (blage=19 and 18.4 le bl_bmi lt 25) or
  (blage=18 and 18.2 le bl_bmi lt 25) or
  (blage=17 and 17.8 le bl_bmi lt 25) or
  (blage=16 and 17.4 le bl_bmi lt 24.7) or
  (blage=15 and 16.9 le bl_bmi lt 24) or
  (blage=14 and 16.4 le bl_bmi lt 23.3) or 
  (blage=13 and 15.9 le bl_bmi lt 22.5) or
  (blage=12 and 15.4 le bl_bmi lt 21.7) then bl_bmicat4=2;

else if (blage ge 20 and 25 le bl_bmi lt 30) or 
  (blage=19 and 25 le bl_bmi lt 30) or
  (blage=18 and 25 le bl_bmi lt 30) or
  (blage=17 and 25 le bl_bmi lt 29.6) or
  (blage=16 and 24.7 le bl_bmi lt 28.9) or
  (blage=15 and 24 le bl_bmi lt 28.1) or
  (blage=14 and 23.3 le bl_bmi lt 27.2) or
  (blage=13 and 22.5 le bl_bmi lt 26.3) or
  (blage=12 and 21.7 le bl_bmi lt 25.2) then bl_bmicat4=3;

else if (blage ge 20 and bl_bmi ge 30) or 
  (blage=19 and bl_bmi ge 30) or
  (blage=18 and bl_bmi ge 30) or
  (blage=17 and bl_bmi ge 29.6) or
  (blage=16 and bl_bmi ge 28.9) or
  (blage=15 and bl_bmi ge 28.1) or
  (blage=14 and bl_bmi ge 27.2) or
  (blage=13 and bl_bmi ge 26.3) or
  (blage=12 and bl_bmi ge 25.2) then bl_bmicat4=4;
label bl_bmicat4='BMI categorized using child criteria until curve crosses adult cutoff';

if (blage ge 19 and bl_bmi lt 17.8) or
  (blage=18 and bl_bmi lt 17.5) or
  (blage=17 and bl_bmi lt 17.2) or
  (blage=16 and bl_bmi lt 16.8) or 
  (blage=15 and bl_bmi lt 16.3) or 
  (blage=14 and bl_bmi lt 15.8) or 
  (blage=13 and bl_bmi lt 15.3) or
  (blage=12 and bl_bmi lt 14.8) then nblbmicat4=0;  

else if (blage ge 20 and 17.8 le bl_bmi lt 26.5) or 
  (blage=19 and 17.8 le bl_bmi lt 26.1) or
  (blage=18 and 17.5 le bl_bmi lt 25.7) or
  (blage=17 and 17.2 le bl_bmi lt 25.2) or
  (blage=16 and 16.8 le bl_bmi lt 24.6) or
  (blage=15 and 16.3 le bl_bmi lt 24) or
  (blage=14 and 15.8 le bl_bmi lt 23.3) or 
  (blage=13 and 15.3 le bl_bmi lt 22.6) or
  (blage=12 and 14.8 le bl_bmi lt 21.7) then nblbmicat4=1;

else if (blage ge 20 and 26.5 le bl_bmi lt 31.8) or 
  (blage=19 and 26.1 le bl_bmi lt 31.0) or
  (blage=18 and 25.7 le bl_bmi lt 30.3) or
  (blage=17 and 25.2 le bl_bmi lt 29.6) or
  (blage=16 and 24.6 le bl_bmi lt 28.9) or
  (blage=15 and 24 le bl_bmi lt 28.1) or
  (blage=14 and 23.3 le bl_bmi lt 27.2) or
  (blage=13 and 22.6 le bl_bmi lt 26.3) or
  (blage=12 and 21.7 le bl_bmi lt 25.2) then nblbmicat4=2;

else if (blage ge 20 and bl_bmi ge 31.8) or 
  (blage=19 and bl_bmi ge 31) or
  (blage=18 and bl_bmi ge 30.3) or
  (blage=17 and bl_bmi ge 29.6) or
  (blage=16 and bl_bmi ge 28.9) or
  (blage=15 and bl_bmi ge 28.1) or
  (blage=14 and bl_bmi ge 27.2) or
  (blage=13 and bl_bmi ge 26.3) or
  (blage=12 and bl_bmi ge 25.2) then nblbmicat4=3;
label nblbmicat4='baseline BMI category using child criteria';
end;


if bl_bmicat4 in (1,2) then bl_bmicat3=1;
  else if bl_bmicat4=3 then bl_bmicat3=2;
  else if bl_bmicat4=4 then bl_bmicat3=3;
label bl_bmicat3='1=under or normal, 2=over, 3=obese hybrid definition';

if nblbmicat4 in (0,1) then nblbmicat3=1;
  else if nblbmicat4=2 then nblbmicat3=2;
  else if nblbmicat4=3 then nblbmicat3=3;
label nblbmicat3='1=under or normal, 2=over, 3=obese child definition';

if bl_bmicat4 ne . then do; 
if bl_bmicat4=1 then bl_underwgt=1;
  else bl_underwgt=0;
if bl_bmicat4=2 then bl_normal=1;
  else bl_normal=0;
if bl_bmicat4=3 then bl_overwgt=1;
  else bl_overwgt=0;
if bl_bmicat4=4 then bl_obesemor=1;
  else bl_obesemor=0;
if bl_bmicat4 ge 3 then bl_overobes=1;
  else bl_overobes=0;

if nblbmicat4=0 then nblunder=1;
  else nblunder=0;
if nblbmicat4=2 then nblover=1;
  else nblover=0;
if nblbmicat4=3 then nblobese=1;
  else nblobese=0;
if nblbmicat4 in (2,3) then nbloverobes=1;
  else nbloverobes=0;
end;


************************;
****BASELINE FRIENDS****;
************************;

if b12='1' then bl_manyfr=1;
  else if b12 in ('3','2') then bl_manyfr=0;
label bl_manyfr='many friends at baseline';

if b19a in ('1','6') then bl_evbf=0;
  else if b19a in ('5','7') then bl_evbf=1;
label bl_evbf='ever had boyfriend at baseline';
 
if b19d='1' then bl_curbf=0;
  else if b19d in ('2','3','4') then bl_curbf=1;
label bl_curbf='current bf at baseline';


***********************;
****BASELINE SCHOOL****;
***********************;

if b1='1' then bl_notinsch=1;
  else if b1 in ('5','6','7') then bl_notinsch=0;


************************;
****BASELINE ALCOHOL****;
************************;

***Intoxication***;
if g6='5' then bl_intox=1;
  else if bl_alcuse ne . then bl_intox=0;


*********************************;
****BASELINE MAJOR DEPRESSION****;
*********************************;

if j13='5' or j13a='5' or j13b='5' then bl_mdd5sx=1;
  else if j13 not in ('R') and j1 ne '.' then bl_mdd5sx=0;

if bl_mdd5sx ne . then do;
if j15=5 then bl_sawmd=1;
  else if j15 not in ('R') then bl_sawmd=0;

if j16=5 then bl_depmed=1;
  else if j16 not in ('R') then bl_depmed=0;

if j19b=5 or j19d=5 then bl_depresp=1;
  else if j19b not in ('R') then bl_depresp=0;
label bl_depresp='failure to fulfill responsibilities';

if j20a=5 or j20c=5 then bl_deppers=1;
  else if j20a not in ('R') then bl_deppers=0;
label bl_deppers='problems with friends or extracurriculars';

if bl_sawmd=1 or bl_depresp=1 or bl_deppers=1 then bl_mddclin=1;
  else bl_mddclin=0;
label bl_mddclin='baseline depression clinical significance';
end;

if bl_mdd5sx=1 and bl_mddclin=1 then bl_mdd=1;
  else if bl_mdd5sx ne . and bl_mddclin ne . then bl_mdd=0;
label bl_mdd='lifetime major depression at baseline';


******************************;
****BASELINE SOCIAL PHOBIA****;
******************************;

if d2_I1="1" and d2_I2="1" and d2_I3="1" and d2_I4="1" and d2_I5="1"
        and d2_I6="1" and d2_I7="1" and d2_I8="1" and d2_I9="1"
        and d2_I10="1" and d2_I11="1" and d2_I12="1" and d2_I13="1" 
        and d2_I14="1" then blsocphob=0;
  else if d2_I1="5" or d2_I2="5" or d2_I3="5" or d2_I4="5" or d2_I5="5"
        or d2_I6="5" or d2_I7="5" or d2_I8="5" or d2_I9="5"
        or d2_I10="5" or d2_I11="5" or d2_I12="5" or d2_I13="5" 
        or d2_I14="5" then blsocphob=1;

if d2d="5" then blsocphobA=1;
  else if d2d="1" then blsocphobA=0;

if d3b="5" then blsocphobB=1;
  else if d3b="1" then blsocphobB=0;

**Criterion C (person recognizes that the fear is excessive) not assessed;

if d3a="5" then blsocphobD=1;
else if d3a="1" then blsocphobD=0;

if d5a="5" or d5b="5" or d5c="5" then blsocphobE=1;
  else if d5a="1" and d5b="1" and d5c="1" then blsocphobE=0;

if d4="5" then blsocphobF=1;
  else if d4="1" then blsocphobF=0;

if (d6="1" or d6a="1") and (d7="1" or d7a="1" or d7b="1") then blsocphobG=1;
  else if d6a="5" or d7a="5" or d7b="5" then blsocphobG=0; 

if blsocphob ne ' ' then do;
if blsocphob=1 and blsocphobA=1 and blsocphobB=1 and blsocphobD=1 and blsocphobE=1 and blsocphobF=0 and blsocphobG=1 then bl_socphobia=1;
  else if blsocphob=1 and blsocphobA=1 and blsocphobB=1 and blsocphobD=1 and blsocphobE=1 and blsocphobF=1 and blsocphobG=1 then bl_socphobia=2;
  else if blsocphob=0 or blsocphobA=0 or blsocphobB=0 or blsocphobD=0 or blsocphobE=0 or blsocphobF=0 or blsocphobG=0 then bl_socphobia=0;
label bl_socphobia='baseline social phobia, 1= <6 months, 2= 6+ months';
end;


*********************************************;
****BASELINE GENERALIZED ANXIETY DISORDER****;
*********************************************;

**1 Symptom of GAD**;
if bl_yagad1=1 or bl_oldgad1=1 then bl_gad1=1;
  else if bl_yagad1=0 or bl_oldgad1=0 then bl_gad1=0; 
label bl_gad1='baseline GAD, 1 symptom';

**3 Symptoms of GAD**;
if bl_yagad3=1 or bl_oldgad3=1 then bl_gad3=1;
  else if bl_yagad3=0 or bl_oldgad3=0 then bl_gad3=0;
label bl_gad3='baseline GAD, 3 symptoms';

**GAD Strict Criteria**;
if bl_yagad=2 or bl_oldgad=1 then bl_gad=1;
if bl_yagad=1 or bl_yagad=0 or bl_oldgad=0 then bl_gad=0;
label bl_gad='Meets GAD criteria for 6+ months';

**GAD Symptoms 3+ for 6 Months**; 
if (bl_yagad3=1 and blgad6mo=1) or (bl_oldgad3=1 and oblgad6mo=1) then bl_3gad6mo=1;
  else if (bl_yagad3=0 or blgad6mo=0) or (bl_oldgad3=0 or oblgad6mo=0) then bl_3gad6mo=0; 
label bl_3gad6mo='3 or more GAD symptoms for at least 6 months';

 
*************************;
****BASELINE MENARCHE****;
*************************;

if e1 ne '1' and e1a ne 'RR' and e1a ne 'R' and e1a ne '99' and e1a ne '97' then do;
if 0 lt e1a*1 lt 12 then blearlymat=1;
  else if e1a*1 ge 12 then blearlymat=0;
label blearlymat='Baseline: 1st period <12';

blmenarche=1;
blmenarc_yr=e1a*1;
label blmenarc_yr='Baseline: Age at Menarche- Year';
end;

if e1 ne '1' and e1b ne 'RR' and e1b ne 'R' and e1b ne 'MM' and e1b ne 'M' and e1b ne '99' then do;
blmenarc_mo=e1b*1;
label blmenarc_mo='Baseline: Age at Menarche- Month';
end;

blagemenarche = blmenarc_yr + (blmenarc_mo/12);
label blagemenarche='Baseline: Age at Menarche in Years and Months';

lblagemenarche=10*(log(blagemenarche));
label lblagemenarche='Baseline: Age at Menarche- Log-transformed';

if blagemenarche ne . AND blagemenarche lt 12 then blearlymenarche=1;
  else if blagemenarche ne . AND blagemenarche ge 12 then blearlymenarche=0;
label blearlymenarche='Baseline: First menstrural period before age 12';


**Recoding 'physical maturity compared to peers' from a character to a numeric value**;
if e2 eq '1' then ble2r=1;
  else if e2 eq '2' then ble2r=2;
  else if e2 eq '3' then ble2r=3;
  else if e2 eq '5' or e2 eq 'M' or e2 eq 'R' then ble2r=.;
label ble2r='Baseline: physical maturity compared to peers where 0=earlier, 1=same time, 2=later';

if ble2r eq 1 then ble2r_early=1;
  else if ble2r eq 2 or ble2r eq 3 then ble2r_early=0;
label ble2r_early='Baseline: physical maturity compared to peers: comparing early vs. on-time and late';

if ble2r eq 3 then ble2r_late=1;
  else if ble2r eq 1 or ble2r eq 2 then ble2r_late=0;
label ble2r_late='Baseline: physical maturity compared to peers: comparing late vs. early and on-time';




************END OF CREATING VARIABLES/DIAGNOSES AT WAVE 1***********;

keep baseline xfamno xidno blage yadol adol
     bl_manyfr bl_evbf bl_curbf bl_notinsch
     blearlymat blmenarc_yr blmenarc_mo blagemenarche lblagemenarche blearlymenarche
     ble2r ble2r_early ble2r_late
     bl_bmi nblbmicat4 nblunder nblover nblobese nbloverobes
     bl_csa bl_sexvic bl_csaons bl_adultrape bl_adultmol bl_adultfs bl_cpa cpa_cl bl_neglect 
     bl_smkev bl_cig100 bl_cursmk bl_clfrsmk bl_smkreg bl_clfrsmk
     bl_alcuse bl_intox bl_twdrkprob bl_pardrkprob bl_momdrkprob bl_daddrkprob 
     bl_mdd5sx bl_mddclin bl_mdd 
     bl_3gad6mo bl_gad bl_gad3 bl_socphobia;

proc sort;
  by xfamno xidno;
run;


*------------*;
****WAVE 2****;
*------------*;

DATA w2;
  set wave2.new_fupadol;




wave2=1;
w2age=1*a1;

if famno ne 'D79356';

xfamno=1*famno;
xidno=1*idno;

keep xfamno xidno wave2 w2age;

proc sort;
  by xfamno xidno;
run;


************END OF CREATING VARIABLES/DIAGNOSES AT WAVE 2***********;


**MERGING Waves 1 and 2**;
DATA w1w2;
  merge allbase w2;
  by xfamno xidno;


*------------*;
****WAVE 3****;
*------------*;

DATA w3;
  set wave2.new_fup2adol;




wave3=1;
if famno ne 'D79356';

xidno=1*idno;
xfamno=1*famno;


***********************;
****WAVE 3 MENARCHE****;
***********************;

**NOTE: Question E1 was given the variable name 'D1' in the dataset**;
 

if d1 ne '1' and e1a ne 'RR' and e1a ne '99' and e1a ne '97' then do;
if 0 lt e1a*1 lt 12 then w3earlymat=1;
  else if e1a*1 ge 12 then w3earlymat=0;
label w3earlymat='Wave 3: 1st period <12';

w3menarche=1;
w3menarc_yr=e1a*1;
label w3menarc_yr='Wave 3: Age at Menarche- Year';
end;

if d1 ne '1' and e1b ne 'RR' and e1b ne 'MM' and e1b ne '99' then do;
w3menarc_mo=e1b*1;
label w3menarc_mo='Wave 3: Age at Menarche- Month';
end;

w3agemenarche = w3menarc_yr + (w3menarc_mo/12);
label w3agemenarche='Wave 3: Age at Menarche in Years and Months';

lw3agemenarche=10*(log(w3agemenarche));
label lw3agemenarche='Wave 3: Age at Menarche- Log-transformed';

if w3agemenarche ne . AND w3agemenarche lt 12 then w3earlymenarche=1;
  else if w3agemenarche ne . AND w3agemenarche ge 12 then w3earlymenarche=0;
label w3earlymenarche='Wave 3: First menstrural period before age 12';



proc sort;
  by xfamno xidno;
run;


**MERGING Waves 1, 2, and 3**;
DATA w1w2w3;
  merge w1w2 w3;
  by xfamno xidno;



*---------------*;
****PREGNANCY****;
*---------------*;

/*
***This dataset has variables indicating whether twins were known to be pregnant or le 6 months post partum at time of baseline and wave 4 interviews***;
DATA pg;
  set alexis.pregnant;


**proc contents position;
**run;


if w4pg=2 or w4pp=2 then w4pgpp=1;
  else w4pgpp=0;

if blpg=2 or blpp=2 then blpgpp=1;
  else blpgpp=0;


proc sort;
  by xfamno xidno;
run;
*/

*----------------------------*;
****ZYGOSITY AND RACE DATA****;
*----------------------------*;

***This is a dataset that Andrew made that has the best zygosity and race data;
DATA zygtwins;
  set here8.newzyggeo; *(keep=xfamno xidno bestzyg black zygos zygbmi zygageint);




if zygbmi ne . then do;
if (zygageint ge 19 and zygbmi lt 17.8) or
  (zygageint=18 and zygbmi lt 17.5) or
  (zygageint=17 and zygbmi lt 17.2) or
  (zygageint=16 and zygbmi lt 16.8) or
  (zygageint=15 and zygbmi lt 16.3) or
  (zygageint=14 and zygbmi lt 15.8) or
  (zygageint=13 and zygbmi lt 15.3) or
  (zygageint=12 and zygbmi lt 14.8) then zygbmicat4=0;

else if (zygageint ge 20 and 17.8 le zygbmi lt 26.5) or
  (zygageint=19 and 17.8 le zygbmi lt 26.1) or
  (zygageint=18 and 17.5 le zygbmi lt 25.7) or
  (zygageint=17 and 17.2 le zygbmi lt 25.2) or
  (zygageint=16 and 16.8 le zygbmi lt 24.6) or
  (zygageint=15 and 16.3 le zygbmi lt 24) or
  (zygageint=14 and 15.8 le zygbmi lt 23.3) or
  (zygageint=13 and 15.3 le zygbmi lt 22.6) or
  (zygageint=12 and 14.8 le zygbmi lt 21.7) then zygbmicat4=1;

else if (zygageint ge 20 and 26.5 le zygbmi lt 31.8) or
  (zygageint=19 and 26.1 le zygbmi lt 31.0) or
  (zygageint=18 and 25.7 le zygbmi lt 30.3) or
  (zygageint=17 and 25.2 le zygbmi lt 29.6) or
  (zygageint=16 and 24.6 le zygbmi lt 28.9) or
  (zygageint=15 and 24 le zygbmi lt 28.1) or
  (zygageint=14 and 23.3 le zygbmi lt 27.2) or
  (zygageint=13 and 22.6 le zygbmi lt 26.3) or
  (zygageint=12 and 21.7 le zygbmi lt 25.2) then zygbmicat4=2;

else if (zygageint ge 20 and zygbmi ge 31.8) or
  (zygageint=19 and zygbmi ge 31) or
  (zygageint=18 and zygbmi ge 30.3) or
  (zygageint=17 and zygbmi ge 29.6) or
  (zygageint=16 and zygbmi ge 28.9) or
  (zygageint=15 and zygbmi ge 28.1) or
  (zygageint=14 and zygbmi ge 27.2) or
  (zygageint=13 and zygbmi ge 26.3) or
  (zygageint=12 and zygbmi ge 25.2) then zygbmicat4=3;
label zygbmicat4='zygosity interview BMI category using child criteria'; 
end;


proc sort;
  by xfamno xidno;




***MERGING the Wave 1, Wave 2, & Wave 3 data with Zygosity and Race***;
DATA zygbasew2;
  merge w1w2w3 zygtwins;
   by xfamno xidno;




*------------*;
****WAVE 4****;
*------------*;

***This is a dataset that Andrew made for Alexis long ago***;
***If I want to use the raw file, it should be 'new_st1fupi.sas7bdat'***;

DATA fup1a;
set andrew.new_st1fupi;


if famno ne 'D79356';
wave4=1;

xfamno=famno*1;
xidno=idno*1;
xfamid=xfamno*100 + xidno ;

proc sort; 
  by xfamid;
run;

DATA fup1;
set fup1a; by xfamid;
if first.xfamid;



***MERGING the Pregnancy data with Zygosity and Race and Wave 4 data***;
DATA w4all;
  merge zygtwins fup1;
  by xfamno xidno;
if wave4=1;



***************************;
****WAVE 4 DEMOGRAPHICS****;
***************************;
if a1 lt 30 then age=1*a1;

if age in (18,19) then agequart=1;
  else if age in (20, 21, 22) then agequart=2;
  else if age in (23, 24) then agequart=3;
  else if age ge 25 then agequart=4;
label agequart='age in quartiles';

***Below is code for age dummy variables - to use, leave out the category ;
***You want to use as the referent;
if agequart=1 then age1=1;
  else age1=0;
if agequart=2 then age2=1;
  else age2=0;
if agequart=3 then age3=1;
  else age3=0;
if agequart=4 then age4=1;
  else age4=0;

if agequart gt 2 then oldage=1;
  else oldage=0;
label oldage = 'median split - age ge 23';

 
***Urbanicty variables from birth address geocoding';
 
if geo_rural=. then rural=0;
else rural=geo_rural;

if rural=0 then rural0=1;
  else rural0=0;
if rural=2 then rural2=1;
  else rural2=0;
if rural=3 then rural3=1;
  else rural3=0;
if rural=4 then rural4=1;
  else rural4=0;
if rural=5 then rural5=1;
  else rural5=0;
if rural=6 then rural6=1;
  else rural6=0;

if rural in (1,2) then urban=2;
 else if rural=0 then urban=0;
 else urban=1;

if urban=1 then rural_dum=1;
  else rural_dum=0;
if urban=0 then rural_mis=1;
  else rural_mis=0;

***Marital and relationship status;
if b18_R='1' or b18_c1 in ('5','6') then married=1;
  else if b18_c1 ne 'M' and b18_R not in ('M','R') then married=0;
label married='currently married or living with someone as married';

if b18_r='1' or b18_c1 in ('5','6') or b18_i in ('2','3') then rlship=1;
  else if b18_r in ('2','3','4','5') and b18_c1 ne 'M' and b18_i ne 'M' then
  rlship=0;
label rlship='currently in romantic relationship';


**********************;
****WAVE 4 FRIENDS****;
**********************;

if b12='3' then friendnum=1;
  else if b12='2' then friendnum=2;
  else if b12='1' then friendnum=3;
label friendnum='1=loner, 2=few, 3=many friends';

if friendnum=1 then loner=1;
  else if friendnum in (2,3) then loner=0;
if friendnum=2 then fewfriend=1;
  else if friendnum in (1,3) then fewfriend=0;
if friendnum=3 then manyfr=1;
  else if friendnum in (1,2) then manyfr=0;

if b13='5' then noclosefr=0;
  else if b13 in ('1','7') then noclosefr=1;
label noclosefr='no close friends';


*****************************;
****WAVE 4 MISC VARIABLES****;
*****************************;

if a4 gt '6' then livathome=1;
  else if a4 ne 'RR' then livathome=0;
label livathome='live at home majority of past year';

if b1='1' then inschool=0;
  else if b1='5' then inschool=1;
label inschool='currently attending school';

if b7_a='5' and b7_b='1' then work=2;
  else if b7_a='5' and b7_b='2' then work=1;
  else if b7_a='1' or b7='00' then work=0;
label work='2=full 1=part 0=none';

if work=2 then workfull=1;
  else if work in (0,1) then workfull=0;
label workfull='work full time';

if work in (1,2) then workany=1;
  else if work=0 then workany=0;


******************;
****WAVE 4 BMI****;
******************;

if a9_ft not in ('R','2') then chtft=a9_ft*1;

if a9_in ne 'RR' then chtin=a9_in*1;

ctothtin=(chtft*12)+chtin;
label ctothtin='total CURRENT height in inches';

if a9_a not in ('RRR', '999') then cweight=1*a9_a;

bmi_cur=(cweight*704.5)/(ctothtin*ctothtin);
label bmi_cur='CURRENT BMI';

logbmi=log(bmi_cur);


if logbmi ne . then do;
if logbmi lt 2.9962 then logbmi5=0;
  else if 2.9962 le logbmi lt 3.08067 then logbmi5=1;
  else if 3.08067 le logbmi lt 3.17075 then logbmi5=2;
  else if 3.17075 le logbmi lt 3.314659 then logbmi5=3; 
  else if logbmi ge 3.314659 then logbmi5=4;
label logbmi5='log transformed BMI in quintiles';
end;


if (bmi_cur lt 18.5) and (bmi_cur ne .) then bmi_cat=1;
  else if 18.5 le bmi_cur lt 25 then bmi_cat=2;
  else if 25 le bmi_cur lt 30 then bmi_cat=3;
  else if 30 le bmi_cur lt 40 then bmi_cat=4;
  else if bmi_cur ne . then bmi_cat=5;

if (bmi_cur lt 18.5) and (bmi_cur ne .) then bmi_cat4=1;
  else if 18.5 le bmi_cur lt 25 then bmi_cat4=2;
  else if 25 le bmi_cur lt 30 then bmi_cat4=3;
  else if bmi_cur ne . then bmi_cat4=4;

if (bmi_cur lt 18.5) and (bmi_cur ne .) then bmi_cat6=1;
  else if 18.5 le bmi_cur lt 25 then bmi_cat6=2;
  else if 25 le bmi_cur lt 30 then bmi_cat6=3;
  else if 30 le bmi_cur lt 35 then bmi_cat6=4;
  else if 35 le bmi_cur lt 40 then bmi_cat6=5;
  else if bmi_cur ne . then bmi_cat6=6;

if bmi_cur lt 20 then bmiquint=0;
  else if 20 le bmi_cur lt 21.8 then bmiquint=1;
  else if 21.8 le bmi_cur lt 23.8 then bmiquint=2;
  else if 23.8 le bmi_cur lt 27.5 then bmiquint=3;
  else if bmi_cur ge 27.5 then bmiquint=4;
label bmiquint='bmi quintiles';


**Creating dummy variables to include in logistic regressions in STATA**;
if bmiquint eq 0 then bmiquint0=1;
  else bmiquint0=0;

if bmiquint eq 1 then bmiquint1=1;
  else bmiquint1=0;

if bmiquint eq 2 then bmiquint2=1;
  else bmiquint2=0;

if bmiquint eq 3 then bmiquint3=1;
  else bmiquint3=0;

if bmiquint eq 4 then bmiquint4=1;
  else bmiquint4=0;


if black=0 then do;
if bmi_cur lt 19.8 then bmiquint_ea=0;
  else if 19.8 le bmi_cur lt 21.5 then bmiquint_ea=1;
  else if 21.5 le bmi_cur lt 23.2 then bmiquint_ea=2;
  else if 23.2 le bmi_cur lt 26.6 then bmiquint_ea=3;
  else if bmi_cur ge 26.6 then bmiquint_ea=4;
label bmiquint_ea='bmi quintiles - EA';
end;

if black=1 then do;
if bmi_cur lt 22 then bmiquint_aa=0;
  else if 22 le bmi_cur lt 24.7 then bmiquint_aa=1;
  else if 24.7 le bmi_cur lt 28.1 then bmiquint_aa=2;
  else if 28.1 le bmi_cur lt 32.6 then bmiquint_aa=3;
  else if bmi_cur ge 32.6 then bmiquint_aa=4;
label bmiquint_aa='bmi quintiles - AA';
end;




if bmi_cat ne . then do;

if bmi_cat6=4 then obese1=1;
  else obese1=0;
if bmi_cat6=5 then obese2=1;
  else obese2=0;
if bmi_cat6=6 then obese3=1;
  else obese3=0;

if bmi_cat=1 then underwgt=1;
  else underwgt=0;
if bmi_cat=3 then overwgt=1;
  else overwgt=0;
if bmi_cat=4 then obese=1;
  else obese=0;
if bmi_cat=5 then morbid=1;
  else morbid=0;
if bmi_cat4=4 then obesemor=1;
  else obesemor=0;
end;


**************************;
****WAVE 4 SUICIDALITY****;
**************************;

if n1='5' then suicidal=1;
  else if n1='1' then suicidal=0;

if n1_a='5' then suicidal_m=1; 
  else if n1='1' or n1_a='1' then suicidal_m=0;

if n1_b='5' then plan=1; 
  else if n1_b not in ('M' 'R' ' ') then plan=0;

if n2='5' then attempt=1;
  else if n2 not in ('R' ' ') then attempt=0;


***********************************************;
****WAVE 4 MENARCHE (MMC updated on 1.4.12)****;
***********************************************;

if e1 ne '1' and e1_a ne 'RR' and e1_a ne '99' and e1_a ne '97' then do;
if 0 lt e1_a*1 lt 12 then earlymat=1;
  else if e1_a*1 ge 12 then earlymat=0;
label earlymat='Wave 4: 1st period <12';

menarche=1;
menarc_yr=e1_a*1;
label menarc_yr='Wave 4: Age at Menarche- Year';
end;

if e1 ne '1' and e1_b ne 'RR' and e1_b ne 'MM' and e1_b ne '99' then do;
menarc_mo=e1_b*1;
label menarc_mo='Wave 4: Age at Menarche- Month';
end;

agemenarche = menarc_yr + (menarc_mo/12);
label agemenarche='Wave 4: Age at Menarche in Years and Months';

lagemenarche=10*(log(agemenarche));
label lagemenarche='Wave 4: Age at Menarche- Log-transformed';

if agemenarche ne . AND agemenarche lt 12 then earlymenarche=1;
  else if agemenarche ne . AND agemenarche ge 12 then earlymenarche=0;
label earlymenarche='Wave 4: First menstrural period before age 12';



**Recoding 'physical maturity compared to peers' from a character to a numeric value**;
if e7 eq '1' then e7r=1;
  else if e7 eq '2' then e7r=2;
  else if e7 eq '3' then e7r=3;
  else if e7 eq '5' or e7 eq 'M' or e7 eq 'R' then e7r=.;
label e7r='Wave 4: physical maturity compared to peers where 0=earlier, 1=same time, 2=later';

if e7r eq 1 then e7r_early=1;
  else if e7r eq 2 or e7r eq 3 then e7r_early=0;
label e7r_early='Wave 4: physical maturity compared to peers: comparing early vs. on-time and late';

if e7r eq 3 then e7r_late=1;
  else if e7r eq 1 or e7r eq 2 then e7r_late=0;
label e7r_late='Wave 4: physical maturity compared to peers: comparing late vs. early and on-time';


******************************;
****WAVE 4 SEXUAL BEHAVIOR****;
******************************;

**First Sexual Behavior**;
if e8_c eq '5' then do; 
  eversex=1;
  if e8_d not in ('RR' 'MM') then agesex=1*e8_d; 
end;
  else if e8_c eq '1' then do;
  eversex=0; 
end;

if e8_j in ('5' '6') then sexwobc=1; 
  else if e8_c = '1' or (e8_c='5' and e8_i='1') or e8_j='1' then sexwobc=0;

if eversex=1 and  1 < agesex < 16 then earlysex=1;
  else if eversex=0 or 16 le agesex le 30 then earlysex=0;


*************************************;
****WAVE 4 CHILDHOOD SEXUAL ABUSE****;
*************************************;

if d10_aag in ('99','MM','RR') or d10 in ('R',' ') or d10='5' and d10_aag='  ' then csa1=.;
  else if d10='5' and 1*d10_aag lt 16 then csa1=1;
  else csa1=0;
if d11_aag in ('99','MM','RR') or d11 in ('R',' ') or d11='5' and d11_aag='  ' then csa2=.;
  else if  (d11='5' and 1*d11_aag lt 16) then csa2=1;
  else csa2=0;
if k56='5' then csa3=1;
  else if k56 not in ('M','R',' ') then csa3=0;
if k57='5' and k57_a2='5' then csa4=1;
  else if k57 not in ('M','R',' ') then csa4=0;

if e8 eq 'M' or e8 eq 'R' then e8=' ';
if e8_b eq 'RR' or e8_b eq '99' then e8_b=' ';
if e8='5' and (e8_b ge 1 and e8_b lt 16) then csa5=1;
  else if e8='5' and e8_b='  ' then csa5=.;
  else if e8 eq 1 or e8_b gt 15 then csa5=0;



if csa1=1 or csa2=1 or csa3=1 or csa4=1 or csa5=1 then csanew=1;
  else if csa1 ne . and csa2 ne . and csa3 ne . and csa4 ne . and csa5 ne . then csanew=0;
if d10_aag not in ('99', 'MM', 'RR') then csa1ons=1*d10_aag;
if d11_aag not in ('99', 'MM', 'RR') then csa2ons=1*d11_aag;
if k57b1 not in ('99', 'RR') then csa3ons=1*k57b1;
if k56b_aof not in ('99', 'RR') then csa4ons=1*k56b_aof;

if csanew=1 then csaons=min(csa1ons, csa2ons, csa3ons, csa4ons);
  else if csanew=0 then csaons=age;


*****************************;
****WAVE 4 PHYSICAL ABUSE****;
*****************************;

physabuse=(d12 eq '5' or k55 eq '5' or k52_d eq '1'
  or k52_m eq '1' or k53_m eq '1' or k52_d eq '1'
  or k54_m eq '1' or k52_d eq '1');


**********************;
****WAVE 4 NEGLECT****;
**********************;

if d14='5' then neglect=1;
  else if d14='1' then neglect=0;


***************************;
****WAVE 4 OTHER TRAUMA****;
***************************;

if d7='5' then natdis=1;
  else if d7='1' then natdis=0;

if d7_aag not in ('RR', 'MM') and natdis ne .  then do;
if natdis=1 then natdisao=1*d7_aag;
  else natdisao=age;

if d7='5' and d7_aag lt 16 then natdis16=1;
  else if d7='1' or d7_aag ge 16 then natdis16=0;
end;

if d8='5' then accident=1;
  else if d8='1' then accident=0;

if d8_aag not in ('RR', 'MM') and accident ne . then do;
if accident=1 then accidentao=1*d8_aag;
  else accidentao=age;

if d8='5' and d8_aag lt 16 then accident16 =1;
  else if d8='1' or d8_aag ge 16 then accident16=0;

end;

if d9='5' then witness=1;
  else if d9='1' then witness=0;

if d9_aag not in ('RR', 'MM') and witness ne . then do;
if witness=1 then witnessao=1*d9_aag;
  else witnessao=age;

if d9='5' and d9_aag lt 16 then witness16=1;
  else if d9='1' or d9_aag ge 16 then witness16=0;
end;


if d13='5' then attack=1;
  else if d13='1' then attack=0;

if d13_aag not in ('RR', 'MM') and attack ne . then do;
if attack=1 then attackao=1*d13_aag;
  else attackao=age;

if d13='5' and d13_aag lt 16 then attack16=1;
  else if d13='1' or d13_aag ge 16 then attack16=0;

end;

if d15='5' then threat=1;
  else if d15='1' then threat=0;

if d15_aag not in ('RR', 'MM') and threat ne . then do;
if threat=1 then threatao=1*d15_aag;
  else threatao=age;

if d15='5' and d15_aag lt 16 then threat16=1;
  else if d15='1' or d15_aag ge 16 then threat16=0;

end;


traumano=sum(natdis, accident, witness, attack, threat);

if traumano=0 then trauma4l=0;
  else if traumano=1 then trauma4l=1;
  else if traumano=2 then trauma4l=2;
  else if 3 le traumano le 5 then trauma4l=3;

if trauma4l ge 1 then trauma_1=1;
  else if trauma4l eq 0 then trauma_1=0;

if trauma4l ge 2 then trauma_2=1;
  else if trauma4l in (0,1) then trauma_2=0;

if trauma4l=3 then trauma_3=1;
  else if trauma4l in (0,1,2) then trauma_3=0;


if natdis=1 then natdis_temp=natdisao;
if accident=1 then accident_temp=accidentao;
if witness=1 then witness_temp=witnessao;
if attack=1 then attack_temp=attackao;
if threat=1 then threat_temp=threatao;


array sx(5) natdis_temp accident_temp witness_temp attack_temp threat_temp;

do i=1 to 5;
   if sx(i)=. then sx(i)=100;
end;

later=1;
 do while (later>0);
  cntsw=0;
  do i=1 to 4;
     j=i+1;
     if sx{i}>sx{j} then do;
        cntsw+1;
        sx2=sx{j};
        sx(j)=sx{i};
        sx(i)=sx2;
     end;
  end;
  if cntsw>0 then later=1;
  else if cntsw=0 then later=0;
end;


fsttrauma=sx(1);
  if fsttrauma=100 then fsttrauma=age;

sndtrauma=sx(2);
  if sndtrauma=100 then sndtrauma=age;

trdtrauma=sx(3);
  if trdtrauma=100 then trdtrauma=age;

if e8='5' then forcedsex=1;
  else if e8='1' then forcedsex=0;
if d10='5' then rape=1;
  else if d10='1' then rape=0;
if d11='5' then molest=1;
  else if d11='1' then molest=0;

if forcedsex=. or (forcedsex=1 and e8_b in ('  ','RR')) then adultfs=.;
  else if forcedsex=1 and e8_b ge '16' then adultfs=1;
  else adultfs=0;
if adultfs=1 and e8_b ne '99' then ageadufs=1*e8_b;
label adultfs='forced sex onset ge 16';

if molest=. or (molest=1 and d11_aar in ('  ','RR')) then adultmol=.;
  else if molest=1 and d11_aar ge 16 then adultmol=1;
  else adultmol=0;
label adultmol='molestation onset ge 16';

if adultmol=1 and d11_aar not in ('MM','RR','99') then ageadumol=d11_aar;

if rape=. or (rape=1 and d10_aar in ('  ','RR','MM')) then adultrape=.;
  else if rape=1 and d10_aar ge 16 then adultrape=1;
  else adultrape=0;
label adultrape='rape onset ge 16';

if adultrape=1 then ageadurape=d10_aar;

if forcedsex=1 or rape=1 or molest=1 then sexvic=1;
  else if forcedsex=0 and rape=0 and molest=0 then sexvic=0;
label sexvic='any sexual victimization lifetime';

if adultfs=1 or adultrape=1 or adultmol=1 then adultsexvic=1;
  else if adultfs=0 and adultrape=0 and adultmol=0 then adultsexvic=0;
if adultsexvic=1 then ageadsexvic=min(of ageadufs, ageadumol, ageadurape);
label adultsexvic='any sexual victimization onset ge 16';


*******************************;
****WAVE 4 EATING DISORDERS****;
*******************************;

*------------------------------*; 
****EATING DISORDER SYMPTOMS****;
*------------------------------*;

**Age at Lowest Weight**;
if q5 ne 'MM' and q5 ne 'RR' and q5 ne 'ZZ' and q5 ne '99' then wtage_n=1*q5;
 if wtage_n gt 5 then wtage=wtage_n;
label wtage='age at lowest weight';


**Refusal to Maintain Body Weight**;
**Body Mass Index (BMI)**;
*Calculating height*; 
if wtage gt 5 then do;
if q4_ft not in ('R','9','0','1','2') then htft=q4_ft*1;

if q4_in='RR' or q4_in='99' or q4_in='17' then htin=.;
  else htin=q4_in*1;

tothtin=(htft*12)+htin;
label tothtin='total height in inches';

*Calculating weight*;
if q3='RRR' then weight1=.;
  else weight1=q3*1;

if q3_a='RRR' or q3_a='999' then weight2=.;
  else weight2=q3_a*1;

weight=min(weight1, weight2);

*Calculating BMI*;
bmi=(weight*704.5)/(tothtin*tothtin);
end;

*Old 'toothin3' variable;
if q3='   ' and q3_a='   ' then old_toothin3=0;
  else if q3='RRR' or q3='999' or q3_a='RRR' or q3_a='999' or q4_ft='R'
    or q4_ft='0' or q4_ft='1' or q4_ft='2' or q4_ft='9' or q4_in='17'
    or q4_in='99'
    or q4_in='RR' then old_toothin3=.;
  else if 1 le bmi lt 17.5 then old_toothin3=2;
  else if 17.5 le bmi lt 19.5 then old_toothin3=1;
  else if bmi ge 19.5 then old_toothin3=0;
label old_toothin3='1=bmi 17.5-19.5, 2=bmi under 17.5';

*New 'toothin' variables;
if q3='RRR' or q3='999' or q3_a='RRR' or q3_a='999' or
q4_ft='R' or q4_ft='0' or q4_ft='1' or q4_ft='2' or q4_ft='9' or q4_in='17'
or q4_in='99' or q4_in='RR' then toothin3=.;

  else if q3='   ' and q3_a='   ' then toothin3=0;
  else if (1 le bmi lt 17.5 and wtage gt 18) or
   (wtage=5 and bmi lt 13.4) or
   (wtage in (6,7) and bmi lt 13.2) or
   (wtage=8 and bmi lt 13.3) or
   (wtage=9 and bmi lt 13.5) or
   (wtage=10 and bmi lt 13.7) or
   (wtage=11 and bmi lt 14.1) or
   (wtage=12 and bmi lt 14.5) or
   (wtage=13 and bmi lt 14.9) or
   (wtage=14 and bmi lt 15.4) or
   (wtage=15 and bmi lt 15.9) or
   (wtage=16 and bmi lt 16.4) or
   (wtage=17 and bmi lt 16.8) or
   (wtage=18 and bmi lt 17.2) then toothin3=2;
  else if (17.5 le bmi le 18.5 and wtage gt 18) or
   (wtage=5 and bmi lt 13.5) or
   (wtage in (6,7) and bmi lt 13.4) or
   (wtage=8 and bmi lt 13.6) or
   (wtage=9 and bmi lt 13.8) or
   (wtage=10 and bmi lt 14.0) or
   (wtage=11 and bmi lt 14.4) or
   (wtage=12 and bmi lt 14.8) or
   (wtage=13 and bmi lt 15.3) or
   (wtage=14 and bmi lt 15.8) or
   (wtage=15 and bmi lt 16.3) or
   (wtage=16 and bmi lt 16.8) or
   (wtage=17 and bmi lt 17.2) or 
   (wtage=18 and bmi lt 17.5) then toothin3=1;
  else toothin3=0;
label toothin3='1=bmi 17.5-18.5 or 3-5 %, 2=bmi under 17.5 or under 3%';

**Changing the AN BMI cut-off from 17.5 (ICD) to 18.5 (DSM) (by MMC on 07.29.15);
**Using 5th percentile in kids**;
if q3='RRR' or q3='999' or q3_a='RRR' or q3_a='999' or
q4_ft='R' or q4_ft='0' or q4_ft='1' or q4_ft='2' or q4_ft='9' or q4_in='17' or q4_in='99' or q4_in='RR' then toothin5=.;
 
  else if q3='   ' and q3_a='   ' then toothin5=0;
  else if (1 le bmi lt 18.5 and wtage gt 20) or
   (wtage=5 and bmi lt 13.5) or
   (wtage in (6,7) and bmi lt 13.4) or
   (wtage=8 and bmi lt 13.5) or
   (wtage=9 and bmi lt 13.7) or
   (wtage=10 and bmi lt 14.0) or
   (wtage=11 and bmi lt 14.4) or
   (wtage=12 and bmi lt 14.8) or
   (wtage=13 and bmi lt 15.3) or
   (wtage=14 and bmi lt 15.8) or
   (wtage=15 and bmi lt 16.3) or
   (wtage=16 and bmi lt 16.8) or
   (wtage=17 and bmi lt 17.2) or
   (wtage=18 and bmi lt 17.5) or
   (wtage=19 and bmi lt 17.8) or
   (wtage=20 and bmi lt 17.8) then toothin5=1;
  else toothin5=0;
label toothin5='bmi under 18.5 or under 5%';

**Using 10th percentile in kids**;
if q3='RRR' or q3='999' or q3_a='RRR' or q3_a='999' or
q4_ft='R' or q4_ft='0' or q4_ft='1' or q4_ft='2' or q4_ft='9' or q4_in='17' or q4_in='99' or q4_in='RR' then toothin10=.;
 
  else if q3='   ' and q3_a='   ' then toothin10=0;
  else if (1 le bmi lt 18.5 and wtage gt 20) or
   (wtage=5 and bmi lt 13.8) or
   (wtage=6 and bmi lt 13.7) or
   (wtage=7 and bmi lt 13.8) or
   (wtage=8 and bmi lt 13.9) or
   (wtage=9 and bmi lt 14.2) or
   (wtage=10 and bmi lt 14.5) or
   (wtage=11 and bmi lt 14.9) or
   (wtage=12 and bmi lt 15.4) or
   (wtage=13 and bmi lt 15.9) or
   (wtage=14 and bmi lt 16.4) or
   (wtage=15 and bmi lt 16.9) or
   (wtage=16 and bmi lt 17.4) or
   (wtage=17 and bmi lt 17.8) or
   (wtage=18 and bmi lt 18.2) or
   (wtage=19 and bmi lt 18.4) or
   (wtage=20 and bmi lt 18.5) then toothin10=1;
  else toothin10=0;
label toothin10='bmi under 18.5 or under 10%';



/*
if 1 le bmi le 17.5 then bmi4=0;
  else if 17.5 lt bmi lt 20 then bmi4=1;
  else if 20 le bmi lt 25 then bmi4=2;
  else if bmi ge 25 then bmi4=3;
label bmi4='0=underweight, 1=ideal weight, 2=overweight, 4=obese';
*/


if q1='5' then lost=1;
  else if q1='1' then lost=0;
label lost='lost a lot of weight on purpose';

if q1_a='1' then nogain=1;
  else if q1_a='5' or q1='5' then nogain=0;
label nogain='didnt gain weight while growing';

if q1='5' then lostgain=2;
  else if q1_a='1' then lostgain=1;
  else if q1='1' and q1_a='5' then lostgain=0;

if toothin5=. then lose5=.;
  else if toothin5=0 then lose5=0;
  else if ((q1='5' or q1_a='1') and toothin5=1) then lose5=1;
  else lose5=0;
label lose5='AN Criterion A: lost or didnt gain weight and bmi le 18.5/5th percentile';

if toothin10=. then lose10=.;
  else if toothin10=0 then lose10=0;
  else if ((q1='5' or q1_a='1') and toothin10=1) then lose10=1;
  else lose10=0;
label lose10='AN Criterion A: lost or didnt gain weight and bmi le 18.5/10th percentile';


**Body Weight/Shape Disturbance**;
if q2='5' or q2_a='5' or (toothin10=1 and q6_a='1') then disturb=1;
  else if q2='1' and q2_a='1' and (q6_a='5' or toothin10=0) then disturb=0;
label disturb='AN Criterion C: wt-shape disturbance OR undue influence OR denial';

if q2='5' then disturb1=1;
  else if q2='1' then disturb1=0;
label disturb1='felt fat, friends/family thought thin';

if q2_a='5' then disturb2=1;
  else if q2_a='1' then disturb2=0;
label disturb2='others thought thin - self thought not thin enough';

if q6_a='1' and toothin10=1 then disturb3=1;
  else if q6_a='5' or toothin10=0 then disturb3=0;
label disturb3='bmi lt 18.5 but did not think health in danger';


**Amenorrhea**;
if q7='R' or q7='M' or q7_a='R' or q7_a='M' then amenor_l=.;
  else if q7='5' or (q7='1' and q7_a='5') then amenor_l=1;
  else amenor_l=0;
label amenor_l='amenorrhea or on bc at lowest weight';

if q7='5' then amenor_s=1;
  else if q7='M' or q7='R' then amenor_s=.;
  else amenor_s=0;
label amenor_s='AN Criterion D: amenorrhea';


**Undue Influence of Body Weight and Shape**;
if q8='5' then concern=1;
  else if q8='1' then concern=0;
label concern='BN Criterion D: greatly concerned with fat and weight';


**Intense Fear of Gaining Weight or Becoming Fat**;
if q6='5' then fatfear=1;
  else if q6='1' or (q1='1' and q1_a='5' and q2='1' and q2_a='1') then fatfear=0;
label fatfear='AN Criterion B: intense fear of weight and fat';


**Binge Eating and Loss of Control (LOC)**;
if q9='1' or q9='5' then do;
***limits to people who answered bn screening question;

if q9='5' then binge=1;
  else if q9='1' then binge=0;
label binge='ever binge with or without loss of control';

if q10='5' then bingeloc=1;
  else if q10='1' or q9='1' then bingeloc=0;
label bingeloc='BN Criterion A: binge with loss of control';

if bingeloc=1 then binge3l=2;
  else if binge=1 then binge3l=1;
  else if binge=0 then binge3l=0;
label binge3l='2=binge with LOC, 1=binge with no LOC, 0=no binge';


**Binge Eating Frequency**;
if q12=7 then nq12_b=0; 
  else if q12_b ne 'RR' then nq12_b=1*q12_b;
if q12 ne 'R' then nq12=1*q12;

freqbin=(q10='5' and 1 le nq12 le 4 and nq12_b ge 3); 
label freqbin='BN Criterion C: binge 2+ days/week';
 
lfreqbin=(q10='5' and 1 le nq12 le 5 and nq12_b ge 3);
label lfreqbin='binge 1+ days/week';

if q10='5' and nq12_b ge 3 and (1 le nq12 le 3) then binge4=3;
  else if q10='5' and nq12_b ge 3 and (nq12=4 or nq12=5) then binge4=2;
  else if q10='5' and nq12_b ge 3 and (nq12=6 or nq12=7) then binge4=1;
  else if q10='1' or nq12_b lt 3 then binge4=0;
label binge4='4 level binge freqency';
end;


**Binge Eating Onset**;
if q9 eq '1' then binons=.;
  else if q11_ag ne 'RR' then binons=1*q11_ag;
label binons='binge eating onset';

if lfreqbin eq 0 then lfbinons=age;
  else if lfreqbin eq 1 and q11_ag ne 'RR' then lfbinons=1*q11_ag;
label lfbinons='binge eating onset- binge 1+ days/week';


**Current Binge Eating**;
if q11_re in ('0','1','2','3','4') then curbinge=1;
label curbinge='current binge eaing';


**Compensatory Behaviors**;
*Self-Induced Vomiting*;
if q14_a ne ' ' then do;
if q14_a='5' then vomit=1;
  else if q14_a='1' then vomit=0;

if q14_af='1' then vomit4=3;
  else if q14_af='2' then vomit4=2;
  else if q14_af='3' then vomit4=1;
  else  if q14_af not in ('M','R') then vomit4=0;
label vomit4='vomiting often (3), sometimes (2), rarely (1)';
end;

*Laxative Use*;
if q14_b ne ' ' then do;
if q14_b='5' then lax=1;
  else if q14_b='R' or q14_bf='M' or q14_bf='R' then lax=.;
  else lax=0;
label lax='laxatives ever';

if q14_bf='1' then lax4=3;
  else if q14_bf='2' then lax4=2;
  else if q14_bf='3' then lax4=1;
  else if q14_bf not in ('M','R') then lax4=0;
label lax='laxitive use often (3), sometimes (2), rarely (1)';
end;

*Diuretic Use*;
if q14_f ne ' ' then do;
if q14_f='5' then diuretics=1;
  else if q14_f='R' or q14_ff='M' or q14_ff='R' then diuretics=.;
  else diuretics=0;
label diuretics='diuretics ever';

if q14_ff='1' then diuretics4=3;
  else if q14_ff='2' then diuretics4=2;
  else if q14_ff='3' then diuretics4=1;
  else if q14_ff not in ('M','R') then diuretics4=0;
label diuretics4='diuretics often (3), sometimes (2), rarely (1)';
end;

*ANY Purging Compensatory Behaviors*;
if vomit=1 or lax=1 or diuretics=1 then purge=1;
  else if vomit=0 and lax=0 and diuretics=0 then purge=0;
label purge='purging compensatory behaviors ever';

*Strict Dieting*;
if q14_c ne ' ' then do;
if q14_c='5' then diet=1;
  else if q14_c='R' or q14_cf='M' or q14_cf='R' then diet=.;
  else diet=0;
label diet='strict dieting ever';

if q14_cf='1' then diet4=3;
  else if q14_cf='2' then diet4=2;
  else if q14_cf='3' then diet4=1;
  else if q14_cf not in ('M','R') then diet4=0;
label diet4='strict dieting often (3), sometimes (2), rarely (1)';
end;

*Fasting*;
if q14_d ne ' ' then do;
if q14_d='5' then fast=1;
  else if q14_d='R' or q14_df='M' or q14_df='R' then fast=.;
  else fast=0;
label fast='fast ever';

if q14_df='1' then fast4=3;
  else if q14_df='2' then fast4=2;
  else if q14_df='3' then fast4=1;
  else if q14_df not in ('M','R') then fast4=0;
label fast4='fasting often (3), sometimes (2), rarely (1)';
end;

*Excessive Exercise*;
if q14_e ne ' ' then do;
if q14_e='5' then exercise=1;
  else if q14_e='R' or q14_ef='M' or q14_ef='R' then exercise=.;
  else exercise=0;
label exercise='exercise ever';

if q14_ef='1' then exercise4=3;
  else if q14_ef='2' then exercise4=2;
  else if q14_ef='3' then exercise4=1;
  else if q14_ef not in ('M','R') then exercise4=0;
label exercise4='exercising often (3), sometimes (2), rarely (1)';
end;

*ANY Non-Purging Compensatory Behaviors*;
if diet=1 or fast=1 or exercise=1 then nonpurge=1;
  else if diet=0 and fast=0 and exercise=0 then nonpurge=0;
label nonpurge='nonpurging compensatory behaviors ever';

*ANY Purging or Non-Purging Compensatory Behaviors*;
if vomit=1 or lax=1 or diet=1 or fast=1 or exercise=1 or diuretics=1 then comp=1;
  else if vomit=. or lax=. or diet=. or fast=. or exercise=. or diuretics=. then comp=.;
  else comp=0;
label comp='BN Criterion B: inappropriate compensatory behaviors';

*FREQUENCY of Compensatory Behaviors*; 
if vomit4=3 or lax4=3 or diet4=3 or fast4=3 or exercise4=3 or diuretics4=3 then comp4=3;
  else if vomit4=2 or lax4=2 or diet4=2 or fast4=2 or exercise4=2 or diuretics4=2 then comp4=2;
  else if vomit4=1 or lax4=1 or diet4=1 or fast4=1 or exercise4=1 or diuretics4=1 then comp4=1;
  else if vomit4=. or lax4=. or diet4=. or fast4=. or exercise4=. or diuretics4=. then comp4=.;
  else comp4=0;
label comp4='4 level compensatory behaviors frequency- often (3), sometimes (2), rarely (1), never (0)';

*Purging Onset*;
if q15_ag not in ("MM", "RR") then purgeons=1*q15_ag;
label purgeons='purging onset';


**Bulimic Behaviors: Binge Eating or ANY Purging or Non-Purging Compensatory Behaviors (08.16.12)**;
if binge eq 1 and comp eq 1 then bulbeh=2;
  else if binge eq 1 or comp eq 1 then bulbeh=1;
  else if binge eq . or comp eq . then bulbeh=.;
  else bulbeh=0;
label bulbeh='bulimic behaviors- BE and CB (2), BE or CB (1), no BE or CB (0)';

if bulbeh eq 2 or bulbeh eq 1 then bulbeh2l=1;
  else if bulbeh eq 0 then bulbeh2l=0;
label bulbeh2l='bulimic behaviors 2 levels- BE and/or CB (1), no BE or CB (0)';


****BINGE EATING DISORDER (BED) SYMPTOMS****;
if q13_a='5' then eatfast=1;
  else if q13_a ne 'R' then eatfast=0;
label eatfast='eat faster than normal (q13_a)';

if q13_b='5' then tummyache=1;
  else if q13_b ne 'R' then tummyache=0;
label tummyache='eat until it hurts (q13_b)';

if q13_c='5' then lgamt=1;
  else if q13_c ne 'R' then lgamt=0;
label lgamt='eat large amts when not hungry (q13_c)';

if q13_d='5' then alone=1;
  else if q13_c ne 'R' then alone=0;
label alone='eat alone because embarassed (q13_d)';

if q13_e='5' then guilty=1;
  else if q13_e ne 'R' then guilty=0;
label guilty='feel guilty/disgusted/depressed after binge (q13_e)';

bed_sum=sum(of eatfast tummyache lgamt alone guilty);
label bed_sum='sum of q13 items';

if bed_sum ge 3 then bed_sxb=1;
  else if  0 le bed_sum le 2 then bed_sxb=0;
label bed_sxb='BED Criterion B (3+ q13 items)';



*-------------------------------*; 
****EATING DISORDER DIAGNOSES****;
*-------------------------------*;

**Treatment for an Eating Disorder**;
if q8_a='5' then edtx=1;
  else if q8_a='1' then edtx=0;
label edtx='Ever treated for ED';


***ANOREXIA NERVOSA (AN)***; 
**Using 5th BMI percentile in kids**;
if lose5 ne . and amenor_s ne . and fatfear ne . and concern ne . and disturb ne . then do;
anorex4=(lose5=1 and amenor_s=1 and fatfear=1 and (concern=1 or disturb=1));
label anorex4='Strict DSM-IV AN using 5% BMI in kids';

lanorex4=(lose5=1 and (concern=1 or disturb=1) and fatfear=1);
label lanorex4='Loose DSM-IV AN (no amennorhea) using 5% BMI in kids';
end;

**Using 10th BMI percentile in kids**;
if lose10 ne . and amenor_s ne . and fatfear ne . and concern ne . and disturb ne . then do;
anorex4_x=(lose10=1 and amenor_s=1 and fatfear=1 and (concern=1 or disturb=1));
label anorex4_x='Strict DSM-IV AN using 10% BMI in kids';

lanorex4_x=(lose10=1 and (concern=1 or disturb=1) and fatfear=1);
label lanorex4_x='Loose DSM-IV AN (no amennorhea) using 10% BMI in kids';
end;


***BULIMIA NERVOSA (BN)***;
if comp=. or freqbin=. or bingeloc=. or concern=. then bn4=.;
  else bn4=(comp=1 and freqbin=1 and bingeloc=1 and concern=1 and (q16='1' or (lanorex4=0)));
label bn4='Strict DSM-IV BN';

if comp4='.' or lfreqbin=. or bingeloc=. or concern=. then bn4l=.;
  else bn4l=(comp4 in ('3','2') and lfreqbin=1 and bingeloc=1 and concern=1 and (q16='1' or (lanorex4=0)));
label bn4l='Loose DSM-IV BN (binge 1+ day/wk, purge sometimes)';

if bn4=1 or anorex4=1 then ednarrow=1;
  else ednarrow=0;
label ednarrow='Narrow DSM-IV Eating Disorder Diagnosis';

if lanorex4=1 or bn4l=1 then edbroad=1;
  else edbroad=0;
label edbroad='Broad DSM-IV Eating Disorder Diagnosis';


***PURGING DISORDER (PD)***;
if lanorex4 ne 1 and binge3l=0 then purgeonly=comp4;
  else purgeonly=9;
label purgeonly='Purging only- No Binge Eating';

if fatfear eq . or q9 eq '.' or q10 eq '.' or q12 eq '.' or purge eq . or anorex4 eq . then purgedx=.;
  else if fatfear eq 1 and (q9 eq '1' or (q9 eq '5' and (q10 eq '1' or q12 eq '7'))) and purge eq 1 and anorex4 eq 0 then purgedx=1;
  else purgedx=0;
label purgedx='Purging Disorder- uses Strict AN';

if fatfear eq . or q9 eq '.' or q10 eq '.' or q12 eq '.' or purge eq . or lanorex4 eq . then lpurgedx=.;
  else if fatfear eq 1 and (q9 eq '1' or (q9 eq '5' and (q10 eq '1' or q12 eq '7'))) and purge eq 1 and lanorex4 eq 0 then lpurgedx=1;
  else lpurgedx=0;
label lpurgedx='Loose Purging Disorder- uses Loose AN';

proc freq; tables lanorex4 lanorex4_x edbroad bn4l lpurgedx;
endsas;

***BINGE EATING DISORDER (BED)***;
if binge ne . then do;
if (bingeloc=1 and nq12_b ge 6 and freqbin=1 and bed_sxb=1 and comp=0 and lanorex4=0 and bn4l=0) then bed=1;
  else if freqbin ne . then bed=0;
label bed='Binge Eating Disorder';
end;



**********************;
****WAVE 4 SMOKING****;
**********************;

**Age at Smoking Milestones**;
*Ever smoked;
if f1a1_r eq '5' then do; smkev=1; if f1c_r not in ('99' 'RR') then agesmk=1*f1c_r; end;
  else if f1a1_r eq '1' then do; smkev=0; agesmk=age; end;
label smkev='ever smoked';
label agesmk='age onset: smoking';

if smkev=0 then agesmk_=.;
  else agesmk_=agesmk;

*Regular smoking (at least once a week for two months in a row);
if smkev ne . then do;
if f3 eq '1' or f3 eq '2' then do; smkreg=1;
if f3_b not in ('MM' 'RR') then agsmkreg=1*f3_b; 
label smkreg='regular smoking (at lease 1x/wk for 2 months in a row)';
label agsmkreg='age at regular smoking';

*Daily smoking;
if f3 eq '1' then do; smkdaily=1; 
if f3_c not in ('MM' 'RR') then agsmkdaily=1*f3_c; end;
  else if f3 eq '2' then do; smkdaily=0; agsmkdaily=age; end; end;
  else do; smkreg=0; agsmkreg=age; smkdaily=0; agsmkdaily=age; end;
if smkreg=0 then agsmkreg_=.;
  else agsmkreg_=agsmkreg;
if smkdaily=0 then agsmkdaily_=.;
  else agsmkdaily_=agsmkdaily;
end;

*Ever smoked 100 cigarettes;
if f3_a in ('I', 'J') then cig100=1;
  else if f3_a ne 'R' then cig100=0;

if smkev=1 and cig100=0 then c100_evsmk=0;
  else if smkev=1 and cig100=1 then c100_evsmk=1;

*Current smoking;
if f4='1' or (f4='5' and f4_bre in ('0','1','2','3')) then cursmk6=1;
  else if (f4='5' and f4_bre in ('4','5')) then cursmk6=0;

if f4='1' or (f4='5' and f4_bre in ('0','1','2')) or (smkev=1 and (age=agesmk_)) then cursmk3=1;
  else if smkev=0 or (smkev=1 and (smkreg eq 0 and cig100 eq 0)) or (f4='5' and f4_bre in ('3','4','5')) then cursmk3=0;


if cursmk3=0 then quit3=1;
  else if cursmk3=1 then quit3=0;

if cursmk6=0 then quit6=1;
  else if cursmk6=1 then quit6=0;


if b17_c in ('O','P','Q') then malefrsmk=1;
  else if b17_c in ('J','K','L','N') then malefrsmk=0;

if b17_e in ('O','P','Q') then femalefrsmk=1;
  else if b17_e in ('J','K','L','N') then femalefrsmk=0;

if malefrsmk=1 or femalefrsmk=1 then frsmk=1;
  else if malefrsmk=0 and femalefrsmk=0 then frsmk=0;

if smkreg=1 then newquit3=quit3;

if f4_bar not in ('MM','RR') then do;
if quit3=1 and f4_bar not in ('  ')  then agequit3=1*f4_bar;
  else if quit3=0 or smkev=0 then agequit3=age;
label agequit3='age quit smoking 3+ mos - survival';

if quit3=1 and f4_bar ne '  ' then agequit3_=1*f4_bar;
label agequit3_='age quit smoking 3+ mos';

if quit6=1 and f4_bar ne '  ' then agequit6_=1*f4_bar;
label agequit6_='age quit smoking 6+ mos';
end;


if f4_bar not in ('MM','RR') then do;
if agequit6_ ge 1 then agequit6=agequit6_;
  else if quit6=0 or cig100=0 or smkreg=0 then agequit6=age;
label agequit6='age quit smoking 6+ mos - survival';

if agequit3_ ge 1 then agequit3=agequit3_;
  else if quit3=0 or cig100=0  or smkreg=0 then agequit3=age;
label agequit3='age quit smoking 3+ mos - survival';
end;


****DSM-4 Nicotine Dependence Symptoms****;
***Tolerance***;
tolerance=((f5 eq 'U' or f5 eq 'W' or f5 eq 'X') or (f8 eq 'U' or f8 eq 'W' or f8 eq 'X') or f13 eq '5' or f13_a eq '5');

***Great deal of time spent getting nicotine, i.e., chain smoking;
if f10 eq '5' then chainsmk=1;
  else if (f10 ne 'R') then chainsmk=0;

***Cut down on activities to smoke;
if f11 eq '5' then activ=1;
  else if f11 ne 'R' then activ=0;

***Used more than intended;
if (f12 eq '5' or f12_b eq '5') then intend=1;
  else if f12 ne 'R' or f12_b ne 'R' then intend=0;

***Difficulty with cessation;
if (f14 eq '5' or f14_a eq '5' or f14_b eq '5') then diffcess=1;
  else if (f14 ne 'R' or f14_a ne 'R' or f14_b ne 'R') and f14_b ne '9' then diffcess=0;


***Withdrawal-using DSM-4 withdrawal criteria**; 
    **first pass;
     num=0;
    
    array x(i) f15e1_i f15e2_i f15e3_i f15e4_i f15e5_i f15e6_i f15e7_i
                f15e8_i;
    do over x; if x='5' then num=num+1; end;
      
    if num ge 4 then with=1;
      else with=0;
       
    **retry;
    num2=0;
      
    array y(i) f15e1_r f15e2_r f15e3_r f15e4_r f15e5_r f15e6_r f15e7_r f15e8_r;

    do over y; if y='5' then num2=num2+1; end;
    
    if num2 ge 4 then with2=1;
      else with2=0;   

    if f14_e eq '00' and f14_f eq 'A' then nowith=1;
      else if smkev ne '.' then nowith=0;

    if f16 eq '5' then startsmk=1;
       else startsmk=0;

    if with=1 or with2=1 or startsmk=1 then withdraw=1;
      else withdraw=0;

***Psychological or physical problems due to smoking;
if (f18_a eq '5' or f19 eq '5' or f20_a eq '5') then problems=1;
  else if f18_a ne 'R' and f19 not in ('R','M') and f20_a ne 'R' then problems=0;


 nicdep=(problems) + (withdraw) + (tolerance) + (diffcess) + (intend) + (activ) + (chainsmk);
 if (nicdep >= 3) then nd2=1; else if smkev ne . then nd2=0;
 if (nicdep >= 2) then ndp2=1; else if smkev ne . then ndp2=0;



****Andrew's Nicotine Dependence****;
nicdepqdy=(f22 eq '5');
if (nicdepqdy) and f22_on not in ('MM' 'RR') then agenicdep=1*f22_on;
  else agenicdep=age;

if agesmk eq 99 then agesmk=.;

if nicdepqdy=0 then agenicdep_=.;
 else agenicdep_=agenicdep;

if agesmk=. or smkev=. then earlysmk=.;
  else if smkev=1 and agesmk lt 14 then earlysmk=1;
  else earlysmk=0;

if agsmkreg=. or smkreg=. then earlysmkreg=.;
  else if smkreg=1 and agsmkreg lt 16 then earlysmkreg=1;
  else earlysmkreg=0;

if smkreg ne . then newsmkreg=smkreg;
  else if smkreg=. and smkev=0 then newsmkreg=0;

if nicdepqdy ne . then newnicdep=nicdepqdy;
  else if nicdepqdy=. and smkev=0 then newnicdep=0;


if nd2=1 then smk4=3;
  else if cig100=1 then smk4=2;
  else if smkev=1 then smk4=1;
  else if smkev=0 then smk4=0;


**********************;
****WAVE 4 ALCOHOL****;
**********************;

**Family Alcohol Problems**;
if gg9='5' or gg9_a='5' then twdrkprob=1;
  else if gg9 in ('R','M','7','9') or gg9_a in ('R','M','7','9') then twdrkprob=.;
  else if (gg9='1' or gg8=1) then twdrkprob=0;
label twdrkprob='twin has problem or is excessive drinker';

if gg9_b='5' or gg9_b1='5' then momdrkprob=1;
  else if gg9_b in ('R','M','9') or gg9_b1 in ('R','M','9') then momdrkprob=.;
  else if gg8_a=1 or (gg9_b='1' and gg9_b1='1') then momdrkprob=0;
label momdrkprob='mom has problem or is excessive drinker';

if gg9_c='5' or gg9_c1='5' then daddrkprob=1;
  else if gg9_c in ('R','M','9') or gg9_c1 in ('R','M','9') then daddrkprob=.;
  else if gg8_b='1' or (gg9_c='1' and gg9_c1='1') then daddrkprob=0;
label daddrkprob='dad has problem or is excessive drinker';

if momdrkprob=1 or daddrkprob=1 then pardrkprob=1;
  else if momdrkprob=0 and daddrkprob=0 then pardrkprob=0;
label pardrkprob='parent has problem or is excessive drinker';


**Initiation of Alcohol Use**;
if (g2 eq '5' or g3 eq '5') then do; alcuse=1; if g4_ag not in ('RR') then agealc=1*g4_ag; 
  end;
  else if (g2 eq '1' and (g3 eq '1' or g3 eq '')) then do; alcuse=0; agealc=age; 
  end;
label alcuse='Initiation of alcohol use';
label agealc='Initiation of alcohol use- age at onset';

if g6_f not in ('98', '99', 'RR') then ng6_f=g6_f*1;
if g6_f2 not in ('98', '99', 'RR') then ng6_f2=g6_f2*1;

maxdrk=max(ng6_f, ng6_f2);
label maxdrk='Max drinks if drank >6 days';

if g4_1aa1='5' or g4_1aa2='5' then drink6=1;
  else if g4_1aa1='R' then drink6=.;
  else drink6=0;
label drink6='Drink on at least 6 days';

if g6='5' or g6_b='5' then regdrk=1;
  else if (g6='1' and g6_b ne 'R') or drink6=0 then regdrk=0;
label regdrk='Regular drinking';

if g6_a ne 'RR' then ng6_a=g6_a*1;
if g6_c ne 'RR' then ng6_c=g6_c*1;

regdrk_ao=min(ng6_a, ng6_c);
if regdrk_ao=1 then regdrk_ao=.;
label regdrk_ao='Regular drinking- age of onset';

if alcuse=. or agealc=. then earlyalc=.;
  else if alcuse=1 and agealc lt 14 then earlyalc=1;
  else earlyalc=0;
label earlyalc='Early alcohol use- age 13 or younger';

if (alcuse ne .) then do;

if g10 in ('9', 'R') then weekdrk12=.;
  else if alcuse=0 and g10 ne ' ' then weekdrk12=.;
  else if g10 in ('A', 'B', 'C', 'F', 'G', 'H') then weekdrk12=1;
  else weekdrk12=0;
label weekdrk12='Drank at least weekly in past 12 mos';

if g11 ne 'R' then do;
if g11 in ('A', 'B', 'C', 'F', 'G', 'H', 'I', 'J', 'K') then alcbinge12=1;
  else alcbinge12=0;
end;
label alcbinge12='Binge drinking in past 12 months';


**First Intoxication**;
   if (alcuse eq 0 or g8_ag eq '00' or g4_1aa2 eq '1') then do; intox=0; 
     ageintox=age; end;
   else if (g8_ag ne '' and g8_ag ne '99') then do; intox=1; if g8_ag not in ('RR' 'XX') then ageintox=1*g8_ag; end;
label ageintox='Age at first intoxication';


*Alcohol Dependence**;
if g40_a eq '5' then do; alcdepiv=1; if g40b_ag not in ('RR') then agealcons=1*g40b_ag; end;
   else do; alcdepiv=0; agealcons=age; end;
label alcdepiv='DSM-IV Alcohol Dependence';

if tg8e_cir='5' or tg9_cir='5' or tg18_cir='5' or tg8d_cir='5' then alcdepsx1=1;
  else alcdepsx1=0;
label alcdepsx1='Alcohol Dependence Sx1- Tolerance';

if tg8e_cir='5' or tg9_cir='5' then alcdepsx1a=1;
  else alcdepsx1a=0;
label alcdepsx2a='quantitative tolerance';

if tg18_cir='5' or tg8d_cir='5' then alcdepsx1b=1;
  else alcdepsx1b=0;
label alcdepsx1b='qualitative tolerance';

if tg8d_cir='5' then adsx1b_alt=1;
  else adsx1b_alt=0;
label adsx1b_alt='coud not get same effect on same amt';

if tg8e_cir='5' or tg9_cir='5' or tg18_cir='5' then adsx1a_alt=1;
  else adsx1a_alt=0;
label adsx1a_alt='needed more to get effect';

if tg19_cir='5' or tg9c_cir='5' or tg9d_cir='5' then alcdepsx3=1;
  else alcdepsx3=0;
label alcdepsx3='Alcohol Dependence Sx3- Larger/Longer';

if tg19_cir='5' or tg9c_cir='5' then alcdepsx3a=1;
  else alcdepsx3a=0;
label alcdepsx3a='larger';

if tg9d_cir='5' then alcdepsx3b=1;
  else alcdepsx3b=0;
label alcdepsx3b='longer';

if tg20_cir='5' then alcdepsx5=1;
  else alcdepsx5=0;
label alcdepsx5='Alcohol Dependence Sx 5- Great deal of time';

if tg25_cir='5' or tg5d_cir='5' then alcdepsx4=1;
  else alcdepsx4=0;
label alcdepsx4='Alcohol Dependence Sx4- Cut down';

if tg25_cir='5' then alcdepsx4a=1;
  else alcdepsx4a=0;
*label alcdepsx4a='larger';

if tg5d_cir='5' then alcdepsx4b=1;
  else alcdepsx4b=0;
*label alcdepsx4b='longer';

if tg34_cir='5' then alcdepsx6=1;
  else alcdepsx6=0;
label alcdepsx6='Alcohol Dependence Sx6- Activities given up';

if tg21_cir='5' or tg36_cir='5' or tg37_cir='5' or tg7d_cir='5' or tg38_cir='5'
  then alcdepsx7=1;
  else alcdepsx7=0;
label alcdepsx7='Alcohol Dependence Sx7- Continued use';

if tg21_cir='5' then alcdepsx7a=1;
  else alcdepsx7a=0;
label alcdepsx7a='blackouts';

if tg36_cir='5' then alcdepsx7b=1;
  else alcdepsx7b=0;
label alcdepsx7b='continued despite psych probs';

if tg37_cir='5' or tg38_cir='5' then alcdepsx7c=1;
  else alcdepsx7c=0;
label alcdepsx7c='continued despite phys probs';

if tg7d_cir='5' then alcdepsx7d=1;
  else alcdepsx7d=0;
label alcdepsx7d='continued despite memory probs';

if tg39_cir='5' or tg3c_cir='5' then alcdepsx2=1;
  else alcdepsx2=0;
label alcdepsx2='Alcohol Dependence Sx2- Withdrawal/Relief';

if tg39_cir='5' then alcdepsx2a=1;
  else alcdepsx2a=0;
label alcdepsx2a='withdrawal';

if tg3c_cir='5' then alcdepsx2b=1;
  else alcdepsx2b=0;
label alcdepsx2b='relief';

alcdepsx=sum(of alcdepsx1-alcdepsx7);
label alcdepsx='Sum of 7 Alcohol Dependence Sxs';

if alcdepsx ge 3 then ad3sx=1;
  else ad3sx=0;
label alcdepsx='3+ Alcohol Dependence Sxs';


**Alcohol Abuse**;
if i3_a='5' then alcabusx1=1;
  else if i3_a not in ('R') and alcuse ne . then alcabusx1=0;
label alcabusx1='Alcohol Abuse Sx1- Failure to fulfill obligations';

if (i4_a='5' and i4_a1='1') or i5_a='5' then alcabusx4=1;
  else if i4_a not in ('R') and i4_a1 not in ('R') and i5_a not in ('R') and alcuse ne . then alcabusx4=0;
label alcabusx4='Alcohol Abuse Sx4- Interpersonal problems';

if g27=5 and g27_a ge 3 then alcabusx2a=1;
  else if g27 not in ('9','R') then alcabusx2a=0;
label alcabusx2a='hazardous use - drunk driving';

if g31='5' and g31_b ='5' then alcabusx2b=1;
  else if g31 not in ('M','R') and g31_b not in ('M','R') then alcabusx2b=0;
label alcabusx2b='hazardous use - drunk driver passenger';

if g32_b='5' or g32_e='5' then alcabusx2c=1;
  else if g32_b not in ('M','R') and g32_e not in ('M','R') then alcabusx2c=0;
label alcabusx2c='hazardous use - risky sex';

if (g30='5' and g30_b='5') or (g33='5' and g33_b='5') then alcabusx2d=1;
  else if g33 not in ('M','R') and g30_b not in ('M','R') then alcabusx2d=0;
label alcabusx2d='hazardous use - other';

if alcabusx2a=1 or alcabusx2b=1 or alcabusx2c=1 or alcabusx2d=1 then alcabusx2=1;
  else if alcabusx2a=0 and alcabusx2b=0 and alcabusx2c=0 and alcabusx2d=0 then alcabusx2=0;
label alcabusx2='Alcohol Abuse Sx2- Hazardous use';

if g29_f='5' or i2_a='5' then alcabusx3=1;
  else if g29_f not in ('M','R') and i2_a not in ('M','R') then alcabusx3=0;
label alcabusx3='Alcohol Abuse Sx3- Legal problems more than once';

if (alcabusx1 in (1,0) and alcabusx2 in (1,0) and alcabusx3 in (1,0) and alcabusx4 in (1,0)) then do;
alcabusx=sum(of alcabusx1-alcabusx4);
end;
label alcabusx='Sum of 4 Alcohol Abuse Sxs';

if alcabusx ge 1 then alcabuse=1;
 else if alcabusx=0 then alcabuse=0;
label alcabuse='1+ Alcohol Abuse Sxs';


**Alcohol Abuse or Dependence**;
if alcabuse=1 or alcdepiv=1 then alcabdp=1;
  else if alcabuse=0 and alcdepiv=0 then alcabdp=0;
label alcabdp='Alcohol Abuse or Dependence';

alcsx=sum(of alcabusx, alcdepsx);
label alcsx='Sum of 11 Alcohol Abuse and Dependence Sxs';
end;

if alcsx=0 then alcsx5=0;
  else if alcsx=1 then alcsx5=1;
  else if alcsx=2 then alcsx5=2;
  else if alcsx=3 then alcsx5=3;
  else if alcsx ge 4 then alcsx5=4;

if alcabuse=1 or alcdepsx ge 1 then anyalcsx=1;
  else if alcabuse=0 and alcdepsx=0 then anyalcsx=0;
label anyalcsx='Any Alcohol Abuse or Dependence Sxs';


*********************************************************************************;
****WAVE 4 COMBINED ALCOHOL ABUSE/DEPENDENCE AND NICOTINE DEPENDENCE VARIABLE****;
*********************************************************************************;

**DSM-IV Nicotine Dependence**;
if alcabdp eq . and newnicdep eq . then aud_nd=.;
  else if alcabdp eq 1 and newnicdep eq 1 then aud_nd=3;
  else if alcabdp eq 1 and newnicdep eq 0 then aud_nd=2;
  else if alcabdp eq 0 and newnicdep eq 1 then aud_nd=1;
  else if alcabdp eq 0 and newnicdep eq 0 then aud_nd=0;
label aud_nd='DSM-IV Alcohol Use Disorder and/or DSM-IV Nicotine Dependence (3=both; 2=AUD; 1=ND; 0=neither)';

if aud_nd eq . then cand3=.;
  else if aud_nd eq 3 then cand3=1;
  else if aud_nd le 2 then cand3=0;
label cand3='1=AUD and ND; 0=all other groups';

if aud_nd eq . then cand2=.;
  else if aud_nd eq 2 then cand2=1;
  else if aud_nd eq 3 OR aud_nd le 1 then cand2=0;
label cand2='1=AUD only; 0=all other groups';

if aud_nd eq . then cand1=.;
  else if aud_nd eq 1 then cand1=1;
  else if aud_nd ge 2 OR aud_nd eq 0 then cand1=0;
label cand1='1=ND only; 0=all other groups';

if aud_nd eq . then cand0=.;
  else if aud_nd eq 0 then cand0=1;
  else if aud_nd ge 1 then cand0=0;
label cand0='1=niether AUD or ND; 0=all other groups';



**100+ Cigs in Lifetime**;
if alcabdp eq . and cig100 eq . then aud_cig100=.;
  else if alcabdp eq 1 and cig100 eq 1 then aud_cig100=3;
  else if alcabdp eq 1 and cig100 eq 0 then aud_cig100=2;
  else if alcabdp eq 0 and cig100 eq 1 then aud_cig100=1;
  else if alcabdp eq 0 and cig100 eq 0 then aud_cig100=0;
label aud_cig100='DSM-IV Alcohol Use Disorder and/or 100+ Cigs in Lifetime (3=both; 2=AUD; 1=cig100; 0=neither)';

if aud_cig100 eq . then can3=.;
  else if aud_cig100 eq 3 then can3=1;
  else if aud_cig100 le 2 then can3=0;
label can3='1=AUD and Cig100; 0=all other groups';

if aud_cig100 eq . then can2=.;
  else if aud_cig100 eq 2 then can2=1;
  else if aud_cig100 eq 3 OR aud_cig100 le 1 then can2=0;
label can2='1=AUD only; 0=all other groups';

if aud_cig100 eq . then can1=.;
  else if aud_cig100 eq 1 then can1=1;
  else if aud_cig100 ge 2 OR aud_cig100 eq 0 then can1=0;
label can1='1=Cig100 only; 0=all other groups';

if aud_cig100 eq . then can0=.;
  else if aud_cig100 eq 0 then can0=1;
  else if aud_cig100 ge 1 then can0=0;
label can0='1=niether AUD or Cig100; 0=all other groups';



	
****************************;
****WAVE 4 ILLICIT DRUGS****;
****************************;

***MARIJUANA***;
**Ever Used Marijuana**;
if h1_n eq '5' then do; mjuse=1; agemjuse=1*h1c_nage; end;
  else if h1_n eq '1' then do; mjuse=0; agemjuse=age; end;
label mjuse='ever used marijuana';
label agemjuse='age ever used marijuana';

if agemjuse=. or mjuse=0 then earlymj=.;
  else if mjuse=1 and agemjuse lt 14 then earlymj=1;
  else earlymj=0;
label earlymj='early marijuana use- before 14';

*Weekly Use**;
if h3_n in ('A', 'B', 'C', 'F', 'G', 'H') then mjweek=1;
  else if h3_n in ('I', 'J', 'K', 'L', 'N', 'O', 'P') or h1_n ne 'R' then mjweek=0;
label mjweek='weekly marijuana use';

**Marijuana Dependence with Clustering**;
if h13_n='5' or h13a_n='5' then mjdep=1;
  else if h13_n='R' and h13a_n='R' then mjdep=.;
  else mjdep=0;
label mjdep='marijuana dependence (with clustering)';

**Marijuana Abuse (non-hierarchical)**;
if mjuse ne . then do;
***Failure to fulfill role obligations;
   if i3_n eq '5' then mjabuse1=1;
    else if i3_n='M' then mjabuse1=.;
    else mjabuse1=0;
label mjabuse1='failure to fulfill role obligations - Mj';
   
***Hazardous use;
   if i1_n='5' then mjabuse2=1;
    else if i1_n='M' then mjabuse2=.;
    else mjabuse2=0;
label mjabuse2='hazardous use - Mj';

***Legal problems;
   if i2_n='5' then mjabuse3=1;
    else if i2_n='M' then mjabuse3=.;
    else mjabuse3=0;
label mjabuse3='legal problems - Mj';

***Social problems;
   if i4_n='5' or i5_n='5' then mjabuse4=1;
    else if i4_n='M' or i5_n='M' then mjabuse4=.;
    else mjabuse4=0;
label mjabuse4='social problems - Mj';

if sum(of mjabuse1-mjabuse4) ge 1 then mjabuse=1;
  else if mjabuse1=. or mjabuse2=. or mjabuse3=. or mjabuse4=. then mjabuse=.;
  else mjabuse=0;
label mjabuse='marijuana abuse';

if mjabuse=1 or mjdep=1 then mjabdp=1;
  else if mjabuse=0 or mjdep=0 then mjabdp=0;
label mjabdp='marijuana abuse or dependence';
end;



***COCAINE***;
if h1_o eq '5' then do; cocuse=1; agecocuse=1*h1c_oage; end;
  else if h1_o eq '1' then do; cocuse=0; agecocuse=age; end;

**Weekly use**;
if h3_o in ('A', 'B', 'C', 'F', 'G', 'H') then cocweek=1;
  else if h3_o in ('I', 'J', 'K', 'L', 'N', 'O', 'P') or h1_o ne 'R' then cocweek=0;

**Cocaine Dependence with Clustering**;
if h13_o='5' or h13a_o='5' then cocdep=1;
  else if h13_o='R' and h13a_o='R' then cocdep=.;
  else cocdep=0;

**Cocaine Abuse (non-hierarchical)**;
if cocuse ne . then do;
***Failure to fulfill role obligations;
   if i3_o eq '5' then cocabuse1=1;
    else if i3_o='M' then cocabuse1=.;
    else cocabuse1=0;
label cocabuse1='failure to fulfill role obligations - cocaine';
   
***Hazardous use;
   if i1_o='5' then cocabuse2=1;
    else if i1_o='M' then cocabuse2=.;
    else cocabuse2=0;
label cocabuse2='hazardous use - cocaine';

***Legal problems;
   if i2_o='5' then cocabuse3=1;
    else if i2_o='M' then cocabuse3=.;
    else cocabuse3=0;
label cocabuse3='legal problems - cocaine';

***Social problems;
   if i4_o='5' or i5_o='5' then cocabuse4=1;
    else if i4_o='M' or i5_o='M' then cocabuse4=.;
    else cocabuse4=0;
label cocabuse4='social problems - cocaine';

if sum(of cocabuse1-cocabuse4) ge 1 then cocabuse=1;
  else if cocabuse1=. or cocabuse2=. or cocabuse3=. or cocabuse4=. then cocabuse=.;
  else cocabuse=0;
end;


***STIMULANTS***;
if h1_p eq '5' then do; stimuse=1; agestuse=1*h1c_page; end;
else if h1_p eq '1' then do; stimuse=0; agestuse=age; end;

if h3_p in ('A', 'B', 'C', 'F', 'G', 'H') then stimweek=1;
  else if h3_p in ('I', 'J', 'K', 'L', 'N', 'O', 'P') or h1_p ne 'R' then stimweek=0;

**Stimulant Dependence with Clustering**;
if h13_p='5' or h13a_p='5' then stimdep=1;
  else if h13_p='R' and h13a_p='R' then stimdep=.;
  else stimdep=0;

**Stimulant Abuse (non-hierarchical)**;
if stimuse ne . then do;
***Failure to fulfill role obligations;
   if i3_p eq '5' then stimabuse1=1;
    else if i3_p='M' then stimabuse1=.;
    else stimabuse1=0;
label stimabuse1='failure to fulfill role obligations - stim';
   
***Hazardous use;
   if i1_p='5' then stimabuse2=1;
    else if i1_p='M' then stim=.;
    else stimabuse2=0;
label stimabuse2='hazardous use - stim';

***Legal problems;
   if i2_p='5' then stimabuse3=1;
    else if i2_p='M' then stim=.;
    else stimabuse3=0;
label stimabuse3='legal problems - stim';

***Social problems;
   if i4_p='5' or i5_p='5' then stimabuse4=1;
    else if i4_p='M' or i5_p='M' then stimabuse4=.;
    else stimabuse4=0;
label stimabuse4='social problems - stim';

if sum(of stimabuse1-stimabuse4) ge 1 then stimabuse=1;
  else if (stimabuse1=. or stimabuse2=. or stimabuse3=. or stimabuse4=.) then stimabuse=.;
  else stimabuse=0;
end;


**Stimulants or Cocaine**;
if stimuse=1 or cocuse=1 then stcocuse=1;
  else if stimuse=0 and cocuse=0 then stcocuse=0;
label stcocuse='stimulant or cocaine use';

if stcocuse=1 then agstcocuse=min(agestuse, agecocuse);
  else if stcocuse=0 then agstcocuse=age;


***OPIOIDS***;
if h1_q eq '5' then do; opiuse=1; end;
  else if h1_q eq '1' then do; opiuse=0; end;

if h3_q in ('A', 'B', 'C', 'F', 'G', 'H') then opiweek=1;
  else if h3_q in ('I', 'J', 'K', 'L', 'N', 'O', 'P') or h1_q ne 'R' then opiweek=0;

**Opioid Dependence with Clustering**;
if h13_q='5' or h13a_q='5' then opidep=1;
  else if h13_q='R' and h13a_q='R' then opidep=.;
  else opidep=0;

**Opioid Abuse (non-hierarchical)**;
if opiuse ne . then do;
***Failure to fulfill role obligations;
   if i3_q eq '5' then opiabuse1=1;
    else if i3_q='M' then opiabuse1=.;
    else opiabuse1=0;
label opiabuse1='failure to fulfill role obligations - opioids';
   
***Hazardous use;
   if i1_q='5' then opiabuse2=1;
    else if i1_q='M' then opiabuse2=.;
    else opiabuse2=0;
label opiabuse2='hazardous use - opioids';

***Legal problems;
   if i2_q='5' then opiabuse3=1;
    else if i2_q='M' then opiabuse3=.;
    else opiabuse3=0;
label opiabuse3='legal problems - opioids';

***Social problems;
   if i4_q='5' or i5_q='5' then opiabuse4=1;
    else if i4_q='M' or i5_q='M' then opiabuse4=.;
    else opiabuse4=0;
label opiabuse4='social problems - opioids';

if sum(of opiabuse1-opiabuse4) ge 1 then opiabuse=1;
  else if opiabuse1=. or opiabuse2=. or opiabuse3=. or opiabuse4=. then opiabuse=.;
  else opiabuse=0;
end;


***SEDATIVES***;
if h1_r eq '5' then do; seduse=1; end;
  else if h1_r eq '1' then do; seduse=0; end;

if h3_r in ('A', 'B', 'C', 'F', 'G', 'H') then sedweek=1;
  else if h3_r in ('I', 'J', 'K', 'L', 'N', 'O', 'P') or h1_r ne 'R' then sedweek=0;

**Sedative Dependence with Clustering**;
if h13_r='5' or h13a_r='5' then seddep=1;
  else if h13_r='R' and h13a_r='R' then seddep=.;
  else seddep=0;

**Sedative Abuse (non-hierarchical)**;
if seduse ne . then do;
***Failure to fulfill role obligations;
   if i3_r eq '5' then sedabuse1=1;
    else if i3_r='M' then sedabuse1=.;
    else sedabuse1=0;
label sedabuse1='failure to fulfill role obligations - sedatives';
   
***Hazardous use;
   if i1_r='5' then sedabuse2=1;
    else if i1_r='M' then sedabuse2=.;
    else sedabuse2=0;
label sedabuse2='hazardous use - sedatives';

***Legal problems;
   if i2_r='5' then sedabuse3=1;
    else if i2_r='M' then sedabuse3=.;
    else sedabuse3=0;
label sedabuse3='legal problems - sedatives';

***Social problems;
   if i4_r='5' or i5_r='5' then sedabuse4=1;
    else if i4_r='M' or i5_r='M' then sedabuse4=.;
    else sedabuse4=0;
label sedabuse4='social problems - sedatives';

if sum(of sedabuse1-sedabuse4) ge 1 then sedabuse=1;
  else if sedabuse1=. or sedabuse2=. or sedabuse3=. or sedabuse4=. then sedabuse=.;
  else sedabuse=0;
end;


***HALLUCINOGENS***;
if h1_s eq '5' then do; haluse=1; end;
  else if h1_s eq '1' then do; haluse=0; end;

if h3_s in ('A', 'B', 'C', 'F', 'G', 'H') then halweek=1;
  else if h3_s in ('I', 'J', 'K', 'L', 'N', 'O', 'P') or h1_s ne 'R' then halweek=0;

**Hallucinogen Dependence with Clustering**;
if h13_s='5' or h13a_s='5' then haldep=1;
  else if h13_s='R' and h13a_s='R' then haldep=.;
  else haldep=0;

**Hallucinogen Abuse (non-hierarchical)**;
if haluse ne . then do;
***Failure to fulfill role obligations;
   if i3_s eq '5' then halabuse1=1;
    else if i3_s='M' then halabuse1=.;
    else halabuse1=0;
label halabuse1='failure to fulfill role obligations - hallucinogens';
   
***Hazardous use;
   if i1_s='5' then halabuse2=1;
    else if i1_s='M' then halabuse2=.;
    else halabuse2=0;
label halabuse2='hazardous use - hallucinogens';

***Legal problems;
   if i2_s='5' then halabuse3=1;
    else if i2_s='M' then halabuse3=.;
    else halabuse3=0;
label halabuse3='legal problems - hallucinogens';

***Social problems;
   if i4_s='5' or i5_s='5' then halabuse4=1;
    else if i4_s='M' or i5_s='M' then halabuse4=.;
    else halabuse4=0;
label halabuse4='social problems - hallucinogens';

if sum(of halabuse1-halabuse4) ge 1 then halabuse=1;
  else if halabuse1=. or halabuse2=. or halabuse3=. or halabuse4=. then halabuse=.;
  else halabuse=0;
end;


***PCP***;
if h1_t eq '5' then do; pcpuse=1; end;
  else if h1_t eq '1' then do; pcpuse=0; end;

if h3_t in ('A', 'B', 'C', 'F', 'G', 'H') then pcpweek=1;
  else if h3_t in ('I', 'J', 'K', 'L', 'N', 'O', 'P') or h1_t ne 'R'
     then pcpweek=0;


****SOLVENTS***;
if h1_v eq '5' then do; soluse=1; end;
  else if h1_v eq '1' then do; soluse=0; end;

if h3_v in ('A', 'B', 'C', 'F', 'G', 'H') then solweek=1;
  else if h3_v in ('I', 'J', 'K', 'L', 'N', 'O', 'P') or h1_v ne 'R' then solweek=0;


***INHALANTS***;
if h1_w eq '5' then do; inhuse=1; end;
  else if h1_w eq '1' then do; inhuse=0; end;

if h3_w in ('A', 'B', 'C', 'F', 'G', 'H') then inhweek=1;
  else if h3_w in ('I', 'J', 'K', 'L', 'N', 'O', 'P') or h1_w ne 'R' then inhweek=0;


***OTHER DRUGS***;
**Ever Used Other Drug**;
if h1_t eq '5' then do; othuse=1; ageothuse=1*h1c_tage; end;
  else if h1_t eq '1' then do; othuse=0; ageothuse=age; end;

**Other Drug Dependence with Clustering**;
if h13_t='5' or h13a_t='5' then othdep=1;
  else if h13_t='R' and h13a_t='R' then othdep=.;
  else othdep=0;

**Other Drug Abuse (non-hierarchical)**;
if othuse ne . then do;
***Failure to fulfill role obligations;
   if i3_t eq '5' then othabuse1=1;
     else if i3_t='M' then othabuse1=.;
     else othabuse1=0;
label othabuse1='failure to fulfill role obligations - other';
   
***Hazardous use;
   if i1_t='5' then othabuse2=1;
    else if i1_t='M' then othabuse2=.;
    else othabuse2=0;
label othabuse2='hazardous use - other drug';

***Legal problems;
   if i2_t='5' then othabuse3=1;
    else if i2_t='M' then othabuse3=.;
    else othabuse3=0;
label othabuse3='legal problems - other drug';

***Social problems;
   if i4_t='5' or i5_t='5' then othabuse4=1;
    else if i4_t='M' or i5_t='M' then othabuse4=.;
    else othabuse4=0;
label othabuse4='social problems - other drug';

if sum(of othabuse1-othabuse4) ge 1 then othabuse=1;
  else if othabuse1=. or othabuse2=. or othabuse3=. or othabuse4=. then othabuse=.;
  else othabuse=0;
end;


**Sum of Illegal Drugs**;
if mjuse=1 or cocuse=1 or stimuse=1 or opiuse=1 or seduse=1 or haluse=1 or inhuse=1 then druguse=1;
  else if mjuse=0 and cocuse=0 and stimuse=0 and opiuse=0 and seduse=0 and haluse=0 and inhuse=0 then druguse=0;

if cocuse=1 or stimuse=1 or opiuse=1 or seduse=1 or haluse=1 or inhuse=1 then harddruguse=1;
  else if cocuse=0 and stimuse=0 and opiuse=0 and seduse=0 and haluse=0 and inhuse=0 then harddruguse=0;

if mjweek=1 or cocweek=1 or stimweek=1 or opiweek=1 or sedweek=1 or halweek=1 or inhweek=1 then drugweek=1;
  else if mjweek=0 and cocweek=0 and stimweek=0 and opiweek=0 and sedweek=0 and halweek=0 and inhweek=0 then drugweek=0;

if cocweek=1 or stimweek=1 or opiweek=1 or sedweek=1 or halweek=1 or inhweek=1 then harddrugweek=1;
  else if cocweek=0 and stimweek=0 and opiweek=0 and sedweek=0 and halweek=0 and inhweek=0 then harddrugweek=0;

if mjdep=1 or cocdep=1 or stimdep=1 or opidep=1 or seddep=1 or haldep=1 or othdep=1 then drugdep=1;
  else if mjdep=. or cocdep=. or stimdep=. or opidep=. or seddep=. or haldep=. or othdep=. then drugdep=.;
  else drugdep=0;
label drugdep='any drug dependence, including mj';

if cocdep=1 or stimdep=1 or opidep=1 or seddep=1 or haldep=1 or othdep=1 then hdrugdep=1;
  else if cocdep=. or stimdep=. or opidep=. or seddep=. or haldep=. or othdep=. then hdrugdep=.;
  else hdrugdep=0;
label hdrugdep='dependence on drug other than mj';

if mjabuse=1 or cocabuse=1 or stimabuse=1 or opiabuse=1 or sedabuse=1 or halabuse=1 or othabuse=1 then drugabuse=1;
  else if mjabuse=. or cocabuse=. or stimabuse=. or opiabuse=. or sedabuse=. or halabuse=. or othabuse=. then drugabuse=.;
  else drugabuse=0;
label drugabuse='any drug abuse - including mj';

if cocabuse=1 or stimabuse=1 or opiabuse=1 or sedabuse=1 or halabuse=1 or othabuse=1 then hdrugabuse=1;
  else if cocabuse=. or stimabuse=. or opiabuse=. or sedabuse=. or halabuse=. or othabuse=. then hdrugabuse=.;
  else hdrugabuse=0;
label hdrugabuse='abuse of drug other than mj';


*******************************;
****WAVE 4 MAJOR DEPRESSION****;
*******************************;

if j1 not in ('R') then do;

if j1='5' or j1_a=5 then dysphoria=1;
  else if j1='1' and j1_a=1 then dysphoria=0;

if j1b_ag not in ('95','MM','RR') then dysage=j1b_ag*1;


if j2=5 or j2_a=5 then anhedonia=1;
  else if j2=1 and j2_a=1 then anhedonia=0;

if j2b_ag not in ('95','MM','RR') then anage=j2b_ag*1;

if j3=5 and '1' le j3b_ag lt '18' then irritable=1;
  else if j3=1 or (j3b_ag not in ('RR','MM') or j3b_ag ge '18') then irritable=0;

if j3b_ag not in ('95','RR','MM') then irage=j3b_ag*1;

if dysphoria=1 or anhedonia=1 or irritable=1 then mddpass1=1;
  else if dysphoria=0 and anhedonia=0 and irritable=0 then mddpass1=0;

if mddpass1=1 then mddpassage=min(dysage, anage, irage);

if j1 ne 5 and j1_a ne 5 and j2 ne 5 and j2_a ne 5 and j3 ne 5 then boxj3=0;
  else boxj3=1;
end;


if j6_i='5' or j7_i='5' or j5_i='5' then sawdoc_i=1;
  else if (j6_i=' ' and j7_i=' ' and j5_i=' ') or (j5_i='1') then sawdoc_i=0;

if j6b_i='5' then hometx_i=1;
  else if j6b_i not in ('M','R') then hometx_i=0;

if j8a_i='5' or j8a2_i='5' or j9_i='5' then impair_i=1;
  else if (j8a_i ne 'R' and j8a2_i ne 'R' and j9_i ne 'R') then impair_i=0;

if j6_r='5' or j7_r='5' or j5_r='5' then sawdoc_r=1;
  else if (j6_r=' ' and j7_r=' ' and j5_r=' ') or (j5_r='1') then sawdoc_r=0;

if j6b_r='5' then hometx_r=1;
  else if j6b_r not in ('M','R') then hometx_r=0;

if j8a_r='5' or j8a2_r='5' or j9_r='5' then impair_r=1;
  else if (j8a_r ne 'R' and j8a2_r ne 'R' and j9_r ne 'R') then impair_r=0;

if hometx_r=1 or hometx_i=1 then hometx=1;
  else if hometx_r ne . and hometx_i ne . then hometx=0;
label hometx='depression home remedy';

if sawdoc_r=1 or sawdoc_i=1 then sawdoc=1;
  else if sawdoc_r ne . and sawdoc_i ne . then sawdoc=0;
label sawdoc='saw professional about depression';

if impair_r=1 or impair_i=1 then impair=1;
  else if impair_r ne . and impair_i ne . then impair=0;
label impair='depression impaired functioning';

if j4c_i='5' or j4c_r='5' then miserable=1;
  else miserable=0;

if miserable=1 or impair=1 or hometx=1 or sawdoc=1 then boxj9=1;
  else boxj9=0;


if j19_i not in ('R') and j19_r not in ('R') then do;

omajdepiv=(j19_i eq '5');

majdepiv=(j19_i eq '5' or j19_r eq '5');
label majdepiv='5+ Symptoms on First Pass or Retry';


if j19a1_wi not in ('RR') then i_week=1*j19a1_wi;
if j19a1_im not in ('RR') then i_month=1*j19a1_im;
if j19a1_iy not in ('RR') then i_year=1*j19a1_iy;

if j19_i eq '5' and (i_week ge 2 or i_month ge 1 or i_year ge 1) then idep_clust=1;

if j19a1_wr not in ('RR') then r_week=1*j19a1_wr;
if j19a1_rm not in ('RR') then r_month=1*j19a1_rm;
if j19a1_ry not in ('RR') then r_year=1*j19a1_ry;

if j19_r eq '5' and (r_week ge 2 or r_month ge 1 or r_year ge 1) then rdep_clust=1;

if rdep_clust=1 or idep_clust=1 then mdd=1;
  else mdd=0;
label mdd='5+ MDD sx clustering within a 2 week period';

if mdd=1 or j22='5' or j23 in ('6','7') then ppdep=1;
end; 


**Depression Tally**;
**NOTE: There is no Symptom D**;
**Clustered Symptoms - INITIAL TRY**; 

**A;
*a1;
if j10a_iwk ne 'RR' and j10a_imo ne 'RR' and j10a_iyr ne 'RR' then do;
if (j10a_iwk ge 02 or j10a_imo ge 01 or j10a_iyr ge 01) and idep_clust=1 then idepA1=1;
  else if j10_i=1 or j10a_iwk le 01 or idep_clust eq '.' then idepA1=0;
end;

*a2; 
if j10e_iwk ne 'RR' and j10e_imo ne 'RR' and j10e_iyr ne 'RR' and j10e_iwk ne 'MM' and j10e_imo ne 'MM' and j10e_iyr ne 'MM' and j10d_i ne 'M' then do;
if (j10e_iwk ge 02 or j10e_imo ge 01 or j10e_iyr ge 01) and idep_clust=1 then idepA2=1;
  else if j10d_i=1 or j10e_iwk le 01 or idep_clust eq '.' then idepA2=0;
end;

if idepA1=1 or idepA2=1 then idepA=1;
  else if idepA1 ne '.' or idepA2 ne '.' then idepA=0;

**B;
if j10c_iwk ne 'RR' and j10c_imo ne 'RR' and j10c_iyr ne 'RR' and j10c_iwk ne 'MM' and j10c_imo ne 'MM' and j10c_iyr ne 'MM' and j10b_i ne 'M' and j10b1_i ne 'M' then do;
if (j10c_iwk ge 02 or j10c_imo ge 01 or j10c_iyr ge 01) and idep_clust=1 then idepB=1;
  else if j10b_i=1 and j10b1_i=1 or j10c_iwk le 01 or idep_clust eq '.' then idepB=0;
end;

**C;
*c1;
if j11a_i ne 'M' and j11a_i ne 'R' and j11b_i ne 'M' and j11b_i ne 'R' then do;
if (j11a_i=1 or j11b_i=1) or idep_clust eq '.' then idepC1=0;
  else if j11b_i=5 and idep_clust=1 then idepC1=1;
end;

*c2;
if j11c_i ne 'M' and j11c_i ne 'R' and j11e_i ne 'M' and j11e_i ne 'R' then do;
if j11c_i=1 or j11e_i=1 or idep_clust eq '.' then idepC2=0;
  else if (j11e_i=5 or j11e_i=6) and idep_clust=1 then idepC2=1;
end;

if idepC1=1 or idepC2=1 then idepC=1;
  else if idepC1 ne '.' or idepC2 ne '.' then idepC=0;

**NO SYMPTOM D**;

**E;
*e1;
if j12_i ne 'R' then do; 
if j12_i=5 and j122_i='5' and idep_clust=1 then idepE1=1;
  else if j12_i=1 or j122_i='1' or idep_clust eq '.' then idepE1=0;
end;

*e2;
if j121_i ne 'R' and j122_i ne 'M' then do;
if j121_i=5 and j122_i='5' and idep_clust=1 then idepE2=1;
  else if j121_i=1 or j122_i='1' or idep_clust eq '.' then idepE2=0;
end; 

if idepE1=1 or idepE2=1 then idepE=1;
  else if idepE1 ne '.' or idepE ne '.' then idepE=0;

**F;
*f1;
if j13_i ne 'R' then do; 
if j13_i=5 and j13a_i=5 and j13b_i=5 and idep_clust=1 then idepF1=1;
  else if j13_i=1 or j13a_i=1 or j13b_i=1 or idep_clust eq '.' then idepF1=0;
end;

*f2;
if j14_i ne 'R' then do; 
if j14_i=5 and j14a_i=5 and j14b_i=5 and idep_clust=1 then idepF2=1;
  else if j14_i=1 or j14a_i=1 or j14b_i=1 or idep_clust eq '.' then idepF2=0;
end;

if idepF1=1 or idepF2=1 then idepF=1;
  else if idepF1 ne '.' or idepF2 ne '.' then idepF=0;

**G;
if j15_i ne 'R' then do;
if j15_i=5 and j15a_i=5 and idep_clust=1 then idepG=1;
  else if j15_i=1 or j15a_i=1 or idep_clust eq '.' then idepG=0;
end;

**H;
if j16_i ne 'R' then do;
if j16_i=5 and j16a_i=5 and idep_clust=1 then idepH=1;
  else if j16_i=1 or j16a_i=1 or idep_clust eq '.' then idepH=0;
end;

**I;
*i1;
if j17_i ne 'R' then do;
if j17_i=5 and j17b_i='5' and idep_clust=1 then idepI1=1;
  else if j17_i=1 or j17b_i='1' or idep_clust eq '.' then idepI1=0;
end;

*i2;
if j17a_i ne 'R' and j17b_i ne 'M' then do;
if j17a_i=5 and j17b_i='5' and idep_clust=1 then idepI2=1;
  else if j17a_i=1 or j17b_i='1' or idep_clust eq '.' then idepI2=0;
end;

if idepI1=1 or idepI2=1 then idepI=1;
  else if idepI1 ne '.' or idepI2 ne '.' then idepI=0;

**J;
*j1;
if j18_i ne 'R' then do;
if j18_i=5 and idep_clust=1 then idepJ1=1;
  else if j18_i=1 or idep_clust eq '.' then idepJ1=0;
end;

*j2;
if j18a_i ne 'R' then do;
if j18a_i=5 and idep_clust=1 then idepJ2=1;
  else if j18a_i=1 or idep_clust eq '.' then idepJ2=0;
end;

*j3;
if j18b_i ne 'R' then do;
if j18b_i=5 and idep_clust=1 then idepJ3=1;
  else if j18b_i=1 or idep_clust eq '.' then idepJ3=0;
end;

*j4;
if j18c_i ne 'R' then do;
if j18c_i=5 and idep_clust=1 then idepJ4=1;
  else if j18c_i=1 or idep_clust eq '.' then idepJ4=0;
end;

if idepJ1=1 or idepJ2=1 or idepJ3=1 or idepJ4=1 then idepJ=1;
  else if idepJ1 ne '.' or idepJ2 ne '.' or idepJ3 ne '.' or idepJ4 ne '.' then idepJ=0;


**Clustered Symptoms - RETRY**; 

**A;
*a1;
if j10a_rwk ne 'RR' and j10a_rmo ne 'RR' and j10a_ryr ne 'RR' then do;
if (j10a_rwk ge 02 or j10a_rmo ge 01 or j10a_ryr ge 01) and rdep_clust=1 then rdepA1=1;
  else if j10_r=1 or j10a_rwk le 01 or rdep_clust eq '.' then rdepA1=0;
end;

*a2; 
if j10e_rwk ne 'RR' and j10e_rmo ne 'RR' and j10e_ryr ne 'RR' and j10e_rwk ne 'MM' and j10e_rmo ne 'MM' and j10e_ryr ne 'MM' and j10d_r ne 'M' then do;
if (j10e_rwk ge 02 or j10e_rmo ge 01 or j10e_ryr ge 01) and rdep_clust=1 then rdepA2=1;
  else if j10d_r=1 or j10e_rwk le 01 or rdep_clust eq '.' then rdepA2=0;
end;

if rdepA1=1 or rdepA2=1 then rdepA=1;
  else if rdepA1 ne '.' or rdepA2 ne '.' then rdepA=0;

**B;
if j10c_rwk ne 'RR' and j10c_rmo ne 'RR' and j10c_ryr ne 'RR' and j10c_rwk ne 'MM' and j10c_rmo ne 'MM' and j10c_ryr ne 'MM' and j10b_r ne 'M' and j10b1_r ne 'M' then do;
if (j10c_rwk ge 02 or j10c_rmo ge 01 or j10c_ryr ge 01) and rdep_clust=1 then rdepB=1;
  else if j10b_r=1 and j10b1_r=1 or j10c_rwk le 01 or rdep_clust eq '.' then rdepB=0;
end;

**C;
*c1;
if j11a_r ne 'M' and j11a_r ne 'R' and j11b_r ne 'M' and j11b_r ne 'R' then do;
if (j11a_r=1 or j11b_r=1) or rdep_clust eq '.' then rdepC1=0;
  else if j11b_r=5 and rdep_clust=1 then rdepC1=1;
end;

*c2;
if j11c_r ne 'M' and j11c_r ne 'R' and j11e_r ne 'M' and j11e_r ne 'R' then do;
if j11c_r=1 or j11e_r=1 or rdep_clust eq '.' then rdepC2=0;
  else if (j11e_r=5 or j11e_r=6) and rdep_clust=1 then rdepC2=1;
end;

if rdepC1=1 or rdepC2=1 then rdepC=1;
  else if rdepC1 ne '.' or rdepC2 ne '.' then rdepC=0;

**NO SYMPTOM D**;

**E;
*e1;
if j12_r ne 'R' then do; 
if j12_r=5 and j122_r=5 and rdep_clust=1 then rdepE1=1;
  else if j12_r=1 or j122_r=1 or rdep_clust eq '.' then rdepE1=0;
end;

*e2;
if j121_r ne 'R' and j122_r ne 'M' then do;
if j121_r=5 and j122_r=5 and rdep_clust=1 then rdepE2=1;
  else if j121_r=1 or j122_r=1 or rdep_clust eq '.' then rdepE2=0;
end; 

if rdepE1=1 or rdepE2=1 then rdepE=1;
  else if rdepE1 ne '.' or rdepE ne '.' then rdepE=0;

**F;
*f1;
if j13_r ne 'R' then do; 
if j13_r=5 and j13a_r=5 and j13b_r=5 and rdep_clust=1 then rdepF1=1;
  else if j13_r=1 or j13a_r=1 or j13b_r=1 or rdep_clust eq '.' then rdepF1=0;
end;

*f2;
if j14_r ne 'R' then do; 
if j14_r=5 and j14a_r=5 and j14b_r=5 and rdep_clust=1 then rdepF2=1;
  else if j14_r=1 or j14a_r=1 or j14b_r=1 or rdep_clust eq '.' then rdepF2=0;
end;

if rdepF1=1 or rdepF2=1 then rdepF=1;
  else if rdepF1 ne '.' or rdepF2 ne '.' then rdepF=0;

**G;
if j15_r ne 'R' then do;
if j15_r=5 and j15b_r='5' and rdep_clust=1 then rdepG=1;
  else if j15_r=1 or j15b_r='1' or rdep_clust eq '.' then rdepG=0;
end;

**H;
if j16_r ne 'R' then do;
if j16_r=5 and j16a_r=5 and rdep_clust=1 then rdepH=1;
  else if j16_r=1 or j16a_r=1 or rdep_clust eq '.' then rdepH=0;
end;

**I;
*i1;
if j17_r ne 'R' then do;
if j17_r='5' and j17b_r='5' and rdep_clust=1 then rdepI1=1;
  else if j17_r='1' or j17b_r='1' or rdep_clust eq '.' then rdepI1=0;
end;

*i2;
if j17a_r ne 'R' and j17b_r ne 'M' then do;
if j17a_r=5 and j17b_r=5 and rdep_clust=1 then rdepI2=1;
  else if j17a_r=1 or j17b_r=1 or rdep_clust eq '.' then rdepI2=0;
end;

if rdepI1=1 or rdepI2=1 then rdepI=1;
  else if rdepI1 ne '.' or rdepI2 ne '.' then rdepI=0;

**J;
*j1;
if j18_r ne 'R' then do;
if j18_r=5 and rdep_clust=1 then rdepJ1=1;
  else if j18_r=1 or rdep_clust eq '.' then rdepJ1=0;
end;

*j2;
if j18a_r ne 'R' then do;
if j18a_r=5 and rdep_clust=1 then rdepJ2=1;
  else if j18a_r=1 or rdep_clust eq '.' then rdepJ2=0;
end;

*j3;
if j18b_r ne 'R' then do;
if j18b_r=5 and rdep_clust=1 then rdepJ3=1;
  else if j18b_r=1 or rdep_clust eq '.' then rdepJ3=0;
end;

*j4;
if j18c_r ne 'R' then do;
if j18c_r=5 and rdep_clust=1 then rdepJ4=1;
  else if j18c_r=1 or rdep_clust eq '.' then rdepJ4=0;
end;

if rdepJ1=1 or rdepJ2=1 or rdepJ3=1 or rdepJ4=1 then rdepJ=1;
  else if rdepJ1 ne '.' or rdepJ2 ne '.' or rdepJ3 ne '.' or rdepJ4 ne '.' then rdepJ=0;


**Combining Intial Try and Retry Depression Symptoms**;
if idepA ne '.' or rdepA ne '.' then do;
if idepA=1 or rdepA=1 then depA=1;
  else depA=0;
end; 

if idepB ne '.' or rdepB ne '.' then do;
if idepB=1 or rdepB=1 then depB=1;
  else depB=0;
end; 

if idepC ne '.' or rdepC ne '.' then do;
if idepC=1 or rdepC=1 then depC=1;
  else depC=0;
end; 

**NO SYMPTOM D**;

if idepE ne '.' or rdepE ne '.' then do;
if idepE=1 or rdepE=1 then depE=1;
  else depE=0;
end; 

if idepF ne '.' or rdepF ne '.' then do;
if idepF=1 or rdepF=1 then depF=1;
  else depF=0;
end; 

if idepG ne '.' or rdepG ne '.' then do;
if idepG=1 or rdepG=1 then depG=1;
  else depG=0;
end; 

if idepH ne '.' or rdepH ne '.' then do;
if idepH=1 or rdepH=1 then depH=1;
  else depH=0;
end; 

if idepI ne '.' or rdepI ne '.' then do;
if idepI=1 or rdepI=1 then depI=1;
  else depI=0;
end; 

if idepJ ne '.' or rdepJ ne '.' then do;
if idepJ=1 or rdepJ=1 then depJ=1;
  else depJ=0;
end; 


**Number of Symptoms**;
depnum=sum(depA, depB, depC, depE, depF, depG, depH, depI, depJ);
label depnum='Number of Depression Sxs - Initial and Retry';

**Age of Onset;
if j4a_i ne 'RR' and mdd=1 then do;
idepage=(1*j4a_i); 
end;

if j4a_r ne 'RR' and mdd=1 then do;
rdepage=(1*j4a_r);
end;

if idep_clust=1 then depage=idepage;
  else if rdep_clust=1 then depage=rdepage; 

if depage ne . then sdepage=depage;
  else sdepage=age;

if mdd=1 then smddpassage=mddpassage;
  else if mdd=0 then smddpassage=age;

if mdd=1 and j28='0' then mddepisode=0;
  else if mdd=1 and j28 not in (' ','RR') then mddepisode=1;


**Treatment**;
if mdd=1 then do;
if (idep_clust=1 and j5_i=5) or (rdep_clust=1 and j5_r=5) then treat=1; 
  else if (idep_clust=1 and j5_i=1) or (rdep_clust=1 and j5_r=1) then treat=0; 
end;


***Full Sample;
**A;
*initial a1;
if j10a_iwk ne 'RR' and j10a_imo ne 'RR' and j10a_iyr ne 'RR' then do;
if (j10a_iwk ge 02 or j10a_imo ge 01 or j10a_iyr ge 01) and j10_i=5 then ifullA1=1;
  else if j10_i=1 or j10a_iwk le 01 then ifullA1=0;
end;

*retry a1;
if j10a_rwk ne 'RR' and j10a_rmo ne 'RR' and j10a_ryr ne 'RR' then do;
if (j10a_rwk ge 02 or j10a_rmo ge 01 or j10a_ryr ge 01) and j10_r=5 then rfullA1=1;
  else if j10_r=1 or j10a_rwk le 01 then rfullA1=0;
end;

*total a1;
if ifullA1=1 or rfullA1=1 then fullA1=1;
  else if ifullA1=0 and rfullA1=0 then fullA1=0; 


*initial a2;
if j10e_iwk ne 'RR' and j10e_imo ne 'RR' and j10e_iyr ne 'RR' and
j10e_iwk ne 'MM' and j10e_imo ne 'MM' and j10e_iyr ne 'MM' and j10d_i ne 'M' then do;
if (j10e_iwk ge 02 or j10e_imo ge 01 or j10e_iyr ge 01) and j10d_i=5 then ifullA2=1;
  else if j10d_i=1 or j10e_iwk le 01 then ifullA2=0;
end;

*retry a2;
if j10e_rwk ne 'RR' and j10e_rmo ne 'RR' and j10e_ryr ne 'RR' and
j10e_rwk ne 'MM' and j10e_rmo ne 'MM' and j10e_ryr ne 'MM' and j10d_r ne 'M' then do;
if (j10e_rwk ge 02 or j10e_rmo ge 01 or j10e_ryr ge 01) and j10d_r=5 then rfullA2=1;
  else if j10d_r=1 or j10e_rwk le 01 then rfullA2=0;
end;

*total a2;
if ifullA2=1 or rfullA2=1 then fullA2=1;
  else if ifullA2=0 and rfullA2=0 then fullA2=0;



**********************************************;
****WAVE 4 ANTISOCIAL PERSONALITY DISORDER****;
**********************************************;

if k22 ne "R" then do;

if k22_a="5" or k23="5" or k23_a="5" or k24_a="5" or k24_b="5" then aspd1=1;
  else aspd1=0;
label aspd1='ASPD Sx1';

if k25="5" or k25_a="5" or k26a="5" or k26b="5" or k27="5" or k28_a="5" or k29="5" or k30="5" then aspd2=1;
  else aspd2=0;
label aspd2='ASPD Sx2';

if k31="5" or k32="5" or k33="5" or k34="5" then aspd3=1;
  else aspd3=0;
label aspd3='ASPD Sx3';

if k35="5" or k36="5" or k37="5" then aspd4=1;
  else aspd4=0;
label aspd4='ASPD Sx4';

if k38="5" or k39="5" or k40="5" or k40_b="5" or k41="5" then aspd5=1;
  else aspd5=0;
label aspd5='ASPD Sx5';

if k42="5" or k43="5" or k44="5" or k45="5" or k46="5" or k47="5" then aspd6=1;
  else aspd6=0;
label aspd6='ASPD Sx6';


aspdsx=sum(of aspd1-aspd6);
label aspdsx='Sum of 6 ASPD Sxs';

if aspdsx ge 1 then anyaspdsx=1;
  else anyaspdsx=0;
label anyaspdsx='Any ASPD Sxs';
end;


*****************************************************************;
****WAVE 4 CONDUCT DISORDER (i.e., 3 or more DSM-IV symptoms)****;
*****************************************************************;

***Skipped School;
if tka1_ag not in ('99','MM') then skip_on=(1*tka1_ag);
if k2_a='R' or (k2_a='K' and skip_on=.) then cd1=.;
  else if  skip_on<13  and skip_on ne '' and  k2_a in ('K','L') then cd1=1;
  else cd1=0;
label cd1='Skipped school lt 13 yo';

if cd1=1 then cdsxons1=skip_on;
  else if cd1=0 then cdsxons1=age;


***Shoplifted;
if k3_a in ('M','R') or k3_d in ('M','R') then cd2=.;
  else if k3_a in ('K','L') or k3_d in ('K','L') then cd2=1;
  else cd2=0;
label cd2='shoplifted/stole or used check or credit card';

if tkb1_ag ne 'RR' then ntkb1_ag=1*tkb1_ag;
if tkb2_ag ne 'MM' then ntkb2_ag=1*tkb2_ag;

if cd2=1 then cdsxons2=min (ntkb1_ag, ntkb2_ag);
  else if cd2=0 then cdsxons2=age;


***Stayed Out/Sneaked Out;
if tkc1_ag not in ('MM','RR') then stayout_on=1*tkc1_ag;
if k4_a='R' or k4_a in ('K','L') and stayout_on = . then cd3=.;
   else if k4_a in ('K','L') and stayout_on lt 13 then cd3=1;
   else cd3=0;
label cd3='stayedout/sneaked out';

if cd3=1 then cdsxons3=stayout_on;
  else if cd3=0 then cdsxons3=age;


***Ran Away from Home;
if k5='R' or k5_b='X' then cd4=.;
  else if (k5='5' and k5_a in ('J','K','L')) or (k5='5' and k5_a='I' and k5_c='1')
       or (k5='5' and k5_a='I' and k5_d in ('D','E','F')) or (k5='4' and k5_b in ('J','K','L')) or (k5='4' and k5_b='I' and k5_c='1') or (k5='4' and k5_b='I'
       and k5_d in ('D','E','F')) then cd4=1;
   else cd4=0;
label cd4='ran away';

if tke1_ag ne '99' then ntke1_ag=1*tke1_ag;

if cd4=1 then cdsxons4=ntke1_ag;
  else if cd4=0 then cdsxons4=age;


***Lying/Conning;
if k6_a in ('2','3') or k6_c='5' then cd5=1;
  else if k6_a in ('R','M') or k6_c in ('R','M') then cd5=.;
  else cd5=0;
label cd5='lying/conning';

if tkf1_ag ne 'RR' then ntkf1_ag=1*tkf1_ag;
if tkf2_ag ne 'MM' then ntkf2_ag=1*tkf2_ag;

if cd5=1 then cdsxons5=min (ntkf1_ag, ntkf2_ag);
  else if cd5=0 then cdsxons5=age;


***Fire Setting;
if k7='5' then cd6=1;
  else if k7 ne 'R' then cd6=0;
label cd6='fire setting';

if cd6=1 then cdsxons6=1*tkg1_ag;
  else if cd6=0 then cdsxons6=age;


***Breaking and Entering;
if k8='5' then cd7=1;
  else if k8 ne 'R' then cd7=0;
label cd7='B&E';

if cd7=1 then cdsxons7=1*tkh1_ag;
  else if cd7=0 then cdsxons7=age;


***Damaged Property;
if k9='5' then cd8=1;
  else if k9 ne 'R' then  cd8=0;
label cd8='damaged property';

if cd8=1 then cdsxons8=1*tki1_ag;
  else if cd8=0 then cdsxons8=age;


***Animal Cruelty;
if k10='5' then cd9=1;
  else if k10 ne 'R' then cd9=0;
label cd9='animal cruelty';

if tkj1_ag ne '99' then ntkj1_ag=1*tkj1_ag;
if cd9=1 then cdsxons9=ntkj1_ag;
  else if cd9=0 then cdsxons9=age;


***Used Weapon;
if k11='5' then cd10=1;
  else if k11 ne 'R' then cd10=0;
label cd10='used weapon in fight';

if cd10=1 then cdsxons10=1*tkk1_ag;
  else if cd10=0 then cdsxons10=age;


***Physical Fights;
if k12_a in ('K','L') then cd11=1;
  else if k12 ne 'R' then cd11=0;
label cd11='physical fights 3+ times';

if tkl1_ag ne 'MM' then ntkl1_ag=1*tkl1_ag;
if cd11=1 then cdsxons11=ntkl1_ag;
  else if cd11=0 then cdsxons11=age;


***Mugging;
if k13='5' then cd12=1;
  else if k13 ne 'R' then cd12=0;
label cd12 = 'mugging or purse snatching';

if cd12=1 then cdsxons12=1*tkn1_ag;
  else if cd12=0 then cdsxons12=age;


***Bullying;
if k14_a in ('K','L') then cd13=1;
  else if k14 ne 'R' then cd13=0;
label cd13='bullying 3+ times';

if cd13=1 then cdsxons13=1*tko1_ag;
  else if cd13=0 then cdsxons13=age;


***Cruel/Inflicting Physical Pain;
if k15='5' then cd14=1;
  else if k15 not in ('M','R') then cd14=0;
label cd14='cruelty to people';

if cd14=1 then cdsxons14=1*tkp1_ag;
  else if cd14=0 then cdsxons14=age;


***Forced Sex;
if k16='5' then cd15=1;
  else if k16 not in ('M','R') then cd15=0;

if cd15=1 then cdsxons15=1*tkq1_ag;
  else if cd15=0 then cdsxons15=age;



****Conduct Symptom Count Measure****;

w4cd4sx=sum(cd1,cd2,cd3,cd4,cd5,cd6,cd7,cd8,cd9,cd10,cd11,cd12,cd13,cd14,cd15);
cdmiss=nmiss(cd1,cd2,cd3,cd4,cd5,cd6,cd7,cd8,cd9,cd10,cd11,cd12,cd13,cd14,cd15);


if w4cd4sx ge 3 then conductfup=1;
  else if (cdmiss+w4cd4sx ge 3) or w4cd4sx=. then conductfup=.;
else if w4cd4sx lt 3 then conductfup=0;

if conductfup=1 then cd4sxonsfup=min(cdsxons1,cdsxons2,cdsxons3,cdsxons4,cdsxons5,cdsxons6,cdsxons7,cdsxons8,cdsxons9,cdsxons10,cdsxons11,cdsxons12,cdsxons13,
  cdsxons14,cdsxons15);
  else if conductfup=0 then cd4sxonsfup=age;


****************************;
****WAVE 4 SOCIAL PHOBIA****;
****************************;

if d11_c1 ne "R" then do;
if d1_b = "5" then socphoA=1;
  else socphoA=0;
label socphoA='Social Phobia Criterion A';

if d3_b="5" then socphoB=1;
  else socphoB=0;
label socphoB='Social Phobia Criterion B';

***Criterion C (The person recognizes that the fear is excessive or unreasonable) is not assessed;

if d3="5" or d3_a="5" then socphoD=1;
  else socphoD=0;
label socphoD='Social Phobia Criterion D';

if d4="5" or d4_a="5" or d4_b="5" or d4_c="5" then socphoE=1;
  else socphoE=0;
label socphoE='Social Phobia Criterion E';

***Criterion F (In individuals under age 18, the duration is at least 6 mos) not assessed;

if d5="1" then socphoG=1;
  else if d5="M" then socphog=.;
  else socphoG=0;
label socphoG='Social Phobia Criterion G';

if socphoa=1 and socphob=1 and socphod=1 and socphoe=1 and socphog=1 then socphobia=1;
  else socphobia=0;
label socphobia='Social Phobia Diagnosis';
end;


********************************************;
****WAVE 4 PANIC DISORDER (from Michele)****;
********************************************;

if (d17 eq '1' or d17 eq '5') then do;
    pan1=(d18_1 eq '5');  
    pan2=(d18_2 eq '5');  
    pan3=(d18_3 eq '5');
    pan4=(d18_4 eq '5');
    pan5=(d18_5 eq '5');
    pan6=(d18_6 eq '5');
    pan7=(d18_7 eq '5'); 
    pan8=(d18_8 eq '5');
    pan9=(d18_9 eq '5');
    pan10=(d18_10 eq '5');
    pan11=(d18_11 eq '5');
    pan12=(d18_12 eq '5');
    pan13=(d18_13 eq '5');
    pansx2=sum(of pan1-pan13);
    panatt2=(pansx2 ge 4 and d20 eq '5' and d17 eq '5');

**Panic Disorder Algorithm**;
panic=((panatt2 eq 1) and (d23 eq '5') and (d24 eq '5' or d24_a eq '5' or d24_b eq '5') and
       (d28 eq '5' or d28_c eq '5' or d28_d eq '5' or d28_e eq '5' or d28_f eq '5') and not
       (d25_a eq '5' or d25_c eq '5'));
end;

proc sort;
  by xfamno xidno;




************END OF CREATING VARIABLES/DIAGNOSES AT WAVE 4***********;



*------------*;
****WAVE 5****;
*------------*;

DATA w5_t1;
  set wave5.st1wv5i;

xfamno=1*famno;
xidno=1*idno;

if xidno=1;

if b3 in ('99','MM','RR') then w5mlths_1=.;
  else if b3 in ('HS','12','13','14','15','16','17','CO','GR') then w5mlths_1=0;
  else w5mlths_1=1;

if b3_a in ('99','MM','RR') then w5dlths_1=.;
  else if b3_a in ('HS','12','13','14','15','16','17','CO','GR') then w5dlths_1=0;
  else w5dlths_1=1;

if b3 in ('99','MM','RR') then w5medu_1=.;
  else if b3 in ('HS','12') then w5medu_1=1;
  else if b3 in ('13','14','15','16','17','CO','GR') then w5medu_1=2;
  else w5medu_1=0;

if b3_a in ('99','MM','RR') then w5dedu_1=.;
  else if b3_a in ('HS','12') then w5dedu_1=1;
  else if b3_a in ('13','14','15','16','17','CO','GR') then w5dedu_1=2;
  else w5dedu_1=0;


keep xfamno xidno w5mlths_1 w5dlths_1 w5dedu_1 w5medu_1;

proc sort;
  by xfamno xidno;
run;


DATA w5_t2;
  set wave5.st1wv5i;

xfamno=1*famno;
xidno=1*idno;

if xidno=2;

if b3 in ('99','MM','RR') then w5mlths_2=.;
  else if b3 in ('HS','12','13','14','15','16','17','CO','GR') then w5mlths_2=0;
  else w5mlths_2=1;

if b3_a in ('99','MM','RR') then w5dlths_2=.;
  else if b3_a in ('HS','12','13','14','15','16','17','CO','GR') then w5dlths_2=0;
  else w5dlths_2=1;

if b3 in ('99','MM','RR') then w5medu_2=.;
  else if b3 in ('HS','12') then w5medu_2=1;
  else if b3 in ('13','14','15','16','17','CO','GR') then w5medu_2=2;
  else w5medu_2=0;

if b3_a in ('99','MM','RR') then w5dedu_2=.;
  else if b3_a in ('HS','12') then w5dedu_2=1;
  else if b3_a in ('13','14','15','16','17','CO','GR') then w5dedu_2=2;
  else w5dedu_2=0;

keep xfamno xidno w5mlths_2 w5dlths_2 w5medu_2 w5dedu_2;

proc sort;
  by xfamno xidno;
run;



DATA w5;
  merge w5_t1 w5_t2;
  by xfamno;


if w5mlths_1=0 or w5mlths_2=0 then w5mlths=0;
  else if w5mlths_1=1 or w5mlths_2=1 then w5mlths=1;
label w5mlths='Wave 5 twin report - mom < high school edu';

if w5dlths_1=0 or w5dlths_2=0 then w5dlths=0;
  else if w5dlths_1=1 or w5dlths_2=1 then w5dlths=1;
label w5mlths='Wave 5 twin report - dad < high school edu';

if w5medu_1=2 or w5medu_2=2 then w5medu=2;
  else if w5medu_1=1 or w5medu_2=1 then w5medu=1;
  else if w5medu_1=0 or w5medu_2=0 then w5medu=0;
label w5medu='Wave 5 twin report - mom edu < HS, HS, >HS';

if w5dedu_1=2 or w5dedu_2=2 then w5dedu=2;
  else if w5dedu_1=1 or w5dedu_2=1 then w5dedu=1;
  else if w5dedu_1=0 or w5dedu_2=0 then w5dedu=0;
label w5dedu='Wave 5 twin report - dad edu < HS, HS, >HS';


keep xfamno w5mlths w5dlths w5medu w5dedu;


****mom data;
DATA biomom;
  set parent.new_parent;

if famno not in ('D79356') then do;
xfamno=famno*1;
end;

xidno=1*idno;


if xidno=3;

biomom=1;


** education;

if n3 in ('R', 'M')  then momedsr=.;
  else if n3 = '17+' then momedsr=17;
  else momedsr=1*n3;
label momedsr='mom self-reported years of education';

if n4_dad in ('DK','R','M','99','099') then dadedmr=.;
  else if n4_dad = '17+' then dadedmr=17;
  else dadedmr=1*n4_dad;
label dadedmr = 'mom report of dad years of education';


* less than high school;

if momedsr ne ' ' then do;
if 0 le momedsr le 11 then momlthssr=1;
  else momlthssr=0;
end;
label momlthssr='mom self-reported <12 years of education';

if dadedmr ne ' ' then do;
if 0 le dadedmr le 11 then dadlthsmr=1;
  else dadlthsmr=0;
end;
label dadlthsmr='mom report of dad <12 years of education';


if momedsr ge 13 then momed3sr=2;
  else if momedsr=12 then momed3sr=1;
  else if 0 le momedsr le 11 then momed3sr=0;
label momed3sr='mom self-report: <HS, HS, >HS';

if dadedmr ge 13 then daded3mr=2;
  else if dadedmr=12 then daded3mr=1;
  else if 0 le dadedmr le 11 then daded3mr=0;
label daded3mr='mom report of dad:  <HS, HS, >HS';


keep xfamno biomom momlthssr dadlthsmr momed3sr daded3mr;

proc sort;
  by xfamno;
run;


DATA biodad;
set parent.new_parent;

if famno not in ('D79356') then do;
xfamno=famno*1;
end;

xidno=1*idno;


if xidno=4;
biodad=1;


** education;

if n3 in ('R', 'M')  then dadedsr=.;
  else if n3 = '17+' then dadedsr=17;
  else dadedsr=1*n3;
label dadedsr='dad self-reported years of education';

if n4_mom in ('DK','R','M','99','099') then momeddr=.;
  else if n4_mom = '17+' then momeddr=17;
  else momeddr=1*n4_mom;
label momeddr = 'dad report of mom years of education';


** less than high school;

if dadedsr ne ' ' then do;
if 0 le dadedsr le 11 then dadlthssr=1;
  else dadlthssr=0;
end;
label dadlthssr='dad self-reported <12 years of education';

if momeddr ne ' ' then do;
if 0 le momeddr le 11 then momlthsdr=1;
  else momlthsdr=0;
end;
label momlthsdr='dad report of mom <12 years of education';

if dadedsr ge 13 then daded3sr=2;
  else if dadedsr=12 then daded3sr=1;
  else if 0 le dadedsr le 11 then daded3sr=0;
label daded3sr='dad self-report: <HS, HS, >HS';

if momeddr ge 13 then momed3dr=2;
  else if momeddr=12 then momed3dr=1;
  else if 0 le momeddr le 11 then momed3dr=0;
label momed3dr='dad report of mom: <HS, HS, >HS';


keep xfamno biodad dadlthssr momlthsdr daded3sr momed3dr;

proc sort;
  by xfamno;
run;


DATA paredu;
merge biomom biodad;
  by xfamno;

if momlthssr ne . then pmomlths=momlthssr;
  else pmomlths=momlthsdr;
label pmomlths='Mom < HS education - parent interview';

if dadlthssr ne . then pdadlths=dadlthssr;
  else pdadlths=dadlthsmr;
label pdadlths='Dad < HS education - parent interview';

if momed3sr ne . then pmomedu=momed3sr;
  else pmomedu=momed3dr;
label pmomedu='Mom <HS, HS, >HS - parent interview';

if daded3sr ne . then pdadedu=daded3sr;
  else pdadedu=daded3mr;
label pdadedu='Dad <HS, HS, >HS - parent interview';

keep xfamno pmomlths pdadlths pmomedu pdadedu;

proc sort;
   by xfamno;
run;


DATA alledu;
  merge paredu w5;
  by xfamno;

if pmomlths ne . then momlths=pmomlths;
  else momlths=w5mlths;
label momlths='Mom < HS education';

if pdadlths ne . then dadlths=pdadlths;
  else dadlths=w5dlths;
label dadlths='Dad < HS education';


if pmomedu ne . then momedu=pmomedu;
  else momedu=w5medu;
label momedu='Mom  <HS, HS, >HS';

if pdadedu ne . then dadedu=pdadedu;
  else dadedu=w5dedu;
label dadedu='Dad < HS education';


keep xfamno momlths dadlths momedu dadedu;

proc sort;
  by xfamno;
run;


DATA w4edu;
  merge w4all alledu;
  by xfamno;

if wave4=1;

if momedu=. then momedumiss=1;
  else momedumiss=0;

if dadedu=. then dadedumiss=1;
  else dadedumiss=0;

if dadedu=. then do;
dadlths=0;
end;

if momedu=. then do;
momlths=0;
end;

if momedumiss=1 then momlths3=2;
  else if momlths=1 then momlths3=1;
  else momlths3=0;
label momlths3='Mom < HS: 2=missing 1=<HS 0=>HS';

if dadedumiss=1 then dadlths3=2;
  else if dadlths=1 then dadlths3=1;
  else dadlths3=0;
label dadlths3='Dad < HS: 2=missing 1=<HS 0=>HS';


proc sort;
  by xfamno;
run;

/*
*------------------------------*;
****GETTING DESCRIPTIVE INFO****;
*------------------------------*;

proc univariate;
  var age;
run;

proc freq;
  tables alcabdp newnicdep cig100 / binomial (level=2);
run;

proc freq;
  tables aud_nd aud_cig100;
run;

proc freq;
  tables lanorex4 bn4 bed lpurgedx / binomial (level=2);
run;

proc freq;
  tables mdd socphobia panic conductfup mjabdp;
run;

proc sort;
  by black;
run;

proc univariate;
  var age;
  by black;
run;

proc freq;
  tables alcabdp newnicdep cig100 / binomial (level=2);
  by black;
run;

proc freq;
  tables aud_nd aud_cig100;
  by black;
run;

proc freq;
  tables lanorex4 bn4 bed lpurgedx / binomial (level=2);
  by black;
run;

proc freq;
  tables mdd socphobia panic conductfup mjabdp;
  by black;
run;
**endsas;


proc sort;
  by xfamno xidno;
run;
*/

*-----------------------*;
****CREATING DATASETS****;
*-----------------------*;

*------------------------------------------------------------------------------------------------------------------*;

****Creating a 'Best Age at Menarche' Variable, which takes into account Wave 1, Wave 3, and Wave 4 Data (09.12.12)**;

DATA bestmenarche;
  merge w1w2w3 w4edu;
  by xfamno xidno;
  drop pers1;

if wave4=1;
/*
if xidno eq 1 or xidno eq 2;
if bestzyg ne .;

*Deleting this family because there is one twin1 and two twin2 (03.06.13)*;
if xfamno eq 790558 then delete;

*/


**We want to use Wave 1 data if available, then Wave 3, and Wave 4 for anyone who doesn't have data at Waves 1 or 3;

if blagemenarche ne . then best_aam=blagemenarche;
  else if blagemenarche eq . and w3agemenarche ne . then best_aam=w3agemenarche;
  else if blagemenarche eq . and w3agemenarche eq . then best_aam=agemenarche;
label best_aam='Age at Menarche- Best estimate from Waves 1, 3, and 4';

if lblagemenarche ne . then best_laam=lblagemenarche;
  else if lblagemenarche eq . and lw3agemenarche ne . then best_laam=lw3agemenarche;
  else if lblagemenarche eq . and lw3agemenarche eq . then best_laam=lagemenarche;
label best_laam='Log of Age at Menarche- Best estimate from Waves 1, 3, and 4';

if blearlymenarche ne . then best_earlymen=blearlymenarche;
  else if blearlymenarche eq . and w3earlymenarche ne . then best_earlymen=w3earlymenarche;
  else if blearlymenarche eq . and w3earlymenarche eq . then best_earlymen=earlymenarche;
label best_earlymen='Early Menarche (before age 12)- Best estimate from Waves 1, 3, and 4';

/*
proc freq;
  tables blagemenarche w3agemenarche agemenarche best_aam / list missprint;
run;

proc freq;
  tables lblagemenarche lw3agemenarche lagemenarche best_laam / list missprint;
run;

proc freq;
  tables blearlymenarche w3earlymenarche earlymenarche best_earlymen / list missprint;
run;

proc print data=bestmenarche (firstobs = 1 obs = 100);
  var blagemenarche w3agemenarche agemenarche best_aam;
run;

proc print data=bestmenarche (firstobs = 1 obs = 100);
  var lblagemenarche lw3agemenarche lagemenarche best_laam;
run;

proc print data=bestmenarche (firstobs = 1 obs = 100);
  var blearlymenarche w3earlymenarche earlymenarche best_earlymen;
run;
*/



proc sort;
  by xfamno xidno;
run;


data ffm;
set andrew.new_st1fupq;
 xfamno = 1*famno;
 xidno=1*idno ;
ffmin=1;     
        array cx (iax) pers_1-pers_50 mper_1-mper_34;
        array dx (iax) pers1-pers84 ;

        do over cx;
        if cx='M' then cx='';
        if cx='M' then dx=.;

        dx=1*(cx-1); 
        end;

*****FFI factors*****;    


neo_n=((4-pers1)+pers6+pers11+(4-pers16)+pers21+pers27+(4-pers35)+pers44+pers52+(4-pers62)+pers71+pers78)/12 ;
neo_e=(pers2+pers7+(4-pers12)+pers17+pers22+(4-pers29)+pers37+pers46+(4-pers54)+pers64+pers72+(4-pers80))/12 ;
neo_o=((4-pers3)+(4-pers8)+pers13+(4-pers18)+(4-pers23)+pers31+(4-pers39)+(4-pers48)+pers56+(4-pers66)+pers74+pers81)/12;
neo_a=(pers4+(4-pers9)+(4-pers14)+pers19+(4-pers24)+(4-pers32)+pers40+(4-pers49)+(4-pers58)+pers67+(4-pers75)+(4-pers82))/12;
neo_c=(pers5+pers10+(4-pers15)+pers20+pers25+(4-pers33)+pers42+pers50+(4-pers60)+pers69+(4-pers76)+pers84)/12;

data final;
merge bestmenarche ffm;
by xfamno xidno;
proc sort; by xfamno xidno;

****Making the STATA Data Set (01.22.15)****;
**Analyses to be redone on 08.19.15**;
**Analyses to be redone again on 03.18.16**;

DATA edaudnd_epi3 (keep=xfamno xidno wave4 bestzyg black age agequart age1 age2 age3 age4
                  geo_rural rural urban rural_dum rural_mis geo_familydisruption geo_loweducation geo_lowincome geo_poverty
                  rlship workfull inschool married livathome manyfr noclosefr workany 
                  momlths momedumiss momlths3 dadlths dadedumiss dadlths3
                  best_earlymen best_aam
                  bmi bmi_cat4 bmiquint bmiquint0 bmiquint1 bmiquint2 bmiquint3 bmiquint4
                  obese1 obese2 obese3 underwgt overwgt obese morbid obesemor 
                  smk4 cig100 f3_a c100_evsmk frsmk agesmk_ agsmkdaily_ agenicdep_
                  smkev smkreg smkdaily cursmk6 cursmk3 quit3 quit6
                  agequit3 agequit6 agequit3_ agequit6_ nd2 nicdepqdy agesmk 
                  agsmkdaily agenicdep newsmkreg newquit3 newnicdep tolerance
                  chainsmk activ intend diffcess withdraw problems
                  alcuse agealc intox ageintox alcdepiv alcabuse alcsx alcsx5 alcabdp
                  drink6 maxdrk regdrk regdrk_ao alcbinge12 weekdrk12
                  twdrkprob momdrkprob daddrkprob pardrkprob
                  aud_nd cand3 cand2 cand1 cand0 aud_cig100 can3 can2 can1 can0
                  mjuse mjweek agemjuse mjabuse mjdep mjabdp
                  cocuse agecocuse
                  stimuse agestuse stcocuse agstcocuse
                  harddruguse harddrugweek hdrugabuse hdrugdep
                  socphobia anyaspdsx panic
                  conductfup
                  physabuse csanew csaons neglect
                  trauma_1 trauma_2 trauma_3 fsttrauma sndtrauma trdtrauma trauma4l
                  sexvic ageadsexvic adultfs adultrape adultmol adultsexvic
                  attack threat witness accident natdis attack16 threat16 witness16 accident16 natdis16
                  anorex4 lanorex4 anorex4_x lanorex4_x bn4 bn4l purgedx lpurgedx bed
                  lose5 lose10 disturb amenor_l amenor_s concern fatfear binge binge3l bingeloc lfreqbin lfbinons binons curbinge comp comp4 purge nonpurge purgeonly purgeons
                  vomit vomit4 lax lax4 diuretics diuretics4 diet diet4 fast fast4 exercise exercise4
                  mdd anhedonia dysphoria irritable mddpass1 majdepiv depA depB neo_n neo_e neo_a neo_a neo_c);

  set final;
  by xfamno xidno;

if wave4=1;


%sas2sta(edaudnd_epi3);
run;
endsas;

