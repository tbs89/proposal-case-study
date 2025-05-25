/*
    This test checks that all instruments in the trades table exist in the price snapshots table.
*/


WITH trades_instruments AS (

    SELECT DISTINCT
        instrument
    FROM {{ ref('stg__trades') }}

),

price_snapshots_instruments AS (

    SELECT DISTINCT
        instrument
    FROM {{ ref('stg__price_snapshots') }}

)

SELECT
    trades_instruments.instrument
FROM trades_instruments
LEFT JOIN price_snapshots_instruments
    ON trades_instruments.instrument = price_snapshots_instruments.instrument
WHERE price_snapshots_instruments.instrument IS NULL

