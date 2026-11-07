
import pandas as pd
from pathlib import Path

# ==========================================
# PROYECTO 02: CREDIT RISK ANALYTICS
# 01 - EXPLORACIÓN INICIAL
# ==========================================

# 1. Ruta exacta del archivo Excel
ruta_excel = Path(
    r"A:\portafolio\proyecto 2\Credit_Risk_Analytics\data\raw\default of credit card clients.xls"
)

# 2. Verificar que el archivo exista
if not ruta_excel.exists():
    raise FileNotFoundError(
        f"No se encontró el archivo: {ruta_excel}"
    )

# 3. Cargar el dataset
df = pd.read_excel(
    ruta_excel,
    header=1,
    engine="xlrd"
)

# 4. Dimensiones del dataset
print("\n=== CREDIT RISK ANALYTICS ===")
print("Archivo:", ruta_excel.name)
print("Total de filas:", df.shape[0])
print("Total de columnas:", df.shape[1])

# 5. Primeros registros
print("\n=== PRIMEROS 5 REGISTROS ===")
print(df.head())

# 6. Nombres de columnas
print("\n=== COLUMNAS ===")
print(df.columns.tolist())

# 7. Tipos de datos
print("\n=== TIPOS DE DATOS ===")
print(df.dtypes)

# 8. Valores faltantes
print("\n=== VALORES FALTANTES ===")
print(df.isnull().sum())

# 9. Duplicados
print("\n=== FILAS DUPLICADAS ===")
print(df.duplicated().sum())

# ==========================================
# 10. DIAGNÓSTICO DE CALIDAD DE DATOS
# ==========================================

print("\n=== IDENTIFICADORES ===")
print("ID únicos:", df["ID"].nunique())
print("ID duplicados:", df["ID"].duplicated().sum())

# Variables categóricas
variables_categoricas = [
    "SEX",
    "EDUCATION",
    "MARRIAGE",
    "PAY_0",
    "PAY_2",
    "PAY_3",
    "PAY_4",
    "PAY_5",
    "PAY_6"
]

print("\n=== DISTRIBUCIÓN DE CÓDIGOS ===")

for columna in variables_categoricas:
    print(f"\n{columna}:")
    print(df[columna].value_counts().sort_index())

# Validación de edad
print("\n=== EDAD ===")
print("Edad mínima:", df["AGE"].min())
print("Edad máxima:", df["AGE"].max())

# Validación de límite crediticio
print("\n=== LÍMITE DE CRÉDITO ===")
print("Mínimo:", df["LIMIT_BAL"].min())
print("Máximo:", df["LIMIT_BAL"].max())
print("Límites negativos:", (df["LIMIT_BAL"] < 0).sum())

# Variable objetivo
print("\n=== INCUMPLIMIENTO CREDITICIO ===")
print(df["default payment next month"].value_counts())
print(
    df["default payment next month"]
    .value_counts(normalize=True)
    .mul(100)
    .round(2)
)
