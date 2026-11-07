
-- ============================================
-- CREDIT RISK ANALYTICS
-- 04 - HISTORIAL DE PAGOS
-- ============================================

-- Incumplimiento según estado de pago reciente

WITH comportamiento AS (
    SELECT
        CASE
            WHEN "PAY_0" <= 0
                THEN 'Sin retraso positivo registrado'
            WHEN "PAY_0" = 1
                THEN '1 mes de retraso'
            WHEN "PAY_0" = 2
                THEN '2 meses de retraso'
            ELSE '3 o más meses de retraso'
        END AS estado_pago,

        CASE
            WHEN "PAY_0" <= 0 THEN 1
            WHEN "PAY_0" = 1 THEN 2
            WHEN "PAY_0" = 2 THEN 3
            ELSE 4
        END AS orden,

        default_next_month

    FROM public.credit_clients
)

SELECT
    estado_pago,
    COUNT(*) AS total_clientes,
    SUM(default_next_month) AS clientes_incumplidos,

    ROUND(
        AVG(default_next_month::NUMERIC) * 100,
        2
    ) AS tasa_incumplimiento_pct

FROM comportamiento

GROUP BY estado_pago, orden
ORDER BY orden;
