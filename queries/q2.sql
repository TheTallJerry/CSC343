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

-- Q2
drop view if exists summer_violent, all_violent;
drop table if exists summer_vs_total_violent;

-- violent-crimes count in summer each year
create view summer_violent as(
    select extract(year from occurrencedate) as year, count(crimetype) as summer_violent
    from events
    where extract(month from occurrencedate) = any('{6, 7, 8, 9}'::int[]) and crimetype = any('{assault, homicide, shooting}'::text[])
    group by extract(year from occurrencedate), extract(month from occurrencedate)
);
-- violent-crimes count in each year
create view all_violent as(
    select extract(year from occurrencedate) as year, count(crimetype) as total_violent
    from events
    where crimetype = any('{assault, homicide, shooting}'::text[])
    group by extract(year from occurrencedate)
);
-- combined
create table summer_vs_total_violent as (
    select s.year, summer_violent, total_violent, summer_violent::float / total_violent as ratio 
    from summer_violent s join all_violent a 
    on s.year = a.year
);
-- check if majority is in summer
select 
    count(*) filter (where ratio >= 0.5) as "ratioMajority",
    count(*) filter (where ratio < 0.5) as "ratioNonMajority" 
from summer_vs_total_violent;

-- conclusion: majority of violent crimes do not happen in summer
-- follow-up question: what's the top 4 months (for each year) that violent crimes occur?
drop table if exists all_violent_by_month, all_violent_by_month_top_4;
-- template table with all months of all the years, with initial count 0
create table all_violent_by_month as (
    select a.year, b.month, b.total_violent
    from (select extract(year from occurrencedate) as year from events) a, (select generate_series(1, 12) as month, 0 as total_violent) b
    group by a.year, b.month, b.total_violent
);
-- fill the table with violent crimes count from each month each year
update all_violent_by_month 
set total_violent = b.total_violent
from (
    select extract(year from occurrencedate) as year, extract(month from occurrencedate) as month, count(crimetype) as total_violent
    from events
    where crimetype = any('{assault, homicide, shooting}'::text[])
    group by extract(year from occurrencedate), extract(month from occurrencedate)
    ) b
where b.year = all_violent_by_month.year and b.month = all_violent_by_month.month;
-- finds top 4 months for each year order by violent-crimes' count
create table all_violent_by_month_top_4 as (
    select *
    from (
        select year, month, total_violent, row_number() over (partition by year order by total_violent desc) as ranking
        from all_violent_by_month
        ) a
    where a.ranking < 5
);
-- sum up the months & neglects year and return the frequency and total_violent for each month
select month, sum(total_violent) as sum_total_violent
from all_violent_by_month_top_4
group by month order by sum(total_violent) desc
limit 4;

-- *very* interesting conclusion: although the count of violent-crimes in summer is not the majority (summer takes up about 32%), 
-- the top 4 months with the most violent-crimes are 6-9, which is indeed summer. 
