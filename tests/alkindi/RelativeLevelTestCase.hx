package alkindi;

import alkindi.Types;
import alkindi.Maybe;
import alkindi.TestData;

class RelativeLevelTestCase extends haxe.unit.TestCase {

    public static var winner = { username: "s", winner: true };
    public static var loser = { username: "s", winner: false };

    public function testNewLevel() {
        //assertEquals(50, RelativeLevel.newLevel(20, winner).newLevel);
        //assertEquals(27, RelativeLevel.newLevel(20, loser).newLevel);
    }

    public function testMaybeNewLevel() {
        //assertTrue(RelativeLevel.maybeNewLevel(Maybe.of(), winner).isNothing());
        //assertFalse(RelativeLevel.maybeNewLevel(Maybe.of(20), winner).isNothing());
    }

    public function testUpdate() {
        var players = [
            { username: "jeko", score: 20, level: 50 },
            { username: "sousou", score: 30, level: 60 }
        ];
        var asUpdateFunction:LevelUpdateFunction = RelativeLevel.update;
        assertEquals(null, RelativeLevel.update(players, [], "none"));
        //assertEquals(90, RelativeLevel.update(players, [], "sousou").newLevel);
        //assertEquals(57, RelativeLevel.update(players, [], "jeko").newLevel);
    }

    public function testDecay() {
        var asDecayFunction:LevelDecayFunction = RelativeLevel.decay;
        // assertEquals(99, RelativeLevel.decay(0, 3600 * 24 + 1, 100).newLevel);
    }
}

