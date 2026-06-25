/* ============================================================================

   Q5 — WHERE IS THE BIGGEST GAP BETWEEN HAZARDOUS WASTE GENERATED
        AND DOMESTIC TREATMENT CAPACITY?

   Datasets   : env_wasgen + env_wastr
   Technique  : country bridge CTE, LEFT JOIN, subtraction, RANK(), CASE WHEN
   ============================================================================ */

WITH country_bridge AS (
    SELECT 'BG' AS iso2, 'Bulgaria'  AS full_name UNION ALL
    SELECT 'CZ',         'Czechia'                UNION ALL
    SELECT 'EE',         'Estonia'                UNION ALL
    SELECT 'HR',         'Croatia'                UNION ALL
    SELECT 'HU',         'Hungary'                UNION ALL
    SELECT 'LT',         'Lithuania'              UNION ALL
    SELECT 'LV',         'Latvia'                 UNION ALL
    SELECT 'PL',         'Poland'                 UNION ALL
    SELECT 'RO',         'Romania'                UNION ALL
    SELECT 'SI',         'Slovenia'               UNION ALL
    SELECT 'SK',         'Slovakia'
),

generation AS (
    SELECT
        geo             AS country_iso2,
        TIME_PERIOD     AS report_year,
        SUM(CAST(OBS_VALUE AS DECIMAL(18,2)))  AS generated_tonnes
    FROM env_wasgen
    WHERE
        hazard  = 'HAZ'
        AND unit    = 'T'
        AND waste   = 'TOTAL'
        AND nace_r2 IN ('A','B','C','D','E','F','G-U_X_G4677','G4677','EP_HH')
        AND geo IN ('BG','CZ','EE','HR','HU','LT','LV','PL','RO','SI','SK')
    GROUP BY geo, TIME_PERIOD
),

treatment AS (
    SELECT
        geo             AS country_full_name,
        TIME_PERIOD     AS report_year,
        SUM(CAST(OBS_VALUE AS DECIMAL(18,2)))  AS treated_tonnes
    FROM env_wastr
    WHERE
        hazard      = 'Hazardous'
        AND wst_oper = 'Waste treatment'
        AND waste    = 'Total waste'
        AND geo IN ('Bulgaria','Czechia','Estonia','Croatia','Hungary','Lithuania','Latvia','Poland','Romania','Slovenia','Slovakia')
    GROUP BY geo, TIME_PERIOD
),

gap_calc AS (
    SELECT
        cb.full_name                                                  AS country,
        g.report_year,
        ROUND(g.generated_tonnes, 0)                                  AS generated_tonnes,
        ROUND(COALESCE(t.treated_tonnes, 0), 0)                       AS treated_tonnes,
        ROUND(g.generated_tonnes - COALESCE(t.treated_tonnes, 0), 0)  AS capacity_gap_tonnes
    FROM generation g
    JOIN country_bridge cb
        ON g.country_iso2 = cb.iso2
    LEFT JOIN treatment t
        ON  cb.full_name    = t.country_full_name
        AND g.report_year   = t.report_year
)

SELECT
    country,
    report_year,
    generated_tonnes,
    treated_tonnes,
    capacity_gap_tonnes,
    RANK() OVER (
        PARTITION BY report_year
        ORDER BY capacity_gap_tonnes DESC
    )                                           AS gap_rank,
    CASE
        WHEN capacity_gap_tonnes > 500000   THEN 'Critical  >500k t'
        WHEN capacity_gap_tonnes > 100000   THEN 'High  100k-500k t'
        WHEN capacity_gap_tonnes > 0        THEN 'Moderate  <100k t'
        ELSE 'No gap / surplus capacity'
    END                                         AS gap_severity
FROM gap_calc
ORDER BY
    report_year DESC,
    capacity_gap_tonnes DESC;