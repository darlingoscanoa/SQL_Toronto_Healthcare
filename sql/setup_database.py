import psycopg2
from aws_config import AWS_RDS_CONFIG

def setup_database():
    print("Setting up database...")
    
    # Read the SQL file
    with open('sql/create_tables_new.sql', 'r') as file:
        sql_commands = file.read()
    
    # Connect to the database
    try:
        conn = psycopg2.connect(
            host=AWS_RDS_CONFIG['host'],
            database=AWS_RDS_CONFIG['database'],
            user=AWS_RDS_CONFIG['user'],
            password=AWS_RDS_CONFIG['password'],
            port=AWS_RDS_CONFIG['port']
        )
        
        # Create a cursor and execute the SQL commands
        cur = conn.cursor()
        print("Executing SQL commands...")
        cur.execute(sql_commands)
        
        # Commit the changes
        conn.commit()
        print("Database setup completed successfully!")
        
    except Exception as e:
        print(f"Error: {str(e)}")
        
    finally:
        if 'cur' in locals():
            cur.close()
        if 'conn' in locals():
            conn.close()

if __name__ == "__main__":
    setup_database()
