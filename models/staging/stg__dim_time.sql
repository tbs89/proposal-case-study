{{ config(
    materialized = 'table',
    unique_key = 'customer_account_id'
) }}

-- This model is used to cast the calendar data.
WITH seed_calendar AS (

    SELECT * 
    FROM {{ ref('seed_calendar') }}

),

casted_calendar AS (

    SELECT 
        CAST(date AS DATE) AS date,
        CAST(day_of_week AS TEXT) AS day_of_week
    FROM seed_calendar

)

SELECT
    NOW() AS _METADATA_UPDATED_AT,
    date,
    day_of_week
FROM casted_calendar
