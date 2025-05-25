
/*
This test checks that the partner_positions_daily_filled table has a complete set of sequential dates for each partner and instrument.
It compares the expected dates (from the partner_positions_daily_filled table) with the actual dates (from the dim_time table) to ensure 
that all dates are present.
*/

WITH data AS (
    SELECT
        partner_id,
        instrument,
        trade_date,
        LEAD(trade_date) OVER (
            PARTITION BY partner_id, instrument
            ORDER BY trade_date
        ) AS next_trade_date
    FROM {{ ref('trf__partner_positions_daily_filled') }}
)

SELECT *
FROM data
WHERE next_trade_date IS NOT NULL
  AND next_trade_date != trade_date + INTERVAL '1 day'

