{{ config(materialized='table', schema='marts') }}

SELECT
    borough,
    TIMESTAMP_TRUNC(hour, HOUR) AS hour,
    AVG(temperature_c) AS avg_temperature,
    AVG(precipitation_mm) AS avg_precipitation,
    AVG(windspeed_kmh) AS avg_windspeed,
    SUM(trip_count) AS total_trips,
    CASE
        WHEN AVG(precipitation_mm) > 1 THEN 'Rainy'
        WHEN AVG(temperature_c) < 5 THEN 'Cold'
        WHEN AVG(temperature_c) > 20 THEN 'Warm'
        ELSE 'Mild'
    END AS weather_category,
    ROUND(SAFE_DIVIDE(SUM(member_trips), SUM(trip_count)) * 100, 2) AS member_pct,
    ROUND(SAFE_DIVIDE(SUM(electric_trips), SUM(trip_count)) * 100, 2) AS electric_pct
FROM `dm2-bike-weather.staging.weather_bikes_joined`
GROUP BY borough, TIMESTAMP_TRUNC(hour, HOUR)
ORDER BY borough, hour