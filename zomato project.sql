#Create "Zomato" database
DROP database IF EXISTS zomato;
create database zomato;
use zomato;

#Create "sheet1" table
DROP TABLE IF EXISTS sheet1;
create table sheet1 (restaurantid int,restaurantname varchar(255),country_code varchar(10),city varchar(255),address varchar(255),Locality varchar(255) 
,LocalityVerbose varchar(250) ,Longitude float ,Latitude float ,Cuisines varchar(255) ,Currency varchar(255) ,Has_Table_booking varchar(255) 
,Has_Online_delivery varchar(255) ,Is_delivering_now varchar(255) ,Switch_to_order_menu varchar(255) ,Price_range varchar(255), Votes varchar(255) 
,Average_Cost_for_two varchar(255) ,Rating varchar(255) ,Datekey_Opening varchar(255));
 
 #load data into sheet1
 load data infile 'D:\\Data anlyst course\\Excler Project\\Zomato analys\\zomato.csv'
into table sheet1
fields terminated by ','
ignore 1 lines;

#Create "sheet2" table
DROP TABLE IF EXISTS sheet2;
create table sheet2 (countryid int,country_name varchar(50), primary key(countryid));

alter table sheet1 modify column restaurantid int primary key;
alter table sheet1 add constraint fk foreign key sheet1(country_code) references sheet2(countryid);
alter table sheet1 modify column country_code int;

#insert value into "sheet2"
insert into sheet2 values (	1	, '	India	 ');
insert into sheet2 values (	14	, '	Australia	 ');
insert into sheet2 values (	30	 ,'	Brazil	 ');
insert into sheet2 values (	37	 ,'	Canada	 ');
insert into sheet2 values (	94	, '	Indonesia	 ');
insert into sheet2 values (	148	 ,'	New Zealand	 ');
insert into sheet2 values (	162	 ,'	Philippines	 ');
insert into sheet2 values (	166	 ,'	Qatar	 ');
insert into sheet2 values (	184	 ,'	Singapore	 ');
insert into sheet2 values (	189	 ,'	South Africa	 ');
insert into sheet2 values (	191	, '	Sri Lanka	 ');
insert into sheet2 values (	208	, '	Turkey	 ');
insert into sheet2 values (	214	 ,'	United Arab Emirates	 ');
insert into sheet2 values (	215	 ,'	United Kingdom	 ');
insert into sheet2 values (	216	, '	United States of America	 ');
select * from sheet1;

#add "USD_convert" column in sheet1
alter table sheet1 add column USD_convert double not null after average_cost_for_two;

#add "buck_avg_cost" column in sheet1
alter table sheet1 add column buck_avg_cost varchar (25) after USD_convert;

#add "buck_Rating" column in sheet1
alter table sheet1 add column buck_Rating varchar (25) after Rating;

#update "USD_convert" column
update sheet1 set USD_convert = 
if(country_code = 1, round(average_cost_for_two/82.72,2),
if(country_code = 14, round(average_cost_for_two/1.48,2),
if(country_code = 30, round(average_cost_for_two/4.93,2),
if(country_code = 37, round(average_cost_for_two/1.33,2),
if(country_code = 94, round(average_cost_for_two/14711.6,2),
if(country_code = 148, round(average_cost_for_two/1.59,2),
if(country_code = 162,round(average_cost_for_two/13.24,2),
if(country_code = 166, round(average_cost_for_two/3.64,2),
if(country_code = 184, round(average_cost_for_two/1.32,2),
if(country_code = 189, round(average_cost_for_two/18.09,2),
if(country_code = 191, round(average_cost_for_two/332.98,2),
if(country_code = 208, round(average_cost_for_two/19.38,2),
if(country_code = 214, round(average_cost_for_two/3.67,2),
if(country_code = 215, round(average_cost_for_two/0.8,2), average_cost_for_two))))))))))))));
rollback;

#update "buck_avg_cost" column
update sheet1
set buck_avg_cost =
case
when USD_convert >= 0 and USD_convert < 100 then '0-100'
when USD_convert >= 100 and USD_convert < 200 then '100-200'
when USD_convert >= 200 and USD_convert < 300 then '200-300'
when USD_convert >= 300 and USD_convert < 400 then '300-400'
else '400-500'
end;

update sheet1
set buck_Rating =
case
when Rating >= 0 and Rating < 1 then '0-1'
when Rating >= 1 and Rating < 2 then '1-2'
when Rating >= 2 and Rating < 3 then '2-3'
when Rating>= 3 and Rating < 4 then '3-4'
else '4-5'
end;


select * from sheet2;

select count(restaurantid) from sheet1;

#1. create "curreny map" table
CREATE TABLE COUNTRIES (COUNTRY_CODE INT, COUNTRY_NAME VARCHAR (100), CURRENCY VARCHAR(100), INR decimal(15,4), USD decimal(15,4));
insert into countries values 
(1,"India","Indian Rupees(Rs.)",1,0.012),
(14,"Australia","Dollar($)",0.018,1.48),
(30,"BrazilBrazilian","Real(R$)",0.06,4.93),
(37,"Canada","Dollar($)",0.016,1.33),
(94,"Indonesia","IndonesianRupiah(IDR)",180,14711.6),
(148,"New Zealand","NewZealand($)",0.019,1.59),
(162,"Philippines","Botswana Pula(P)",0.16,13.24),
(166,"Qatar","Qatari Rial(QR)",0.045,3.64),
(184,"Singapore","Dollar($)",0.016,1.32),
(189,"South Africa","Rand(R)",0.22,18.09),
(191,"Srilanka","Sri Lankan Rupee(LKR)",3.96,322.98),
(208,"Turkey","Turkish Lira(TL)",0.24,19.38),
(214,"United Arab Emirates","Emirati Diram(AED)",0.045,3.67),
(215,"United Kingdom","Pounds(Œ£)",0.0098,0.8),
(216,"United States","Dollar($)",0.012,1);
SELECT * FROM COUNTRIES;

#create "calender atble"
drop table if exists Calendar_Table;
create table Calendar_Table (Datekey_Opening varchar (12), year int (4), month_no int (2), month__name varchar (20), querter varchar(2), yearmonth varchar(10), Weekdayno int (2), weekday_name varchar (10), FinancialMOnth varchar (4), Financial_Quarter varchar (3));
select * from Calendar_Table;

insert into Calendar_Table (Datekey_Opening) select Datekey_Opening from sheet1;
select count(Datekey_Opening) from Calendar_Table;

#2. Build a Calendar Table using the Column Datekey Add all the below Columns in the Calendar Table using the Formulas
select * from Calendar_Table;
update Calendar_Table set year=year(Datekey_Opening);
update Calendar_Table set month_no=month(Datekey_Opening);
update Calendar_Table set month__name=monthname(Datekey_Opening);
update Calendar_Table set querter=quarter(Datekey_Opening);
update Calendar_Table set yearmonth=concat(left(Datekey_Opening,6),left(month__name,3));
update Calendar_Table set Weekdayno= weekday(Datekey_Opening);
update Calendar_Table set weekday_name= DAYNAME(Datekey_Opening);
update Calendar_Table set FinancialMOnth=concat("fm",IF(MONTH(Datekey_Opening)>=4,MONTH(Datekey_Opening)-3,MONTH(Datekey_Opening)+9));
update Calendar_Table set Financial_Quarter=concat("fq",if(quarter(Datekey_Opening)=1,quarter(Datekey_Opening)+3,quarter(Datekey_Opening)-1));
select * from Calendar_Table;

#3.Find the Numbers of Resturants based on City and Country.
select city,  count(restaurantid) from sheet1 group by city;
select count(sheet1.restaurantid),sheet1.country_code, sheet2.country_name from sheet1 join sheet2 on sheet1.country_code=sheet2.countryid group by sheet1.country_code; 

#4.Numbers of Resturants opening based on Year , Quarter , Month
select count(restaurantid), year(Datekey_Opening) from sheet1 group by year(Datekey_Opening)
order by year(Datekey_Opening) asc;
select count(restaurantid), quarter(Datekey_Opening) from sheet1 group by quarter(Datekey_Opening)
order by quarter(Datekey_Opening);
select count(restaurantid), monthname(Datekey_Opening) from sheet1 group by month(Datekey_Opening)
order by month((Datekey_Opening));

#5. Count of Resturants based on Average Ratings
select count(restaurantid), avg(rating),buck_rating from sheet1 group by buck_rating
order by avg(rating);

#6. Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets
select count(restaurantid), buck_avg_cost from sheet1 group by buck_avg_cost;

#7.Percentage of Resturants based on "Has_Table_booking"
select (select count(restaurantid) from sheet1 where Has_Table_booking='	Yes	 ')*100/count(restaurantid) as "Percentage of Resturants Has Table booking" from sheet1;

#9.Percentage of Resturants based on "Has_Online_delivery"
select (select count(restaurantid) from sheet1 where Has_Online_delivery='	Yes	 ')*100/count(restaurantid) as "Percentage of Resturants Has Online delivery" from sheet1;

