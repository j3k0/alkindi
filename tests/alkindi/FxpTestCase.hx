package alkindi;

import alkindi.Fxp;

class FxpTestCase extends haxe.unit.TestCase {

    public function testMaybe() {
        assertEquals(true, Maybe.of().isNothing());
        var add3 = function(x:Int) return x + 3;
        assertEquals(8, Maybe.of(5).map(add3).maybe(0, Fxp.id));
    }

    public function testLast() {
        assertEquals(3, Fxp.last([1,2,3]).maybe(-1, Fxp.id));
    }
}
