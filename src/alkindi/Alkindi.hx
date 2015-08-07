package alkindi;

import alkindi.Fxp;
import alkindi.Types;
import alkindi.Archives;
import alkindi.Games;
using Lambda;

class F {

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
    addGame(update:LevelUpdateFunction, decay:LevelDecayFunction, archives:Array<PlayerArchive>, game:Game) : Array<PlayerGameOutcome>
    {
        if (update == null || decay == null || archives == null || game == null)
            return [];

        var players = Games.getPlayers(game).filter(Archives.dontContain.bind(archives, game));
        var scoreAndLevels = Archives.getScoreAndLevels(archives, players);
        var decayed = scoreAndLevels.map(decayedLevel.bind(decay, archives, game));
        var updated = decayed.map(updatedLevel.bind(update, decayed));
        return outcomes(game, updated);
        //var bestScore = players.maybe(0, getBestScore);
        //var winlose = players.map(getWinners.bind(bestScore));
        //return null;
    }
}

@:expose
class Alkindi {
    static function emptyLevelUpdate() return { newLevel: 0 };

    static function emptyPlayerStats() return {
        username: "",
        victories: [],
        defeats: [],
        rankings: [],
        winningSprees: []
    };

    public static function
    addGame (update:LevelUpdateFunction, decay:LevelDecayFunction, archives:Array<PlayerArchive>, game:Game): Array<PlayerGameOutcome>
        return F.addGame(update, decay, archives, game);

    public static function
    simpleLevelUpdate (scores:Array<PlayerScoreAndLevel>, username:String): LevelUpdate {
        var highest = 0;
        var score = 0;

        for (scorelevel in scores) {
            if (scorelevel.score > highest) highest = scorelevel.score;
            if (username == scorelevel.username) score = scorelevel.score;
        }

        var newLevel : Int;
        if (score == highest)
            newLevel = 30;
        else
            newLevel = 7;
        
        return { newLevel: newLevel };
    }

    public static function simpleLevelDecay( then : Date
                                           , now : Date
                                           , level : Int
                                           ) : LevelUpdate {
        return emptyLevelUpdate();
    }

    public static function getPlayerStats(archive:PlayerArchive):PlayerStats {
        var games = archive.games;

        var victories : Array<DateValue> = [];
        var defeats : Array<DateValue> = [];
        var rankings : Array<DateValue> = [];
        var winningSprees : Array<DateValue> = [];

        var stats : PlayerStats =
            { username: archive.username
            , victories: victories
            , defeats: defeats
            , rankings: rankings
            , winningSprees: winningSprees
            };

        return stats;
    }
}
