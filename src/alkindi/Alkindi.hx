package alkindi;

import alkindi.Types;
import alkindi.AddGame;
import alkindi.SimpleLevel;
import alkindi.Stats;

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

    // This level function will increase `level` by:
    //
    // * `30` points for the player(s) with the best score
    // * `7` for other players
    public static function
    simpleLevelUpdate (scores:Array<PlayerScoreAndLevel>, username:Username): LevelUpdate
        return SimpleLevel.update(scores, username);

    // Level decreases 1 point per day, but won't go below 0.
    public static function
    simpleLevelDecay (then:Timestamp, now:Timestamp, level:Level): LevelUpdate
        return SimpleLevel.decay(then, now, level);

    // Compute a player' statistics from her archive of games
    public static function
    getPlayerStats (archive:PlayerArchive): PlayerStats
        return Stats.execute(archive);
}
