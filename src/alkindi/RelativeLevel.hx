package alkindi;

using Lambda;
import alkindi.Fxp;
import alkindi.Types;

class RelativeLevel
{
    public static inline var WIN_POINTS = 30;
    public static inline var WIN_BEST_COEF = 0.01;
    public static inline var LOSE_POINTS = 7;
    public static inline var DECAY_INTERVAL = 3600 * 24;

    // TRIPOCH is the beggining of times for triominos.
    public static inline var TRIPOCH:Timestamp = 1439500000;

    public static inline function
    timeCoef(now:Timestamp): Float {
        return Math.log(1 + 0.000004 * (now - TRIPOCH));
    }

    public static inline function
    winPoints(now:Timestamp, repetitions:Int, bestLevel:Level, level:Level): Level {
        var p1 = Std.int((bestLevel - level) * WIN_BEST_COEF + timeCoef(now) * WIN_POINTS);
        return p1 > repetitions ? p1 - repetitions : 1;
    }

    public static inline function
    losePoints(now:Timestamp, repetitions:Int, bestLevel:Level, level:Level): Level {
        var p1 = level < bestLevel ? Std.int(timeCoef(now) * LOSE_POINTS) : 1;
        return p1 > repetitions ? p1 - repetitions : 0;
    }

    public static inline function
    hasAllPlayers(usernames:Array<Username>, gameOutcome:GameOutcome): Bool {
        return Fxp.intersect(
            gameOutcome.game.players.map(Types.getUsername),
            usernames
        ).length == usernames.length;
    }

    public static inline function
    opponentRepetitions(scores:Array<PlayerScoreAndLevel>, archives:Array<PlayerArchive>): Int {
        var usernames:Array<Username> = scores.map(Types.getUsername);
        return (archives.length > 0 && archives[0].games != null)
            ? archives[0].games.filter(hasAllPlayers.bind(usernames)).length
            : 0;
    }

    public static inline function
    newLevel (now:Timestamp, repetitions:Int, bestLevel:Level, level:Level, player:PlayerWinner): LevelUpdate {
        var points:Level = (player.winner
            ? winPoints(now, repetitions, bestLevel, level)
            : losePoints(now, repetitions, bestLevel, level));
        return { newLevel:
            level + points
        };
    }

    public static inline function
    maybeNewLevel (now:Timestamp, repetitions:Int, bestLevel:Level, level:Maybe<Level>, player:PlayerWinner): Maybe<LevelUpdate>
        return level.map(newLevel.bind(now, repetitions, bestLevel, _, player));

    public static inline function
    getDate (gameOutcome:Maybe<GameOutcome>):Timestamp
        return gameOutcome
            .map(Types.getGame)
            .map(Types.getDate)
            .maybe(TRIPOCH, Fxp.id);
 
    // Returns the max of 2 dates
    public static inline function
    maxDate(s1:Timestamp, s2:Timestamp): Timestamp
        return s1 > s2 ? s1 : s2;

    // Return the latest of the games found in the player archives
    public static inline function
    latestTime(archives:Array<PlayerArchive>):Timestamp
        return archives.map(Types.getGames) // Array[Array[GameOutcome]]
            .map(Fxp.last)                  // Array[Maybe[GameOutcome]]
            .map(getDate)                   // Array[Timestamp]
            .fold(maxDate, TRIPOCH);

    // This level function will increase `level` by:
    //
    // * `30` points for the player(s) with the best score
    // * `7` for other players
    // 
    // returns null if player doesn't exists.
    public static function
    update (scores:Array<PlayerScoreAndLevel>, archives:Array<PlayerArchive>, username:Username): LevelUpdate {
        var player = Archives.forPlayerSL(scores, username);
        var bestLevel = Games.getBestLevel(scores);
        var bestScore = Games.getBestScore(scores);
        var repetitions = opponentRepetitions(scores, archives);
        var now = latestTime(archives);
        return player
            .map(Games.isWinner.bind(bestScore))
            .chain(maybeNewLevel.bind(now, repetitions, bestLevel, player.map(Types.getLevel)))
            .maybe(null, Fxp.id);
    }

    // Level decreases 1 point per day, but won't go below 0.
    public static function
    decay (then:Timestamp, now:Timestamp, level:Level): LevelUpdate
        return {
            newLevel: level +
                Std.int((then - now) / DECAY_INTERVAL)
        }
}

