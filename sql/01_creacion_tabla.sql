
-- ============================================
-- CREDIT RISK ANALYTICS
-- 01 - CREACIÓN DE TABLA
-- ============================================

CREATE TABLE IF NOT EXISTS credit_clients (

    -- Identificación del cliente
    "ID" INTEGER PRIMARY KEY,

    -- Información demográfica y financiera
    "LIMIT_BAL" INTEGER,
    "SEX" INTEGER,
    "EDUCATION" INTEGER,
    "MARRIAGE" INTEGER,
    "AGE" INTEGER,

    -- Historial de comportamiento de pago
    "PAY_0" INTEGER,
    "PAY_2" INTEGER,
    "PAY_3" INTEGER,
    "PAY_4" INTEGER,
    "PAY_5" INTEGER,
    "PAY_6" INTEGER,

    -- Montos facturados
    "BILL_AMT1" INTEGER,
    "BILL_AMT2" INTEGER,
    "BILL_AMT3" INTEGER,
    "BILL_AMT4" INTEGER,
    "BILL_AMT5" INTEGER,
    "BILL_AMT6" INTEGER,

    -- Montos pagados
    "PAY_AMT1" INTEGER,
    "PAY_AMT2" INTEGER,
    "PAY_AMT3" INTEGER,
    "PAY_AMT4" INTEGER,
    "PAY_AMT5" INTEGER,
    "PAY_AMT6" INTEGER,

    -- Variable objetivo
    default_next_month INTEGER,

    -- Variables creadas con Python
    education_group TEXT,
    marriage_group TEXT,
    age_group TEXT,
    credit_limit_group TEXT
);
