"""Test AWS RDS connection and run a sample query"""
from sqlalchemy import create_engine, text
from aws_config import get_connection_string

def test_aws_connection():
    try:
        # Create connection
        print("Connecting to AWS RDS...")
        engine = create_engine(get_connection_string())
        
        # Test connection with a simple query
        with engine.connect() as conn:
            # Test PostGIS
            result = conn.execute(text('SELECT PostGIS_Version();'))
            postgis_version = result.scalar()
            print(f"PostGIS Version: {postgis_version}")
            
            # Get table counts
            result = conn.execute(text('''
                SELECT 
                    (SELECT COUNT(*) FROM healthcare_facilities) as facilities_count,
                    (SELECT COUNT(*) FROM neighborhoods) as neighborhoods_count,
                    (SELECT COUNT(*) FROM hospital_beds) as beds_count;
            '''))
            counts = result.fetchone()
            print("\nDatabase Statistics:")
            print(f"Healthcare Facilities: {counts[0]}")
            print(f"Neighborhoods: {counts[1]}")
            print(f"Hospital Beds: {counts[2]}")
            
            # Test spatial query
            result = conn.execute(text('''
                SELECT 
                    n.neighbourhood_name,
                    COUNT(hf.facility_name) as nearby_hospitals
                FROM neighborhoods n
                LEFT JOIN healthcare_facilities hf 
                    ON ST_DWithin(n.location, hf.location, 2000)
                GROUP BY n.neighbourhood_name
                ORDER BY nearby_hospitals DESC
                LIMIT 3;
            '''))
            print("\nTop 3 Neighborhoods by Nearby Hospitals:")
            for row in result:
                print(f"{row[0]}: {row[1]} hospitals within 2km")
                
        print("\nAWS RDS Connection Test Successful!")
        return True
        
    except Exception as e:
        print(f"Error testing AWS RDS connection: {e}")
        return False

if __name__ == "__main__":
    test_aws_connection()
