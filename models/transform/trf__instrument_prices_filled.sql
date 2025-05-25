
{{ config(
    materialized = 'view'
) }}

WITH dim_time AS (
    SELECT date_day
    FROM {{ ref('trf__dim_time') }}
),

instruments AS (
    SELECT DISTINCT instrument
    FROM {{ ref('stg__price_snapshots') }}
),

crossed_instruments_dates AS (
    SELECT
        instruments.instrument,
        dim_time.date_day
    FROM instruments
    CROSS JOIN dim_time
),

joined_prices AS (
    SELECT
        crossed_instruments_dates.instrument,
        crossed_instruments_dates.date_day,
        price_snapshots.price
    FROM crossed_instruments_dates
    LEFT JOIN {{ ref('stg__price_snapshots') }} price_snapshots
        ON crossed_instruments_dates.instrument = price_snapshots.instrument
        AND crossed_instruments_dates.date_day = price_snapshots.snapshot_date
),

/*
This is the correct way to fill the prices using Snowflake. Ignore NULLS is not supported in Postgres.
filled_prices AS (
    SELECT
        instrument,
        date_day,
        LAST_VALUE(price) IGNORE NULLS OVER (
            PARTITION BY instrument
            ORDER BY date_day
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS filled_price
    FROM joined_prices
)
*/

filled_prices AS (
    SELECT
        instrument,
        date_day,
        MAX(price) OVER (
            PARTITION BY instrument
            ORDER BY date_day
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS filled_price
    FROM joined_prices
)

SELECT
    NOW() AS _METADATA_UPDATED_AT,
    instrument,
    date_day AS snapshot_date,
    filled_price AS price
FROM filled_prices
ORDER BY instrument, snapshot_date
