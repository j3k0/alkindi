package alkindi;

import haxe.Int64;
import alkindi.Types;
import alkindi.Archives;
import alkindi.Fxp;
import alkindi.TestData;

class ArchivesTestCase extends haxe.unit.TestCase {

    public static function getTrue<T>(x:T) return true;

    public function testForPlayer() {
        assertTrue(
            Archives.forPlayer(TestData.archivesNoGames, "jeko")
            .maybe(false, getTrue));
        assertEquals("jeko",
            Archives.forPlayer(TestData.archivesNoGames, "jeko")
            .maybe("", Types.getUsername));
    }

    public function testLastGame() {

        assertEquals(1,
            Archives.forPlayer(TestData.archivesSousou1, "sousou")
            .map(Types.getGames)
            .maybe(-1, Reflect.field.bind(_, "length")));

        assertEquals(4,
            Archives.lastGame(TestData.archivesSousou1, "sousou")
            .map(Types.getOutcome)
            .map(Types.getNewLevel)
            .maybe(-1, Fxp.id));
    }

    public function testLastGameDate() {
        assertEquals(1981,
            Archives.lastGameDate(TestData.archivesSousou1, "sousou")
            .maybe(0, Int64.toInt));
        assertEquals(0,
            Archives.lastGameDate(TestData.archivesSousou1, "jeko")
            .maybe(0, Int64.toInt));
    }

    public function testContains() {
        assertTrue(Archives.contains(TestData.archivesSousou1[0], { id: "dummy" }));
        assertFalse(Archives.contains(TestData.archivesSousou1[0], { id: "none" }));
    }

    public function testDontContain() {
        assertFalse(Archives.dontContain(TestData.archivesSousou1,
                                        { id: "dummy" }, { username: "sousou" }));
        assertTrue(Archives.dontContain(TestData.archivesSousou1,
                                        { id: "none" }, { username: "sousou" }));
        assertTrue(Archives.dontContain(TestData.archivesSousou1,
                                        { id: "dummy" }, { username: "jeko" }));
    }

    public function testGetLevel() {
        assertEquals(4, Archives.getLevel(TestData.archivesSousou1, "sousou"));
        assertEquals(Archives.STARTING_LEVEL,
                     Archives.getLevel(TestData.archivesSousou1, "jeko"));
    }

    public function testGetScoreAndLevel() {
        assertEquals(25, Archives.getScoreAndLevel(TestData.archivesSousou1,
                                                   { username: "sousou", score: 25 }).score);
        assertEquals(4, Archives.getScoreAndLevel(TestData.archivesSousou1,
                                                   { username: "sousou", score: 25 }).level);
        assertEquals("sousou", Archives.getScoreAndLevel(TestData.archivesSousou1,
                                                   { username: "sousou", score: 25 }).username);
    }
}
