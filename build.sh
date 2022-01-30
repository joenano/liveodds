#!/bin/bash

if [ $# -eq 0 ]; then
    nim c --gc: orc --threads:on --app:lib -d:ssl -d:release --out:lib/odds.so src/odds.nim
elif [ $1 == "docs" ]; then
    pdoc --html -o docs/ lib/liveodds.py --force
fi
