package alkindi;

import alkindi.Archives;
import alkindi.Games;
import alkindi.Levels;
import alkindi.Types;

using alkindi.Fxp; // thisMap
using Lambda; // map

// Compute the effect of game on players statistics
class AddGame {

    // Decay and update game participants levels, based on each one's score.
    //
    // Returns an array of outcomes, which for now is simply the players' new level.
    // 
    // Note: if the added game is already in the player archive: outcome will be an empty array.
    public static inline function
    execute (update:LevelUpdateFunction, decay:LevelDecayFunction, archives:Array<PlayerArchive>, game:Game): Array<PlayerGameOutcome>
        return (update == null || decay == null || archives == null || game == null)
            ? []
            : Games.getPlayers(game)
                // get players' scores and level
                .map(Archives.getScoreAndLevel.bind(archives))
                // decay
                .map(Levels.decay.bind(decay, archives, game))
                // update
                .thisMap(Levels.update.bind(update, archives))
                // filter
                .filter(Archives.dontContain.bind(archives, game))
                // return
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

