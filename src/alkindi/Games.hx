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
    public static var
    getBestScore: Array<PlayerScore> -> Score
        = Fxp.compose(
            Lambda.fold.bind(_, maxScore, 0),
            Lambda.map.bind(_, Types.getScore)
        );

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

    // Returns all players winning status
    public static inline function
    getWinners (bestScore:Score, players:Array<PlayerScore>): Array<PlayerWinner>
        return players.map(isWinner.bind(bestScore));
}
