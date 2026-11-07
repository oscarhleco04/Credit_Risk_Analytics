
-- ============================================
-- CREDIT RISK ANALYTICS
-- 06 - UTILIZACIÓN DEL CRÉDITO
-- ============================================

WITH utilizacion AS (
    SELECT
        "ID",
        "LIMIT_BAL",
        "BILL_AMT1",
        default_next_month,

        ROUND(
            "BILL_AMT1"::NUMERIC
            / NULLIF("LIMIT_BAL", 0) * 100,
            2
        ) AS utilizacion_pct

    FROM public.credit_clients
),

segmentacion AS (
    SELECT
        *,
        CASE
            WHEN utilizacion_pct < 0
                THEN 'Saldo negativo'
            WHEN utilizacion_pct < 30
                THEN '0% a menos de 30%'
            WHEN utilizacion_pct < 60
                THEN '30% a menos de 60%'
            WHEN utilizacion_pct < 90
                THEN '60% a menos de 90%'
            WHEN utilizacion_pct <= 100
                THEN '90% a 100%'
            ELSE 'Más de 100%'
        END AS grupo_utilizacion,

        CASE
            WHEN utilizacion_pct < 0 THEN 1
            WHEN utilizacion_pct < 30 THEN 2
            WHEN utilizacion_pct < 60 THEN 3
            WHEN utilizacion_pct < 90 THEN 4
            WHEN utilizacion_pct <= 100 THEN 5
            ELSE 6
        END AS orden

    FROM utilizacion
)

SELECT
    grupo_utilizacion,
    COUNT(*) AS total_clientes,
    SUM(default_next_month) AS incumplidos,

    ROUND(
        AVG(default_next_month::NUMERIC) * 100,
        2
    ) AS tasa_incumplimiento_pct,

    ROUND(
        AVG(utilizacion_pct),
        2
    ) AS utilizacion_promedio_pct

FROM segmentacion

GROUP BY grupo_utilizacion, orden
ORDER BY orden;
