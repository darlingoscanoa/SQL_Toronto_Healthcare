-- Query 2: Population to Hospital Bed Ratio Analysis
WITH NeighborhoodBeds AS (
    SELECT 
        n.neighbourhood_name,
        n.population_2021,
        COUNT(DISTINCT f.facility_id) as facility_count,
        COALESCE(SUM(hb.beds_staffed), 0) as total_beds
    FROM neighborhoods n
    LEFT JOIN healthcare_facilities f 
        ON ST_DWithin(n.location, f.location, 2000)
    LEFT JOIN hospital_beds hb 
        ON f.facility_name = hb.facility_name
    GROUP BY n.neighbourhood_name, n.population_2021
)
SELECT 
    neighbourhood_name as "Neighborhood",
    population_2021 as "Population",
    facility_count as "Facilities",
    total_beds as "Total Beds",
    CASE 
        WHEN total_beds > 0 THEN CAST(CAST(population_2021 AS FLOAT) / total_beds AS INTEGER)
        ELSE NULL 
    END as "Population per Bed"
FROM NeighborhoodBeds
ORDER BY "Population per Bed" ASC NULLS LAST;
