
-- ============================================
-- CREDIT RISK ANALYTICS
-- 08 - VISTA ANALÍTICA PARA POWER BI
-- ============================================

CREATE OR REPLACE VIEW public.vw_credit_risk AS

WITH indicadores AS (
    SELECT
        "ID" AS cliente_id,
        "AGE" AS edad,
        age_group AS grupo_edad,
        education_group AS nivel_educativo,
        marriage_group AS estado_civil,
        "LIMIT_BAL" AS limite_credito,
        credit_limit_group AS rango_credito,

        default_next_month AS incumplimiento,

        -- Estado de pago más reciente
        "PAY_0" AS estado_pago_reciente,

        -- Frecuencia de retrasos en seis meses
        (
            CASE WHEN "PAY_0" > 0 THEN 1 ELSE 0 END +
            CASE WHEN "PAY_2" > 0 THEN 1 ELSE 0 END +
            CASE WHEN "PAY_3" > 0 THEN 1 ELSE 0 END +
            CASE WHEN "PAY_4" > 0 THEN 1 ELSE 0 END +
            CASE WHEN "PAY_5" > 0 THEN 1 ELSE 0 END +
            CASE WHEN "PAY_6" > 0 THEN 1 ELSE 0 END
        ) AS meses_con_retraso,

        GREATEST(
            "PAY_0", "PAY_2", "PAY_3",
            "PAY_4", "PAY_5", "PAY_6"
        ) AS max_codigo_retraso,

        -- Utilización aproximada del crédito
        ROUND(
            "BILL_AMT1"::NUMERIC /
            NULLIF("LIMIT_BAL", 0) * 100,
            2
        ) AS utilizacion_pct,

        -- Suma de saldos facturados
        (
            "BILL_AMT1"::BIGINT +
            "BILL_AMT2"::BIGINT +
            "BILL_AMT3"::BIGINT +
            "BILL_AMT4"::BIGINT +
            "BILL_AMT5"::BIGINT +
            "BILL_AMT6"::BIGINT
        ) AS facturacion_acumulada,

        -- Suma de pagos realizados
        (
            "PAY_AMT1"::BIGINT +
            "PAY_AMT2"::BIGINT +
            "PAY_AMT3"::BIGINT +
            "PAY_AMT4"::BIGINT +
            "PAY_AMT5"::BIGINT +
            "PAY_AMT6"::BIGINT
        ) AS pagos_acumulados

    FROM public.credit_clients
)

SELECT
    *,

    CASE
        WHEN meses_con_retraso = 0 THEN '0 meses'
        WHEN meses_con_retraso = 1 THEN '1 mes'
        WHEN meses_con_retraso = 2 THEN '2 meses'
        WHEN meses_con_retraso = 3 THEN '3 meses'
        ELSE '4 a 6 meses'
    END AS frecuencia_retraso,

    CASE
        WHEN utilizacion_pct < 0 THEN 'Saldo negativo'
        WHEN utilizacion_pct < 30 THEN '0% a menos de 30%'
        WHEN utilizacion_pct < 60 THEN '30% a menos de 60%'
        WHEN utilizacion_pct < 90 THEN '60% a menos de 90%'
        WHEN utilizacion_pct <= 100 THEN '90% a 100%'
        ELSE 'Más de 100%'
    END AS grupo_utilizacion,

    ROUND(
        pagos_acumulados::NUMERIC /
        NULLIF(facturacion_acumulada, 0) * 100,
        2
    ) AS ratio_pago_facturacion_pct,

    CASE
        WHEN facturacion_acumulada <= 0
            THEN 'Facturación no positiva'
        WHEN pagos_acumulados::NUMERIC /
             NULLIF(facturacion_acumulada, 0) * 100 < 10
            THEN 'Menos de 10%'
        WHEN pagos_acumulados::NUMERIC /
             NULLIF(facturacion_acumulada, 0) * 100 < 30
            THEN '10% a menos de 30%'
        WHEN pagos_acumulados::NUMERIC /
             NULLIF(facturacion_acumulada, 0) * 100 < 60
            THEN '30% a menos de 60%'
        WHEN pagos_acumulados::NUMERIC /
             NULLIF(facturacion_acumulada, 0) * 100 <= 100
            THEN '60% a 100%'
        ELSE 'Más de 100%'
    END AS grupo_ratio_pago

FROM indicadores;
