{{ config(materialized='table', schema='marts') }}

SELECT
    borough,
    TIMESTAMP_TRUNC(hour, HOUR) AS hour,
    AVG(temperature_c) AS avg_temperature,
    AVG(precipitation_mm) AS avg_precipitation,
    AVG(windspeed_kmh) AS avg_windspeed,
    ANY_VALUE(temperature_bucket) AS temperature_bucket,
    SUM(trip_count) AS total_trips,
    SUM(member_trips) AS total_member_trips,
    SUM(casual_trips) AS total_casual_trips,
    SUM(electric_trips) AS total_electric_trips,
    CASE
        WHEN AVG(precipitation_mm) > 1 THEN 'Rainy'
        WHEN AVG(temperature_c) < 5 THEN 'Cold'
        WHEN AVG(temperature_c) > 20 THEN 'Warm'
        ELSE 'Mild'
    END AS weather_category,
    ROUND(SAFE_DIVIDE(SUM(member_trips), SUM(trip_count)) * 100, 2) AS member_pct,
    ROUND(SAFE_DIVIDE(SUM(electric_trips), SUM(trip_count)) * 100, 2) AS electric_pct,
    ROUND(AVG(rush_hour_ratio) * 100, 2) AS rush_hour_pct,
    ROUND(AVG(weekend_ratio) * 100, 2) AS weekend_pct
FROM {{ source('staging', 'weather_bikes_joined') }}
GROUP BY borough, TIMESTAMP_TRUNC(hour, HOUR)
ORDER BY borough, hour