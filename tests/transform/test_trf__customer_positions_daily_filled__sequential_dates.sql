
/*
This test checks that the customer_positions_daily_filled table has a complete set of sequential dates for each customer account and instrument.
It compares the expected dates (from the customer_positions_daily_filled table) with the actual dates (from the dim_time table) to validate that 
all dates are present.
*/


WITH expected_dates AS (
    SELECT
        customer_account_id,
        instrument,
        date_day
    FROM {{ ref('trf__customer_positions_daily_filled') }}
    CROSS JOIN (
        SELECT DISTINCT date_day
        FROM {{ ref('trf__dim_time') }}
    ) d
),

actual_dates AS (
    SELECT
        customer_account_id,
        instrument,
        trade_date
    FROM {{ ref('trf__customer_positions_daily_filled') }}
)

SELECT
    expected_dates.customer_account_id,
    expected_dates.instrument,
    expected_dates.date_day
FROM expected_dates
LEFT JOIN actual_dates
    ON expected_dates.customer_account_id = actual_dates.customer_account_id
    AND expected_dates.instrument = actual_dates.instrument
    AND expected_dates.date_day = actual_dates.trade_date
WHERE actual_dates.trade_date IS NULL

