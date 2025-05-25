{{ config(
    materialized = 'view',
    unique_key = 'surrogate_key'
) }}

WITH customer_positions_daily_filled AS (

    SELECT
        partner_id,
        instrument,
        trade_date,
        cumulative_position,
        instrument_price,
        cumulative_position_value
    FROM {{ ref('trf__customer_positions_daily_filled') }}

),

partner_positions_aggregated AS (

    SELECT
        partner_id,
        instrument,
        trade_date,
        SUM(cumulative_position) AS cumulative_position,
        MAX(instrument_price) AS instrument_price,
        SUM(cumulative_position_value) AS cumulative_position_value
    FROM customer_positions_daily_filled
    GROUP BY partner_id, instrument, trade_date

)

SELECT
    NOW() AS _METADATA_UPDATED_AT,
    CONCAT(partner_id, '-', instrument, '-', trade_date) AS surrogate_key,
    partner_id,
    instrument,
    trade_date,
    cumulative_position,
    instrument_price,
    cumulative_position_value
FROM partner_positions_aggregated
ORDER BY partner_id, instrument, trade_date

