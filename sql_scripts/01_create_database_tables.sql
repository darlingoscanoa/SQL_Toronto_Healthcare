-- Create tables for Toronto Healthcare Analysis

-- Enable PostGIS extension for spatial queries
CREATE EXTENSION IF NOT EXISTS postgis;

-- Healthcare Facilities Table
CREATE TABLE healthcare_facilities (
    facility_id SERIAL PRIMARY KEY,
    facility_name VARCHAR(255) NOT NULL,
    facility_type VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(100),
    province VARCHAR(50),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    location GEOMETRY(Point, 4326)
);

-- Toronto Neighbourhoods Table
CREATE TABLE toronto_neighbourhoods (
    neighbourhood_id INTEGER PRIMARY KEY,
    neighbourhood_name VARCHAR(255) NOT NULL,
    population INTEGER,
    area_sqkm DECIMAL(10,2),
    geometry GEOMETRY(MultiPolygon, 4326)
);

-- Hospital Beds Data Table
CREATE TABLE hospital_beds (
    bed_id SERIAL PRIMARY KEY,
    organization_name VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    beds_staffed INTEGER,
    care_setting VARCHAR(100)
);

-- Create index for spatial queries
CREATE INDEX idx_healthcare_facilities_location ON healthcare_facilities USING GIST(location);
CREATE INDEX idx_toronto_neighbourhoods_geometry ON toronto_neighbourhoods USING GIST(geometry);
