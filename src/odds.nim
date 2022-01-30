import asyncdispatch
import htmlparser
import httpclient
import nimpy
import nre
import strutils
import sugar
import tables
import xmltree

import utils/bookies
import utils/xmlfuncs

const REGIONS = {"gbr": "gb", "fra": "fr"}.toTable

type TableOdds = Table[string, Table[string, Table[string, Table[string, Table[string, Table[string, float]]]]]]
type TableRace = Table[string, Table[string, Table[string, seq[(string, string)]]]]

type Race = tuple[day, course, region, time, url: string]

proc `[]`[A, B, C](t: var Table[A, Table[B, C]], key: A): var Table[B, C] =
  t.mgetOrPut(key, initTable[B, C]())

proc getHtmlString(content: string): string =
  let regex = re("iframe><.noscript>(.*)<div class=.layout-tablet-betslip")
  let match = content.find(regex)
  if match.isSome: result = match.get.captures[0]

proc getNode(key, url: string): Future[(string, XmlNode)] {.async.} =
  var client = newAsyncHttpClient()
  let content = await client.getContent(url)
  let html = getHtmlString(content)
  result = (key, parseHtml(html))

proc getNodes(urls: seq[(string, string)]): Future[seq[(string, XmlNode)]] {.async.} =
  var futures = newSeq[Future[(string, XmlNode)]](len(urls))
  for i, url in urls.pairs(): futures[i] = getNode(url[0], url[1])
  result = await all(futures)

proc getRegion(meeting: XmlNode): string =
  let flag = findElement(meeting, "svg", "class", "svg--flag")
  let region = flag.child("use").attr("xlink:href").split("_")[1]
  result = if region in REGIONS: REGIONS[region] else: region

proc getOdds(races: seq[Race]): Future[TableOdds] {.async.} =
  var raceDict: Table[string, Race]
  
  for race in races:
    raceDict[race.url] = race 
  
  let urls = collect(for race in races: (race.url, race.url))

  for node in await getNodes(urls):
    let (url, htmlNode) = node
    var runners = findElements(htmlNode, "div", "class", "racecard__runner__header")
  
    for i in 0..len(runners)-2:
      let name = findElement(runners[i], "div", "class", "racecard__runner__name")
      let horse = name.child("div").innerText.replace("'", "").split("(")[0].strip()
      let odds = elementsWithAttribue(runners[i], "ruk-odd", "data-js-odds-decimal")

      for book in odds:
        let bookieCode = book.attr("data-js-odds-bookmaker-code")
        let price = book.attr("data-js-odds-decimal")

        let day = raceDict[url].day
        let region = raceDict[url].region
        let course = raceDict[url].course
        let time = raceDict[url].time

        result[day][region][course][time][horse][BOOKIES[bookieCode]] = parseFloat(price)

proc getRaces(): Future[TableRace] {.async.} =
  let url = "https://www.racingtv.com"
  let urlToday = url & "/racecards"
  let urlTomorrow = urlToday & "/tomorrow"
  var days = @[("today", urlToday), ("tomorrow", urlTomorrow)]

  for (day, node) in await getNodes(days):
    let meetings = findElements(node, "div", "class", "race-selector__race")

    for meeting in meetings:
      let region = getRegion(meeting)
      let course = findElement(meeting, "div", "class", "race-selector__title").innerText
      let timeSection = findElement(meeting, "div", "class", "race-selector__times")

      var times: seq[(string, string)]

      for link in findAll(timeSection, "a"):
        times.add((link.innerText, url & link.attr("href") & "/oddschecker"))

      result[day][region][course] = times

proc odds(races: seq[Race]): TableOdds {.exportpy.} =
  result = waitFor getOdds(races)

proc races(): TableRace {.exportpy.} =
  result = waitFor getRaces()
