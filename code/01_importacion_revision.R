# ============================================
# SEMINARIO DE EPIDEMIOLOGÍA II
# Proyecto: Cohorte ERC
# Autora: Ana Sofía Gramajo
# Script 01: Importación y revisión inicial
# ============================================

# Cargar la base de datos
base_raw <- read.csv(
  "data/raw/base_erc_cohorte.csv",
  fileEncoding = "UTF-8"
)

# Verificar dimensiones
dim(base_raw)

# Revisar los primeros registros
head(base_raw)

# Nombres de las variables
names(base_raw)

# Estructura de la base de datos
str(base_raw)

# Resumen estadístico inicial
summary(base_raw)

# Revisar valores faltantes por variable
colSums(is.na(base_raw))

# Verificar identificadores duplicados
sum(duplicated(base_raw$id_estudio))
