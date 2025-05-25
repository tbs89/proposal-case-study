
/*
This test checks that the customer_positions_daily_filled table has no missing days per customer and instrument.
It compares the expected dates (from the customer_positions_daily_filled table) with the actual dates (from the dim_time table) 
to ensure that all dates are present.
*/

WITH date_ranges AS (
    SELECT
        customer_account_id,
        instrument,
        MIN(trade_date) AS min_date,
        MAX(trade_date) AS max_date
    FROM {{ ref('trf__customer_positions_daily_filled') }}
    GROUP BY 1, 2
),

expected_dates AS (
    SELECT
        ranges.customer_account_id,
        ranges.instrument,
        dim_time.date_day
    FROM date_ranges ranges
    JOIN {{ ref('trf__dim_time') }} dim_time
      ON dim_time.date_day BETWEEN ranges.min_date AND ranges.max_date
),

missing_dates AS (
    SELECT
        expected_dates.customer_account_id,
        expected_dates.instrument,
        expected_dates.date_day
    FROM expected_dates
    LEFT JOIN {{ ref('trf__customer_positions_daily_filled') }} customer_positions
      ON expected_dates.customer_account_id = customer_positions.customer_account_id
     AND expected_dates.instrument = customer_positions.instrument
     AND expected_dates.date_day = customer_positions.trade_date
    WHERE customer_positions.surrogate_key IS NULL
)

SELECT *
FROM missing_dates

