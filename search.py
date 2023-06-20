import csv
from datetime import datetime, timedelta
import pandas as pd

# test.csv = all dates from the event table
with open('test.csv', newline='') as f:
    reader = csv.reader(f)
    data = [t for row in reader for t in row][1:]
# collected from wikipedia
lockedDown = ["2020-11-23 00:00:00",
              "2021-03-08 00:00:00",
              "2021-04-03 00:00:00",
              "2021-06-02 00:00:00"
              ]
notlocked = [
    "2021-03-09 00:00:00",
    "2021-04-02 00:00:00",
    "2021-06-03 00:00:00"
]


# gets all the datetime in between 2 dates
def date_range(start, end):
    delta = end - start
    days = [start + timedelta(days=i) for i in range(delta.days + 1)]
    return days


# the split[0] extras only the date part - because if we're locked down on 2021-01-01 00:00:00,
# then we're locked down on 2021-01-01 23:59:59 as well
for i in range(4):
    lockedDown[i] = datetime.strptime(lockedDown[i].split()[0], '%Y-%m-%d')
mi = min(lockedDown)
for i in range(3):
    notlocked[i] = datetime.strptime(notlocked[i].split()[0], '%Y-%m-%d')
# locked down between 2020-11-23 and 2021-03-08
lockedDown.extend(date_range(lockedDown[0], lockedDown[1]))
# locked down between 2021-04-03 and 2021-06-02 00:00:00
lockedDown.extend(date_range(lockedDown[2], lockedDown[3]))
# not locked down between 2021-03-09 00:00:00 and 2021-04-02 00:00:00
notlocked.extend(date_range(notlocked[0], notlocked[1]))
d = dict()
for date in data:
    temp = datetime.strptime(date.split()[0], '%Y-%m-%d')
    if temp not in d:
        if temp in lockedDown:
            d[date] = True
        elif temp in notlocked:
            d[date] = False
        elif temp < min(lockedDown):
            d[date] = False
        elif temp > max(notlocked):
            d[date] = False
        else:
            pass

pd.DataFrame.from_dict(data=d, orient='index').to_csv('dict_file.csv', header=False)
