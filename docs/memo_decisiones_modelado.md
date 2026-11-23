# Memo de decisiones metodológicas — 

**Proyecto:** Cohorte de pacientes con enfermedad renal crónica (ERC)  
**Autora:** Ana Sofía Gramajo  
**Fecha:** Noviembre de 2026

## 1. Objetivo del análisis

Se implementaron tres modelos estadísticos para evaluar factores relacionados con la progresión de la enfermedad renal crónica y el cambio anual de la tasa de filtración glomerular (TFG): regresión logística, regresión lineal múltiple y regresión de riesgos proporcionales de Cox.

## 2. Recategorización del estadio basal

Siguiendo la recomendación de la profesora, para los modelos de progresión renal se utilizó la agrupación G2–G3b frente a G4.

Esta decisión respondió a la distribución desigual de los 33 eventos registrados. En G2–G3b se observó un evento entre 247 participantes, mientras que en G4 ocurrieron 32 eventos entre 53 participantes.

La agrupación permitió simplificar los modelos y evitar estimaciones separadas para categorías con eventos extremadamente escasos. Sin embargo, no resolvió completamente la dificultad, debido a que el grupo de referencia mantuvo únicamente un evento.

Además, esta recategorización implica una pérdida de información sobre el gradiente clínico entre los estadios originales.

## 3. Regresión logística

Se estimó un modelo crudo y un modelo ajustado por edad y log-proteinuria basal.

El modelo ajustado mostró una asociación estadísticamente significativa entre el estadio G4 y la progresión renal (OR = 380; IC del 95 %: 75.5–6,934; p < 0.001).

La selección de un número reducido de covariables respondió a los 33 eventos disponibles. A pesar de ello, la amplitud del intervalo de confianza indica una precisión limitada y posible inestabilidad de las estimaciones.

No se identificaron problemas relevantes de multicolinealidad. La prueba de Hosmer-Lemeshow no mostró evidencia estadísticamente significativa de falta de ajuste (p = 0.605), aunque su interpretación es limitada por la escasez de eventos.

## 4. Regresión lineal múltiple

Se utilizó como desenlace la tasa anual de cambio de TFG, incluyendo 246 participantes con información disponible.

Se conservaron los cuatro estadios originales de ERC para evaluar sus diferencias mediante un desenlace continuo.

El estadio G4, la diabetes mellitus y el uso de IECA o ARA2 mostraron asociaciones estadísticamente significativas con un cambio anual de TFG más negativo.

Los diagnósticos evidenciaron ligeras desviaciones de algunos supuestos. Se identificaron nueve observaciones por encima del umbral exploratorio de distancia de Cook.

El análisis de sensibilidad, realizado con 237 participantes, mostró que las tres asociaciones principales conservaron su dirección y significación estadística.

La asociación observada con IECA o ARA2 no debe interpretarse como un efecto perjudicial del tratamiento, debido a la posible confusión por indicación.

## 5. Análisis de supervivencia

Se estimaron curvas de Kaplan-Meier, una prueba de Log-rank y modelos de Cox crudo y ajustado.

El análisis mostró diferencias significativas en la supervivencia libre de progresión entre G2–G3b y G4 (Log-rank: p < 0.001).

El modelo de Cox ajustado por edad y log-proteinuria basal mostró un HR de 209 (IC del 95 %: 28.4–1,530; p < 0.001).

La prueba global de Schoenfeld no identificó evidencia estadísticamente significativa de incumplimiento del supuesto de riesgos proporcionales (p = 0.330).

Sin embargo, el único evento del grupo de referencia y la amplitud del intervalo de confianza limitan la precisión y estabilidad de los resultados. La definición de los tiempos de evento y censura deberá verificarse con la documentación de la base.

## 6. Limitaciones generales

Los resultados deben interpretarse considerando el número limitado de eventos, su distribución desigual y la reducción del gradiente clínico ocasionada por la agrupación de estadios.

También se identificaron datos faltantes durante el seguimiento, especialmente al mes 24. No se ha establecido el mecanismo de ausencia de estas mediciones.

La reducción del número de covariables disminuyó la complejidad de los modelos, pero no garantiza la ausencia de sobreajuste o sesgos.

Debido a estas limitaciones, las asociaciones observadas no deben interpretarse como relaciones causales.

Durante la verificación de la coherencia temporal de los datos se identificaron dos participantes (ERC-0162 y ERC-0268) que registraron progresión renal y pérdida de seguimiento tanto al mes 12 como al mes 24.
Sus tiempos registrados fueron de 610 y 516 días, respectivamente. Debido a que ambos tiempos superan los 365 días, existe incertidumbre sobre la secuencia temporal entre la pérdida de seguimiento y la ocurrencia del evento. 
Aunque el diccionario define la variable como el tiempo hasta el evento o último seguimiento, la documentación disponible no permite confirmar cómo se construyeron estos registros. Por tanto, se conservaron los datos originales sin modificaciones y se documentó esta inconsistencia potencial como una limitación pendiente de aclaración. En consecuencia, los resultados de supervivencia deben considerarse provisionales hasta confirmar la validez de los tiempos y la censura.

## 7. Consideración final

Las decisiones metodológicas buscaron equilibrar la factibilidad del ejercicio, la disponibilidad de información y la interpretación clínica de los resultados.

Los modelos proporcionan estimaciones útiles para fines académicos y exploratorios, pero requieren una validación crítica adicional antes de considerar definitivas sus conclusiones.