-- =====================================================
-- Spotify Streaming Audit
-- Business Queries - DA Ingeniería & SQL
-- Dataset: spotify_clean
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
-- igual o superior a 72 (segmento premium).
--------------------------------------------------------

SELECT
    artist,
    title,
    top_genre,
    year,
    popularity
FROM spotify_clean
WHERE popularity >= 72
ORDER BY popularity DESC;


--------------------------------------------------------
-- QUERY 2
-- Segmentación del catálogo por cuartiles
-- de Popularity.
--
-- Pregunta de negocio:
-- ¿Cómo se distribuye el catálogo entre
-- canciones de bajo y alto rendimiento?
--
-- Decisión:
-- Comparar el 25% inferior y el 25% superior
-- para identificar diferencias de rendimiento.
--------------------------------------------------------

SELECT
    title,
    artist,
    popularity,
    NTILE(4) OVER (ORDER BY popularity) AS popularity_quartile
FROM spotify_clean
ORDER BY popularity;


--------------------------------------------------------
-- QUERY 3
-- Géneros con mayor rendimiento promedio.
--
-- Pregunta de negocio:
-- ¿Qué géneros presentan mejor desempeño
-- dentro del catálogo?
--
-- Decisión:
-- Priorizar géneros de alto rendimiento en
-- playlists premium, recomendaciones y campañas.
--------------------------------------------------------

SELECT
    top_genre,
    COUNT(*) AS total_canciones,
    ROUND(AVG(popularity), 2) AS popularity_promedio
FROM spotify_clean
GROUP BY top_genre
HAVING COUNT(*) >= 20
ORDER BY popularity_promedio DESC;


--------------------------------------------------------
-- QUERY 4
-- Segmentación del catálogo por década.
--
-- Pregunta de negocio:
-- ¿Qué décadas tienen mejor rendimiento promedio?
--
-- Decisión:
-- Determinar qué épocas musicales deberían
-- tener mayor presencia en playlists premium.
--------------------------------------------------------

SELECT
    FLOOR(year / 10) * 10 AS decade,
    COUNT(*) AS total_canciones,
    ROUND(AVG(popularity), 2) AS popularity_promedio
FROM spotify_clean
GROUP BY decade
ORDER BY popularity_promedio DESC;
