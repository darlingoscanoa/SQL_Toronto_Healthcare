import psycopg2
import sys

try:
    print("Attempting to connect to database...")
    conn = psycopg2.connect(
        host="toronto-healthcare-db-public.cdeyqou0gld5.us-east-1.rds.amazonaws.com",
        database="postgres",
        user="postgres",
        password="postgrestoronto",
        connect_timeout=10
    )
    print("Successfully connected!")
    conn.close()
    
except Exception as e:
    print(f"Error type: {type(e).__name__}")
    print(f"Error details: {str(e)}")
    print(f"Python version: {sys.version}")
    print(f"psycopg2 version: {psycopg2.__version__}")
