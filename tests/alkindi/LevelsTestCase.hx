package alkindi;

import alkindi.Types;
import alkindi.Levels;
import alkindi.Fxp;

class LevelsTestCase extends haxe.unit.TestCase {

    public function testApplyUpdate() {
        assertEquals(4,
            Levels.applyUpdate({
                username: "sousou", score: 22, level: 3
            }, {
                newLevel: 4
            }).level);
    }

    public function testDecay() {
        assertEquals(90,
            Levels.decay(TestData.myDecay, TestData.archivesSousou1, TestData.dummyGame, {
                username: "sousou", score: 33, level: 100
            }).level);
    }

    public function testUpdate() {
        var jeko = { username: "jeko", score: 21, level: 10 }; 
        var sousou = { username: "sousou", score: 11, level: 100 };
        assertEquals(200, Levels.update(TestData.myUpdate, [], [sousou, jeko], sousou).level);
    }
}

