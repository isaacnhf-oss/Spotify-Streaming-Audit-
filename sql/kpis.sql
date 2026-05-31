-- =====================================================
-- Spotify Streaming Audit
-- KPI Queries - DA Ingeniería & SQL
--
-- Tablas esperadas en DuckDB:
--   spotify         -> dataset limpio de Spotify con variables de EDA
--   spotify_grammy  -> dataset integrado Spotify + Grammy + clusters
--
-- Umbrales utilizados:
--   zona crítica       -> popularity <= 49
--   potencial premium  -> popularity >= 72
-- =====================================================


--------------------------------------------------------
-- KPI 1
-- Estado general del catálogo
--
-- Pregunta de negocio:
-- ¿Cuál es el estado general del catálogo musical?
--
-- Decisión:
-- Medir tamaño del catálogo, Popularity promedio,
-- zona crítica y potencial premium.
--------------------------------------------------------

SELECT
    COUNT(*) AS total_canciones,
    ROUND(AVG(popularity), 2) AS popularity_promedio,
    ROUND(MEDIAN(popularity), 2) AS popularity_mediana,
    SUM(CASE WHEN popularity <= 49 THEN 1 ELSE 0 END) AS canciones_zona_critica,
    ROUND(
        100.0 * SUM(CASE WHEN popularity <= 49 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS tasa_zona_critica_pct,
    SUM(CASE WHEN popularity >= 72 THEN 1 ELSE 0 END) AS canciones_premium,
    ROUND(
        100.0 * SUM(CASE WHEN popularity >= 72 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS tasa_potencial_premium_pct
FROM spotify;


--------------------------------------------------------
-- KPI 2
-- Benchmark premium por cuartil superior
--
-- Pregunta de negocio:
-- ¿Qué tan fuerte es el segmento superior del catálogo?
--
-- Decisión:
-- Usar Q4 como referencia para definir el estándar
-- de canciones candidatas premium.
--------------------------------------------------------

SELECT
    popularity_quartile,
    COUNT(*) AS total_canciones,
    ROUND(AVG(popularity), 2) AS popularity_promedio,
    MIN(popularity) AS popularity_minima,
    MAX(popularity) AS popularity_maxima
FROM spotify
WHERE popularity_quartile = 'Q4_alto'
GROUP BY popularity_quartile;


--------------------------------------------------------
-- KPI 3
-- Géneros prioritarios
--
-- Pregunta de negocio:
-- ¿Qué géneros tienen mejor Popularity promedio
-- y volumen suficiente?
--
-- Decisión:
-- Priorizar géneros con alto rendimiento y al menos
-- 20 canciones para evitar conclusiones por muestras pequeñas.
--------------------------------------------------------

SELECT
    top_genre AS genero,
    COUNT(*) AS total_canciones,
    ROUND(AVG(popularity), 2) AS popularity_promedio,
    ROUND(MEDIAN(popularity), 2) AS popularity_mediana,
    MAX(popularity) AS popularity_maxima,
    MIN(popularity) AS popularity_minima,
    ROUND(
        100.0 * SUM(CASE WHEN popularity >= 72 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS tasa_premium_pct,
    CASE
        WHEN AVG(popularity) >= 65 THEN 'Prioridad alta - playlist premium'
        WHEN AVG(popularity) >= 55 THEN 'Prioridad media - evaluar'
        ELSE 'No priorizar en playlists premium'
    END AS recomendacion
FROM spotify
GROUP BY top_genre
HAVING COUNT(*) >= 20
ORDER BY popularity_promedio DESC
LIMIT 10;


--------------------------------------------------------
-- KPI 4
-- Historial Grammy como señal complementaria
--
-- Pregunta de negocio:
-- ¿Qué proporción del catálogo pertenece a artistas
-- con historial Grammy y cómo se comporta su Popularity?
--
-- Decisión:
-- Usar Grammy como señal secundaria de prestigio,
-- no como criterio único de selección.
--------------------------------------------------------

SELECT
    artist_has_grammy_record,
    COUNT(*) AS total_canciones,
    ROUND(AVG(popularity), 2) AS popularity_promedio,
    ROUND(
        100.0 * SUM(CASE WHEN popularity >= 72 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS tasa_premium_pct
FROM spotify_grammy
GROUP BY artist_has_grammy_record
ORDER BY popularity_promedio DESC;


--------------------------------------------------------
-- KPI 5
-- Clusters musicales con mejor rendimiento
--
-- Pregunta de negocio:
-- ¿Qué vibes musicales muestran mejor desempeño?
--
-- Decisión:
-- Priorizar clusters con mayor Popularity promedio
-- para playlists premium por experiencia musical.
--------------------------------------------------------

SELECT
    cluster_name,
    COUNT(*) AS total_canciones,
    ROUND(AVG(popularity), 2) AS popularity_promedio,
    ROUND(
        100.0 * SUM(CASE WHEN popularity >= 72 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS tasa_premium_pct
FROM spotify_grammy
GROUP BY cluster_name
ORDER BY popularity_promedio DESC;
