
from pathlib import Path
import pandas as pd

# ==========================================
# CREDIT RISK ANALYTICS
# 02 - LIMPIEZA Y PREPARACIÓN
# ==========================================

BASE_DIR = Path(__file__).resolve().parent.parent

ruta_entrada = (
    BASE_DIR / "data" / "raw"
    / "default of credit card clients.xls"
)

ruta_salida = (
    BASE_DIR / "data" / "processed"
    / "credit_risk_clean.csv"
)

# 1. Cargar datos originales
df = pd.read_excel(
    ruta_entrada,
    header=1,
    engine="xlrd"
)

# 2. Renombrar variable objetivo
df = df.rename(columns={
    "default payment next month": "default_next_month"
})

# 3. Crear categorías educativas
df["education_group"] = df["EDUCATION"].map({
    1: "Posgrado",
    2: "Universidad",
    3: "Secundaria",
    4: "Otros/no especificado",
    5: "Otros/no especificado",
    6: "Otros/no especificado",
    0: "Otros/no especificado"
})

# 4. Crear categorías de estado civil
df["marriage_group"] = df["MARRIAGE"].map({
    1: "Casado/a",
    2: "Soltero/a",
    3: "Otro",
    0: "No especificado"
})

# 5. Crear grupos de edad
df["age_group"] = pd.cut(
    df["AGE"],
    bins=[20, 30, 40, 50, 60, 100],
    labels=[
        "21-30",
        "31-40",
        "41-50",
        "51-60",
        "61+"
    ]
)

# 6. Crear grupos de límite crediticio
# Los límites están expresados en nuevos dólares taiwaneses (NTD)
df["credit_limit_group"] = pd.cut(
    df["LIMIT_BAL"],
    bins=[0, 50000, 100000, 200000, 500000, float("inf")],
    labels=[
        "Hasta 50 mil",
        "50-100 mil",
        "100-200 mil",
        "200-500 mil",
        "Más de 500 mil"
    ],
    include_lowest=True
)

# 7. Verificar calidad del dataset resultante
print("=== VALIDACIÓN DE LIMPIEZA ===")
print("Filas:", len(df))
print("Columnas:", len(df.columns))
print("ID duplicados:", df["ID"].duplicated().sum())
print("Valores faltantes:", df.isnull().sum().sum())

print("\n=== EDUCACIÓN ===")
print(df["education_group"].value_counts())

print("\n=== ESTADO CIVIL ===")
print(df["marriage_group"].value_counts())

print("\n=== GRUPOS DE EDAD ===")
print(df["age_group"].value_counts().sort_index())

print("\n=== GRUPOS DE CRÉDITO ===")
print(df["credit_limit_group"].value_counts().sort_index())

print("\n=== TASA DE INCUMPLIMIENTO ===")
print(round(df["default_next_month"].mean() * 100, 2), "%")

# 8. Exportar dataset procesado
ruta_salida.parent.mkdir(
    parents=True,
    exist_ok=True
)

df.to_csv(
    ruta_salida,
    index=False,
    encoding="utf-8-sig"
)

print("\nArchivo generado:")
print(ruta_salida)
