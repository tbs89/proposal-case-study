
/*
This test checks that the cumulative position in the transformed customer positions daily table 
is consistent with the cumulative position in the mart customer positions daily table.
*/

SELECT transform_customer_positions.surrogate_key
FROM {{ ref('trf__customer_positions_daily_filled') }} transform_customer_positions
LEFT JOIN {{ ref('mrt__customer_positions_daily') }} mart_customer_positions
  ON transform_customer_positions.surrogate_key = mart_customer_positions.surrogate_key
WHERE transform_customer_positions.cumulative_position != mart_customer_positions.cumulative_position

