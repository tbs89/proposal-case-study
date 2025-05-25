{{ config(
    materialized = 'table',
    unique_key = 'surrogate_key'
) }}

-- This model is used to store the customer positions daily data.
SELECT
    NOW() AS _METADATA_UPDATED_AT,
    surrogate_key,
    customer_account_id,
    customer_id,
    partner_id,
    instrument,
    ROUND(instrument_price, 6) AS instrument_price,
    trade_date,
    ROUND(cumulative_position, 6) AS cumulative_position,
    ROUND(cumulative_position_value, 6) AS cumulative_position_value
FROM {{ ref('trf__customer_positions_daily_filled') }}
