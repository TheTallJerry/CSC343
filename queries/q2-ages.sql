-- create table events(
--     eventid text primary key, 
--     crimetype text not null,
--     occurrencedate timestamp not null, 
--     neighbourhoodid integer not null
-- );

-- create table PopulationDemographics(
--     neighbourhoodID integer primary key, 
--     totalPopulation integer not null, 
--     numChildren integer not null,
--     numYouthMales integer not null, 
--     numYouthFemales integer not null, 
--     numWorkingAgeMales integer not null,
--     numWorkingAgeFemales integer not null, 
--     num55PlusMales integer not null, 
--     num55PlusFemales integer not null
-- );

-- Q2 ages: Do neighbourhoods with higher proportions of men in the 19-24 age range report higher levels of crime
-- because of data limitation, we'll be analyzing with 15-25 aka youth instead.
drop view if exists neighbourhood_youthmale;
create view neighbourhood_youthmale as(
    select p.neighbourhoodID, round(cast(numYouthMales::float / totalPopulation as numeric), 2) as youth_male_proportion, count(eventid) as crime_count
    from PopulationDemographics p natural join events
    group by p.neighbourhoodID
);
-- corr = 0.31
select round(corr(youth_male_proportion, crime_count)::numeric, 2) from neighbourhood_youthmale;

-- Follow up question: what about other age groups we have data on?
drop view if exists neighbourhoodid_other_age_groups;
create view neighbourhoodid_other_age_groups as (
    select p.neighbourhoodID, 
        round(cast(numChildren::float / totalPopulation as numeric), 2) as children_proportion,
        round(cast(numYouthFemales::float / totalPopulation as numeric), 2) as youth_female_proportion, 
        round(cast(numWorkingAgeMales::float / totalPopulation as numeric), 2) as working_male_proportion, 
        round(cast(numWorkingAgeFemales::float / totalPopulation as numeric), 2) as working_female_proportion, 
        round(cast(num55PlusMales::float / totalPopulation as numeric), 2) as fiftyfive_plus_male_proportion, 
        round(cast(num55PlusFemales::float / totalPopulation as numeric), 2) as fiftyfive_plus_female_proportion, 
        count(eventid) as crime_count
    from PopulationDemographics p natural join events
    group by p.neighbourhoodID
);

-- 0.44, 0.41, -0.04, -0.34, -0.43
select round(corr(youth_female_proportion, crime_count)::numeric, 2) as youth_female_corr, 
    round(corr(working_male_proportion, crime_count)::numeric, 2) as working_male_corr, 
    round(corr(working_female_proportion, crime_count)::numeric, 2) as working_female_corr, 
    round(corr(fiftyfive_plus_male_proportion, crime_count)::numeric, 2) as fiftyfive_plus_male_proportion_corr, 
    round(corr(fiftyfive_plus_female_proportion, crime_count)::numeric, 2) as fiftyfive_plus_female_corr
from neighbourhoodid_other_age_groups;

