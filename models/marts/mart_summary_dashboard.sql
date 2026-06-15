{{ config(materialized='table', schema='marts') }}

SELECT
    borough,
    COUNT(*) AS total_hours_recorded,
    SUM(total_trips) AS total_trips,
    ROUND(AVG(total_trips), 1) AS avg_trips_per_hour,
    ROUND(AVG(avg_temperature), 1) AS avg_temperature,
    ROUND(AVG(avg_precipitation), 3) AS avg_precipitation,
    ROUND(AVG(member_pct), 1) AS avg_member_pct,
    ROUND(AVG(electric_pct), 1) AS avg_electric_pct,
    ROUND(AVG(rush_hour_pct), 1) AS avg_rush_hour_pct,
    ROUND(AVG(weekend_pct), 1) AS avg_weekend_pct,
    MAX(total_trips) AS peak_hour_trips
FROM {{ ref('mart_weather_bike_correlation') }}
GROUP BY borough
ORDER BY total_trips DESC