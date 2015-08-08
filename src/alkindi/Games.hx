package alkindi;

using Lambda;
import alkindi.Fxp;
import alkindi.Types;
import alkindi.Maybe;

// Extract data from games
class Games {
    
    // Returns the best of 2 scores
    public static inline function
    maxScore (s1:Score, s2:Score): Score
        return Std.int(Math.max(s1,s2));

    // Returns the best of all players' scores
    public static inline function
    getBestScore (scores:Iterable<TScore>): Score
        return scores.map(Types.getScore).fold(maxScore, 0);

    // Return all players of a game
    public static inline function
    getPlayers (game:Game): Array<PlayerScore>
        return Maybe.of(game).map(Types.getPlayers).maybe([], Fxp.id);

    // Returns a player's winning status
    public static inline function
    isWinner (bestScore:Score, player:PlayerScore): PlayerWinner
        return {
            username: player.username,
            winner: player.score == bestScore
        }
}
