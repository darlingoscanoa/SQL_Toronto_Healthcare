import pandas as pd
import psycopg2
from sqlalchemy import create_engine, text
import os
from aws_config import get_connection_string

def create_db_connection():
    """Create connection to AWS RDS PostgreSQL instance"""
    try:
        # Get AWS RDS connection string
        connection_string = get_connection_string()
        engine = create_engine(connection_string)
        
        # Test connection and enable PostGIS
        with engine.connect() as conn:
            conn.execute(text('CREATE EXTENSION IF NOT EXISTS postgis;'))
            conn.commit()
            print("Successfully connected to AWS RDS and enabled PostGIS")
        
        return engine
    except Exception as e:
        print(f"Error connecting to AWS RDS: {e}")
        return None

def load_healthcare_facilities(engine):
    """Load healthcare facilities data"""
    df = pd.read_csv('raw_data/toronto_healthcare_facilities.csv')
    
    # Add PostGIS point geometry
    df['location'] = df.apply(
        lambda row: f"POINT({row['longitude']} {row['latitude']})", 
        axis=1
    )
    
    # Load to database
    df.to_sql('healthcare_facilities', engine, if_exists='append', index=False)
    print("Loaded healthcare facilities data")

def load_neighborhoods(engine):
    """Load neighborhoods data"""
    df = pd.read_csv('raw_data/toronto_neighbourhoods.csv')
    
    # Add PostGIS point geometry
    df['location'] = df.apply(
        lambda row: f"POINT({row['longitude']} {row['latitude']})", 
        axis=1
    )
    
    # Load to database
    df.to_sql('neighborhoods', engine, if_exists='append', index=False)
    print("Loaded neighborhoods data")

def load_hospital_beds(engine):
    """Load hospital beds data"""
    df = pd.read_csv('raw_data/toronto_hospital_beds.csv')
    df.to_sql('hospital_beds', engine, if_exists='append', index=False)
    print("Loaded hospital beds data")

def main():
    # Create database connection
    engine = create_db_connection()
    if not engine:
        return
    
    try:
        # Load all datasets
        load_healthcare_facilities(engine)
        load_neighborhoods(engine)
        load_hospital_beds(engine)
        
        print("\nAll data loaded successfully!")
        
    except Exception as e:
        print(f"Error loading data: {e}")

if __name__ == "__main__":
    main()
