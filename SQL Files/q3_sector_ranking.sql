 Q3 — WHICH INDUSTRIAL SECTORS ARE THE TOP HAZARDOUS WASTE GENERATORS,
        AND HOW DOES THE SECTORAL MIX DIFFER ACROSS CEE COUNTRIES?

   Dataset    : env_wasgen
   Technique  : GROUP BY, RANK() partitioned by country + year, % share of total
   ============================================================================ */

WITH sector_waste AS (

    SELECT
        geo                         AS country_iso2,
        nace_r2                     AS sector_code,
        TIME_PERIOD                 AS report_year,
        OBS_VALUE                   AS sector_waste_tonnes
    FROM env_wasgen
    WHERE
        hazard  = 'HAZ'
        AND unit    = 'T'
        AND waste   = 'TOTAL'
        -- Only the 9 non-overlapping top-level sections — see header note
        AND nace_r2 IN ('A','B','C','D','E','F','G-U_X_G4677','G4677','EP_HH')
        AND geo IN ('BG','CZ','EE','HR','HU','LT','LV','PL','RO','SI','SK')
        AND OBS_VALUE IS NOT NULL
),

country_totals AS (

    SELECT
        country_iso2,
        report_year,
        SUM(CAST(sector_waste_tonnes AS DECIMAL(18,2)))AS country_total_tonnes
    FROM sector_waste
    GROUP BY country_iso2, report_year
)

SELECT
    s.country_iso2,
    s.report_year,
    s.sector_code,
    CASE s.sector_code
        WHEN 'A'             THEN 'Agriculture, forestry and fishing'
        WHEN 'B'             THEN 'Mining and quarrying'
        WHEN 'C'             THEN 'Manufacturing'
        WHEN 'D'             THEN 'Electricity, gas, steam and air conditioning supply'
        WHEN 'E'             THEN 'Water supply, sewerage, waste management'
        WHEN 'F'             THEN 'Construction'
        WHEN 'G-U_X_G4677'   THEN 'Services (except wholesale of waste and scrap)'
        WHEN 'G4677'         THEN 'Wholesale of waste and scrap'
        WHEN 'EP_HH'         THEN 'Households'
    END                                                 AS sector_name,
    ROUND(s.sector_waste_tonnes, 0)                     AS sector_waste_tonnes,
    ROUND(
        s.sector_waste_tonnes
        / NULLIF(ct.country_total_tonnes, 0) * 100,
    1)                                                  AS pct_of_country_total,
    RANK() OVER (
        PARTITION BY s.country_iso2, s.report_year
        ORDER BY s.sector_waste_tonnes DESC
    )                                                   AS sector_rank
FROM sector_waste s
JOIN country_totals ct
    ON  s.country_iso2  = ct.country_iso2
    AND s.report_year   = ct.report_year
ORDER BY
    s.country_iso2,
    s.report_year DESC,
    sector_rank;
