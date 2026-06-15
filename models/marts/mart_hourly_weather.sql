{{ config(materialized='table', schema='marts') }}

SELECT
    borough,
    TIMESTAMP_TRUNC(hour, HOUR) AS hour,
    AVG(temperature_c) AS avg_temperature,
    AVG(precipitation_mm) AS avg_precipitation,
    AVG(windspeed_kmh) AS avg_windspeed,
    AVG(humidity_pct) AS avg_humidity,
    SUM(trip_count) AS total_trips,
    SUM(member_trips) AS total_member_trips,
    SUM(casual_trips) AS total_casual_trips,
    SUM(electric_trips) AS total_electric_trips
FROM `dm2-bike-weather.staging.weather_bikes_joined`
GROUP BY borough, TIMESTAMP_TRUNC(hour, HOUR)
ORDER BY borough, hour
