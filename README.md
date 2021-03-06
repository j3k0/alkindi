# Alkindi

Statistics module for haxe. Generates AS3 and JS.

http://documentup.com/j3k0/alkindi

## Summary

This API solves generic issues with handling game statitics.

 * Number of victories and defeats
 * Longuest / current winning spree (number of succecutive victories)
 * User leveling

## API

### Import/require the package

From javascript.
```js
var alkindi = require("alkindi");
```

From actionscript.
```actionscript
import alkindi.Alkindi;
```

### addGame()

Add a game to player's stats. This function actually doesn't change any object. It just takes an initial state, do some computation and return the list changes to perform (refered to as "outcome").

Definition:
```haxe
addGame: LevelUpdateFunction -> LevelDecayFunction -> Array<PlayerArchive> -> Game -> Array<PlayerGameOutcome>
```

Note: if the added game is already in the player archive: outcome will be an empty array.

Usage from javascript:
```js
var outcomes = alkindi.addGame(myUpdate, myDecay, archives, game);
```

Usage from actionscript:
```actionscript
var outcomes:Array = Alkindi.addGame(myUpdate, myDecay, archives, game);
```

See also: [LevelDecayFunction](#leveldecayfunction), [LevelUpdateFunction](#levelupdatefunction), [PlayerArchive](#playerarchive), [Game](#game),
[PlayerGameOutcome](#playergameoutcome)

### getPlayerStats()

Compute a player' statistics from her archive of games.

Statistics include `victories`, `defeats`, `levels`, `winningSprees`. Each of those elements are arrays of `DateValue` (timestamp + value).

Definition:
```haxe
archive: PlayerArchive -> PlayerStats
```

Usage from javascript:
```js
var stats = alkindi.getPlayerStats(archives);
```

Usage from actionscript:
```actionscript
var stats:Object = Alkindi.getPlayerStats(archives);
```

See also: [PlayerArchive](#playerarchive), [PlayerStats](#playerstats), [DateValue](#datevalue)

## Level functions

Level reflects experience in the game. Each defeat of victory will change level points. Level points will decay over time while not playing. A global ranking could just be the list of players ordered by level points (but this is not managed by this library).

### LevelUpdateFunction

Defines how Level updates while playing

```haxe
typedef LevelUpdateFunction = Array<PlayerScoreAndLevel> -> Username -> LevelUpdate;
```

To define your own.

In javascript.
```js
function myUpdate(players, username) {
    return { "newLevel": players.find(username).level + 10 }
}
```

In actionscript.
```actionscript
function myUpdate(players:Array, username:String):Object {
    return { newLevel: players.find(username).level + 10 }
}
```

See also: [PlayerScoreAndLevel](#playerscoreandlevel), [LevelUpdate](#levelupdate)

### LevelDecayFunction

Define how Level decays while not playing.

Player's level will decay from start date to end date, from given Level to the returned LevelUpdate.

```haxe
typedef LevelDecayFunction = Timestamp -> Timestamp -> Level -> LevelUpdate;
```

To define your own.

In javascript.
```js
function myDecay(t0, t1, level) {
    return { "newLevel": Math.round(level - (t1 - t0) / 3600) }
}
```

In actionscript.
```actionscript
function myDecay(t0:Number, t1:Number, level:int):int {
    return { newLevel: Math.round(level - (t1 - t0) / 3600) }
}
```

See also: [LevelUpdate](#levelupdate)

### LevelUpdate

```haxe
typedef LevelUpdate = {
    newLevel: Int
}
```

## Featured level functions

Alkindi features a number of level update/decay functions, they're free to use!

### simpleLevelUpdate()

This level function will increase `level` by:

- `30` points for the player(s) with the best score
- `7` for other players

Usage from javascript.
```js
var outcomes = alkindi.addGame(alkindi.simpleLevelUpdate, myDecay, archives, game);
```

Usage from actionscript.
```actionscript
var outcomes:Array = Alkindi.addGame(Alkindi.simpleLevelUpdate, myDecay, archives, game);
```

### simpleLevelDecay

Level decreases 1 point per day, but won't go below 0.

Usage from javascript.
```js
var outcomes = alkindi.addGame(myUpdate, alkindi.simpleLevelDecay, archives, game);
```

Usage from actionscript.
```actionscript
var outcomes:Array = Alkindi.addGame(myUpdate, Alkindi.simpleLevelDecay, archives, game);
```

### relativeLevelUpdate

This strategy will increase `level`:

**For the winner**, by:

    K(t) * w + 0.01 * d
    1 if the above is less than 1.

with: w = max(30 - r, 1)

d is the difference of levels with the strongest player.
(0 for the best player, positive integers for others)

r is the number of repetitions of this game. A repetition is a game featuring exactly all of the same players.

K(t) is a coefficient that increases with time.

    K(t) = 2 ^ (t / M)
    
with T0 being the beginning of times (see Alkindi.TRIPOCH)
This coefficient allow to give more weight to recent games than older games.

The magic numbers are such as K(t + 1month) ~= K(t) * 2

**For the loosers**, by:

    0           for the strongest players
    K(t) * l    for others

with: l = max(7 - r, 0)

K(t) and r defined as for winners

Usage from javascript.
```js
var outcomes = alkindi.addGame(alkindi.relativeLevelUpdate, myDecay, archives, game);
```

Usage from actionscript.
```actionscript
var outcomes:Array = Alkindi.addGame(Alkindi.relativeLevelUpdate, myDecay, archives, game);
```

## Basic Types

```haxe
typedef Score = Int;
typedef Level = Int;
typedef Username = String;
typedef Timestamp = Float;
typedef GameId = String;
```

## Games archives

### PlayerArchive

```haxe
typedef PlayerArchive = {
    username: String,
    games: Array<GameOutcome>
}
```

See also: [GameOutcome](#gameoutcome)

### GameOutcome

```haxe
typedef GameOutcome = {
    game: Game,
    outcome: LevelUpdate
}
```

See also: [LevelUpdate](#levelupdate), [Game](#game)

## Games and players

### Game

```haxe
typedef Game = {
    date: Timestamp,
    id: String,
    players: Array<PlayerScore>
}
```

### PlayerScore

```haxe
typedef PlayerScore = {
    username: String,
    score: Int
}
```

### PlayerScoreAndLevel

```haxe
typedef PlayerScoreAndLevel = {
    username: String,
    score: Int,
    level: Int
}
```

### PlayerGameOutcome

```haxe
typedef PlayerGameOutcome = {
    username: String,
    game: GameOutcome,
}
```

See also: [GameOutcome](#gameoutcome)

## Statistics

### PlayerStats

```haxe
typedef PlayerStats = {
    username: String,
    victories: Array<DateValue>,
    defeats: Array<DateValue>,
    levels: Array<DateValue>,
    winningSprees: Array<DateValue>
}
```

`victories`: Number of victories over time.

`defeats`: Number of defeats over time.

`levels`: Player level over time.

`winningSprees`: Succecutive victories over time.

### DateValue

```haxe
typedef DateValue = {
    date: Timestamp,
    value: Int
}
```

# Examples

## Javascript

To use the library from javascript, run in your terminal:

```sh
npm install alkindi
```

Then in your javascript:

```js
var alkindi = require("alkindi");

var archives = [{
    username: "sousou",
    games: [{
        outcome: { "newLevel": 50 },
        game: {
            date: 1981,
            id: "mummy",
            players: [{
                username: "sousou",
                score: 20
            }, {
                username: "oreo",
                score: 35
            }]
        }
    }]
}, {
    username: "jeko",
    games: []
}];

var game = {
    id: "dummy",
    date: 1991,
    players: [{
        username: "jeko",
        score: 21
    }, {
        username: "sousou",
        score: 20
    }]
};

var outcomes = alkindi.addGame(
    alkindi.simpleLevelUpdate,
    alkindi.simpleLevelDecay,
    archives, game);
```

# Contribute

## Build the library

The build system uses no tools or dependencies that aren't in a docker image, except for make. Only have docker installed and type one of the commands below, it shouldn't bother with any missing dependencies.

If you find it more conveniant, you can use locally installed haxe by setting:
```sh
export dhaxe=/path/to/haxe
```

### Javascript

Javascript output can be generated by typing:
```sh
make js
```

This gonna generate a file called `bin/alkindi.js`

### Actionscript

Actionscript output can be generated by typing:
```sh
make swc
```

This gonna generate a file called `bin/alkindi.swc`

or to generate actionscript files:
```sh
make a3
```

## Run tests

To run unit tests:
```sh
make test
```

