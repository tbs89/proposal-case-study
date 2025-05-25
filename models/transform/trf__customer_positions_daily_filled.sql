

{{ config(
    materialized = 'view',
    unique_key = 'surrogate_key'
) }}

-- This model is used to store the customer positions daily data.
WITH customer__instruments AS (

    SELECT DISTINCT
        customer_account_id,
        customer_id,
        partner_id,
        instrument
    FROM {{ ref('trf__customer_positions_daily') }}

),

crossed_with_dates AS (

    SELECT
        customer__instruments.customer_account_id,
        customer__instruments.customer_id,
        customer__instruments.partner_id,
        customer__instruments.instrument,
        dim_time.date_day AS trade_date
    FROM customer__instruments
    CROSS JOIN {{ ref('trf__dim_time') }} dim_time

),

joined_positions AS (

    SELECT
        crossed.customer_account_id,
        crossed.customer_id,
        crossed.partner_id,
        crossed.instrument,
        price_snapshots.price,
        crossed.trade_date,
        evolution.cumulative_position,
        COALESCE(evolution.cumulative_position, 0) * price_snapshots.price AS cumulative_position_value
    FROM crossed_with_dates crossed
    LEFT JOIN {{ ref('trf__customer_positions_daily') }} evolution
        ON crossed.customer_account_id = evolution.customer_account_id
        AND crossed.instrument = evolution.instrument
        AND crossed.trade_date = evolution.trade_date
    LEFT JOIN {{ ref('trf__instrument_prices_filled') }} price_snapshots
        ON crossed.instrument = price_snapshots.instrument
        AND crossed.trade_date = price_snapshots.snapshot_date


),
/*
This is the correct way to fill the cumulative positions using Snowflake. Ignore NULLS is not supported in Postgres.
final_positions AS (

    SELECT
        customer_account_id,
        customer_id,
        partner_id,
        instrument,
        trade_date,
        LAST_VALUE(cumulative_position) IGNORE NULLS OVER (
            PARTITION BY customer_account_id, instrument
            ORDER BY trade_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_position,
        price,
        cumulative_position_value
    FROM joined_positions

),
*/

final_positions AS (

    SELECT
        customer_account_id,
        customer_id,
        partner_id,
        instrument,
        trade_date,
        MAX(cumulative_position) OVER (
            PARTITION BY customer_account_id, instrument
            ORDER BY trade_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_position,
        price,
        cumulative_position_value
    FROM joined_positions

),

/*
This is the correct way to fill the prices using Snowflake. Ignore NULLS is not supported in Postgres.
filled_prices AS (

    SELECT
        customer_account_id,
        customer_id,
        partner_id,
        instrument,
        trade_date,
        LAST_VALUE(price) IGNORE NULLS OVER (
            PARTITION BY customer_account_id, instrument
            ORDER BY trade_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS filled_price,
        cumulative_position
    FROM final_positions

)
*/

filled_prices AS (

    SELECT
        customer_account_id,
        customer_id,
        partner_id,
        instrument,
        trade_date,
        MAX(price) OVER (
            PARTITION BY customer_account_id, instrument
            ORDER BY trade_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS filled_price,
        cumulative_position
    FROM final_positions

)

SELECT
    NOW() AS _METADATA_UPDATED_AT,
    CONCAT(customer_account_id, '-', instrument, '-', trade_date) AS surrogate_key,
    customer_account_id,
    customer_id,
    partner_id,
    instrument,
    trade_date,
    COALESCE(cumulative_position, 0) AS cumulative_position,
    filled_price AS instrument_price,
    COALESCE(cumulative_position, 0) * filled_price AS cumulative_position_value
FROM filled_prices
ORDER BY customer_account_id, instrument, trade_date




