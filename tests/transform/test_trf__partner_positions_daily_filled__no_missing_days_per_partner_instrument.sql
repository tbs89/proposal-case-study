
/*
This test checks that the partner_positions_daily_filled table has no missing days per partner and instrument.
It compares the expected dates (from the partner_positions_daily_filled table) with the actual dates (from the dim_time table) 
to ensure that all dates are present.
*/


WITH date_ranges AS (
    SELECT
        partner_id,
        instrument,
        MIN(trade_date) AS min_date,
        MAX(trade_date) AS max_date
    FROM {{ ref('trf__partner_positions_daily_filled') }}
    GROUP BY 1, 2
),

expected_dates AS (
    SELECT
        ranges.partner_id,
        ranges.instrument,
        dim_time.date_day
    FROM date_ranges ranges
    JOIN {{ ref('trf__dim_time') }} dim_time
      ON dim_time.date_day BETWEEN ranges.min_date AND ranges.max_date
),

missing_dates AS (
    SELECT
        expected_dates.partner_id,
        expected_dates.instrument,
        expected_dates.date_day
    FROM expected_dates
    LEFT JOIN {{ ref('trf__partner_positions_daily_filled') }} partner_positions
      ON expected_dates.partner_id = partner_positions.partner_id
     AND expected_dates.instrument = partner_positions.instrument
     AND expected_dates.date_day = partner_positions.trade_date
    WHERE partner_positions.surrogate_key IS NULL
)

SELECT *
FROM missing_dates

