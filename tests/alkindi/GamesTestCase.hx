package alkindi;

import haxe.Int64;
import alkindi.Types;
import alkindi.Games;
import alkindi.Fxp;

class GamesTestCase extends haxe.unit.TestCase {

    public function testMaxScore() {
        // TODO
    }

    public function testBestScore() {
        // TODO
    }

    public function testGetPlayers() {
        var game:Game = {
            id: "dummy",
            date: Int64.ofInt(0),
            players: [{
                username: "jeko",
                score: 21
            }, {
                username: "sousou",
                score: 20
            }]
        };
        assertEquals(2,  Games.getPlayers(game).length);
        assertEquals(21, Games.getBestScore(Games.getPlayers(game)));
    }

    public function testIsWinner() {
        // TODO
    }
}
