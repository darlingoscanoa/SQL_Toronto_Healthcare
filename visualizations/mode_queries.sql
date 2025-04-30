-- Queries for Mode.com Visualizations

-- 1. Facility Distribution Map
-- Use this for creating a map visualization
SELECT 
    facility_name,
    facility_type,
    latitude,
    longitude,
    COALESCE(b.beds_staffed, 0) as bed_count
FROM healthcare_facilities f
LEFT JOIN hospital_beds b ON f.facility_name = b.organization_name
WHERE city = 'Toronto';

-- 2. Healthcare Access Heatmap
-- Use this for creating a heatmap
SELECT 
    n.neighbourhood_name,
    n.population,
    COUNT(f.facility_id) as facility_count,
    COALESCE(SUM(b.beds_staffed), 0) as total_beds,
    ROUND(CAST(n.population AS FLOAT) / NULLIF(COUNT(f.facility_id), 0), 2) as population_per_facility
FROM toronto_neighbourhoods n
LEFT JOIN healthcare_facilities f 
    ON ST_Contains(n.geometry, ST_Point(f.longitude, f.latitude))
LEFT JOIN hospital_beds b ON f.facility_name = b.organization_name
GROUP BY n.neighbourhood_name, n.population;

-- 3. Facility Type Distribution
-- Use this for creating a pie chart or bar chart
SELECT 
    facility_type,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) as percentage
FROM healthcare_facilities
WHERE city = 'Toronto'
GROUP BY facility_type
ORDER BY count DESC;
