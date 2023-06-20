-- Neighbourhood
insert into Neighbourhood
select hood_id::integer, Neighbourhood, AverageaftertaxfamilyincomeFamilyincomein2010ofeconomicfamilies::float as avg_income
from neighbourhood_crime join demographics on hood_id::integer = hood::integer;

-- Events
insert into events
select eventuniqueid, 'assault', occurrencedate::timestamp, case when hoodid = 'NSA' or hoodid is null then -1 else hoodid::integer end
from assault
on conflict (eventid) do nothing;

insert into events
select eventuniqueid, 'homicide', occurrencedate::timestamp, case when hoodid = 'NSA' or hoodid is null then -1 else hoodid::integer end
from homicide
on conflict (eventid) do nothing;

insert into events
select eventuniqueid, 'shooting', occurrencedate::timestamp, case when hoodid = 'NSA' or hoodid is null then -1 else hoodid::integer end
from shooting
on conflict (eventid) do nothing;

insert into events
select eventuniqueid, 'robbery', occurrencedate::timestamp, case when hoodid = 'NSA' or hoodid is null then -1 else hoodid::integer end
from robbery
on conflict (eventid) do nothing;

insert into events
select eventuniqueid, 'auto_theft', occurrencedate::timestamp, case when hoodid = 'NSA' or hoodid is null then -1 else hoodid::integer end
from auto_theft
on conflict (eventid) do nothing;

insert into events
select eventuniqueid, 'break_enter', occurrencedate::timestamp, case when hoodid = 'NSA' or hoodid is null then -1 else hoodid::integer end
from break_enter
on conflict (eventid) do nothing;

insert into events
select eventuniqueid, 'theft_over', occurrencedate::timestamp, case when hoodid = 'NSA' or hoodid is null then -1 else hoodid::integer end
from theft_over
on conflict (eventid) do nothing;

-- remove null (bad data)
delete from events 
where neighbourhoodid = -1;

-- PopulationDemographics
insert into PopulationDemographics
select NeighbourhoodID::integer, translate(TotalPopulation2016, ',', '')::integer, translate(Children014years, ',', '')::integer, 
translate(numberOfYouthMales, ',', '')::integer, translate(numberOfYouthFemales, ',', '')::integer, translate(numberWorkingAgeMales, ',', '')::integer, 
translate(numberWorkingAgeFemales, ',', '')::integer, translate(number55PlusMales, ',', '')::integer, translate(number55PlusFemales, ',', '')::integer
from demographics_edited
on conflict (NeighbourhoodID) do nothing;

-- lockdown data

-- constraints
alter table events
add constraint Neighbourhood_ids_events foreign key (neighbourhoodid) references Neighbourhood(neighbourhoodid);

alter table PopulationDemographics
add constraint Neighbourhood_ids_PopulationDemographics foreign key (neighbourhoodid) references Neighbourhood(neighbourhoodid);

alter table events
add constraint event_dates foreign key (occurrencedate) references lockdownData(targetDate);

