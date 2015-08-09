package alkindi;

using alkindi.Fxp;
import alkindi.Maybe;
import alkindi.Types;
import alkindi.Games;

class Stats {

    public static inline function
    execute (archive:PlayerArchive): PlayerStats
        return {
            username: archive.username,
            victories: victories(archive),
            defeats: defeats(archive),
            levels: levels(archive),
            winningSprees: []
        };

    public static inline function
    victories (archive:PlayerArchive): Array<DateValue>
        return games(archive)
            .filter(isVictory.bind(archive.username))
            .waterfall(gameCounter, { date: 0., value: 0 });

    public static inline function
    defeats (archive:PlayerArchive): Array<DateValue>
        return games(archive)
            .filter(Fxp.not(isVictory.bind(archive.username)))
            .waterfall(gameCounter, { date: 0., value: 0 });

    public static inline function
    levels(archive:PlayerArchive): Array<DateValue>
        return games(archive)
            .map(getDateLevel)
            .filter(hasPositiveDateAndValue);

    public static inline function
    hasPositiveDateAndValue (dv:DateValue): Bool
        return dv.date >= 0 && dv.value >= 0;

    public static inline function
    getDateLevel (game:GameOutcome): DateValue
        return {
            date: getGameDate(game),
            value: getGameLevel(game)
        }

    public static inline function
    getGameDate (game:GameOutcome): Timestamp
        return Maybe.of(game)
                .map(Types.getGame)
                .map(Types.getDate)
                .maybe(-1., Fxp.id);

    public static inline function
    getGameLevel (game:GameOutcome): Level
        return Maybe.of(game)
                .map(Types.getOutcome)
                .map(Types.getNewLevel)
                .maybe(-1, Fxp.id);

    public static inline function
    gameCounter (prev:DateValue, go:GameOutcome): DateValue
        return {
            date: go.game.date,
            value: prev.value + 1
        };

    public static inline function
    games (archive:PlayerArchive): Array<GameOutcome>
        return Maybe.of(archive).map(Types.getGames).maybe([], Fxp.id);
        
    public static inline function
    isVictory (username:Username, gameO:GameOutcome): Bool
        return Maybe.of(gameO)
            .map(Types.getGame)
            .maybe(false, isGameVictory.bind(username));

    public static inline function
    isGameVictory (username:Username, game:Game): Bool
        return getPlayerScore(username, game)
            .map(Games.isWinner.bind(getBestScore(game)))
            .map(Types.getWinner)
            .maybe(false, Fxp.id);

    public static inline function
    getPlayerScore (username:Username, game:Game): Maybe<PlayerScore>
        return Maybe.of(game)
            .map(Types.getPlayers)
            .chain(Archives.forPlayerS.bind(_, username));

    public static inline function
    getBestScore (game:Game): Score
        return Maybe.of(game)
            .map(Games.getPlayers)
            .map(Games.getBestScore)
            .maybe(0, Fxp.id);
}
