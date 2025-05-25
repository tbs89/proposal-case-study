{% macro parse_fractional_values(field) %}
    (
        CAST(SPLIT_PART(REPLACE({{ field }}, '(', ''), ',', 1) AS NUMERIC)
        /
        POWER(
            10,
            CAST(REPLACE(SPLIT_PART({{ field }}, ',', 2), ')', '') AS NUMERIC)
        )
    )
{% endmacro %}
 
/*  

For fractional values: (amount, scale)
Actual value = amount / 10^(scale)



 Examples:
* (9412,2,EUR) = 94.12 EUR
* (100,2,EUR) = 1.00 EUR
* (100,0,EUR) = 100 EUR
* (-3,3) = -0.003
*/  