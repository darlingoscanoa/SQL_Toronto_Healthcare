-- Basic Analysis Queries for Toronto Healthcare

-- 1. Count of Healthcare Facilities by Type
SELECT 
    facility_type,
    COUNT(*) as facility_count
FROM healthcare_facilities
WHERE city = 'Toronto'
GROUP BY facility_type
ORDER BY facility_count DESC;

-- 2. Join Facilities with Neighbourhoods
SELECT 
    n.neighbourhood_name,
    COUNT(f.facility_id) as facility_count
FROM toronto_neighbourhoods n
LEFT JOIN healthcare_facilities f 
    ON ST_Contains(n.geometry, ST_Point(f.longitude, f.latitude))
GROUP BY n.neighbourhood_name
ORDER BY facility_count DESC;
