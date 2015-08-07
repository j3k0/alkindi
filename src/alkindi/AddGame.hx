package alkindi;

import alkindi.Fxp;
import alkindi.Types;
import alkindi.Archives;
import alkindi.Games;
using Lambda;

// Compute the effect of game on players statistics
class AddGame {

    // Returns the updated level of a single player after decay
    public static inline function
    decayedLevel (decay:LevelDecayFunction, archives:Array<PlayerArchive>, game:Game, player:PlayerScoreAndLevel): PlayerScoreAndLevel
        return updateLevel(player, 
            Archives.lastGameDate(archives, player.username).maybe(
                { newLevel: player.level },
                decay.bind(_, game.date, player.level)));

    public static inline function
    updateLevel (player:PlayerScoreAndLevel, levelUpdate:LevelUpdate): PlayerScoreAndLevel
        return {
            username: player.username,
            score: player.score,
            level: Types.getNewLevel(levelUpdate)
        }

    // Returns the updated level of a single player after accounting his result in a game.
    public static inline function
    updatedLevel (update:LevelUpdateFunction, players:Array<PlayerScoreAndLevel>, player:PlayerScoreAndLevel): PlayerScoreAndLevel
        return updateLevel(player, update(players, player.username));

    public static inline function
    outcome (game:Game, player:PlayerScoreAndLevel): PlayerGameOutcome
        return {
            username: player.username,
            game: {
                game: game,
                outcome: {
                    newLevel: player.level
                }
            }
        };

    public static inline function
    outcomes (game:Game, players:Array<PlayerScoreAndLevel>): Array<PlayerGameOutcome>
        return players.map(outcome.bind(game));

    public static inline function
    execute(update:LevelUpdateFunction, decay:LevelDecayFunction, archives:Array<PlayerArchive>, game:Game) : Array<PlayerGameOutcome>
    {
        if (update == null || decay == null || archives == null || game == null)
            return [];

        var players = Games.getPlayers(game);
        var scoreAndLevels = Archives.getScoreAndLevels(archives, players);
        var decayed = scoreAndLevels.map(decayedLevel.bind(decay, archives, game));
        var updated = decayed.map(updatedLevel.bind(update, decayed));
        var needUpdate = updated.filter(Archives.dontContain.bind(archives, game));
        return outcomes(game, needUpdate);
    }
}

