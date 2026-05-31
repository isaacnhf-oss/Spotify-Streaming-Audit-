-- =====================================================
-- Spotify Streaming Audit
-- Business Queries - DA Ingeniería & SQL
--
-- Tablas esperadas en DuckDB:
--   spotify         -> dataset limpio de Spotify con variables de EDA
--   spotify_grammy  -> dataset integrado Spotify + Grammy + clusters
--
-- Estas queries están alineadas con el notebook final:
-- notebooks/Spotify_Hackathon_proyecto_final.ipynb
-- =====================================================


--------------------------------------------------------
-- QUERY 1
-- Candidatas premium
--
-- Pregunta de negocio:
-- ¿Qué canciones deberían incluirse inicialmente
-- en playlists premium?
--
-- Decisión:
-- Seleccionar canciones con Popularity Score >= 72,
-- incorporando género, década, cluster musical
-- e historial Grammy como señales complementarias.
--------------------------------------------------------

SELECT
    title,
    artist,
    top_genre,
    year,
    decade,
    popularity,
    cluster_name,
    artist_has_grammy_record
FROM spotify_grammy
WHERE popularity >= 72
ORDER BY popularity DESC;


--------------------------------------------------------
-- QUERY 2
-- Segmentación del catálogo por década
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
    ROUND(MEDIAN(popularity), 2) AS popularity_mediana,
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
ORDER BY decade;


--------------------------------------------------------
-- QUERY 3
-- Segmentación del catálogo por cuartiles de Popularity
--
-- Pregunta de negocio:
-- ¿Qué caracteriza al 25% superior del catálogo
-- frente al resto?
--
-- Decisión:
-- Usar el cuartil superior como benchmark inicial
-- para playlists premium.
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
-- QUERY 4
-- Géneros con mayor potencial premium
--
-- Pregunta de negocio:
-- ¿Qué géneros combinan alto rendimiento y volumen suficiente?
--
-- Decisión:
-- Priorizar géneros sólidos para playlists premium,
-- recomendaciones y campañas.
--------------------------------------------------------

SELECT
    top_genre,
    COUNT(*) AS total_canciones,
    ROUND(AVG(popularity), 2) AS popularity_promedio,
    ROUND(MEDIAN(popularity), 2) AS popularity_mediana,
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
-- QUERY 5
-- Historial Grammy como señal secundaria
--
-- Pregunta de negocio:
-- ¿Las canciones de artistas con historial Grammy
-- presentan mejor rendimiento promedio?
--
-- Decisión:
-- Evaluar si Grammy puede utilizarse como criterio
-- complementario de prestigio, sin reemplazar Popularity.
--------------------------------------------------------

SELECT
    artist_has_grammy_record,
    COUNT(*) AS total_canciones,
    ROUND(AVG(popularity), 2) AS popularity_promedio,
    ROUND(MEDIAN(popularity), 2) AS popularity_mediana,
    ROUND(
        100.0 * SUM(CASE WHEN popularity >= 72 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS tasa_premium_pct,
    ROUND(
        100.0 * SUM(CASE WHEN popularity <= 49 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS tasa_zona_critica_pct
FROM spotify_grammy
GROUP BY artist_has_grammy_record
ORDER BY popularity_promedio DESC;


--------------------------------------------------------
-- QUERY 6
-- Clusters de vibes musicales
--
-- Pregunta de negocio:
-- ¿Qué perfiles musicales tienen mejor desempeño
-- y podrían convertirse en playlists premium por vibe?
--
-- Decisión:
-- Priorizar clusters con alta Popularity promedio,
-- suficiente volumen y baja tasa de zona crítica.
--------------------------------------------------------

SELECT
    cluster_name,
    COUNT(*) AS total_canciones,
    ROUND(AVG(popularity), 2) AS popularity_promedio,
    ROUND(MEDIAN(popularity), 2) AS popularity_mediana,
    ROUND(
        100.0 * SUM(CASE WHEN popularity >= 72 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS tasa_premium_pct,
    ROUND(
        100.0 * SUM(CASE WHEN popularity <= 49 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS tasa_zona_critica_pct,
    ROUND(
        100.0 * SUM(CASE WHEN artist_has_grammy_record = TRUE THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS artistas_grammy_pct
FROM spotify_grammy
GROUP BY cluster_name
ORDER BY popularity_promedio DESC;
