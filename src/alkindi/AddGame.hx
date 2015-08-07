package alkindi;

import alkindi.Archives;
import alkindi.Games;
import alkindi.Levels;
import alkindi.Types;

using alkindi.Fxp; // thisMap
using Lambda; // map

// Compute the effect of game on players statistics
class AddGame {

    // Execute the addGame operation.
    //
    // Returns an array of outcomes.
    public static inline function
    execute(update:LevelUpdateFunction, decay:LevelDecayFunction, archives:Array<PlayerArchive>, game:Game): Array<PlayerGameOutcome>
        return (update == null || decay == null || archives == null || game == null)
            ? []
            : Games.getPlayers(game)
                .map(Archives.getScoreAndLevel.bind(archives))
                .map(Levels.decay.bind(decay, archives, game))
                .thisMap(Levels.update.bind(update))
                .filter(Archives.dontContain.bind(archives, game))
                .map(outcome.bind(game));

    // Generates the game outcome of a player
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
}

