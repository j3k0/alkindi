package alkindi;

using Lambda;
import alkindi.Fxp;
import alkindi.Types;

// Extract data from the players archives
class Archives {

    // Level for a player that never played any game
    public static inline var STARTING_LEVEL:Level = 0;

    // Find the archive of a given user
    public static inline function
    forPlayer (array:Array<PlayerArchive>, player:Username): Maybe<PlayerArchive>
        return Fxp.where(function(archive:PlayerArchive) {
            return archive.username == player;
        }, array);

    // Find the last game of a given player
    public static inline function
    lastGame (array:Array<PlayerArchive>, player:Username): Maybe<GameOutcome>
        return forPlayer(array, player)
            .map(Types.getGames)
            .chain(Fxp.last);

    // Returns the date of the last game of a given player
    public static inline function
    lastGameDate (archives:Array<PlayerArchive>, player:Username): Maybe<Timestamp>
        return lastGame(archives, player).map(Types.getGame).map(Types.getDate);

    // Returns true iff player's archive already contains the given game
    public static inline function
    contains (archive:PlayerArchive, game:Game):Bool
        return (archive.games != null &&
            archive.games.find(function(outcome:GameOutcome) {
                return outcome.game.id == game.id;
            }) != null);

    // Returns true iff given player's archive isn't found in his archive
    public static inline function
    dontContain (archives:Array<PlayerArchive>, game:Game, player:TUsername): Bool
        return !forPlayer(archives, Types.getUsername(player))
            .maybe(false, contains.bind(_, game));

    // Returns the players level from his archive
    public static inline function
    getLevel(archives:Array<PlayerArchive>, player:Username): Level
        return Maybe.of(archives)
            .chain(lastGame.bind(_, player))
            .map(Types.getOutcome)
            .maybe(STARTING_LEVEL, Types.getNewLevel);

    // Add level to the PlayerScore of a given player
    public static inline function
    getScoreAndLevel (archives:Array<PlayerArchive>, player:PlayerScore): PlayerScoreAndLevel
        return {
            username: player.username,
            score: player.score,
            level: getLevel(archives, player.username)
        }

    // Add level to the PlayerScore of all players
    public static inline function
    getScoreAndLevels (archives:Array<PlayerArchive>, players:Array<PlayerScore>): Array<PlayerScoreAndLevel>
        return players.map(getScoreAndLevel.bind(archives));
}
