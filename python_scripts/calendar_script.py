import csv
from datetime import datetime, timedelta

start_date = datetime(2023, 1, 1)
end_date = datetime(2026, 12, 31)

with open('seed_calendar.csv', 'w', newline='', encoding='utf-8') as csvfile:
    fieldnames = ['date', 'day_of_week']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()

    current_date = start_date
    while current_date <= end_date:
        writer.writerow({
            'date': current_date.strftime('%Y-%m-%d'),
            'day_of_week': current_date.strftime('%A')
        })
        current_date += timedelta(days=1)
