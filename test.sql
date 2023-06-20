drop schema if exists crimedata cascade;
create schema crimedata;
set search_path to crimedata;

-- temporary tables 
create table neighbourhood_crime(
    OBJECTID text,Neighbourhood text,Hood_ID text,F2020_Population_Projection text,Assault_2014 text,Assault_2015 text,Assault_2016 text,Assault_2017 text,Assault_2018 text,Assault_2019 text,Assault_2020 text,Assault_Rate2014 text,Assault_Rate2015 text,Assault_Rate2016 text,Assault_Rate2017 text,Assault_Rate2018 text,Assault_Rate2019 text,Assault_Rate2020 text,AutoTheft_2014 text,AutoTheft_2015 text,AutoTheft_2016 text,AutoTheft_2017 text,AutoTheft_2018 text,AutoTheft_2019 text,AutoTheft_2020 text,AutoTheft_Rate2014 text,AutoTheft_Rate2015 text,AutoTheft_Rate2016 text,AutoTheft_Rate2017 text,AutoTheft_Rate2018 text,AutoTheft_Rate2019 text,AutoTheft_Rate2020 text,BreakAndEnter_2014 text,BreakAndEnter_2015 text,BreakAndEnter_2016 text,BreakAndEnter_2017 text,BreakAndEnter_2018 text,BreakAndEnter_2019 text,BreakAndEnter_2020 text,BreakAndEnter_Rate2014 text,BreakAndEnter_Rate2015 text,BreakAndEnter_Rate2016 text,BreakAndEnter_Rate2017 text,BreakAndEnter_Rate2018 text,BreakAndEnter_Rate2019 text,BreakAndEnter_Rate2020 text,Robbery_2014 text,Robbery_2015 text,Robbery_2016 text,Robbery_2017 text,Robbery_2018 text,Robbery_2019 text,Robbery_2020 text,Robbery_Rate2014 text,RobberyRate_2015 text,Robbery_Rate2016 text,Robbery_Rate2017 text,Robbery_Rate2018 text,Robbery_Rate2019 text,Robbery_Rate2020 text,TheftOver_2014 text,TheftOver_2015 text,TheftOver_2016 text,TheftOver_2017 text,TheftOver_2018 text,TheftOver_2019 text,TheftOver_2020 text,TheftOver_Rate2014 text,TheftOver_Rate2015 text,TheftOver_Rate2016 text,TheftOver_Rate2017 text,TheftOver_Rate2018 text,TheftOver_Rate2019 text,TheftOver_Rate2020 text,Homicide_2014 text,Homicide_2015 text,Homicide_2016 text,Homicide_2017 text,Homicide_2018 text,Homicide_2019 text,Homicide_2020 text,Homicide_Rate2014 text,Homicide_Rate2015 text,Homicide_Rate2016 text,Homicide_Rate2017 text,Homicide_Rate2018 text,Homicide_Rate2019 text,Homicide_Rate2020 text,Shootings_2014 text,Shootings_2015 text,Shootings_2016 text,Shootings_2017 text,Shootings_2018 text,Shootings_2019 text,Shootings_2020 text,Shooting_Rate2014 text,Shootings_Rate2015 text,Shootings_Rate2016 text,Shootings_Rate2017 text,Shootings_Rate2018 text,Shootings_Rate2019 text,Shootings_Rate2020 text,Shape__Area text,Shape__Length text
);

create table demographics(
    Hood text,TotalPopulation text,Child014 text,Youth1524 text,Seniors65 text,Totalvisibleminoritypopulation text,SouthAsian text,Chinese text,Black text,Filipino text,LatinAmerican text,Arab text,SoutheastAsian text,WestAsian text,Korean text,Japanese text,Visibleminoritynie text,Multiplevisibleminorities text,Notavisibleminority text,TotalMobilitystatus5yearsago text,Nonmovers text,Movers text,Totalrecentimmigrantpopulationinprivatehouseholdsbyselectedplacesofbirth text,MiddleEastWesternAsia text,Eastern text,SouthEast text,Southern text,OtherplacesofbirthinAsia text,AmericaswoUSA text,Europe text,Africa text,Totalpopulationaged15yearsandoverbylabourforcestatus text,Inthelabourforce text,Unemployed text,Notinthelabourforce text,Nocertificatediplomaordegree text,CollegeCEGEPorothernonuniversitycertificateordiploma text,Universitycertificateordiplomabelowbachelorlevel text,Totalnumberofprivatehouseholdsbytenure text,Owner text,Renter text,ofownerhouseholdsspending30ormoreofhouseholdtotalincomeonsheltercosts text,Majorrepairsneeded text,Averagemonthlysheltercostsforrenteddwellings text,AverageaftertaxfamilyincomeFamilyincomein2010ofeconomicfamilies text,Householdincomein2010ofprivatehouseholds text,Medianhouseholdtotalincome text,Medianaftertaxhouseholdincome text
);

create table demographics_edited(
    Neighbourhood text,NeighbourhoodID text,TotalPopulation2016 text,Children014years text,Youth1524years text,WorkingAge2554years text,Preretirement5564years text,Seniors65years text,numberOfYouthMales text,numberWorkingAgeMales text,number55PlusMales text,numberOfYouthFemales text,numberWorkingAgeFemales text,number55PlusFemales text
);

create table assault(
    X text,Y text,Index text,eventuniqueid text,Division text,occurrencedate text,reporteddate text,premisestype text,ucrcode text,ucrext text,offence text,reportedyear text,reportedmonth text,reportedday text,reporteddayofyear text,reporteddayofweek text,reportedhour text,occurrenceyear text,occurrencemonth text,occurrenceday text,occurrencedayofyear text,occurrencedayofweek text,occurrencehour text,MCI text,HoodID text,Neighbourhood text,Long text,Lat text,ObjectId text
);

create table homicide(
    X text,Y text,Index text,EventUniqueId text,Occurrenceyear text,Division text,HomicideType text,OccurrenceDate text,HoodID text,Neighbourhood text,Long text,Lat text,ObjectId text
);

create table shooting(
    X text,Y text,Index text,EventUniqueID text,OccurrenceDate text,Occurrenceyear text,Month text,Dayofweek text,OccurrenceHour text,TimeRange text,Division text,Death text,Injuries text,HoodID text,Neighbourhood text,Longitude text,Latitude text,ObjectId text
);

create table robbery(
    X text,Y text,Index text,eventuniqueid text,Division text,occurrencedate text,reporteddate text,premisestype text,ucrcode text,ucrext text,offence text,reportedyear text,reportedmonth text,reportedday text,reporteddayofyear text,reporteddayofweek text,reportedhour text,occurrenceyear text,occurrencemonth text,occurrenceday text,occurrencedayofyear text,occurrencedayofweek text,occurrencehour text,MCI text,HoodID text,Neighbourhood text,Long text,Lat text,ObjectId text
);

create table auto_theft(
    X text,Y text,Index text,eventuniqueid text,Division text,occurrencedate text,reporteddate text,premisestype text,ucrcode text,ucrext text,offence text,reportedyear text,reportedmonth text,reportedday text,reporteddayofyear text,reporteddayofweek text,reportedhour text,occurrenceyear text,occurrencemonth text,occurrenceday text,occurrencedayofyear text,occurrencedayofweek text,occurrencehour text,MCI text,HoodID text,Neighbourhood text,Long text,Lat text,ObjectId text
);

create table break_enter(
    X text,Y text,Index text,eventuniqueid text,Division text,occurrencedate text,reporteddate text,premisestype text,ucrcode text,ucrext text,offence text,reportedyear text,reportedmonth text,reportedday text,reporteddayofyear text,reporteddayofweek text,reportedhour text,occurrenceyear text,occurrencemonth text,occurrenceday text,occurrencedayofyear text,occurrencedayofweek text,occurrencehour text,MCI text,HoodID text,Neighbourhood text,Long text,Lat text,ObjectId text
);

create table theft_over(
    X text,Y text,Index text,eventuniqueid text,Division text,occurrencedate text,reporteddate text,premisestype text,ucrcode text,ucrext text,offence text,reportedyear text,reportedmonth text,reportedday text,reporteddayofyear text,reporteddayofweek text,reportedhour text,occurrenceyear text,occurrencemonth text,occurrenceday text,occurrencedayofyear text,occurrencedayofweek text,occurrencehour text,MCI text,HoodID text,Neighbourhood text,Long text,Lat text,ObjectId text
);

-- actual tables 
create table Neighbourhood(
    neighbourhoodid integer primary key, 
    neighbourhoodname text not null, 
    avgIncome float not null
);

create table events(
    eventid text primary key, 
    crimetype text not null,
    occurrencedate timestamp not null, 
    neighbourhoodid integer not null
);

create table PopulationDemographics(
    neighbourhoodID integer primary key, 
    totalPopulation integer not null, 
    numChildren integer not null,
    numYouthMales integer not null, 
    numYouthFemales integer not null, 
    numWorkingAgeMales integer not null,
    numWorkingAgeFemales integer not null, 
    num55PlusMales integer not null, 
    num55PlusFemales integer not null
);

create table lockdownData(
    targetdate timestamp primary key, 
    status boolean not null
);