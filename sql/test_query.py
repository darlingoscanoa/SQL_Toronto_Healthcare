import pandas as pd
from sqlalchemy import create_engine, text
from aws_config import get_connection_string

def main():
    # Create connection
    connection_string = get_connection_string()
    engine = create_engine(connection_string)
    
    # Test queries
    queries = [
        "SELECT COUNT(*) as facility_count FROM healthcare_facilities",
        "SELECT COUNT(*) as neighborhood_count FROM neighborhoods",
        "SELECT COUNT(*) as beds_count FROM hospital_beds",
        """
        SELECT 
            hf.facility_name,
            hb.beds_staffed,
            hb.annual_admissions,
            hb.occupancy_rate
        FROM healthcare_facilities hf
        JOIN hospital_beds hb ON hf.facility_name = hb.facility_name
        ORDER BY hb.beds_staffed DESC
        LIMIT 5
        """
    ]
    
    print("Database Content Summary:")
    print("-----------------------")
    
    for query in queries:
        with engine.connect() as conn:
            result = pd.read_sql(query, conn)
            if len(result.columns) == 1:
                print(f"\n{result.columns[0]}: {result.iloc[0,0]}")
            else:
                print("\nTop 5 Hospitals by Bed Count:")
                print(result.to_string(index=False))

if __name__ == "__main__":
    main()
