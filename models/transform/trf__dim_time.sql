{{ config(
    materialized = 'view',
    unique_key = 'date_day'
) }}

WITH min_and_max_date AS (
    SELECT
        MIN(trade_date) AS min_date,
        MAX(trade_date) AS max_date
    FROM {{ ref('stg__trades') }}
),

filtered_dates AS (
    SELECT
        date AS date_day,
        day_of_week
    FROM {{ ref('stg__dim_time') }}
    WHERE date BETWEEN (SELECT min_date FROM min_and_max_date)
                    AND (SELECT max_date FROM min_and_max_date)
)

SELECT
    NOW() AS _METADATA_UPDATED_AT,
    date_day,
    day_of_week
FROM filtered_dates
ORDER BY date_day
