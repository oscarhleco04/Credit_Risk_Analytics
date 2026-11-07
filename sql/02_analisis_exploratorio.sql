
-- ============================================
-- CREDIT RISK ANALYTICS
-- 02 - ANÁLISIS EXPLORATORIO
-- ============================================

-- 1. Indicadores generales de la cartera

SELECT
    COUNT(*) AS total_clientes,

    SUM(default_next_month) AS clientes_incumplidos,

    COUNT(*) - SUM(default_next_month)
        AS clientes_sin_incumplimiento,

    ROUND(
        AVG(default_next_month::NUMERIC) * 100,
        2
    ) AS tasa_incumplimiento_pct,

    ROUND(
        AVG("LIMIT_BAL"::NUMERIC),
        2
    ) AS limite_credito_promedio,

    SUM("LIMIT_BAL"::BIGINT)
        AS limite_credito_total

FROM public.credit_clients;
