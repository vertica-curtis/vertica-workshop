
CREATE TABLE if not exists precip_description (
  precip_descrip_id char(1)
 ,precip_description varchar(300) ) ;

truncate table precip_description ;

insert into precip_description values ('A', '1 report of 6-hour precipitation amount.');
insert into precip_description values ('B', 'Summation of 2 reports of 6-hour precipitation amount.');
insert into precip_description values ('C', 'Summation of 3 reports of 6-hour precipitation amount.');
insert into precip_description values ('D', 'Summation of 4 reports of 6-hour precipitation amount.');
insert into precip_description values ('E', '1 report of 12-hour precipitation amount.');
insert into precip_description values ('F', 'Summation of 2 reports of 12-hour precipitation amount.');
insert into precip_description values ('G', '1 report of 24-hour precipitation amount.');
insert into precip_description values ('H', 'Station reported ''0'' as the amount for the day (eg, from 6-hour reports), but also reported at least one occurrence of precipitation in hourly observations--this could indicate a trace occurred, but should be considered  as incomplete data for the day.');
insert into precip_description values ('I', 'Station did not report any precip data for the day and did not report any occurrences of precipitation in its hourly observations--it''s still possible that precip occurred but was not reported.');
commit ;


CREATE TABLE if not exists public.weather_station_raw
(
    station_nbr int,
    wban_nbr int,
    station_name varchar(30),
    country_cd char(2),
    state_province_cd char(2),
    icao_id char(4),
    lat float,
    long float,
    elevation_mtr float,
    begin_dt date,
    end_dt date) ;

truncate table weather_station_raw ;

\set t_pwd `pwd`

\set input_file '''':t_pwd'/isd-history2.txt'''
--copy weather_station_raw from 's3://verticaworkshop/rawdata/isd-history.txt' fixedwidth colsizes(7,6,30,5,3,6,8,9,8,9,8) trim ' ' ;

ALTER SESSION SET AWSRegion='us-west-1';
--copy weather_station_raw from 's3://verticaworkshopwest1/rawdata/isd-history2.txt' fixedwidth colsizes(7,6,30,5,3,6,8,9,8,9,8) trim ' ' ;
copy weather_station_raw from :input_file fixedwidth colsizes(7,6,30,5,3,6,8,9,8,9,8) trim ' ' ;


CREATE TABLE if not exists state_province_codes (
state_province_cd char(2)
,state_name varchar(100) ) ;

truncate table state_province_codes ;
--copy state_province_codes from 's3://verticaworkshopwest1/rawdata/state_codes.txt' delimiter ',' ;
\set input_file '''':t_pwd'/state_codes.txt'''
copy state_province_codes from :input_file delimiter ',' ;


CREATE TABLE if not exists country_codes (
country_cd char(2)
,country_description varchar(100) ) ;

truncate table country_codes ;

--copy country_codes from 'country-list.txt' fixedwidth colsizes(12,80) trim ' ' ;
\set input_file '''':t_pwd'/country-list.txt'''
copy country_codes from :input_file fixedwidth colsizes(12,80) trim ' ' ;



CREATE TABLE if not exists public.weather_fact_raw
(
    station_nbr int,
    wban_nbr int,
    reporting_date date,
    mean_temperature_f float,
    num_temp_obsrvtns int,
    mean_dewpoint float,
    num_dewpoint_obsrvtns int,
    mean_sea_level_pressure float,
    num_slp_obsrvtns int,
    mean_station_pressure float,
    num_stp_obsrvtns int,
    mean_visibility_miles float,
    num_visib_obsrvtns int,
    mean_wind_speed_knots float,
    num_wdsp_obsrvtns int,
    max_wind_speed_knots float,
    max_gust_speed_knots float,
    max_temperature_f float,
    derived_max_temp_flag char(1),
    min_temperature_f float,
    derived_min_temp_flag char(1),
    total_precipitation_inches float,
    precip_descrip_id char(1),
    snow_depth_inches float,
    fog_flag boolean,
    rain_drizzle_flag boolean,
    snow_ice_flag boolean,
    hail_flag boolean,
    thunder_flag boolean,
    tornado_or_funnel_flag boolean) ;

truncate table weather_fact_raw ;

--loading just 2020 weather data
copy weather_fact_raw from 's3://verticaworkshopwest1/rawdata/weather_fact_raw_2020.txt' delimiter '|' ;
 --3.6 seconds


CREATE OR REPLACE VIEW weather_station AS
SELECT 
station_nbr 
,wban_nbr
,station_name 
,country_cd
,state_province_cd as state_province_cd
,lat/1000 as lat
,long/1000 as long
,elevation_mtr
,elevation_mtr*3.28084 as elevation_ft
from weather_station_raw ;

CREATE OR REPLACE VIEW weather_fact
AS
select 
station_nbr
,nullif(wban_nbr, 99999) as wban_nbr
,reporting_date
,mean_temperature_f
,num_temp_obsrvtns
,mean_dewpoint
,num_dewpoint_obsrvtns
,nullif(mean_sea_level_pressure, 9999.9)  as mean_sea_level_pressure
,num_slp_obsrvtns  as slp_count
,nullif(mean_station_pressure, 9999.9) as mean_station_pressure
,num_stp_obsrvtns  as num_stp_obsrvtns
,nullif(mean_visibility_miles, 999.9)  as mean_visibility_miles
,num_visib_obsrvtns  as num_visib_obsrvtns
,nullif(mean_wind_speed_knots, 999.9)  as mean_wind_speed_knots
,num_wdsp_obsrvtns
,nullif(max_wind_speed_knots, 999.9)  as max_wind_speed_knots
,nullif(max_gust_speed_knots, 999.9)  as max_gust_speed_knots
,max_temperature_f
,derived_max_temp_flag
,min_temperature_f
,derived_min_temp_flag
,total_precipitation_inches
,precip_descrip_id
,nullif(snow_depth_inches, 999.9)  as snow_depth_inches
,fog_flag
,rain_drizzle_flag
,snow_ice_flag
,hail_flag
,thunder_flag
,tornado_or_funnel_flag
from weather_fact_raw ;


--copy weather_fact_raw from 's3://verticaworkshopwest1/rawdata/weather_fact_raw_2010_to_2019.txt' delimiter '|' ;
--copy weather_fact_raw from 's3://verticaworkshopwest1/rawdata/weather_fact_raw_2000_to_2009.txt' delimiter '|' ;
--copy weather_fact_raw from 's3://verticaworkshopwest1/rawdata/weather_fact_raw_1990_to_1999.txt' delimiter '|' ;
--copy weather_fact_raw from 's3://verticaworkshopwest1/rawdata/weather_fact_raw_1980_to_1989.txt' delimiter '|' ;
--copy weather_fact_raw from 's3://verticaworkshopwest1/rawdata/weather_fact_raw_1970_to_1979.txt' delimiter '|' ;
--copy weather_fact_raw from 's3://verticaworkshopwest1/rawdata/weather_fact_raw_1955_to_1969.txt' delimiter '|' ;
--copy weather_fact_raw from 's3://verticaworkshopwest1/rawdata/weather_fact_raw_1929_to_1954.txt' delimiter '|' ;
--takes around 2-2.5 minutes to load all of it


