{{ config(
    materialized = 'view',
    unique_key = 'surrogate_key'
) }}

-- This model is used to store the customer positions daily data.
WITH stg_customer_trades_base AS (

    SELECT
        trades.customer_account_id,
        customer_accounts.customer_id,
        customer_accounts.partner_id,
        trades.instrument,
        trades.trade_date,
        CASE 
            WHEN trades.side = 'buy' THEN trades.quantity
            WHEN trades.side = 'sell' THEN -1 * trades.quantity
            ELSE 0
        END AS position_delta
    FROM {{ ref('stg__trades') }} trades
    LEFT JOIN {{ ref('stg__customer_accounts') }} customer_accounts
        ON trades.customer_account_id = customer_accounts.customer_account_id

),

customer_daily_positions AS (

    SELECT
        customer_account_id,
        customer_id,
        partner_id,
        instrument,
        trade_date,
        SUM(position_delta) AS net_position_delta
    FROM stg_customer_trades_base
    GROUP BY customer_account_id, customer_id, partner_id, instrument, trade_date

),

customer_positions_evolution AS (

    SELECT
        customer_account_id,
        customer_id,
        partner_id,
        instrument,
        trade_date,
        SUM(net_position_delta) OVER (
            PARTITION BY customer_account_id, instrument 
            ORDER BY trade_date 
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS cumulative_position
    FROM customer_daily_positions

)

SELECT
    NOW() AS _METADATA_UPDATED_AT,
    CONCAT(customer_account_id, '-', instrument, '-', trade_date) AS surrogate_key,
    customer_account_id,
    customer_id,
    partner_id,
    instrument,
    trade_date,
    cumulative_position
FROM customer_positions_evolution
ORDER BY customer_account_id, instrument, trade_date
 