-- KPIs principales del proyecto Spotify Streaming Audit
-- Tabla esperada en DuckDB: spotify_clean
-- Dataset limpio con columnas en snake_case.
-- Nota: se usan umbrales inclusivos (<=49 y >=72) para mantener consistencia
-- con los cuartiles del EDA y aproximarse al 25% inferior/superior del catálogo.

-- KPI 1: Tasa de canciones en zona crítica
-- Pregunta de negocio:
-- ¿Qué porcentaje del catálogo puede perjudicar la experiencia premium?
-- Decisión:
-- Reducir la presencia de canciones con bajo rendimiento en playlists premium.

SELECT
    COUNT(CASE WHEN popularity <= 49 THEN 1 END) AS canciones_zona_critica,
    COUNT(*) AS total_canciones,
    ROUND(
        100.0 * COUNT(CASE WHEN popularity <= 49 THEN 1 END) / COUNT(*),
        2
    ) AS tasa_zona_critica_pct
FROM spotify_clean;


-- KPI 2: Tasa de potencial premium
-- Pregunta de negocio:
-- ¿Qué porcentaje del catálogo tiene potencial para playlists premium?
-- Decisión:
-- Priorizar canciones con Popularity Score igual o superior a 72.

SELECT
    COUNT(CASE WHEN popularity >= 72 THEN 1 END) AS canciones_premium,
    COUNT(*) AS total_canciones,
    ROUND(
        100.0 * COUNT(CASE WHEN popularity >= 72 THEN 1 END) / COUNT(*),
        2
    ) AS tasa_potencial_premium_pct
FROM spotify_clean;


-- KPI 3: Género con mayor rendimiento
-- Pregunta de negocio:
-- ¿Qué géneros tienen mayor Popularity Score promedio y deberían priorizarse?
-- Decisión:
-- Priorizar géneros de alto rendimiento en playlists premium,
-- recomendaciones automáticas y campañas promocionales.

SELECT
    top_genre AS genero,
    COUNT(*) AS total_canciones,
    ROUND(AVG(popularity), 2) AS popularity_promedio,
    MAX(popularity) AS popularity_maxima,
    MIN(popularity) AS popularity_minima,
    CASE
        WHEN AVG(popularity) >= 65 THEN 'Prioridad alta - playlist premium'
        WHEN AVG(popularity) >= 55 THEN 'Prioridad media - evaluar'
        ELSE 'No priorizar en playlists premium'
    END AS recomendacion
FROM spotify_clean
GROUP BY top_genre
HAVING COUNT(*) >= 20
ORDER BY popularity_promedio DESC
LIMIT 10;
