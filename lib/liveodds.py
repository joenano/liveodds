#!/usr/bin/env python3

import nimporter
import lib.odds as odds

from dataclasses import dataclass, astuple
from orjson import dumps


@dataclass
class Race:
    ''' Contains information about a race '''

    day: str
    ''' Day of the race [today | tomorrow] '''

    course: str
    ''' Name of the course '''

    region: str
    ''' 2 or 3 letter country code e.g 'gb' '''

    time: str
    ''' Off time of the race '''

    url: str
    ''' Url for race odds '''


class Liveodds:
    ''' Main interface to access race odds '''

    def __init__(self) -> None:
        self._races = odds.races()
        
    def all_races(self) -> list:
        ''' Returns a list of Race objects for all available races '''
        races = []
        for day in self.days():
            for region in self.regions(day):
                for course in self.courses(day, region):
                    for race in self.races(day, region, course):
                        races.append(race)
        return races

    def courses(self, day: str, region: str) -> tuple:
        ''' Returns a tuple of string course names for a given day and region '''
        return tuple(course for course in sorted(self._races[day][region]))

    def days(self) -> tuple:
        ''' Returns a tuple of string days for which odds are available '''
        return tuple(day for day in sorted(self._races))
    
    def json(self) -> str:
        ''' Retrns a JSON string of all available race odds '''
        races = self.all_races()
        odds = self.odds(races)
        return dumps(odds).decode('utf-8')

    def odds(self, races) -> dict:
        ''' Returns a dictionary of odds for given races '''
        args = [astuple(races)] if isinstance(races, Race) else [astuple(race) for race in races]
        return odds.odds(args)
    
    def races(self, day: str, region: str, course: str) -> tuple:
        ''' Returns a tuple of Race objects for a given day, region and course '''
        return tuple(Race(day, course, region, *race) for race in self._races[day][region][course])

    def regions(self, day: str) -> tuple:
        ''' Returns a tuple of string region codes for a given day '''
        return tuple(region for region in self._races[day])
