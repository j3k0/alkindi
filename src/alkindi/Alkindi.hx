package alkindi;

import alkindi.AddGame;
import alkindi.SimpleLevel;
import alkindi.Types;

@:expose
class Alkindi {

    // Decay and update game participants levels, based on each one's score.
    //
    // Returns an array of outcomes, which for now is simply the players' new level.
    // 
    // Note: if the added game is already in the player archive: outcome will be an empty array.
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

    // This level function will increase `level` by:
    //
    // * `30` points for the player(s) with the best score
    // * `7` for other players
    public static function
    simpleLevelUpdate (scores:Array<PlayerScoreAndLevel>, username:Username): LevelUpdate
        return SimpleLevel.update(scores, username);

    // Level decreases 1 point per day, but won't go below 0.
    public static function
    simpleLevelDecay (then:Date, now:Date, level:Level): LevelUpdate
        return SimpleLevel.decay(then, now, level);

    /*
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
    */
}
