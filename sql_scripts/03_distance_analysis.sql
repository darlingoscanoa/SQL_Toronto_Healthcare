-- Query 3: Distance Analysis
WITH FacilityDistances AS (
    SELECT 
        n.neighbourhood_name,
        f.facility_name,
        CAST(ST_Distance(n.location, f.location)/1000 AS NUMERIC(5,2)) as distance_km,
        RANK() OVER (PARTITION BY n.neighbourhood_name ORDER BY ST_Distance(n.location, f.location)) as nearest_rank
    FROM neighborhoods n
    CROSS JOIN healthcare_facilities f
)
SELECT 
    neighbourhood_name as "Neighborhood",
    STRING_AGG(
        CASE WHEN nearest_rank <= 3 
            THEN facility_name || ' (' || distance_km || ' km)'
            ELSE NULL END,
        ', ' ORDER BY distance_km
    ) as "Nearest 3 Facilities",
    MIN(distance_km) as "Distance to Nearest (km)",
    ROUND(AVG(CASE WHEN nearest_rank <= 3 THEN distance_km END), 2) as "Avg Distance to Top 3 (km)"
FROM FacilityDistances
GROUP BY neighbourhood_name
ORDER BY MIN(distance_km);
