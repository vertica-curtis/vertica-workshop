drop table if exists weather_fact_raw_flat ;
CREATE TABLE public.weather_fact_raw_flat
(
    station_nbr int,
    wban_nbr int,
    station_name varchar(30) DEFAULT (select station_name FROM weather_station_raw WHERE (weather_fact_raw_flat.station_nbr = weather_station_raw.station_nbr) and weather_fact_raw_flat.wban_nbr = weather_station_raw.wban_nbr),
    country_cd char(2) DEFAULT (select country_cd FROM weather_station_raw WHERE (weather_fact_raw_flat.station_nbr) = weather_station_raw.station_nbr and weather_fact_raw_flat.wban_nbr = weather_station_raw.wban_nbr),
    state_province_cd char(2) DEFAULT (select state_province_cd FROM weather_station_raw WHERE (weather_fact_raw_flat.station_nbr = weather_station_raw.station_nbr) and weather_fact_raw_flat.wban_nbr = weather_station_raw.wban_nbr),
    icao_id char(4) DEFAULT (select icao_id FROM weather_station_raw WHERE (weather_fact_raw_flat.station_nbr) = weather_station_raw.station_nbr and weather_fact_raw_flat.wban_nbr = weather_station_raw.wban_nbr),
    lat float DEFAULT (select lat FROM weather_station_raw WHERE (weather_fact_raw_flat.station_nbr) = weather_station_raw.station_nbr and weather_fact_raw_flat.wban_nbr = weather_station_raw.wban_nbr),
    long float DEFAULT (select long FROM weather_station_raw WHERE (weather_fact_raw_flat.station_nbr) = weather_station_raw.station_nbr and weather_fact_raw_flat.wban_nbr = weather_station_raw.wban_nbr),
    elevation_mtr float DEFAULT (select elevation_mtr FROM weather_station_raw WHERE (weather_fact_raw_flat.station_nbr) = weather_station_raw.station_nbr and weather_fact_raw_flat.wban_nbr = weather_station_raw.wban_nbr),
    begin_dt date DEFAULT (select begin_dt FROM weather_station_raw WHERE (weather_fact_raw_flat.station_nbr) = weather_station_raw.station_nbr and weather_fact_raw_flat.wban_nbr = weather_station_raw.wban_nbr),
    end_dt date DEFAULT (select end_dt FROM weather_station_raw WHERE (weather_fact_raw_flat.station_nbr) = weather_station_raw.station_nbr and weather_fact_raw_flat.wban_nbr = weather_station_raw.wban_nbr),
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
    precip_description varchar(300) DEFAULT (select precip_description FROM precip_description WHERE (weather_fact_raw_flat.precip_descrip_id = precip_description.precip_description)),
    snow_depth_inches float,
    fog_flag boolean,
    rain_drizzle_flag boolean,
    snow_ice_flag boolean,
    hail_flag boolean,
    thunder_flag boolean,
    tornado_or_funnel_flag boolean
)
segmented by hash(station_nbr, wban_nbr) all nodes ksafe 1 ;


insert into weather_fact_raw_flat
( station_nbr ,wban_nbr ,reporting_date ,mean_temperature_f ,num_temp_obsrvtns ,mean_dewpoint ,num_dewpoint_obsrvtns ,mean_sea_level_pressure ,num_slp_obsrvtns ,mean_station_pressure ,num_stp_obsrvtns ,mean_visibility_miles ,num_visib_obsrvtns ,mean_wind_speed_knots ,num_wdsp_obsrvtns ,max_wind_speed_knots ,max_gust_speed_knots ,max_temperature_f ,derived_max_temp_flag ,min_temperature_f ,derived_min_temp_flag ,total_precipitation_inches ,precip_descrip_id ,snow_depth_inches ,fog_flag ,rain_drizzle_flag ,snow_ice_flag ,hail_flag ,thunder_flag ,tornado_or_funnel_flag)

select  station_nbr ,wban_nbr ,reporting_date ,mean_temperature_f ,num_temp_obsrvtns ,mean_dewpoint ,num_dewpoint_obsrvtns ,mean_sea_level_pressure
,num_slp_obsrvtns ,mean_station_pressure ,num_stp_obsrvtns ,mean_visibility_miles ,num_visib_obsrvtns ,mean_wind_speed_knots ,num_wdsp_obsrvtns
,max_wind_speed_knots ,max_gust_speed_knots ,max_temperature_f ,derived_max_temp_flag ,min_temperature_f ,derived_min_temp_flag ,total_precipitation_inches
,precip_descrip_id ,snow_depth_inches ,fog_flag ,rain_drizzle_flag ,snow_ice_flag ,hail_flag ,thunder_flag ,tornado_or_funnel_flag
from weather_fact_raw;

commit ;