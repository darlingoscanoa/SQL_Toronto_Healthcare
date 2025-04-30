-- Query 5: Future Demand Forecast
WITH CurrentMetrics AS (
    SELECT 
        n.neighbourhood_name,
        n.population_2021,
        COALESCE(SUM(hb.beds_staffed), 0) as current_beds,
        COALESCE(AVG(hb.occupancy_rate), 0) as current_occupancy,
        CASE 
            WHEN n.population_2021 > 100000 THEN 2.5
            WHEN n.population_2021 > 50000 THEN 3.5
            ELSE 4.5
        END as estimated_growth_rate
    FROM neighborhoods n
    LEFT JOIN healthcare_facilities f 
        ON ST_DWithin(n.location, f.location, 2000)
    LEFT JOIN hospital_beds hb 
        ON f.facility_name = hb.facility_name
    GROUP BY n.neighbourhood_name, n.population_2021
)
SELECT 
    neighbourhood_name as "Neighborhood",
    population_2021 as "Current Population",
    current_beds as "Current Beds",
    current_occupancy as "Current Occupancy Rate",
    CAST(population_2021 * (1 + estimated_growth_rate/100) AS INTEGER) as "Projected Population 2026",
    CAST(current_beds * (current_occupancy/100) AS INTEGER) as "Beds Currently in Use",
    CAST(current_beds * 0.85 AS INTEGER) as "Optimal Bed Capacity"
FROM CurrentMetrics
ORDER BY "Current Population" DESC;
