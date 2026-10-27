/*
The below query is used to create an empty table 
in accordance with the nine columns available 
in the dataset CSV obtained from BigQuery.
*/
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

-- The below query is used to fill in the country_emissions_raw table.
COPY country_emissions_raw
FROM '/tmp/country_emissions.csv'
DELIMITER ',' CSV HEADER;

-- The below query is used to display the country_emissions_raw table.
SELECT * FROM country_emissions_raw;

-- The below query is used to count the total rows in country_emissions_raw.
SELECT COUNT(*) FROM country_emissions_raw;

-- The below query is used to check the time period of the dataset (which is 2015-2026).
SELECT MIN(start_time), MAX(start_time) FROM country_emissions_raw;

/*
The below query is used to extract 5 columns that are most relevant to the project.
It will also include extracting 2015 to 2025 data from ASEAN countries only, as the project focuses on these countries.
For gas, it will only include data with co2e_100yr, as it represents all greenhouse gases combined as CO2 equivalent.
This will be the raw dataset that is used for the project.
*/
SELECT iso3_country, subsector, start_time, gas, emissions_quantity
FROM country_emissions_raw
WHERE gas = 'co2e_100yr'
	AND iso3_country IN ('IDN', 'MYS', 'THA', 'VNM', 'PHL', 'SGP', 'MMR', 'KHM', 'LAO', 'BRN')
	AND start_time < '2026-01-01';

-- NOTE: The extracted dataset (named raw_country_emissions.csv) was downloaded using the download icon on the Data Output panel.