package alkindi;

import alkindi.Types;
import alkindi.AddGame;
import alkindi.Fxp;
import alkindi.Maybe;
import alkindi.TestData;

class SimpleLevelTestCase extends haxe.unit.TestCase {

    public static var winner = { username: "s", winner: true };
    public static var loser = { username: "s", winner: false };

    public function testNewLevel() {
        assertEquals(50, SimpleLevel.newLevel(20, winner).newLevel);
        assertEquals(27, SimpleLevel.newLevel(20, loser).newLevel);
    }

    public function testMaybeNewLevel() {
        assertTrue(SimpleLevel.maybeNewLevel(Maybe.of(), winner).isNothing());
        assertFalse(SimpleLevel.maybeNewLevel(Maybe.of(20), winner).isNothing());
    }

    public function testUpdate() {
        var players = [
            { username: "jeko", score: 20, level: 50 },
            { username: "sousou", score: 30, level: 60 }
        ];
        assertEquals(null, SimpleLevel.update(players, "none"));
        assertEquals(90, SimpleLevel.update(players, "sousou").newLevel);
        assertEquals(57, SimpleLevel.update(players, "jeko").newLevel);
    }

    public function testDecay() {
        // TODO
    }
}
