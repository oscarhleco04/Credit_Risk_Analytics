
-- ============================================
-- CREDIT RISK ANALYTICS
-- 05 - HISTORIAL DE PAGOS DE 6 MESES
-- ============================================

WITH historial AS (
    SELECT
        "ID",
        default_next_month,

        -- Número de meses con retraso positivo
        (
            CASE WHEN "PAY_0" > 0 THEN 1 ELSE 0 END +
            CASE WHEN "PAY_2" > 0 THEN 1 ELSE 0 END +
            CASE WHEN "PAY_3" > 0 THEN 1 ELSE 0 END +
            CASE WHEN "PAY_4" > 0 THEN 1 ELSE 0 END +
            CASE WHEN "PAY_5" > 0 THEN 1 ELSE 0 END +
            CASE WHEN "PAY_6" > 0 THEN 1 ELSE 0 END
        ) AS meses_con_retraso,

        -- Mayor código de retraso registrado
        GREATEST(
            "PAY_0", "PAY_2", "PAY_3",
            "PAY_4", "PAY_5", "PAY_6"
        ) AS max_retraso

    FROM public.credit_clients
),

segmentacion AS (
    SELECT
        *,
        CASE
            WHEN meses_con_retraso = 0
                THEN '0 meses'
            WHEN meses_con_retraso = 1
                THEN '1 mes'
            WHEN meses_con_retraso = 2
                THEN '2 meses'
            WHEN meses_con_retraso = 3
                THEN '3 meses'
            ELSE '4 a 6 meses'
        END AS frecuencia_retraso,

        CASE
            WHEN meses_con_retraso = 0 THEN 1
            WHEN meses_con_retraso = 1 THEN 2
            WHEN meses_con_retraso = 2 THEN 3
            WHEN meses_con_retraso = 3 THEN 4
            ELSE 5
        END AS orden

    FROM historial
)

SELECT
    frecuencia_retraso,
    COUNT(*) AS total_clientes,
    SUM(default_next_month) AS incumplidos,

    ROUND(
        AVG(default_next_month::NUMERIC) * 100,
        2
    ) AS tasa_incumplimiento_pct,

    ROUND(
        AVG(max_retraso::NUMERIC),
        2
    ) AS max_codigo_retraso_promedio

FROM segmentacion

GROUP BY frecuencia_retraso, orden
ORDER BY orden;
