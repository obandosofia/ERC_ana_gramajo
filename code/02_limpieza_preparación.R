install.packages("naniar")

# =========================================================
# SCRIPT 02: LIMPIEZA Y PREPARACIÓN DE DATOS
# Proyecto: Cohorte ERC - Seminario de Epidemiología II
# Autora: Ana Sofía Gramajo
# Fecha: Noviembre 2026
# =========================================================

# 1. Cargar librerías
library(tidyverse)
library(here)
library(skimr)
library(naniar)

# 2. Importar la base de datos original
base_raw <- read.csv(
  here("data", "raw", "base_erc_cohorte.csv"),
  encoding = "UTF-8"
)

# 3. Verificar la importación
cat("Base cargada:", nrow(base_raw), "participantes,",
    ncol(base_raw), "variables\n")


# 4. CORRECCIÓN DE TIPOS DE VARIABLES

base <- base_raw %>%
  mutate(
    # Variables categóricas ordinales
    estadio_basal = factor(
      estadio_basal,
      levels = c("G2", "G3a", "G3b", "G4"),
      ordered = TRUE
    ),
    
    nivel_educativo = factor(
      nivel_educativo,
      levels = c("Ninguno", "Primaria", "Secundaria",
                 "Tecnico", "Universitario"),
      ordered = TRUE
    ),
    
    # Variables categóricas nominales
    sexo = factor(sexo),
    etnia = factor(etnia),
    procedencia = factor(procedencia),
    etiologia_erc = factor(etiologia_erc),
    
    # Variables lógicas (0/1)
    diabetes = as.logical(diabetes),
    hipertension = as.logical(hipertension),
    cardiopatia_isquemica = as.logical(cardiopatia_isquemica),
    tabaquismo_actual = as.logical(tabaquismo_actual),
    tabaquismo_previo = as.logical(tabaquismo_previo),
    ieca_o_ara2 = as.logical(ieca_o_ara2),
    estatinas = as.logical(estatinas),
    perdida_seguimiento_m12 = as.logical(perdida_seguimiento_m12),
    perdida_seguimiento_m24 = as.logical(perdida_seguimiento_m24),
    progresion_g5_o_trr = as.logical(progresion_g5_o_trr)
  )

# Verificar los tipos de variables
cat("\nTipos de variables después de la corrección:\n")
sapply(base, class) %>% print()

# 5. IDENTIFICACIÓN DE VALORES ATÍPICOS

# Definir rangos esperados
rangos <- list(
  edad = c(30, 85),
  peso_kg_basal = c(35, 180),
  talla_cm = c(145, 185),
  imc_basal = c(15, 50),
  pas_mmhg_basal = c(80, 220),
  pad_mmhg_basal = c(40, 120),
  tfg_ml_min_basal = c(10, 89),
  creatinina_mg_dl_basal = c(0.4, 15),
  hemoglobina_g_dl_basal = c(5, 18),
  albumina_g_dl_basal = c(1.5, 5.5),
  proteinuria_mg_g_basal = c(20, 5500)
)

# Identificar valores fuera de rango
cat("=== VALORES FUERA DE RANGO ===\n")

atipicos_encontrados <- list()

for (var in names(rangos)) {
  
  fuera <- base %>%
    filter(
      !is.na(.data[[var]]),
      .data[[var]] < rangos[[var]][1] |
        .data[[var]] > rangos[[var]][2]
    ) %>%
    select(id_estudio, all_of(var))
  
  if (nrow(fuera) > 0) {
    cat("\nVariable:", var, "\n")
    print(fuera)
    atipicos_encontrados[[var]] <- fuera
  }
}

if (length(atipicos_encontrados) == 0) {
  cat("No se encontraron valores fuera de rango.\n")
}

# 6. VERIFICACIÓN DE LOS VALORES ATÍPICOS

# Examinar características clínicas de los participantes
base %>%
  filter(id_estudio %in% c(
    "ERC-0058", "ERC-0064", "ERC-0122",
    "ERC-0152", "ERC-0234"
  )) %>%
  select(
    id_estudio,
    edad,
    estadio_basal,
    tfg_ml_min_basal,
    creatinina_mg_dl_basal,
    peso_kg_basal,
    talla_cm,
    imc_basal
  ) %>%
  arrange(id_estudio) %>%
  print()

# 7. CORRECCIÓN DOCUMENTADA DE VALORES ATÍPICOS

# Conservar valores originales para comparación
base <- base %>%
  mutate(
    creatinina_original = creatinina_mg_dl_basal,
    peso_original = peso_kg_basal
  )

# Aplicar correcciones provisionales del ejercicio
base <- base %>%
  mutate(
    creatinina_mg_dl_basal = case_when(
      id_estudio == "ERC-0058" ~ 0.84,
      id_estudio == "ERC-0064" ~ 142 / 88.4,
      TRUE ~ creatinina_mg_dl_basal
    ),
    
    peso_kg_basal = case_when(
      id_estudio %in% c("ERC-0152", "ERC-0234") ~ NA_real_,
      TRUE ~ peso_kg_basal
    )
  )

# Comparar valores originales y corregidos
base %>%
  filter(id_estudio %in% c(
    "ERC-0058", "ERC-0064", "ERC-0122",
    "ERC-0152", "ERC-0234"
  )) %>%
  select(
    id_estudio,
    creatinina_original,
    creatinina_mg_dl_basal,
    peso_original,
    peso_kg_basal
  ) %>%
  print()

# Verificar cantidad de datos faltantes en peso
sum(is.na(base$peso_kg_basal))


# 8. VERIFICACIÓN DE CONSISTENCIA LÓGICA

# 1. Presión arterial: PAD debe ser menor que PAS
inconsistencia_pa <- base %>%
  filter(!is.na(pas_mmhg_basal) &
           !is.na(pad_mmhg_basal)) %>%
  filter(pad_mmhg_basal >= pas_mmhg_basal)

cat("Inconsistencias de presión arterial:",
    nrow(inconsistencia_pa), "casos\n")


# 2. Tabaquismo actual y previo
inconsistencia_tabaco <- base %>%
  filter(tabaquismo_actual == TRUE &
           tabaquismo_previo == TRUE)

cat("Inconsistencias de tabaquismo:",
    nrow(inconsistencia_tabaco), "casos\n")


# 3. Verificar coherencia del IMC
base <- base %>%
  mutate(
    imc_calculado = round(
      peso_kg_basal / (talla_cm / 100)^2, 1
    ),
    discrepancia_imc = abs(
      imc_basal - imc_calculado
    )
  )

inconsistencia_imc <- base %>%
  filter(!is.na(discrepancia_imc) &
           discrepancia_imc > 2)

cat("Discrepancias de IMC mayores a 2:",
    nrow(inconsistencia_imc), "casos\n")

# Mostrar registros inconsistentes
print(inconsistencia_imc %>%
        select(id_estudio, peso_kg_basal,
               talla_cm, imc_basal,
               imc_calculado))


# 9. CREACIÓN DE VARIABLES DERIVADAS

base <- base %>%
  mutate(
    
    # Grupos de edad
    grupo_edad = cut(
      edad,
      breaks = c(0, 45, 60, 75, Inf),
      labels = c("<45 años", "45-59 años",
                 "60-74 años", "75 años o más"),
      right = FALSE
    ),
    
    # Agrupación original de la guía
    estadio_agrupado = case_when(
      estadio_basal %in% c("G2", "G3a") ~
        "Leve-moderado (G2-G3a)",
      estadio_basal %in% c("G3b", "G4") ~
        "Moderado-severo (G3b-G4)",
      TRUE ~ NA_character_
    ) %>% factor(),
    
    # Agrupación recomendada por la profesora
    estadio_modelo = case_when(
      estadio_basal %in% c("G2", "G3a", "G3b") ~
        "G2-G3b",
      estadio_basal == "G4" ~ "G4",
      TRUE ~ NA_character_
    ) %>% factor(levels = c("G2-G3b", "G4")),
    
    # Etiología agrupada
    etiologia_agrupada = case_when(
      is.na(etiologia_erc) ~ NA_character_,
      etiologia_erc == "Diabetica" ~ "Diabética",
      etiologia_erc == "Hipertensiva" ~ "Hipertensiva",
      TRUE ~ "Otras / Desconocida"
    ) %>% factor(),
    
    # Transformación logarítmica
    log_proteinuria_basal = if_else(
      proteinuria_mg_g_basal > 0,
      log(proteinuria_mg_g_basal),
      NA_real_
    ),
    
    # Cambios en TFG
    cambio_tfg_m12 = tfg_ml_min_m12 -
      tfg_ml_min_basal,
    
    cambio_tfg_m24 = tfg_ml_min_m24 -
      tfg_ml_min_basal,
    
    # Tasa anual de cambio de TFG
    tasa_declive_tfg = (
      tfg_ml_min_m24 - tfg_ml_min_basal
    ) / 2,
    
    # Anemia basal
    anemia_basal = case_when(
      is.na(hemoglobina_g_dl_basal) |
        is.na(sexo) ~ NA,
      sexo == "Femenino" &
        hemoglobina_g_dl_basal < 12 ~ TRUE,
      sexo == "Masculino" &
        hemoglobina_g_dl_basal < 13 ~ TRUE,
      TRUE ~ FALSE
    )
  )

# Verificar las variables creadas
cat("Variables derivadas creadas correctamente\n")

table(base$grupo_edad, useNA = "ifany")

table(base$estadio_modelo, useNA = "ifany")

table(base$anemia_basal, useNA = "ifany")

# Eventos según agrupación recomendada
base %>%
  group_by(estadio_modelo) %>%
  summarise(
    participantes = n(),
    eventos = sum(progresion_g5_o_trr, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  print()

# 10. EVALUACIÓN DE DATOS FALTANTES

# Resumen de datos faltantes por variable
faltantes_resumen <- base %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(
    everything(),
    names_to = "variable",
    values_to = "n_faltantes"
  ) %>%
  mutate(
    pct = round(n_faltantes / nrow(base) * 100, 1)
  ) %>%
  filter(n_faltantes > 0) %>%
  arrange(desc(n_faltantes))

# Mostrar resultados
cat("=== RESUMEN DE DATOS FALTANTES ===\n")
print(faltantes_resumen, n = Inf)

# Visualizar patrón de datos faltantes

faltantes_seguimiento <- colSums(is.na(
  base[, c(
    "tfg_ml_min_m12",
    "hemoglobina_g_dl_m12",
    "albumina_g_dl_m12",
    "proteinuria_mg_g_m12",
    "tfg_ml_min_m24",
    "hemoglobina_g_dl_m24",
    "albumina_g_dl_m24",
    "proteinuria_mg_g_m24"
  )]
))

barplot(
  faltantes_seguimiento,
  horiz = TRUE,
  las = 1,
  cex.names = 0.6,
  main = "Datos faltantes en el seguimiento",
  xlab = "Número de valores faltantes"
)


# Evaluar faltantes de TFG al mes 12 según estadio basal
base %>%
  mutate(
    faltante_tfg_m12 = is.na(tfg_ml_min_m12)
  ) %>%
  count(estadio_basal, faltante_tfg_m12) %>%
  print()


# 11. CONSTRUCCIÓN FINAL DE LA BASE ANALÍTICA

# Conservar los 300 participantes
# Retirar variables auxiliares de verificación

base_analitica <- base %>%
  select(
    -imc_basal,
    -discrepancia_imc,
    -creatinina_original,
    -peso_original
  )

# Verificar dimensiones
cat("=== BASE ANALÍTICA FINAL ===\n")

cat("Participantes:",
    nrow(base_analitica), "\n")

cat("Variables:",
    ncol(base_analitica), "\n")

# Número de eventos de progresión
cat("Eventos de progresión:",
    sum(base_analitica$progresion_g5_o_trr,
        na.rm = TRUE), "\n")

# Número de pacientes con seguimiento al mes 24
cat("Sin pérdida de seguimiento al mes 24:",
    sum(base_analitica$perdida_seguimiento_m24 == FALSE,
        na.rm = TRUE), "\n")


# 12. EXPORTACIÓN DE LA BASE ANALÍTICA

# Guardar versión RDS

# Crear la carpeta processed si no existe
dir.create(
  here("data", "processed"),
  recursive = TRUE,
  showWarnings = FALSE
)

# Verificar que existe
dir.exists(here("data", "processed"))

saveRDS(
  base_analitica,
  here("data", "processed",
       "base_analitica_v1.0.rds")
)

# Guardar versión CSV
write.csv(
  base_analitica,
  here("data", "processed",
       "base_analitica_v1.0.csv"),
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

cat("\nBase analítica exportada correctamente\n")


# 13. INFORMACIÓN DE SESIÓN

capture.output(
  sessionInfo(),
  file = here("docs", "session_info_limpieza.txt")
)

cat("Información de sesión guardada\n")


# 14. MEMO DE DECISIONES DE PREPARACIÓN

writeLines(c(
  "MEMO DE PREPARACIÓN DE DATOS",
  "Proyecto: Cohorte de enfermedad renal crónica",
  "Autora: Ana Sofía Gramajo",
  "Fecha: Noviembre 2026",
  "",
  "1. IDENTIFICACIÓN Y CORRECCIÓN DE VALORES ATÍPICOS",
  "",
  "Creatinina basal:",
  "ERC-0058: 0.08 a 0.84 mg/dL.",
  "Corrección didáctica por posible error decimal.",
  "No verificada con el registro original.",
  "",
  "ERC-0064: 142 a 1.61 mg/dL aproximadamente.",
  "Se asumió un posible error de unidades:",
  "142 micromol/L dividido entre 88.4.",
  "Conversión pendiente de confirmación documental.",
  "",
  "ERC-0122: 18.50 mg/dL conservado.",
  "Valor extremo que requiere verificación clínica.",
  "",
  "Peso basal:",
  "ERC-0152: 198 kg reemplazado por NA.",
  "Inconsistente con talla e IMC registrados.",
  "",
  "ERC-0234: 8.5 kg reemplazado por NA.",
  "Valor incompatible con las características",
  "antropométricas registradas para un adulto.",
  "",
  "Las correcciones son decisiones del ejercicio.",
  "No representan verificaciones de datos originales.",
  "",
  "2. VARIABLES DERIVADAS",
  "",
  "Se crearon grupos de edad, estadio agrupado,",
  "etiología agrupada, logaritmo de proteinuria,",
  "cambios de TFG a 12 y 24 meses, tasa anual",
  "de cambio de TFG y presencia de anemia.",
  "",
  "Se conservó el estadio basal original.",
  "También se creó estadio_modelo: G2-G3b vs G4,",
  "siguiendo la recomendación de la profesora.",
  "",
  "3. DATOS FALTANTES",
  "",
  "TFG al mes 12: 37 de 300 registros faltantes",
  "(12.3%). El estadio G3b presentó 20% de",
  "datos faltantes en esta variable.",
  "",
  "No se realizó imputación de datos faltantes.",
  "El mecanismo de ausencia no está establecido.",
  "",
  "4. BASE ANALÍTICA",
  "",
  "Se conservaron los 300 participantes.",
  "Se excluyeron las variables auxiliares de",
  "verificación y el IMC original, reemplazado",
  "por el IMC calculado cuando fue posible.",
  "",
  "La base analítica se exportó en formatos",
  "RDS y CSV dentro de data/processed/.",
  "",
  "5. LIMITACIONES PARA EL MODELADO",
  "",
  "Se registraron 33 eventos de progresión.",
  "Agrupación G2-G3b: 247 participantes, 1 evento.",
  "Agrupación G4: 53 participantes, 32 eventos.",
  "El escaso número de eventos en una categoría",
  "puede producir estimaciones inestables.",
  "La agrupación también reduce el gradiente clínico",
  "entre los estadios originales."
),
here("docs", "memo_preparacion_datos.txt"))

cat("Memo de preparación creado correctamente\n")
