# indonesia-asean-emissions-analysis

Analysis of Indonesia's greenhouse gas emissions vs 9 other ASEAN countries (2015 to 2025) using SQL, Python and Tableau.

**Tableau Dashboard**: [ASEAN Country Emissions Analysis Dashboard](https://public.tableau.com/app/profile/narda.noviantoro/viz/ASEANCountryEmissionsAnalysisDashboard/Visualization)

**Google Slides**: [Presentation on ASEAN Country Emissions Analysis](https://docs.google.com/presentation/d/1Nx7RRnWja2BviSipnSvHHqrGtoLT-qNVVk4iKNmUa8w/edit?usp=sharing)

## Summary

Indonesia has committed to net zero emissions by 2060, yet it is also one of the largest greenhouse gas emitters in ASEAN. This project uses Climate TRACE data to find out how Indonesia compares with 9 other ASEAN countries and which subsectors drive its emissions, so reduction efforts can be prioritized where they matter.

**Key findings**
- Indonesia is the largest emitter in ASEAN, averaging about 1.65 billion metric tons CO2e per year (39.34% of the region's total), and is a statistical outlier among ASEAN countries.
- Five subsectors make up 60.2% of Indonesia's 2025 emissions, led by electricity generation (15.63%).
- Emissions in 2025 are slightly higher than in 2015, and a paired t-test shows no significant reduction across subsectors.
- Electricity generation and solid fuels show the clearest upward trends, which points to the energy sector as the main priority.

## Project files

| File | Description |
|---|---|
| `asean_emissions_queries.sql` | SQL used to load the Climate TRACE data into PostgreSQL and extract the subset for the analysis |
| `asean_emissions_analysis.ipynb` | Python notebook covering data cleaning and the full analysis |
| `raw_country_emissions.csv` | Extracted dataset from PostgreSQL (7,480 rows, 5 columns) |
| `clean_country_emissions.csv` | Cleaned dataset used for the analysis (7,040 rows, 5 columns) |
| `LICENSE` | MIT License |

## Workflow

BigQuery (download) → PostgreSQL (import and extract) → Python (cleaning and analysis) → Tableau (dashboard)

1. **BigQuery**: download the original Climate TRACE `country_emissions` table (over 1 million rows) as a CSV.
2. **PostgreSQL**: import the CSV, then extract only the columns, gas type, countries and years needed.
3. **Python**: clean the extracted data, then answer six analytical questions with visualizations and statistical tests.
4. **Tableau**: present the results in an interactive dashboard.

## Data and cleaning

**Source**: [Climate TRACE](https://climatetrace.org/data) 'Country Emissions' dataset, accessed through BigQuery.

**Scope**: Indonesia and 9 other ASEAN countries (BRN, IDN, KHM, LAO, MMR, MYS, PHL, SGP, THA, VNM), 2015 to 2025, in metric tons of CO2e. 2026 is excluded because the year is incomplete and would distort trends.

**Columns kept**: `iso3_country`, `subsector`, `start_time`, `gas`, `emissions_quantity`. Only the `co2e_100yr` gas type is used because it converts all greenhouse gases to CO2 equivalent over 100 years, which allows fair comparisons.

| Step | What was done | Why |
|---|---|---|
| Date conversion | Converted `start_time` to datetime and extracted `year` | The analysis works on yearly trends |
| Duplicate check | Found 0 duplicate rows | No rows needed to be dropped |
| Consistency check | Confirmed one gas type, 10 ASEAN countries and 2015 to 2025 only | Ensures the data matches the scope |
| Removed absorption subsectors | Dropped `net-forest-land`, `net-shrubgrass`, `net-wetland` and `removals` (440 rows, 7,480 to 7,040) | These have negative values (emissions absorption) that would offset real emissions and make large emitters look smaller |
| Skewness check | Skewness of 6.89, data kept as is | The skew reflects reality: a few subsectors produce most emissions |
| Dropped `start_time` | Kept `year` instead | `start_time` became redundant |

## How to run

1. Clone this repo and open the folder.
2. Install the libraries:
   ```
   pip install pandas numpy scipy matplotlib seaborn jupyter
   ```
3. Open `asean_emissions_analysis.ipynb` in Jupyter and choose **Restart and Run All**. The notebook reads `raw_country_emissions.csv` from the same folder, so the SQL step is not needed to reproduce the analysis.

To reproduce the extraction yourself, download the Climate TRACE `country_emissions` table from BigQuery, import it into PostgreSQL and run `asean_emissions_queries.sql`. The original dataset is not included in this repo because of its size.

## Findings

1. **Top 5 subsectors in Indonesia (2025)**: electricity generation (15.63%), other agricultural soil emissions (13.93%), other solid fuels (11.98%), forest land clearing (9.77%) and road transportation (8.89%). Together they contribute 60.2% of total emissions.
2. **Indonesia vs ASEAN**: Indonesia has the highest average yearly emissions at about 1.65 billion metric tons CO2e (39.34% of ASEAN's total), roughly three times Thailand (12.84%). Brunei is the lowest at 0.30%.
3. **Indonesia's trend**: emissions peaked in 2023 at about 1.88 billion metric tons CO2e and were lowest in 2017 at about 1.42 billion. The trend fluctuates, with a drop in 2020 likely linked to COVID-19, and 2025 ends slightly above 2015.
4. **Top 5 subsectors over time**: electricity generation rose from about 191 million to 288 million metric tons CO2e, and other solid fuels from about 87 million to 221 million. Road transportation grew from about 129 million to 164 million but has plateaued since 2022. Agricultural soil emissions stayed stable, while forest land clearing fell from about 249 million to 180 million with a fluctuating trend.
5. **Outlier check**: using Tukey's rule, Indonesia is the only outlier among ASEAN countries, well above the upper boundary of about 931 million metric tons CO2e. The ASEAN mean (about 420 million) sits well above the median (about 313 million) because of Indonesia.
6. **Paired t-test (2015 vs 2025)**: p-value of 0.83, so there is no statistically significant difference in Indonesia's subsector emissions between 2015 and 2025. Emissions have not shown notable reductions toward the 2060 target.

## Conclusion

Indonesia is the largest greenhouse gas emitter in ASEAN and a statistical outlier within the region. Its emissions have not meaningfully declined over 2015 to 2025, and they are concentrated in a few subsectors, with energy-related ones (electricity generation and solid fuels) showing the clearest upward trends.

## Recommendations

- **Policymakers**: prioritize emission reduction in the energy sector, particularly power plants and solid fuels, for example through a transition to renewable energy.
- **Businesses and investors**: focus ESG and decarbonization efforts on energy-heavy operations, including switching to renewable electricity.

## Limitations

- The analysis uses gross emissions, so it does not account for carbon absorption by forests and land.
- Country comparisons use total emissions, not emissions per capita, so population and land size influence the results.
- The outlier check is based on only 10 data points, so one unusual value can skew it.
- The data is right-skewed, so the paired t-test may be influenced by a few subsectors with very large changes.

## Tools

- **SQL (PostgreSQL, pgAdmin 4)**: data import and extraction
- **BigQuery**: source data access
- **Python**: pandas, NumPy, SciPy, Matplotlib, Seaborn (in Jupyter Notebook)
- **Tableau Public**: dashboard
- **Google Slides**: presentation