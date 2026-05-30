-- =====================================================
-- Spotify Streaming Audit
-- Business Queries - DA Ingeniería & SQL
-- Dataset registrado en DuckDB: spotify
-- Base: Spotify limpio + variables integradas con Grammy
-- =====================================================

--------------------------------------------------------
-- QUERY 1
-- ¿Qué canciones tienen potencial premium?
--
-- Pregunta de negocio:
-- ¿Qué canciones deberían incluirse en playlists premium?
--
-- Decisión:
-- Seleccionar canciones con Popularity Score
-- igual o superior a 72.
--------------------------------------------------------

SELECT
    artist,
    title,
    top_genre,
    year,
    decade,
    popularity,
    artist_has_grammy_record
FROM spotify
WHERE popularity >= 72
ORDER BY popularity DESC;


--------------------------------------------------------
-- QUERY 2
-- Segmentación del catálogo por cuartiles de Popularity.
--
-- Pregunta de negocio:
-- ¿Cómo se distribuye el catálogo entre canciones
-- de bajo, medio y alto rendimiento?
--
-- Decisión:
-- Comparar el 25% inferior y el 25% superior
-- para identificar diferencias de rendimiento.
--------------------------------------------------------

SELECT
    popularity_quartile,
    COUNT(*) AS total_canciones,
    MIN(popularity) AS popularity_minima,
    MAX(popularity) AS popularity_maxima,
    ROUND(AVG(popularity), 2) AS popularity_promedio,
    ROUND(AVG(energy), 2) AS energy_promedio,
    ROUND(AVG(danceability), 2) AS danceability_promedio,
    ROUND(AVG(acousticness), 2) AS acousticness_promedio,
    ROUND(AVG(valence), 2) AS valence_promedio
FROM spotify
GROUP BY popularity_quartile
ORDER BY popularity_quartile;


--------------------------------------------------------
-- QUERY 3
-- Géneros con mayor rendimiento promedio.
--
-- Pregunta de negocio:
-- ¿Qué géneros presentan mejor desempeño dentro del catálogo?
--
-- Decisión:
-- Priorizar géneros de alto rendimiento en playlists premium,
-- recomendaciones y campañas.
--------------------------------------------------------

SELECT
    top_genre,
    COUNT(*) AS total_canciones,
    ROUND(AVG(popularity), 2) AS popularity_promedio,
    ROUND(
        100.0 * SUM(CASE WHEN popularity >= 72 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS tasa_premium_pct,
    ROUND(
        100.0 * SUM(CASE WHEN popularity <= 49 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS tasa_zona_critica_pct
FROM spotify
GROUP BY top_genre
HAVING COUNT(*) >= 20
ORDER BY popularity_promedio DESC
LIMIT 10;


--------------------------------------------------------
-- QUERY 4
-- Segmentación del catálogo por década.
--
-- Pregunta de negocio:
-- ¿Qué décadas tienen mejor rendimiento promedio?
--
-- Decisión:
-- Determinar qué épocas musicales deberían tener mayor
-- presencia en playlists premium.
--------------------------------------------------------

SELECT
    decade,
    COUNT(*) AS total_canciones,
    ROUND(AVG(popularity), 2) AS popularity_promedio,
    ROUND(
        100.0 * SUM(CASE WHEN popularity >= 72 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS tasa_premium_pct,
    ROUND(
        100.0 * SUM(CASE WHEN popularity <= 49 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS tasa_zona_critica_pct
FROM spotify
GROUP BY decade
ORDER BY popularity_promedio DESC;


--------------------------------------------------------
-- QUERY 5
-- Historial Grammy como señal secundaria.
--
-- Pregunta de negocio:
-- ¿Los artistas con historial Grammy presentan mayor Popularity?
--
-- Decisión:
-- Evaluar si Grammy puede usarse como criterio complementario
-- en la selección premium.
--------------------------------------------------------

SELECT
    artist_has_grammy_record,
    COUNT(*) AS total_canciones,
    ROUND(AVG(popularity), 2) AS popularity_promedio,
    ROUND(
        100.0 * SUM(CASE WHEN popularity >= 72 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS tasa_premium_pct,
    ROUND(
        100.0 * SUM(CASE WHEN popularity <= 49 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS tasa_zona_critica_pct
FROM spotify
GROUP BY artist_has_grammy_record
ORDER BY popularity_promedio DESC;
