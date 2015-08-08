package alkindi;

using Lambda;
import alkindi.Fxp;
import alkindi.Maybe;
import alkindi.Types;

// Extract data from the players archives
class Archives {

    // Level for a player that never played any game
    public static inline var STARTING_LEVEL:Level = 0;

    public static inline function
    equalUsers (username:Username, user:PlayerArchive):Bool
        return user.username == username;

    // Find the archive of a given user
    public static inline function
    forPlayer (array:Iterable<PlayerArchive>, player:Username): Maybe<PlayerArchive>
        return Fxp.where(equalUsers.bind(player), array);

    public static inline function
    equalUsersSL (username:Username, user:PlayerScoreAndLevel):Bool
        return user.username == username;

    // Find the PlayerScoreAndLevel from a given username
    public static inline function
    forPlayerSL (array:Iterable<PlayerScoreAndLevel>, player:Username): Maybe<PlayerScoreAndLevel>
        return Fxp.where(equalUsersSL.bind(player), array);

    // Find the last game of a given player
    public static function
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
    contains (archive:PlayerArchive, game:TGameId):Bool
        return (archive.games != null &&
            archive.games.find(function(outcome:GameOutcome) {
                return outcome.game.id == game.id;
            }) != null);

    // Returns true iff given player's archive isn't found in his archive
    public static inline function
    dontContain (archives:Array<PlayerArchive>, game:TGameId, player:TUsername): Bool
        return !forPlayer(archives, player.username)
            .maybe(false, contains.bind(_, game));

    // Returns the players level from his archive
    public static inline function
    getLevel (archives:Array<PlayerArchive>, player:Username): Level
        return Maybe.of(archives)
            .chain(lastGame.bind(_, player))
            .map(Types.getOutcome)
            .map(Types.getNewLevel)
            .maybe(STARTING_LEVEL, Fxp.id);

    // Add level to the PlayerScore of a given player
    public static inline function
    getScoreAndLevel (archives:Array<PlayerArchive>, player:PlayerScore): PlayerScoreAndLevel
        return {
            username: player.username,
            score: player.score,
            level: getLevel(archives, player.username)
        }
}
