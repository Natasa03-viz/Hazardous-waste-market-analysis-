

  Q1 — WHICH CEE COUNTRY GENERATES THE MOST HAZARDOUS WASTE,
        AND HOW HAS THE TREND CHANGED SINCE EU ACCESSION?
 
   Dataset    : env_wasgen 
   Technique  : GROUP BY + SUM, LAG() for year-over-year change, RANK()
   ============================================================================ */
 
WITH yearly_totals AS (
 
    -- Step 1: Sum the 9 non-overlapping top-level sections → total hazardous
    -- waste per country per year. Using nace_r2 = 'TOTAL_HH' directly would
    -- also work and is simpler — kept here as the explicit, auditable version.
    SELECT
        geo                                     AS country_iso2,
        TIME_PERIOD                             AS report_year,
         SUM(CAST(OBS_VALUE AS DECIMAL(18,2)))   AS haz_waste_tonnes
    FROM env_wasgen
    WHERE
        hazard      = 'HAZ'                     -- Hazardous waste only
        AND unit    = 'T'                       -- absolute tonnes, not kg/capita
        AND waste   = 'TOTAL'                   -- total waste, not a sub-category
        AND nace_r2 IN ('A','B','C','D','E','F','G-U_X_G4677','G4677','EP_HH')
        AND geo IN ('BG','CZ','EE','HR','HU','LT','LV','PL','RO','SI','SK')
    GROUP BY
        geo, TIME_PERIOD
),
 
with_yoy AS (
 
    -- Step 2: Year-over-year change using LAG()
    -- LAG() looks back at the PREVIOUS row within the same country, ordered by year
    SELECT
        country_iso2,
        report_year,
        haz_waste_tonnes,
        LAG(haz_waste_tonnes) OVER (
            PARTITION BY country_iso2
            ORDER BY report_year
        )                                       AS prev_period_tonnes,
        ROUND(
            (
                haz_waste_tonnes
                - LAG(haz_waste_tonnes) OVER (PARTITION BY country_iso2 ORDER BY report_year)
            )
            / NULLIF(
                LAG(haz_waste_tonnes) OVER (PARTITION BY country_iso2 ORDER BY report_year), 0
            ) * 100,
        2)                                      AS change_vs_prev_period_pct
    FROM yearly_totals
)
 
SELECT
    country_iso2,
    report_year,
    ROUND(haz_waste_tonnes, 0)                  AS haz_waste_tonnes,
    ROUND(prev_period_tonnes, 0)                AS prev_period_tonnes,
    change_vs_prev_period_pct,
    -- Rank countries within each year: 1 = highest waste generator that year
    RANK() OVER (
        PARTITION BY report_year
        ORDER BY haz_waste_tonnes DESC
    )                                           AS rank_in_year
FROM with_yoy
ORDER BY
    report_year DESC,
    haz_waste_tonnes DESC;
 