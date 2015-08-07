package alkindi;

import alkindi.AddGame;
import alkindi.Types;

//var bestScore = players.maybe(0, getBestScore);
//var winlose = players.map(getWinners.bind(bestScore));
//return null;

@:expose
class Alkindi {

    //
    public static function
    addGame (update:LevelUpdateFunction, decay:LevelDecayFunction, archives:Array<PlayerArchive>, game:Game): Array<PlayerGameOutcome>
        return AddGame.execute(update, decay, archives, game);

    static function emptyLevelUpdate() return { newLevel: 0 };

    static function emptyPlayerStats() return {
        username: "",
        victories: [],
        defeats: [],
        rankings: [],
        winningSprees: []
    };

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
