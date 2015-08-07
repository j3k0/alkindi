package alkindi;

import haxe.Int64;
import alkindi.Types;
import alkindi.Alkindi;
import alkindi.Fxp;

class AlkindiTestCase extends haxe.unit.TestCase {

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
        assertEquals(2,  F.getPlayers(game).length);
        assertEquals(21, F.getBestScore(F.getPlayers(game)));
    }
}
