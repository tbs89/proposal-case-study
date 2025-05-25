{{ config(
    materialized = 'table',
    unique_key = 'trade_id'
) }}

-- This model is used to store the trades data.
WITH source_trades AS (

    SELECT * 
    FROM {{ ref('trades') }}
    
),

casted_trades AS (

    SELECT 
        CAST(id AS TEXT) AS trade_id,
        CAST(customer_account_id AS TEXT) AS customer_account_id,
        CAST(instrument AS TEXT) AS instrument,
        CAST(side AS TEXT) AS side,
        {{ parse_fractional_values("quantity") }} AS quantity,
        {{ parse_fractional_values("price") }} AS price,
        {{ parse_fractional_values("amount") }} AS amount,
        CAST(created_at AS DATE) AS trade_date
    FROM source_trades

)

SELECT
    NOW() AS _METADATA_UPDATED_AT,
    trade_id,
    customer_account_id,
    instrument,
    side,
    quantity,
    price,
    amount,
    trade_date
FROM casted_trades
