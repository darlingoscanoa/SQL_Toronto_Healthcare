-- Query 4: Capacity Utilization Analysis
SELECT 
    hf.facility_name,
    hf.facility_type,
    hb.beds_staffed,
    hb.annual_admissions,
    hb.emergency_visits,
    CAST(hb.occupancy_rate AS NUMERIC(5,1)) as occupancy_percentage,
    hb.care_type
FROM healthcare_facilities hf
JOIN hospital_beds hb ON hf.facility_name = hb.facility_name
ORDER BY hb.beds_staffed DESC;
