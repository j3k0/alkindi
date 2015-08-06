package alkindi;

import alkindi.Game;
import alkindi.Level;
import alkindi.Stats;


@:expose
class Alkindi {
    static function emptyLevelUpdate(){ return {newLevel: 0}; }

    static function emptyPlayerStats(){
        return { username: ""
               , victories: []
               , defeats: []
               , rankings: []
               , winningSprees: []
               };
    };

    static function getLevel(archives:Array<PlayerArchive>, player:String) {
        for (archive in archives) {
            if (archive.username == player) {
                return archive.games[-1].outcome.newLevel;
            }
        }
        return 0;
    }

    static function getLastPlay(archives:Array<PlayerArchive>, player:String, game:Game) {
        for (archive in archives) {
            if (archive.username == player) {
                return archive.games[-1].game.date;
            }
        }
        return game.date;
    }

    static function hasGame(archives:Array<PlayerArchive>, player:String, game:Game) {
        for (archive in archives) {
            if (archive.username == player) {
                for (existing in archive.games) {
                    if (existing.game == game) return true;
                }
                return false;
            }
        }
        return false;
    }

    public static function addGame( update : LevelUpdateFunction
                                  , decay : LevelDecayFunction
                                  , archives : Array<PlayerArchive>
                                  , game : Game
                                  ) : Array<PlayerGameOutcome> {

        var outcomes = [];

        var levels : Map<String, Int> = new Map();

        for (player in game.players) {
            levels[player.username] = getLevel(archives, player.username);
        }

        var scoreLevels = [
            for (player in game.players)
                { username: player.username
                , score: player.score
                , level: levels[player.username]
                }
        ];

        for (player in game.players) {
            var name = player.username;

            // TODO if we can safely assume that if ANY of the
            // player archives contain this game, then they ALL will...
            // we can check for that much earlier in the function (cheaply enough)
            // and save a lot more time
            if (hasGame(archives, name, game)) continue;

            var lastPlay = getLastPlay(archives, name, game);
            var updated = update(scoreLevels, name);
            var decayed = decay(lastPlay, game.date, updated.newLevel);

            var gameOutcome =
                { game: game
                , outcome: decayed
                }

            outcomes.push(
                { username: name
                , game: gameOutcome
                }
            );
        }

        return outcomes;
        
    }

    public static function simpleLevelUpdate( scores : Array<PlayerScoreAndLevel>
                                            , username: String
                                            ) : LevelUpdate {
        return emptyLevelUpdate();
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
