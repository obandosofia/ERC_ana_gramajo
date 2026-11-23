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

