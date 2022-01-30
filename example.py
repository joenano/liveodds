#!/usr/bin/env python3

from orjson import dumps

from lib.liveodds import Liveodds


liveodds = Liveodds()

odds = liveodds.json()

with open('odds.json', 'w', encoding='utf-8') as f:
    f.write(odds)
