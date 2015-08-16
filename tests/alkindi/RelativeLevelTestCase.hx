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

    public function testLatestTime() {
        assertEquals(Alkindi.TRIPOCH + 1981, Std.int(RelativeLevel.latestTime(TestData.archivesSousou1)));
    }

    public function testUpdate() {
        var players = [
            { username: "jeko", score: 20, level: 50 },
            { username: "sousou", score: 30, level: 60 }
        ];
        var asUpdateFunction:LevelUpdateFunction = RelativeLevel.update;
        assertEquals(null, RelativeLevel.update(players, [], "none"));
        assertEquals(90, RelativeLevel.update(players, TestData.archivesSousou1, "sousou").newLevel);
        TestData.archivesSousou1[0].games[0].game.date += 3600 * 24 * 30;
        assertEquals(120, RelativeLevel.update(players, TestData.archivesSousou1, "sousou").newLevel);
        TestData.archivesSousou1[0].games[0].game.date -= 3600 * 24 * 30;
        //assertEquals(57, RelativeLevel.update(players, [], "jeko").newLevel);
    }
}

