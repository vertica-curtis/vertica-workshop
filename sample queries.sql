

--top 10 hottest places, on average
WITH top_average AS (select distinct wf.station_nbr, wf.wban_nbr
                          , avg(mean_temperature_f) as average_temp, max(mean_temperature_f) as max_temp
                       from weather_fact wf
                      where wf.mean_temperature_f is not null
                      group by 1,2 order by 3 desc
                      limit 20 )
select ta.average_temp, ta.max_temp, ws.station_name, cc.country_description, ws.state_province_cd
  from top_average ta
  join weather_station ws on ta.station_nbr = ws.station_nbr
  join country_codes cc on ws.country_cd = cc.country_cd
order by 1 desc
limit 10 ;
--419ms

--coldest areas
WITH top_average AS (select distinct wf.station_nbr, wf.wban_nbr
                          , avg(mean_temperature_f) as average_temp, min(mean_temperature_f) as min_temp
                       from weather_fact wf
                      where wf.mean_temperature_f is not null
                      group by 1,2
                      order by 3 asc
                      limit 10 )
select distinct cc.country_description, ws.station_name, ta.average_temp
             , min_temp as coldest_temp
  from top_average ta
  join weather_station ws on ta.station_nbr = ws.station_nbr
  join country_codes cc on ws.country_cd = cc.country_cd
 order by 1 asc ;
--449ms


--locations with the most temperature variation - largest margin between extremes

--really slow
select distinct cc.country_description, wf.station_name
             , first_value(reporting_date) over (w order by mean_temperature_f asc) as coldest_day
             , first_value(reporting_date) over (w order by mean_temperature_f desc) as hottest_day
             , stddev_pop(mean_temperature_f) over (partition by wf.station_nbr, wf.wban_nbr) as deviation
  from weather_fact wf
  join country_codes cc on wf.country_cd = cc.country_cd
WINDOW w AS (partition by wf.station_nbr, wf.wban_nbr)
 order by deviation desc 
limit 30 ;
--41412 ms

--days in Phoenix where it's never rained
select to_char(month(reporting_date), '00') || '-' || trim(to_char(day(reporting_date), '00'))
, sum(total_precipitation_inches) as total_rain  
from weather_fact where station_nbr = 722780 
and total_precipitation_inches != 99.99 
group by 1 order by 2 asc limit 20 ;
-- 41 ms
