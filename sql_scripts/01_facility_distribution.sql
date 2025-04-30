-- Query 1: Healthcare Facility Distribution Analysis
WITH NeighborhoodFacilities AS (
    SELECT 
        n.neighbourhood_name,
        COUNT(f.facility_id) as facility_count,
        n.population_2021,
        STRING_AGG(f.facility_name, ', ') as facilities_list
    FROM neighborhoods n
    LEFT JOIN healthcare_facilities f 
        ON ST_DWithin(n.location, f.location, 2000)  -- Facilities within 2km
    GROUP BY n.neighbourhood_name, n.population_2021
),
NeighborhoodStats AS (
    SELECT 
        neighbourhood_name,
        facility_count,
        population_2021,
        facilities_list,
        CAST(CAST(population_2021 AS FLOAT) / NULLIF(facility_count, 0) AS INTEGER) as people_per_facility,
        RANK() OVER (ORDER BY facility_count DESC) as rank_by_facilities,
        RANK() OVER (ORDER BY (CAST(population_2021 AS FLOAT) / NULLIF(facility_count, 0))) as rank_by_coverage
    FROM NeighborhoodFacilities
)
SELECT 
    neighbourhood_name as "Neighborhood",
    facility_count as "Number of Facilities",
    population_2021 as "Population",
    people_per_facility as "People per Facility",
    facilities_list as "Facilities in Area"
FROM NeighborhoodStats
ORDER BY facility_count DESC;
