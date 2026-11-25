\# Análisis reproducible de una cohorte de pacientes con enfermedad renal crónica



\*\*Autora:\*\* Ana Sofía Gramajo  

\*\*Curso:\*\* Seminario de Epidemiología Clínica II  

\*\*Programa:\*\* Maestría en Epidemiología Clínica



\## Descripción del proyecto



Este repositorio contiene el desarrollo de un proyecto analítico reproducible utilizando una base de datos sintética de 300 pacientes con enfermedad renal crónica (ERC) en estadios G2 a G4, con seguimiento durante 24 meses.



El objetivo es aplicar herramientas de organización, limpieza, análisis estadístico y generación de reportes reproducibles mediante R y RStudio.



\## Estructura del repositorio



\- `code/`: scripts de R y documentos R Markdown.

\- `data/raw/`: base de datos original sin modificaciones.

\- `data/processed/`: bases de datos preparadas para el análisis.

\- `docs/`: diccionario de variables, fuentes de datos y documentación.

\- `output/figures/`: figuras y gráficos.

\- `output/tables/`: tablas de resultados.



\## Análisis previstos



1\. Importación y exploración de datos.

2\. Limpieza y preparación de la base analítica.

3\. Análisis exploratorio y descriptivo.

4\. Regresión logística.

5\. Regresión lineal múltiple.

6\. Análisis de supervivencia mediante modelos de Cox.

7\. Validación de resultados y análisis de sensibilidad.

8\. Elaboración del reporte final reproducible.



\## Herramientas



R, RStudio, Git, GitHub y R Markdown.



\## Reproducibilidad



Los scripts se ejecutan desde el proyecto de RStudio. Para reproducir los resultados, es necesario disponer de la base original `base\_erc\_cohorte.csv` dentro de `data/raw/`.



Las carpetas `data/raw/` y `data/processed/` están excluidas del control de versiones mediante `.gitignore`.



\## Fuente de datos



Base sintética proporcionada para las prácticas del Módulo II del Seminario de Epidemiología Clínica II.






## Estado del proyecto

**Versión actual:** v1.0 - Análisis final

**Proyecto:** Cohorte de pacientes con enfermedad renal crónica (ERC).

**Curso:** Seminario de Epidemiología II.

**Autora:** Ana Sofía Gramajo.

### Productos generados

El proyecto incluye los análisis estadísticos y un reporte final reproducible desarrollado mediante R Markdown.

**Reporte final:**
- `code/08_reporte_final.Rmd`
- `code/08_reporte_final.html`

**Tablas:**
- `output/tables/tabla_01_caracteristicas_basales.docx`
- `output/tables/tabla_02_or_ajustados.docx`
- `output/tables/tabla_03_hr_ajustados.docx`
- `output/tables/tabla_04_regresion_lineal.docx`

**Figuras:**
- `output/figures/figura_01_tfg_declive_estadio.png`
- `output/figures/figura_02_kaplan_meier.png`

### Cómo reproducir el análisis

1. Clonar el repositorio de GitHub.
2. Colocar la base sintética `base_erc_cohorte.csv` en `data/raw/`.
3. Instalar los paquetes de R utilizados.
4. Ejecutar los scripts de preparación y análisis en orden numérico.
5. Generar `code/08_reporte_final.Rmd` mediante Knit.
6. Consultar los productos exportados en `output/tables/` y `output/figures/`.

### Consideraciones metodológicas

Los datos utilizados son sintéticos y fueron proporcionados con fines académicos.

Los análisis de progresión utilizaron la agrupación G2-G3b frente a G4 debido a la distribución desigual de eventos.

Se realizaron evaluaciones de supuestos estadísticos y análisis de sensibilidad.

Permanece pendiente la verificación de la secuencia temporal de dos registros con progresión renal y pérdida de seguimiento.

### Reproducibilidad

Los análisis se desarrollaron en RStudio mediante R Markdown. Los reportes contienen código, resultados estadísticos e información de sesión para documentar las versiones de R y los paquetes utilizados.

La base de datos no debe publicarse en el repositorio de GitHub.

