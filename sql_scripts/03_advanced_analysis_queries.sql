-- Advanced Analysis Queries for Toronto Healthcare

-- 1. Window Function: Rank facilities by bed count within neighborhoods
WITH FacilityRanks AS (
    SELECT 
        f.facility_name,
        n.neighbourhood_name,
        b.beds_staffed,
        RANK() OVER (PARTITION BY n.neighbourhood_name ORDER BY b.beds_staffed DESC) as bed_rank
    FROM healthcare_facilities f
    JOIN hospital_beds b ON f.facility_name = b.organization_name
    JOIN toronto_neighbourhoods n 
        ON ST_Contains(n.geometry, f.location)
    WHERE b.beds_staffed IS NOT NULL
)
SELECT * FROM FacilityRanks WHERE bed_rank <= 3;

-- 2. Identify underserved areas using population/facility ratio
WITH NeighbourhoodMetrics AS (
    SELECT 
        n.neighbourhood_name,
        n.population,
        COUNT(f.facility_id) as facility_count,
        COALESCE(SUM(b.beds_staffed), 0) as total_beds,
        ST_Area(n.geometry::geography) / 1000000.0 as area_km2
    FROM toronto_neighbourhoods n
    LEFT JOIN healthcare_facilities f 
        ON ST_Contains(n.geometry, f.location)
    LEFT JOIN hospital_beds b ON f.facility_name = b.organization_name
    GROUP BY n.neighbourhood_name, n.population, n.geometry
)
SELECT 
    neighbourhood_name,
    population,
    facility_count,
    total_beds,
    ROUND(CAST(population AS NUMERIC) / NULLIF(facility_count, 0), 2) as population_per_facility,
    ROUND(CAST(area_km2 AS NUMERIC), 2) as area_km2,
    ROUND(CAST(facility_count AS NUMERIC) / NULLIF(area_km2, 0), 2) as facilities_per_km2
FROM NeighbourhoodMetrics
ORDER BY population_per_facility DESC;
