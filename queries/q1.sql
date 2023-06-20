drop table if exists total_crime_by_neighbourhood;
create table total_crime_by_neighbourhood as (
    SELECT neighbourhoodid, count(neighbourhoodid) AS total_crime
FROM events  GROUP BY neighbourhoodid order by total_crime desc
);
drop table if exists total_crime_vs_income;
create table total_crime_vs_income as (
    select neighbourhoodid, total_crime, avgincome 
    From total_crime_by_neighbourhood NATURAL JOIN Neighbourhood
);
----Pearson Correlation to see if there's a correlation between these two variables-------
SELECT corr("total_crime", "avgincome") as "Corr Coef Using PGSQL Func" 
from total_crime_vs_income;

\COPY total_crime_vs_income TO 'total_crime_vs_income.csv' DELIMITER ',' CSV HEADER;
