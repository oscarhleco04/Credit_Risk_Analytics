
-- ============================================
-- CREDIT RISK ANALYTICS
-- 03 - ANÁLISIS DE SEGMENTACIÓN
-- ============================================

-- 1. Riesgo crediticio por grupo de edad

SELECT
    age_group AS grupo_edad,

    COUNT(*) AS total_clientes,

    SUM(default_next_month)
        AS clientes_incumplidos,

    ROUND(
        AVG(default_next_month::NUMERIC) * 100,
        2
    ) AS tasa_incumplimiento_pct,

    ROUND(
        AVG("LIMIT_BAL"::NUMERIC),
        2
    ) AS limite_credito_promedio

FROM public.credit_clients

GROUP BY age_group

ORDER BY
    MIN("AGE");


-- 2. Riesgo crediticio por nivel educativo

SELECT
    education_group AS nivel_educativo,

    COUNT(*) AS total_clientes,

    SUM(default_next_month)
        AS clientes_incumplidos,

    ROUND(
        AVG(default_next_month::NUMERIC) * 100,
        2
    ) AS tasa_incumplimiento_pct

FROM public.credit_clients

GROUP BY education_group

ORDER BY tasa_incumplimiento_pct DESC;


-- 3. Riesgo por límite crediticio

SELECT
    credit_limit_group AS rango_credito,

    COUNT(*) AS total_clientes,

    SUM(default_next_month)
        AS clientes_incumplidos,

    ROUND(
        AVG(default_next_month::NUMERIC) * 100,
        2
    ) AS tasa_incumplimiento_pct

FROM public.credit_clients

GROUP BY credit_limit_group

ORDER BY MIN("LIMIT_BAL");
