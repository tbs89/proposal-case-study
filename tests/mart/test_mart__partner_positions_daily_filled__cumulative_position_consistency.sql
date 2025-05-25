
/*
This test checks that the cumulative position in the transformed partner positions daily table 
is consistent with the cumulative position in the mart partner positions daily table.
*/

SELECT transform_partner_positions.surrogate_key
FROM {{ ref('trf__partner_positions_daily_filled') }} transform_partner_positions
LEFT JOIN {{ ref('mrt__partner_positions_daily') }} mart_partner_positions
  ON transform_partner_positions.surrogate_key = mart_partner_positions.surrogate_key
WHERE transform_partner_positions.cumulative_position != mart_partner_positions.cumulative_position

