-- TRANSFORM LAYER

{% docs surrogate_key_transform %}
Synthetic key composed of customer_account_id or partner_id, instrument, and trade_date, used as a unique identifier.
{% enddocs %}

{% docs customer_account_id_transform %}
Unique ID of the customer account holding the position.
{% enddocs %}

{% docs customer_id_transform %}
Unique identifier of the customer who owns the account.
{% enddocs %}

{% docs partner_id_transform %}
Identifier of the partner associated with the customer account.
{% enddocs %}

{% docs instrument_transform %}
ISIN (International Securities Identification Number) of the financial instrument.
{% enddocs %}

{% docs instrument_price_transform %}
Daily price of a given financial instrument.
{% enddocs %}

{% docs trade_date_transform %}
The date on which the trade or position snapshot is recorded.
{% enddocs %}

{% docs date_day_transform %}
Represents a single calendar day, used to join and analyze data at the daily level across different models.
It is the primary key of the time dimension table.
{% enddocs %}

{% docs cumulative_position %}
The cumulative quantity of an instrument held by the customer or partner up to and including the trade_date.
{% enddocs %}

{% docs cumulative_position_transform %}
Represents the cumulative number of units held by a customer or partner for a given instrument over time.
It is calculated by summing all buy and sell trades up to the current trade date, including forward-filling
to account for periods with no trading activity.
{% enddocs %}

{% docs _METADATA_UPDATED_AT %}
Timestamp capturing when the model was last refreshed, used for audit and monitoring purposes.
{% enddocs %}


