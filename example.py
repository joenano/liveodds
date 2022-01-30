#!/usr/bin/env python3

from orjson import dumps

from lib.liveodds import Liveodds


liveodds = Liveodds()

races = liveodds.all_races()

odds = liveodds.odds(races)

json = dumps(odds).decode('utf-8')

with open('odds.json', 'w') as f:
    f.write(json)
