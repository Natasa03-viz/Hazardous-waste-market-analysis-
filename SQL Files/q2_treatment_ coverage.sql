/* ============================================================================

   Q2 — WHAT SHARE OF GENERATED HAZARDOUS WASTE IS ACTUALLY TREATED
        IN EACH COUNTRY?

   Datasets   : env_wasgen + env_wastr
   Technique  : country bridge CTE, LEFT JOIN, ratio calculation, CASE WHEN
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
        geo                     AS country_iso2,
        TIME_PERIOD             AS report_year,
        SUM(CAST(OBS_VALUE AS DECIMAL(18,2))) AS generated_tonnes
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
        geo                     AS country_full_name,
        TIME_PERIOD             AS report_year,
        SUM(CAST(OBS_VALUE AS DECIMAL(18,2))) AS treated_tonnes
    FROM env_wastr
    WHERE
        hazard      = 'Hazardous'
        AND wst_oper = 'Waste treatment'
        AND waste    = 'Total waste'
        AND geo IN ('Bulgaria','Czechia','Estonia','Croatia','Hungary','Lithuania','Latvia','Poland','Romania','Slovenia','Slovakia')
    GROUP BY geo, TIME_PERIOD
)
SELECT
    cb.full_name                                        AS country,
    g.report_year,
    ROUND(g.generated_tonnes, 0)                        AS generated_tonnes,
    ROUND(COALESCE(t.treated_tonnes, 0), 0)             AS treated_tonnes,
    ROUND(
        COALESCE(t.treated_tonnes, 0)
        / NULLIF(g.generated_tonnes, 0) * 100,
    1)                                                  AS treatment_coverage_pct,
    CASE
        WHEN COALESCE(t.treated_tonnes,0) / NULLIF(g.generated_tonnes,0) >= 0.9
            THEN 'High >=90%'
        WHEN COALESCE(t.treated_tonnes,0) / NULLIF(g.generated_tonnes,0) >= 0.6
            THEN 'Medium 60-90%'
        ELSE 'Low <60%'
    END                                                 AS coverage_category
FROM generation g
JOIN country_bridge cb
    ON g.country_iso2 = cb.iso2
LEFT JOIN treatment t
    ON  cb.full_name    = t.country_full_name
    AND g.report_year   = t.report_year
ORDER BY
    g.report_year DESC,
    treatment_coverage_pct ASC;