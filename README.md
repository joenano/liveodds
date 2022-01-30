<p align="center">
  <img src="https://i.postimg.cc/1RHL7DTT/liveodds.png">
</p>

##### Requirements
To build you will need [Nim](https://nim-lang.org/) compiler, I would recommend using [Choosenim](https://github.com/dom96/choosenim) to install and manage.

[Python](https://www.python.org/downloads/) 3.7 or greater and the [Nimporter](https://github.com/Pebaz/Nimporter) and [orjson](https://github.com/ijl/orjson) packages are required. These can be installed with Pip.

```
pip install nimporter orjson
```

##### Install

```
git clone https://github.com/joenano/liveodds.git
```

Build files are included for compiling the library, or copy and paste from here.


###### Linux
```
nim c --gc: orc --threads:on --app:lib -d:ssl -d:release --out:lib/odds.so src/odds.nim
```

###### Windows
```
nim c --gc: orc --threads:on --app:lib --tlsEmulation:off -d:ssl -d:release --out:lib/odds.pyd src/odds.nim
```


##### Example

```python
from lib.liveodds import Liveodds

liveodds = Liveodds()

# get tuple of all available races
races = liveodds.all_races()

# get dictionary of odds for all races
odds = liveodds.odds(races)

```


##### Structure

![json](https://i.postimg.cc/9Q5Z4gtw/json.png)

![json](https://i.postimg.cc/L8pvd8WW/json1.png)

Will add more examples later, in the meantime, more info in docs.