-- STAGING LAYER

{% docs trade_id %}
Unique identifier for each trade.
{% enddocs %}

{% docs customer_account_id_staging %}
Unique ID of the customer account that executed the trade.
{% enddocs %}

{% docs customer_id_staging %}
Unique identifier of the customer who owns the account.
{% enddocs %}

{% docs partner_id_staging %}
Partner identifier where the customer is registered.
{% enddocs %}

{% docs instrument_staging %}
ISIN (International Securities Identification Number) of the traded instrument.
{% enddocs %}

{% docs side %}
Indicates if the trade is a 'buy' or a 'sell'.
{% enddocs %}

{% docs quantity %}
Number of units traded, parsed from raw format.
{% enddocs %}

{% docs price %}
Price per unit at the time of the trade or snapshot.
{% enddocs %}

{% docs amount %}
Total amount of the trade: quantity * price.
{% enddocs %}

{% docs trade_date_staging %}
Date of the trade (derived from timestamp).
{% enddocs %}

{% docs surrogate_key_staging %}
Synthetic key composed of instrument and snapshot date.
{% enddocs %}

{% docs snapshot_date %}
Date of the price snapshot.
{% enddocs %}
