<p align="center">
  <img src="https://i.postimg.cc/1RHL7DTT/liveodds.png">
</p>

<br>
#### Example

```python
from lib.liveodds import Liveodds

liveodds = Liveodds()

# get tuple of all available races
races = liveodds.all_races()

# get dictionary of odds for all races
odds = liveodds.odds(races)

```
<br>
#### Structure

![json](https://i.postimg.cc/9Q5Z4gtw/json.png)

<br>
![json](https://i.postimg.cc/L8pvd8WW/json1.png)

More info in docs