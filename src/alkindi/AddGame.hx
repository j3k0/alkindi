package alkindi;

import alkindi.Types;
import alkindi.Archives;
import alkindi.Games;

using alkindi.Fxp;
using Lambda;

// Compute the effect of game on players statistics
class AddGame {

    // Exectute the addGame operation.
    //
    // Returns an array of outcomes.
    public static inline function
    execute(update:LevelUpdateFunction, decay:LevelDecayFunction, archives:Array<PlayerArchive>, game:Game) : Array<PlayerGameOutcome>
    {
        // Missing arguments, no outcome
        if (update == null || decay == null || archives == null || game == null)
            return [];

        return Games.getPlayers(game)
                      .map(Archives.getScoreAndLevel.bind(archives))
                      .map(decayedLevel.bind(decay, archives, game))
        // return decayed.map(updatedLevel.bind(update, decayed))
                      .thisMap(updatedLevel.bind(update))
                      .filter(Archives.dontContain.bind(archives, game))
                      .map(outcome.bind(game));
    }

    // Apply a LevelUpdate to a PlayerScoreAndLevel
    public static inline function
    applyUpdate (player:PlayerScoreAndLevel, levelUpdate:LevelUpdate): PlayerScoreAndLevel
        return {
            username: player.username,
            score: player.score,
            level: Types.getNewLevel(levelUpdate)
        }

    // Returns the updated level of a single player after decay
    public static inline function
    decayedLevel (decay:LevelDecayFunction, archives:Array<PlayerArchive>, game:Game, player:PlayerScoreAndLevel): PlayerScoreAndLevel
        return applyUpdate(player, 
            Archives.lastGameDate(archives, player.username).maybe(
                { newLevel: player.level },
                decay.bind(_, game.date, player.level)));

    // Returns the updated level of a single player after accounting his result in a game.
    public static inline function
    updatedLevel (update:LevelUpdateFunction, players:Array<PlayerScoreAndLevel>, player:PlayerScoreAndLevel): PlayerScoreAndLevel
        return applyUpdate(player, update(players, player.username));

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

