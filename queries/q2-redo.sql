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
drop table if exists summer_violent, winter_violent, spring_violent, autumn_violent, all_years;
drop table if exists summer_vs_other_seasons_violent;

create table all_years as (
    select distinct extract(year from targetdate) as year from lockdowndata
);

create or replace function seasonal_violent_table(months int[])
    returns table(year int, violent_count int)
    as $$
    select a.year, coalesce(s.violent, 0)
    from all_years a full outer join (
        select extract(year from occurrencedate) as year, count(crimetype) as violent
        from events
        where extract(month from occurrencedate) = any(months) and crimetype = any('{assault, homicide, shooting}'::text[])
        group by extract(year from occurrencedate)
    ) s
    on a.year = s.year
    group by a.year, s.violent
    $$
    language sql;

-- violent-crimes count in each season each year
create table summer_violent as(
    select year, violent_count as summer_count from seasonal_violent_table('{6, 7, 8}')
);

create table winter_violent as(
    select year, violent_count as winter_count from seasonal_violent_table('{12, 1, 2}')
);

create table spring_violent as(
    select year, violent_count as spring_count from seasonal_violent_table('{3, 4, 5}')
);

create table autumn_violent as(
    select year, violent_count as autumn_count from seasonal_violent_table('{9, 10, 11}')
);

-- combined
create table summer_vs_other_seasons_violent as (
    select z.year, summer_count, winter_count, spring_count, autumn_count
    from (((summer_violent natural join winter_violent) x natural join spring_violent) y natural join autumn_violent) z
);
-- check if majority is in summer
select 
    count(*) filter (where summer_count >= greatest(spring_count, winter_count, autumn_count)) as "summerIsTheMost", 
    count(*) as total_years
from summer_vs_other_seasons_violent;

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
