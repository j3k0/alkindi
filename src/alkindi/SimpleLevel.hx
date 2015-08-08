package alkindi;

using Lambda;
import alkindi.Fxp;
import alkindi.Types;

class SimpleLevel
{
    public static inline function
    newLevel (level:Level, player:PlayerWinner): LevelUpdate
        return { newLevel: level + (player.winner ? 30 : 7) };

    public static inline function
    maybeNewLevel (level:Maybe<Level>, player:PlayerWinner): Maybe<LevelUpdate>
        return level.map(newLevel.bind(_, player));

    // This level function will increase `level` by:
    //
    // * `30` points for the player(s) with the best score
    // * `7` for other players
    // 
    // returns null if player doesn't exists.
    public static function
    update (scores:Array<PlayerScoreAndLevel>, username:Username): LevelUpdate {
        var player = Archives.forPlayerSL(scores, username);
        var bestScore = Games.getBestScore(scores);
        return player
            .map(Games.isWinner.bind(bestScore))
            .chain(maybeNewLevel.bind(player.map(Types.getLevel)))
            .maybe(null, Fxp.id);
    }

    // Level decreases 1 point per day, but won't go below 0.
    public static function
    decay (then:Date, now:Date, level:Level): LevelUpdate
        return { newLevel: 0 }
}
