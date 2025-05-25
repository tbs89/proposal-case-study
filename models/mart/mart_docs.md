{% docs surrogate_key_mart %}
Synthetic key combining relevant fields (such as customer/partner, instrument, and date) to uniquely identify each daily position record.
{% enddocs %}

{% docs customer_account_id_mart %}
Unique identifier for a customer's trading account, used to track positions at the customer level.
{% enddocs %}

{% docs customer_id_mart %}
Unique identifier for the customer who owns the account.
{% enddocs %}

{% docs partner_id_mart %}
Identifier of the partner associated with the customer or account.
{% enddocs %}

{% docs instrument_mart %}
ISIN (International Securities Identification Number) representing the traded financial instrument.
{% enddocs %}

{% docs trade_date_mart %}
The specific date on which the position is recorded or carried over.
{% enddocs %}

{% docs cumulative_position_mart %}
The total quantity of an instrument held at the end of the day, including forward-filling across non-trading days.
{% enddocs %}

{% docs instrument_price_mart %}
Daily price of a given financial instrument.
{% enddocs %}