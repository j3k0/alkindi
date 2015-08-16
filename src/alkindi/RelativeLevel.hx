package alkindi;

using Lambda;
import alkindi.Fxp;
import alkindi.Types;

//
// This strategy will increase `level`:
//
// For the winner by:
// 
//  .   K(t) * w + 0.01 * d
//  .   1 if the above is less than 1.
//
// with: w = max(30 - r, 1)
//
// d is the difference of levels with the strongest player.
// (0 for the best player, positive integers for others)
// > see winPoints()
//
// r is the number of repetitions of this game. A repetition is a
// game featuring exactly all of the same players.
// > see opponentRepetitions()
//
// K(t) is a coefficient that increases with time.
// > see timeCoef()
// 
//     K(t) = 2 ^ (t / M)
//     
// with T0 being the beginning of times (see Alkindi.TRIPOCH)
// This coefficient allow to give more weight to recent games
// than older games.
//
// The magic numbers are such as K(t + 1month) ~= K(t) * 2
//
//
// For the loosers, increase is:
//
//  .   0           for the strongest players
//  .   K(t) * l    for others
//
// with: l = max(7 - r, 0)
//
// K(t) and r defined as for winners
//
class RelativeLevel
{
    public static inline var WIN_POINTS = 30;
    public static inline var WIN_BEST_COEF = 0.01;
    public static inline var LOSE_POINTS = 7;

    // The magic numbers are such as K(t + M) ~= K(t) * 2
    // M = 3600 * 24 * 30 ~= (1 month)
    //
    //    K(t) = 2^(t/M)
    //
    public static inline function
    timeCoef(now:Timestamp): Float {
        var M = 3600 * 24 * 30;
        return Math.pow(2.0, (now - Alkindi.TRIPOCH) / M);
    }

    public static inline function
    winPoints(now:Timestamp, repetitions:Int, bestLevel:Level, level:Level): Level {
        var w = WIN_POINTS > repetitions ? WIN_POINTS - repetitions : 1;
        return Std.int((bestLevel - level) * WIN_BEST_COEF + timeCoef(now) * w);
    }

    public static inline function
    losePoints(now:Timestamp, repetitions:Int, bestLevel:Level, level:Level): Level {
        var l = LOSE_POINTS > repetitions ? LOSE_POINTS : 0;
        return level < bestLevel ? Std.int(timeCoef(now) * l) : 1;
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
            .maybe(Alkindi.TRIPOCH, Fxp.id);
 
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
            .fold(maxDate, Alkindi.TRIPOCH);

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
}

