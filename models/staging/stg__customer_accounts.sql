{{ config(
    materialized = 'table',
    unique_key = 'customer_account_id'
) }}

-- This model is used to store the customer accounts data.
WITH source_customer_accounts AS (

    SELECT * 
    FROM {{ ref('customer_accounts') }}

),

casted_accounts AS (

    SELECT 
        CAST(customer_account_id AS TEXT) AS customer_account_id,
        CAST(customer_id AS TEXT) AS customer_id,
        CAST(partner_id AS TEXT) AS partner_id
    FROM source_customer_accounts

)

SELECT
    NOW() AS _METADATA_UPDATED_AT,
    customer_account_id,
    customer_id,
    partner_id
FROM casted_accounts


