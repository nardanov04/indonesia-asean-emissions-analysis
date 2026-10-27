/*
Project: Indonesia vs. ASEAN Greenhouse Gas Emissions Analysis (2015-2025)
Author: Narda Parama Agung Noviantoro
Database: PostgreSQL (run in pgAdmin 4)
Data source: Climate TRACE 'Country Emissions' dataset, downloaded from BigQuery as country_emissions.csv

Purpose:
This script loads the original Climate TRACE dataset into PostgreSQL and extracts
the subset used in the analysis: greenhouse gas emissions (CO2e) of 10 ASEAN countries
from 2015 to 2025. The output of the final query is saved as raw_country_emissions.csv
and cleaned further in the Python notebook (asean_emissions_analysis.ipynb).
*/

-- STEP 1: Create the table
-- The table mirrors the nine columns available in the original CSV from BigQuery.
CREATE TABLE country_emissions_raw (
	iso3_country VARCHAR(3),
	sector VARCHAR(100),
	subsector VARCHAR(100),
	start_time TIMESTAMP,
	end_time TIMESTAMP,
	gas VARCHAR(20),
	emissions_quantity FLOAT,
	emissions_quantity_units VARCHAR(20),
	temporal_granularity VARCHAR(20)
);

-- STEP 2: Import the original dataset into the table
COPY country_emissions_raw
FROM '/tmp/country_emissions.csv'
DELIMITER ',' CSV HEADER;

-- STEP 3: Inspect the imported data
-- Preview the table to confirm the import worked.
SELECT * FROM country_emissions_raw;

-- Count the total rows in the table.
SELECT COUNT(*) FROM country_emissions_raw;

-- Check the time period covered by the dataset (2015 to 2026).
SELECT MIN(start_time), MAX(start_time) FROM country_emissions_raw;

/*
STEP 4: Extract the dataset used for the analysis
Filters applied:
- Columns: only the 5 most relevant to the project (country, subsector, start time, gas, emissions quantity).
- Gas: only 'co2e_100yr', which represents all greenhouse gases combined as CO2 equivalent over 100 years,
  allowing fair comparisons between emission sources.
- Countries: Indonesia and the 9 other ASEAN countries (IDN, MYS, THA, VNM, PHL, SGP, MMR, KHM, LAO, BRN).
- Period: 2015 to 2025. 2026 is excluded because the year is incomplete and would distort trends.
*/
SELECT iso3_country, subsector, start_time, gas, emissions_quantity
FROM country_emissions_raw
WHERE gas = 'co2e_100yr'
	AND iso3_country IN ('IDN', 'MYS', 'THA', 'VNM', 'PHL', 'SGP', 'MMR', 'KHM', 'LAO', 'BRN')
	AND start_time < '2026-01-01';

-- NOTE: The result (7,480 rows) was exported as raw_country_emissions.csv using the download icon on the Data Output panel in pgAdmin 4.