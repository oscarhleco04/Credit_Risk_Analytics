
-- ============================================
-- CREDIT RISK ANALYTICS
-- 07 - FACTURACIÓN Y COMPORTAMIENTO DE PAGOS
-- ============================================

WITH movimientos AS (
    SELECT
        "ID",
        default_next_month,

        (
            "BILL_AMT1"::BIGINT +
            "BILL_AMT2"::BIGINT +
            "BILL_AMT3"::BIGINT +
            "BILL_AMT4"::BIGINT +
            "BILL_AMT5"::BIGINT +
            "BILL_AMT6"::BIGINT
        ) AS facturacion_acumulada,

        (
            "PAY_AMT1"::BIGINT +
            "PAY_AMT2"::BIGINT +
            "PAY_AMT3"::BIGINT +
            "PAY_AMT4"::BIGINT +
            "PAY_AMT5"::BIGINT +
            "PAY_AMT6"::BIGINT
        ) AS pagos_acumulados

    FROM public.credit_clients
),

indicadores AS (
    SELECT
        *,
        ROUND(
            pagos_acumulados::NUMERIC /
            NULLIF(facturacion_acumulada, 0) * 100,
            2
        ) AS ratio_pago_facturacion_pct

    FROM movimientos
),

segmentacion AS (
    SELECT
        *,
        CASE
            WHEN facturacion_acumulada <= 0
                THEN 'Facturación no positiva'
            WHEN ratio_pago_facturacion_pct < 10
                THEN 'Menos de 10%'
            WHEN ratio_pago_facturacion_pct < 30
                THEN '10% a menos de 30%'
            WHEN ratio_pago_facturacion_pct < 60
                THEN '30% a menos de 60%'
            WHEN ratio_pago_facturacion_pct <= 100
                THEN '60% a 100%'
            ELSE 'Más de 100%'
        END AS grupo_ratio,

        CASE
            WHEN facturacion_acumulada <= 0 THEN 1
            WHEN ratio_pago_facturacion_pct < 10 THEN 2
            WHEN ratio_pago_facturacion_pct < 30 THEN 3
            WHEN ratio_pago_facturacion_pct < 60 THEN 4
            WHEN ratio_pago_facturacion_pct <= 100 THEN 5
            ELSE 6
        END AS orden

    FROM indicadores
)

SELECT
    grupo_ratio,
    COUNT(*) AS total_clientes,
    SUM(default_next_month) AS incumplidos,

    ROUND(
        AVG(default_next_month::NUMERIC) * 100,
        2
    ) AS tasa_incumplimiento_pct,

    ROUND(
        AVG(ratio_pago_facturacion_pct),
        2
    ) AS ratio_promedio_pct

FROM segmentacion

GROUP BY grupo_ratio, orden
ORDER BY orden;
