package alkindi;

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

        assertEquals(50,
            Archives.lastGame(TestData.archivesSousou1, "sousou")
            .map(Types.getOutcome)
            .map(Types.getNewLevel)
            .maybe(-1, Fxp.id));
    }

    public function testLastGameDate() {
        assertEquals(Alkindi.TRIPOCH + 1981.,
            Archives.lastGameDate(TestData.archivesSousou1, "sousou")
            .maybe(0., Fxp.id));
        assertEquals(0.,
            Archives.lastGameDate(TestData.archivesSousou1, "jeko")
            .maybe(0., Fxp.id));
    }

    public function testContains() {
        assertTrue(Archives.contains(TestData.archivesSousou1[0], { id: "mummy" }));
        assertFalse(Archives.contains(TestData.archivesSousou1[0], { id: "none" }));
    }

    public function testDontContain() {
        assertFalse(Archives.dontContain(TestData.archivesSousou1,
                                        { id: "mummy" }, { username: "sousou" }));
        assertTrue(Archives.dontContain(TestData.archivesSousou1,
                                        { id: "none" }, { username: "sousou" }));
        assertTrue(Archives.dontContain(TestData.archivesSousou1,
                                        { id: "mummy" }, { username: "jeko" }));
        assertTrue(Archives.dontContain(TestData.archivesSousou1, TestData.dummyGame, { username: "sousou" }));
    }

    public function testGetLevel() {
        assertEquals(50, Archives.getLevel(TestData.archivesSousou1, "sousou"));
        assertEquals(Archives.STARTING_LEVEL,
                     Archives.getLevel(TestData.archivesSousou1, "jeko"));
    }

    public function testGetScoreAndLevel() {
        assertEquals(25, Archives.getScoreAndLevel(TestData.archivesSousou1,
                                                   { username: "sousou", score: 25 }).score);
        assertEquals(50, Archives.getScoreAndLevel(TestData.archivesSousou1,
                                                   { username: "sousou", score: 25 }).level);
        assertEquals("sousou", Archives.getScoreAndLevel(TestData.archivesSousou1,
                                                   { username: "sousou", score: 25 }).username);
        assertEquals(Archives.STARTING_LEVEL, Archives.getScoreAndLevel(TestData.archivesSousou1,
                                                   { username: "jeko", score: 25 }).level);
    }
}
