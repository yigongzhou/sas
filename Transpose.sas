data ss;
input id test $ values;
cards;
1001 height 2
1001 weight 3
1002 height 4
1002 weight 3
;
run;
data ss;
set ss;

if test = "weight"
	then weight = values;

if test = "height"
	then height = values;

run;

proc sql;
create table newss as
select id, sum(weight) as w, sum(height) as h, sum(weight)/(sum(height)*sum(height)) as BMI from ss
group by id;
quit;

proc transpose data=ss out=trans;
var values;
id test;
by id;
run;
