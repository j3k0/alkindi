package alkindi;

using alkindi.Fxp;
import alkindi.Maybe;
import alkindi.Types;
import alkindi.Games;
import haxe.ds.StringMap;

class Stats {

    // Compute a player' statistics from her archive of games
    public static inline function
    execute (archive:PlayerArchive): PlayerStats
        return {
            username: archive.username,
            victories: victories(archive),
            defeats: defeats(archive),
            levels: levels(archive),
            winningSprees: winningSprees(archive)
        };

    // Returns the number of victories over time
    public static inline function
    winningSprees (archive:PlayerArchive): Array<DateValue>
        return games(archive)
            .waterfall(spreeCounter.bind(archive.username), { date: 0., value: 0 })
            .filter(hasPositiveDateAndValue);

    // Returns game date and a counter increasing with each victory,
    // reset on defeats (meant to be used with Fxp.waterfall)
    public static inline function
    spreeCounter (username:Username, prev:DateValue, go:GameOutcome): DateValue
        return {
            date: getGameDate(go),
            value: isVictory(username, go) ? prev.value + 1 : 0
        };

    // Returns the number of victories over time
    public static inline function
    victories (archive:PlayerArchive): Array<DateValue>
        return games(archive)
            .filter(isVictory.bind(archive.username))
            .waterfall(gameCounter, { date: 0., value: 0 })
            .filter(hasPositiveDateAndValue);

    // Returns the number of defeats over time
    public static inline function
    defeats (archive:PlayerArchive): Array<DateValue>
        return games(archive)
            .filter(Fxp.not(isVictory.bind(archive.username)))
            .waterfall(gameCounter, { date: 0., value: 0 })
            .filter(hasPositiveDateAndValue);

    // Returns the evolution of level over time
    public static inline function
    levels(archive:PlayerArchive): Array<DateValue>
        return games(archive)
            .map(getDateLevel)
            .filter(hasPositiveDateAndValue);

    // Returns true if date and value are >= 0
    public static inline function
    hasPositiveDateAndValue (dv:DateValue): Bool
        return dv.date >= 0 && dv.value >= 0;

    // Returns the date and the newLevel for a given game
    public static inline function
    getDateLevel (game:GameOutcome): DateValue
        return {
            date: getGameDate(game),
            value: getGameLevel(game)
        }

    // Returns the date of a game
    public static inline function
    getGameDate (game:GameOutcome): Timestamp
        return Maybe.of(game)
                .map(Types.getGame)
                .map(Types.getDate)
                .maybe(-1., Fxp.id);

    // Returns the level reached after a game
    public static inline function
    getGameLevel (game:GameOutcome): Level
        return Maybe.of(game)
                .map(Types.getOutcome)
                .map(Types.getNewLevel)
                .maybe(-1, Fxp.id);

    // Returns game date and an increasing counter as a value
    // (meant to be used with Fxp.waterfall)
    public static inline function
    gameCounter (prev:DateValue, go:GameOutcome): DateValue
        return {
            date: getGameDate(go),
            value: prev.value + 1
        };

    // Safely returns the games listed in a player's archive
    public static inline function
    games (archive:PlayerArchive): Array<GameOutcome>
        return Maybe.of(archive).map(Types.getGames).maybe([], Fxp.id);

    // Safely return true if the game was a victory for the player
    public static inline function
    _isVictory (username:Username, gameO:GameOutcome): Bool
        return Maybe.of(gameO)
            .map(Types.getGame)
            .maybe(false, isGameVictory.bind(username));

    public static var isVictoryMemo = new StringMap<Bool>();
    public static inline function
    isVictory (username:Username, gameO:GameOutcome): Bool {
        var key = username + " " + gameO.game.id;
        var memo = isVictoryMemo.get(key);
        if (memo == null) {
            memo = _isVictory(username, gameO);
            isVictoryMemo.set(key, memo);
        }
        return memo;
    }

    // Return true if the game was a victory for the player
    public static inline function
    isGameVictory (username:Username, game:Game): Bool
        return getPlayerScore(username, game)
            .map(Games.isWinner.bind(getBestScore(game)))
            .map(Types.getWinner)
            .maybe(false, Fxp.id);

    // Return the score of a player in a given game
    public static inline function
    getPlayerScore (username:Username, game:Game): Maybe<PlayerScore>
        return Maybe.of(game)
            .map(Types.getPlayers)
            .chain(Archives.forPlayerS.bind(_, username));

    // Return the best score in a game
    public static inline function
    getBestScore (game:Game): Score
        return Maybe.of(game)
            .map(Games.getPlayers)
            .map(Games.getBestScore)
            .maybe(0, Fxp.id);
}
