package alkindi;

import alkindi.Types;
import alkindi.AddGame;
import alkindi.Fxp;

class AddGameTestCase extends haxe.unit.TestCase {

    public function testOutcome() {
        assertEquals(99, 
            AddGame.outcome(TestData.dummyGame, {
                username: "sousou",
                score: 20,
                level: 99
            }).game.outcome.newLevel);
    }

    public function testExecute() {
        var arr = AddGame.execute(TestData.myUpdate, TestData.myDecay, TestData.archivesSousou1, TestData.dummyGame);
        assertEquals(2, arr.length);
        assertEquals("jeko", arr[0].username);
        assertEquals(100, arr[0].game.outcome.newLevel);
        assertEquals("sousou", arr[1].username);
        assertEquals(140, arr[1].game.outcome.newLevel);
    }

}


