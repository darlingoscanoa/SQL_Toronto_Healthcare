# SQL_Toronto_Healthcare Resource Allocation Analysis

A data-driven approach to help the Toronto government optimize healthcare resource allocation using SQL analysis and spatial data.

## Project Overview

This project analyzes healthcare facility distribution and capacity across Toronto to support evidence-based decision-making for healthcare resource allocation. It combines geographical data with facility metrics to identify service gaps and forecast future needs.

## Directory Structure

```
SQL_Toronto_Healthcare/
├── sql/
│   └── create_tables.sql       # Database schema creation
├── sql_scripts/
│   ├── 01_facility_distribution.sql   # Facility distribution analysis
│   ├── 02_population_bed_ratio.sql    # Population to bed ratio analysis
│   ├── 03_distance_analysis.sql       # Geographic accessibility analysis
│   ├── 04_capacity_utilization.sql    # Facility capacity analysis
│   └── 05_future_demand.sql           # Future demand forecasting
└── visualizations/             # Mode.com visualization screenshots
```

## Technical Stack

- PostgreSQL with PostGIS for spatial database operations
- AWS RDS for cloud database hosting
- Mode.com for analysis and visualization
- Python for data processing and ETL
- Git/GitHub for version control

## Key Features

1. **Spatial Analysis**: Uses PostGIS to analyze healthcare facility coverage and accessibility
2. **Capacity Planning**: Analyzes current facility utilization and projects future demand
3. **Population Analysis**: Maps population density to healthcare resources
4. **Distance Analysis**: Measures accessibility using geographic data

## Getting Started

1. Set up PostgreSQL with PostGIS extension
2. Run create_tables.sql to set up the database schema
3. Execute SQL scripts in numerical order
4. View results in Mode.com dashboard

## Database Schema

The project uses three main tables:
- healthcare_facilities: Stores facility information and locations
- neighborhoods: Contains demographic data and boundaries
- hospital_beds: Tracks capacity and utilization metrics

## Future Enhancements

1. Include walk-in clinics for granular neighborhood analysis
2. Add public transportation accessibility metrics
3. Incorporate wait time data
4. Analyze seasonal demand variations
5. Add demographic projections

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

*Built with ❤️ for Toronto's healthcare planning*
