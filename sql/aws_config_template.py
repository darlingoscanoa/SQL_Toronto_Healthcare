"""AWS RDS Configuration Template
This is a template file. To use this project:
1. Copy this file to aws_config.py
2. Replace the placeholder values with your AWS RDS credentials
3. Never commit aws_config.py to GitHub
"""

# AWS RDS PostgreSQL configuration
AWS_RDS_CONFIG = {
    'host': 'your-db-name.xxxxx.region.rds.amazonaws.com',  # Your RDS endpoint
    'database': 'postgres',  # Default database name
    'user': 'your_username',        # Your RDS master username
    'password': 'your_password',    # Your RDS master password
    'port': '5432'
}

# Create the SQLAlchemy connection string
def get_connection_string():
    return f"postgresql://{AWS_RDS_CONFIG['user']}:{AWS_RDS_CONFIG['password']}@{AWS_RDS_CONFIG['host']}:{AWS_RDS_CONFIG['port']}/{AWS_RDS_CONFIG['database']}"
