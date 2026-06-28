# Industrial Hazardous Waste Market Analysis

## Overview
This project presents a concise, business-focused analysis of hazardous waste generation and treatment trends across selected European countries for a fictitious company, GreenLoop, exploring potential expansion opportunities for its hazardous waste management operations in Europe. The objective was to identify suitable publicly available data that could reveal attractive markets for expansion and extract insights. SQL was used to efficiently prepare and analyze large datasets, while Power BI was used to visualize country- and sector-level market signals and support the identification of potential opportunities.

## Project Goal
Help GreenLoop identify attractive hazardous-waste markets and treatment shortfalls by answering: Which countries generate the most hazardous waste, how much is treated domestically, which sectors produce the most waste, and where are the largest gaps between generation and domestic treatment capacity?

## Tools and Data

- SQL (for data extraction, aggregation and modelling)

- Power BI (interactive dashboard; screenshot included)
  Link: https://github.com/Natasa03-viz/Hazardous-waste-market-analysis-/tree/main/Images

- CSV exports (from SQL outputs)
  Link:https://github.com/Natasa03-viz/Hazardous-waste-market-analysis-/tree/main/SQL%20Files

Source: Eurostat (env_wasgen, env_wastrt),  [Eurostat waste statistics data sources](https://ec.europa.eu/eurostat/statistics-explained/index.php?title=Waste_statistics#Data_sources)

## Outputs

Four SQL analyses exported as CSVs for use in BI tools: country trends, treatment coverage, sector ranking, and capacity gap.

Power BI dashboard designed on a star schema data model to support DAX measure development, filter context interaction across country and year dimensions, sector-level segmentation, trend analysis, KPI aggregation, and geographic comparison.
Note:.pbix is excluded to keep the repo lightweight; screenshots demonstrate the full interactive report.

## Business Questions and SQL analyses outputs (short descriptions)

 - Which CEE country generates the most hazardous waste, and how has that volume changed over time?
(q1_country_trend) - Ranks countries by total hazardous waste tonnage per reporting year and tracks the change versus the previous period. Identifies the largest and fastest-growing markets.

 - What share of generated hazardous waste is actually treated domestically in each country?
(q2_treatment_coverage) - Joins generation and treatment volumes to calculate a treatment coverage %, then classifies each country into High/Medium/Low coverage. Flags where treatment infrastructure is lagging behind generation.

 - Which industrial sectors generate the most hazardous waste, and how does that mix differ across countries?
( q3_sector_ranking) - Breaks total hazardous waste down by economic sector (Manufacturing, Mining, Construction, etc.), ranks sectors within each country, and calculates each sector's share of the country total. Identifies the highest-potential industrial customers per market.

 - Where is the biggest gap between hazardous waste generated and domestic treatment capacity?
( q5_capacity_gap) - Subtracts treated tonnage from generated tonnage per country-year and ranks the resulting capacity gap, with a severity label (Critical/High/Moderate/None). Points out the most underserved markets — i.e., the clearest expansion opportunities.

## Dashboard Preview

<img width="1907" height="1072" alt="Power BI_Dashboard_CZ_MA" src="https://github.com/user-attachments/assets/ab022c70-ec32-440d-948d-e63ecd9227e9" />
<img width="1917" height="1067" alt="image" src="https://github.com/user-attachments/assets/ae5a9245-31d2-4859-8389-3eb432ff6ffd" />
<img width="2082" height="1167" alt="Power BI dashobard Market Analysys" src="https://github.com/user-attachments/assets/2da47464-c972-48fc-bcf7-986759daa0cd" />

What this dashboard shows: 

- Market size and trend: total hazardous waste generated over time per country.

- Treatment coverage: % of generated hazardous waste treated domestically (KPI).

- Sector composition: treemap and bars showing which sectors drive hazardous waste volumes.

- Capacity gap: where demand likely exceeds domestic treatment capacity.

Interactivity: country and year slicers, hover tooltips, and cross-filtering across visuals.

### Key Findings 

- Czechia, Poland, and Bulgaria are the largest generators, showing a steady trend over the years. While Estonia's trend has been declining since 2018, Bulgaria shows a steady increase alongside high treatment coverage.

- Treatment coverage varies widely; several countries fall into the “Low <60%” category, indicating potential outbound treatment demand.

- Manufacturing is consistently among the top waste sources in multiple markets.

- Czechia, and Romania show a significant capacity gap (>500k tonnes in 2022 alone), suggesting an underserved domestic market or need for cross-border treatment solutions. Based on these results, the most sensible expansion targets are Czechia and Poland.

## Data Limitations

- Biennial reporting: The source data is reported every two years, so some calendar years are not present.
- YoY change: Year-over-year change compares reporting periods, not every calendar year.
- Country code mismatch: env_wasgen uses ISO-2 codes, while env_wastrt uses country names, so a manual bridge table was needed.
- Coverage ratio: Treatment coverage is a directional indicator, not an exact accounting match.
- Negative gaps: Negative capacity gaps can happen when treated volumes exceed domestic generation.
-  Households code: EP_HH is Eurostat’s classification and is included as reported.
- No facility detail: The analysis is at country and sector level only.
- Flags not used: Source confidence or suppression flags were not filtered in this version.
