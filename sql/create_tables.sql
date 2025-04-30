-- Enable PostGIS extension for spatial queries
CREATE EXTENSION IF NOT EXISTS postgis;

-- Create healthcare facilities table
CREATE TABLE IF NOT EXISTS healthcare_facilities (
    facility_id SERIAL PRIMARY KEY,
    facility_name VARCHAR(100) NOT NULL,
    facility_type VARCHAR(50) NOT NULL,
    address VARCHAR(200) NOT NULL,
    postal_code VARCHAR(7) NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    location GEOGRAPHY(POINT), -- For spatial queries
    CONSTRAINT unique_facility_name UNIQUE (facility_name)
);

-- Create neighborhoods table
CREATE TABLE IF NOT EXISTS neighborhoods (
    neighbourhood_id INTEGER PRIMARY KEY,
    neighbourhood_name VARCHAR(100) NOT NULL,
    population_2021 INTEGER NOT NULL,
    households_2021 INTEGER NOT NULL,
    population_density INTEGER NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    location GEOGRAPHY(POINT) -- For spatial queries
);

-- Create hospital beds table
CREATE TABLE IF NOT EXISTS hospital_beds (
    facility_id SERIAL PRIMARY KEY,
    facility_name VARCHAR(100) NOT NULL,
    beds_staffed INTEGER NOT NULL,
    annual_admissions INTEGER NOT NULL,
    emergency_visits INTEGER NOT NULL,
    occupancy_rate DECIMAL(4,1) NOT NULL,
    facility_type VARCHAR(50) NOT NULL,
    care_type VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    province VARCHAR(50) NOT NULL,
    CONSTRAINT fk_facility
        FOREIGN KEY (facility_name)
        REFERENCES healthcare_facilities(facility_name)
        ON DELETE CASCADE
);

-- Create indexes for better query performance
CREATE INDEX idx_facility_name ON healthcare_facilities(facility_name);
CREATE INDEX idx_facility_location ON healthcare_facilities USING GIST(location);
CREATE INDEX idx_neighborhood_location ON neighborhoods USING GIST(location);
CREATE INDEX idx_beds_facility ON hospital_beds(facility_name);

-- Create a view for facility capacity analysis
CREATE OR REPLACE VIEW facility_capacity_view AS
SELECT 
    hf.facility_name,
    hf.address,
    hb.beds_staffed,
    hb.annual_admissions,
    hb.emergency_visits,
    hb.occupancy_rate,
    hb.care_type,
    ST_Y(location::geometry) as latitude,
    ST_X(location::geometry) as longitude
FROM healthcare_facilities hf
JOIN hospital_beds hb ON hf.facility_name = hb.facility_name;

-- Create a view for neighborhood healthcare access
CREATE OR REPLACE VIEW neighborhood_healthcare_view AS
SELECT 
    n.neighbourhood_name,
    n.population_2021,
    n.population_density,
    COUNT(hf.facility_name) as nearby_hospitals,
    COALESCE(SUM(hb.beds_staffed), 0) as total_beds,
    COALESCE(SUM(hb.annual_admissions), 0) as total_annual_admissions
FROM neighborhoods n
LEFT JOIN healthcare_facilities hf ON ST_DWithin(n.location, hf.location, 2000)
LEFT JOIN hospital_beds hb ON hf.facility_name = hb.facility_name
GROUP BY n.neighbourhood_name, n.population_2021, n.population_density;
