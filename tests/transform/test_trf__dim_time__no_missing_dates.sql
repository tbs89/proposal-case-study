
/*
This test checks that the dim_time table has no missing dates.
It compares the expected dates (from the dim_time table) with the actual dates (from the dim_time table) to ensure that all dates are present.
*/

SELECT
    date_day
FROM {{ ref('trf__dim_time') }}
WHERE date_day IS NULL
   OR date_day < (SELECT MIN(date_day) FROM {{ ref('trf__dim_time') }})
   OR date_day > (SELECT MAX(date_day) FROM {{ ref('trf__dim_time') }})
ORDER BY date_day

