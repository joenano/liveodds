#!/usr/bin/env python3

from orjson import dumps

from lib.liveodds import Liveodds


liveodds = Liveodds()

races = liveodds.all_races()

odds = liveodds.odds(races)

for day in odds:
    for region in odds[day]:
        for meeting in odds[day][region]:
            print(meeting)

# json = dumps(odds).decode('utf-8')

# print(json)
