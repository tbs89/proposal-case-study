{{ config(
    materialized = 'table',
    unique_key = 'surrogate_key'
) }}

-- This model is used to store the price snapshots data.
WITH source_price_snapshots AS (

    SELECT * 
    FROM {{ ref('price_snapshots') }}

),

casted_snapshots AS (

    SELECT 
        CAST(instrument AS TEXT) AS instrument,
        {{ parse_fractional_values("price") }} AS price,
        CAST("timestamp" AS DATE) AS snapshot_date
    FROM source_price_snapshots

),

snapshots_window AS (

    SELECT 
        instrument,
        snapshot_date,
        price,
        ROW_NUMBER() OVER (
            PARTITION BY instrument, snapshot_date
            ORDER BY snapshot_date DESC
        ) AS rn
    FROM casted_snapshots

),

deduplicated_snapshots AS (
    SELECT
        instrument,
        snapshot_date,
        price
    FROM snapshots_window
    WHERE rn = 1
)

SELECT
    NOW() AS _METADATA_UPDATED_AT,
    CONCAT(instrument, '-', snapshot_date) AS surrogate_key,
    instrument,
    price,
    snapshot_date
FROM deduplicated_snapshots