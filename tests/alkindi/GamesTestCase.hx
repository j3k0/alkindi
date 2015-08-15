package alkindi;

import alkindi.Types;
import alkindi.Games;
import alkindi.Fxp;

class GamesTestCase extends haxe.unit.TestCase {

    public function testMaxScore() {
        assertEquals(2, Games.maxScore(1,2));
    }

    public function testBestScore() {
        assertEquals(3, Games.getBestScore([
            { score: 1 },
            { score: 3 },
            { score: 2 }
        ]));
    }

    public function testBestLevel() {
        assertEquals(3, Games.getBestLevel([
            { level: 1 },
            { level: 3 },
            { level: 2 }
        ]));
    }

    public function testGetPlayers() {
        assertEquals(2,  Games.getPlayers(TestData.dummyGame).length);
        assertEquals(21, Games.getBestScore(Games.getPlayers(TestData.dummyGame)));
    }

    public function testIsWinner() {
        assertEquals("jeko", Games.isWinner(21, { username: "jeko", score: 21 }).username);
        assertTrue(Games.isWinner(21, { username: "jeko", score: 21 }).winner);
        assertFalse(Games.isWinner(22, { username: "jeko", score: 21 }).winner);
    }
}
