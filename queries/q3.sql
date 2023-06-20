-- pasted from schema.ddl for easier referencing
-- create table Neighbourhood(
--     neighbourhoodid integer primary key, 
--     neighbourhoodname text not null, 
--     avgIncome float not null,
--     medianincome float not null
-- );

-- create table events(
--     eventid text primary key, 
--     crimetype text not null,
--     occurrencedate timestamp not null, 
--     neighbourhoodid integer not null
-- );

-- create table lockdowndata(
--     targetdate timestamp primary key, 
--     status boolean not null
-- );

-- Q3
-- rates of all crime types each 5 years pre pandemic
-- covid started in 2020, so 2015 - 2019
drop table if exists crime_rates_all;
create table crime_rates_all as (
    select crimetype, extract(year from occurrencedate) as "year", count(crimetype) as crimecount, 0 as increase
    from events
    where extract(year from occurrencedate) = any(select * from generate_series(2015, 2020))
    group by crimetype, extract(year from occurrencedate)
    order by crimetype, extract(year from occurrencedate)
);
 
-- increase from last year (if exisis)
with a as (
    select crimetype, year, coalesce(crimecount - lag(crimecount) over(partition by crimetype), 0) as tempincrease
    from crime_rates_all
    )
update crime_rates_all
set increase = a.tempincrease
from a
where crime_rates_all.crimetype = a.crimetype and a.year = crime_rates_all.year;

select * 
from crime_rates_all
where year = 2020 and increase > 0;
-- overall, auto_theft and shooting had an increase of 239 and 27 respectively, while 
-- all other crime types had a decrease. 

-- does lockdown have an impact? 
drop table if exists crime_rates_all_in_pandemic_in_lockdown, crime_rates_all_in_pandemic_notin_lockdown;
-- rates of all crime types each 5 years during pandemic during lockdown
create table crime_rates_all_in_pandemic_in_lockdown as (
    select crimetype, count(crimetype) as crimecount, 0.0 as ratio
    from events join lockdowndata on occurrencedate = targetdate
    where extract(year from occurrencedate) = 2020 and status = true
    group by crimetype
    order by crimetype
);
-- rates of all crime types each 5 years during pandemic not in lockdown
create table crime_rates_all_in_pandemic_notin_lockdown as (
    select crimetype, count(crimetype) as crimecount, 0.0 as ratio
    from events join lockdowndata on occurrencedate = targetdate
    where extract(year from occurrencedate) = 2020 and status = false
    group by crimetype
    order by crimetype
);

drop table if exists lockdown_dates_distribution, combined_lockdown_crime_rates;
create table lockdown_dates_distribution as (
    select a.status, count(a.status) as datescount
    from (
        select targetdate::date, status 
        from lockdowndata
        where extract(year from targetdate) = 2020
        group by targetdate::date, status
        ) a
    group by a.status
);

update crime_rates_all_in_pandemic_notin_lockdown
set ratio = crimecount::float / datescount
from lockdown_dates_distribution
where status = false;

update crime_rates_all_in_pandemic_in_lockdown
set ratio = crimecount::float / datescount
from lockdown_dates_distribution
where status = true;

create table combined_lockdown_crime_rates as (
    select a.crimetype, a.ratio as lockdown_ratio, b.ratio as not_lockdown_ratio
    from crime_rates_all_in_pandemic_in_lockdown a join crime_rates_all_in_pandemic_notin_lockdown b
    on a.crimetype = b.crimetype
);
select * from combined_lockdown_crime_rates;

-- conclusion: crime rates not in lockdown are always higher than in lockdown, but very close. Overall, crime rates have decreased since the pandemic
-- followup question: historically, has the locked down months had the most crimes?
drop view if exists pre_pandemic_crime_rates_by_month, in_lockdown_crime_rates_by_month, notin_lockdown_crime_rates_by_month;
drop table if exists lockdown_vs_pre_pandemic, not_lockdown_vs_pre_pandemic;
create view pre_pandemic_crime_rates_by_month as (
    select extract(month from occurrencedate) as "month", crimetype, count(crimetype)::float / 5 as avg_crimecount
    from events
    where extract(year from occurrencedate) = any(select * from generate_series(2015, 2019))
    group by extract(month from occurrencedate), crimetype
    order by extract(month from occurrencedate), crimetype
);

-- select * from pre_pandemic_crime_rates_by_month;

create view in_lockdown_crime_rates_by_month as (
    select extract(month from occurrencedate) as "month", crimetype, count(crimetype)::float as avg_crimecount
    from events join lockdowndata on occurrencedate = targetdate
    where extract(year from occurrencedate) = 2020 and status = true
    group by extract(month from occurrencedate), crimetype
    order by extract(month from occurrencedate), crimetype
);

create view notin_lockdown_crime_rates_by_month as (
    select extract(month from occurrencedate) as "month", crimetype, count(crimetype)::float as avg_crimecount
    from events join lockdowndata on occurrencedate = targetdate
    where extract(year from occurrencedate) = 2020 and status = false
    group by extract(month from occurrencedate), crimetype
    order by extract(month from occurrencedate), crimetype
);

create table lockdown_vs_pre_pandemic as (
    select a.month, a.crimetype, a.avg_crimecount as pre_pandemic_ratio, b.avg_crimecount as in_lockdown_ratio
    from pre_pandemic_crime_rates_by_month a join in_lockdown_crime_rates_by_month b
    on a.month = b.month and a.crimetype = b.crimetype
);

create table not_lockdown_vs_pre_pandemic as (
    select a.month, a.crimetype, a.avg_crimecount as pre_pandemic_ratio, b.avg_crimecount as notin_lockdown_ratio
    from pre_pandemic_crime_rates_by_month a join notin_lockdown_crime_rates_by_month b
    on a.month = b.month and a.crimetype = b.crimetype
);

-- crimetypes that had higher ratio not in lockdown & in pandemic than the avg of 5 years pre pandemic
-- month_count = number of months the said criteria is satisfied
-- prepandemic ratio for a month for a crime type = sum(2015-2019 crime counts for a month for a crime type) / 5
-- not in lockdown ratio for a month = sum(not in lockdown counts for a month for a crime type) / month_count
select crimetype, count(month) as month_count, sum(pre_pandemic_ratio) / count(month) as pre_pandemic_ratio, sum(notin_lockdown_ratio) / count(month) as notin_lockdown_ratio 
from not_lockdown_vs_pre_pandemic 
where notin_lockdown_ratio > pre_pandemic_ratio
group by crimetype order by crimetype;

-- conclusion: compared to 5 years pre pandemic on average, there were significantly more auto_theft in december, which was in lockdown;
-- Quite surprisingly, every single crime types had a higher ratio than those 5 years, in every single month that had days we're not in lockdown (1-10). 
-- Among them is auto_theft, which had 11 months in pandemic that had a higher ratio.