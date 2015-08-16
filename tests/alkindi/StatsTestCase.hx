package alkindi;

import alkindi.Types;
import alkindi.Stats;
import alkindi.TestData;
import alkindi.Fxp;

class StatsTestCase extends haxe.unit.TestCase {

    public function testVictories() {
        assertEquals(2, Stats.victories(TestData.complexArchive).length);
        assertEquals(Alkindi.TRIPOCH + 1981., Stats.victories(TestData.complexArchive)[0].date);
        assertEquals(1, Stats.victories(TestData.complexArchive)[0].value);
        assertEquals(Alkindi.TRIPOCH + 2004., Stats.victories(TestData.complexArchive)[1].date);
        assertEquals(2, Stats.victories(TestData.complexArchive)[1].value);
    }

    public function testDefeats() {
        assertEquals(1, Stats.defeats(TestData.complexArchive).length);
        assertEquals(Alkindi.TRIPOCH + 1990., Stats.defeats(TestData.complexArchive)[0].date);
        assertEquals(1, Stats.defeats(TestData.complexArchive)[0].value);
    }

    public function testLevels() {
        assertEquals(3, Stats.levels(TestData.complexArchive).length);
        assertEquals(30., Stats.levels(TestData.complexArchive)[0].value);
        assertEquals(37., Stats.levels(TestData.complexArchive)[1].value);
        assertEquals(67., Stats.levels(TestData.complexArchive)[2].value);
    }

    public function testHasPositiveDateAndValue() {
        assertTrue(Stats.hasPositiveDateAndValue({ date: 0, value: 0 }));
        assertTrue(Stats.hasPositiveDateAndValue({ date: 1, value: 0 }));
        assertTrue(Stats.hasPositiveDateAndValue({ date: 0, value: 1 }));
        assertFalse(Stats.hasPositiveDateAndValue({ date: 0, value: -1 }));
        assertFalse(Stats.hasPositiveDateAndValue({ date: -1, value: 0 }));
        assertFalse(Stats.hasPositiveDateAndValue({ date: 0, value: null }));
        assertFalse(Stats.hasPositiveDateAndValue({ date: null, value: -1 }));
    }

    public function testDateLevel() {
    }

    public function testGameDate() {
    }

    public function testGameLevel() {
    }

    public function testGameCounter() {
    }

    public function testGames() {
    }

    public function testIsVictory() {
    }

    public function testGetPlayerScore() {
        var games = TestData.complexArchive.games;
        // roger isn't a player
        assertTrue(Stats.getPlayerScore("roger", games[0].game).isNothing());
        assertTrue(Stats.getPlayerScore("roger", null).isNothing());
        // standard cases
        assertEquals(20, Stats.getPlayerScore("sousou", games[0].game).maybe(0, Types.getScore));
        assertEquals(20, Stats.getPlayerScore("sousou", games[1].game).maybe(0, Types.getScore));
        assertEquals(20, Stats.getPlayerScore("sousou", games[2].game).maybe(0, Types.getScore));
        assertEquals(20, Stats.getPlayerScore("jeko", games[0].game).maybe(0, Types.getScore));
        assertEquals(51, Stats.getPlayerScore("jeko", games[1].game).maybe(0, Types.getScore));
        assertEquals(11, Stats.getPlayerScore("jeko", games[2].game).maybe(0, Types.getScore));
    }

    public function testIsGameVictory() {
        var games = TestData.complexArchive.games;
        // roger isn't a player, so he's not winning obviously
        assertFalse(Stats.isGameVictory("roger", games[0].game));
        assertFalse(Stats.isGameVictory("roger", null));
        // those are standard cases
        assertEquals(true, Stats.isGameVictory("sousou", games[0].game));
        assertEquals(false, Stats.isGameVictory("sousou", games[1].game));
        assertEquals(true, Stats.isGameVictory("sousou", games[2].game));
        assertEquals(true, Stats.isGameVictory("jeko", games[0].game));
        assertEquals(true, Stats.isGameVictory("jeko", games[1].game));
        assertEquals(false, Stats.isGameVictory("jeko", games[2].game));
    }

    public function testGetBestScore() {
        var games = TestData.complexArchive.games;
        assertEquals(20, Stats.getBestScore(games[0].game));
        assertEquals(51, Stats.getBestScore(games[1].game));
        assertEquals(20, Stats.getBestScore(games[2].game));
    }

    public function testExecute() {
        // victories (tested in details in testVictories)
        assertEquals(2, Stats.execute(TestData.complexArchive).victories.length);
        assertEquals(1, Stats.execute(TestData.complexArchive).defeats.length);
    }
}

