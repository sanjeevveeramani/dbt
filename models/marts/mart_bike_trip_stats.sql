{{ config(materialized='table', schema='marts') }}

SELECT
    borough,
    TIMESTAMP_TRUNC(hour, HOUR) AS hour,
    EXTRACT(DAYOFWEEK FROM hour) AS day_of_week,
    EXTRACT(HOUR FROM hour) AS hour_of_day,
    SUM(trip_count) AS total_trips,
    SUM(member_trips) AS total_member_trips,
    SUM(casual_trips) AS total_casual_trips,
    SUM(electric_trips) AS total_electric_trips,
    ROUND(SAFE_DIVIDE(SUM(member_trips), SUM(trip_count)) * 100, 2) AS member_pct,
    ROUND(SAFE_DIVIDE(SUM(electric_trips), SUM(trip_count)) * 100, 2) AS electric_pct
FROM `dm2-bike-weather.staging.weather_bikes_joined`
GROUP BY borough, TIMESTAMP_TRUNC(hour, HOUR), day_of_week, hour_of_day
ORDER BY borough, hour