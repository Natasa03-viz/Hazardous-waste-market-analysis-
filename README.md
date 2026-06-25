# Industrial Hazardous Waste Market Analysis

## Overview
This repository contains a compact, business-focused analysis of hazardous waste generation and treatment across selected European countries for a fictitious company, GreenLoop. The work uses SQL to prepare analysis tables and a Power BI dashboard to explore country- and sector-level market signals for hazardous waste treatment opportunities.

## Project Goal
Help GreenLoop identify attractive hazardous-waste markets and treatment shortfalls by answering: Which countries generate the most hazardous waste, how much is treated domestically, which sectors produce the most waste, and where are the largest gaps between generation and domestic treatment capacity?

## Tools and Data

- SQL (for data extraction, aggregation and modelling)

- Power BI (interactive dashboard; screenshot included)

- CSV exports (from SQL outputs)

Source: Eurostat (env_wasgen, env_wastrt),  [Eurostat waste statistics data sources](https://ec.europa.eu/eurostat/statistics-explained/index.php?title=Waste_statistics#Data_sources)

## Outputs

Four SQL analyses exported as CSVs for use in BI tools: country trends, treatment coverage, sector ranking, and capacity gap.

A Power BI dashboard that supports country and year filtering, sector breakdowns, trend analysis, KPI summaries, and a geographic comparison.
Note: I am not publishing the Power BI .pbix file; the repository contains the SQL, CSV outputs and dashboard screenshot for preview.

## SQL analyses outputs (short descriptions)

- q1_country_trend.csv - Total hazardous waste (tonnes) per country per year, year-over-year change using LAG(), and rank by annual volume.

- q2_treatment_coverage.csv - Generated vs treated hazardous waste per country-year (joined across datasets), % treated, and coverage category (High/Medium/Low).

- q3_sector_ranking.csv - Waste by sector per country-year, % share of country total, and sector rank.

- q5_capacity_gap.csv - Generated minus treated per country-year (capacity gap), ranked and labeled by severity (Critical/High/Moderate/No gap).

## Dashboard Preview

<img width="1907" height="1072" alt="Power BI_Dashboard_CZ_MA" src="https://github.com/user-attachments/assets/ab022c70-ec32-440d-948d-e63ecd9227e9" />
<img width="1917" height="1067" alt="image" src="https://github.com/user-attachments/assets/ae5a9245-31d2-4859-8389-3eb432ff6ffd" />
<img width="2082" height="1167" alt="Power BI dashobard Market Analysys" src="https://github.com/user-attachments/assets/2da47464-c972-48fc-bcf7-986759daa0cd" />

What the dashboard shows: 

- Market size and trend: total hazardous waste generated over time per country.

- Treatment coverage: % of generated hazardous waste treated domestically (KPI).

- Sector composition: treemap and bars showing which sectors drive hazardous waste volumes.

- Capacity gap: where demand likely exceeds domestic treatment capacity.

Interactivity: country and year slicers, hover tooltips, and cross-filtering across visuals.

### Key Findings 

- Czechia, Poland, and Bulgaria are the largest generators, showing a steady trend over the years. While Estonia's trend has been declining since 2018, Bulgaria shows a steady increase alongside high treatment coverage.

- Treatment coverage varies widely; several countries fall into the “Low <60%” category, indicating potential outbound treatment demand.

- Manufacturing and Households are consistently among the top waste sources in multiple markets.

- Czechia, and Romania show a significant capacity gap (>500k tonnes in 2022 alone), suggesting an underserved domestic market or need for cross-border treatment solutions. Based on these results, the most sensible expansion targets are Czechia and Poland
