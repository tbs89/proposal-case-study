
/*
This test checks that the price snapshots are positive.
*/

WITH source_prices AS (

    SELECT
        instrument,
        snapshot_date,
        price
    FROM {{ ref('stg__price_snapshots') }}

),

invalid_prices AS (

    SELECT
        instrument,
        snapshot_date,
        price
    FROM source_prices
    WHERE price <= 0

)

SELECT
    *
FROM invalid_prices

