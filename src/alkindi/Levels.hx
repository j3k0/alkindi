package alkindi;

using Lambda;
import alkindi.Fxp;
import alkindi.Types;
import alkindi.Maybe;

// Extra data from games
class Levels {
    
    // Apply a LevelUpdate to a PlayerScoreAndLevel
    public static inline function
    applyUpdate (player:PlayerScoreAndLevel, levelUpdate:LevelUpdate): PlayerScoreAndLevel
        return {
            username: player.username,
            score: player.score,
            level: levelUpdate.newLevel
        }

    // Returns the updated level of a single player after decay
    public static inline function
    decay (decay:LevelDecayFunction, archives:Array<PlayerArchive>, game:Game, player:PlayerScoreAndLevel): PlayerScoreAndLevel
        return applyUpdate(player, 
            Archives.lastGameDate(archives, player.username).maybe(
                { newLevel: player.level },
                decay.bind(_, game.date, player.level)));

    // Returns the updated level of a single player after accounting his result in a game.
    public static inline function
    update (update:LevelUpdateFunction, archives:Array<PlayerArchive>, players:Array<PlayerScoreAndLevel>, player:PlayerScoreAndLevel): PlayerScoreAndLevel
        return applyUpdate(player, update(players, archives, player.username));
}
