# Spotify-Streaming-Audit-
Solución desarrollada en el Hackaton Spotify Streaming Audit, utilizando trabajo colaborativo de análisis de datos y ciencia de datos. Utilizando tecnologías como Python, Tableau, DuckDB y algoritmos de aprendizaje automático.

🎧 Spotify Playlist Optimizer — Hackathon Data Analysis
Problema de Negocio
Una plataforma de streaming musical cuenta con un catálogo de 1,994 canciones
sin criterio de selección para sus playlists premium. El 25% del catálogo
presenta un Popularity Score menor a 49, lo que puede estar afectando
negativamente la experiencia del usuario y la retención.

## 🎯 Misión del Proyecto

Identificar qué segmentos del catálogo funcionan y cuáles no, entregando recomendaciones concretas y accionables respaldadas por datos para optimizar la toma de decisiones estratégicas.

---

## 🛠️ Stack Tecnológico

El proyecto está desarrollado utilizando las siguientes herramientas y librerías:

* **Lenguaje Principal:** `Python`
* **Procesamiento y Modelado:** `pandas`, `scikit-learn`
* **Visualización de Datos:** `plotly`
* **Motor de Base de Datos & Analytics:** `DuckDB` (SQL analytics)
* **Entorno de Desarrollo:** `Jupyter Notebooks`
* **Control de Versiones:** `GitHub`

---
📓 Notebook final

El notebook principal del proyecto se encuentra en:

`notebooks/Spotify_Hackathon_proyecto_final.ipynb`

> Nota: si GitHub no renderiza correctamente el notebook `.ipynb`, revisar la versión HTML en `notebooks/Spotify_Hackathon_proyecto_final.html` o descargar el notebook para ejecutarlo localmente. 
> El cuaderno de desarrollo activo de EDA se encuentra en `notebooks/EDA_Dev.ipynb`. 

## 📂 Estructura del Proyecto

```text
.
├── data/
│   ├── raw/            # Dataset original sin modificar
│   └── processed/      # Datos limpios listos para análisis y modelado
├── models/             # Modelos predictivos
├── notebooks/          # Notebooks del proyecto: incluye el notebook final, HTML de revisión, limpieza, EDA y modelos
├── src/                # Scripts necesarios para los análisis y generación de modelos
├── visualizations/     # Gráficas e imágenes exportadas
├── presentation/       # Presentación en formato Pitch Ejecutivo para negocio
└── requirements.txt    # Dependencias y librerías del proyecto

```

## 🎯 Contexto del Proyecto


* **Situación:** Catálogo de 2,000 canciones con métricas acústicas sin un criterio de selección claro.
* **Complicación:** Datos de prestigio (Grammys) desconectados de los de rendimiento (Spotify).
* **Pregunta:** ¿Cómo integrar y modelar estos datos para predecir la popularidad y segmentar las canciones en playlists *premium*?
* **Respuesta:** Implementación de un flujo que incluye EDA con **Pandas**, consultas de segmentación en **DuckDB**, modelos de **Regresión** y **Clustering (K-Means)**, presentados en un **Dashboard interactivo**.


## Equipo y Roles

### 🎨 Isbeth Hernández 
* **Rol:** DA Visualización
* **Responsabilidades:** * Diseño y desarrollo del tablero en **Tableau**.
  * Integración de datos limpios y resultados de los modelos predictivos.
  * Cumplimiento de las 4 visualizaciones obligatorias y configuración del filtro interactivo.

---

### 🧠 Isaac Isai Noh Flores
* **Rol:** Data Scientist & Control de Versiones
* **Responsabilidades:**
  * Creación y gestión del repositorio del proyecto.
  * Validación de que los insumos y resultados cumplan con la problemática del negocio para alimentar los modelos predictivos.
  * Desarrollo e implementación de los modelos predictivos.

---

### 📊 Mónica Ibarra
* **Rol:** DA Business
* **Responsabilidades:**
  * Realización del Análisis Exploratorio de Datos (EDA).
  * Estudio de distribuciones, análisis de correlación y segmentación.
  * Redacción y estructuración del reporte de negocio.

---

### 🛠️ Maria Paz Munita Vidal
* **Rol:** DA Ingeniería & SQL
* **Responsabilidades:**
  * Calidad de datos, limpieza profunda y ejecución de consultas en **DuckDB**.
  * Entrega de datasets limpios para el EDA y estructuración de consultas para la visualización.
  * Revisión de la limpieza del código, comentarios y aseguramiento de buenas prácticas de desarrollo.

## Resultados Clave

- Se identificaron segmentos de alto rendimiento y zona crítica mediante `Popularity Score`.
- Se analizaron géneros, décadas y atributos acústicos para definir criterios de priorización.
- Se integró el dataset Grammy Awards como señal complementaria de prestigio musical.
- Se implementaron consultas en DuckDB para responder preguntas de negocio.
- Se entrenó un modelo de regresión para estimar `Popularity` a partir de atributos acústicos.
- Se aplicó K-Means para segmentar canciones en perfiles o vibes musicales.
- Se exportaron insumos para el dashboard en Tableau.


