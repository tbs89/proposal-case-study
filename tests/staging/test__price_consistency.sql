
/*
This test checks that the price snapshots are consistent with the customer and partner positions.
*/

WITH snapshot_prices AS (
    SELECT
        instrument,
        snapshot_date,
        price
    FROM {{ ref('trf__instrument_prices_filled') }}
),

customer_prices AS (
    SELECT
        instrument,
        trade_date,
        instrument_price
    FROM {{ ref('trf__customer_positions_daily_filled') }}
),

partner_prices AS (
    SELECT
        instrument,
        trade_date,
        instrument_price
    FROM {{ ref('trf__partner_positions_daily_filled') }}
),

all_prices AS (
    SELECT * FROM customer_prices
    UNION ALL
    SELECT * FROM partner_prices
),

closest_snapshots AS (
    SELECT
        ap.instrument,
        ap.trade_date,
        sp.price,
        ROW_NUMBER() OVER (
            PARTITION BY ap.instrument, ap.trade_date
            ORDER BY sp.snapshot_date DESC
        ) AS rn
    FROM all_prices ap
    LEFT JOIN snapshot_prices sp
        ON ap.instrument = sp.instrument
        AND sp.snapshot_date <= ap.trade_date
)

SELECT
    ap.instrument,
    ap.trade_date,
    ap.instrument_price AS filled_price,
    cs.price AS snapshot_price
FROM all_prices ap
LEFT JOIN closest_snapshots cs
    ON ap.instrument = cs.instrument
    AND ap.trade_date = cs.trade_date
WHERE cs.rn = 1
  AND ABS(ap.instrument_price - cs.price) > 0.000001

