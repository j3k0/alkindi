package alkindi;

using alkindi.Fxp;

class FxpTestCase extends haxe.unit.TestCase {

    public static function add(a:Int, b:Int) return a + b;
    public static function mul(a:Int, b:Int) return a * b;
    public static function equals(a:Int, b:Int) return a == b;

    public function testCompose() {
        var add5mul2 = Fxp.compose(mul.bind(2), add.bind(5));
        assertEquals(12, add5mul2(1));
    }

    public function testWhere() {
        assertTrue(Fxp.where(equals.bind(4), [1,2,3]).isNothing());
        assertEquals(3, Fxp.where(equals.bind(3), [1,2,3]).maybe(-1, Fxp.id));
    }

    public function testLast() {
        assertEquals(3, Fxp.last([1,2,3]).maybe(-1, Fxp.id));
        assertEquals(-1, Fxp.last([]).maybe(-1, Fxp.id));
    }

    public function testThisMap() {
        var res = Fxp.thisMap([1,2,3], function(a:Array<Int>, x:Int) { return a.length + x; } );
        assertEquals(4, res[0]);
        assertEquals(5, res[1]);
        assertEquals(6, res[2]);
        var dotNot = [1,2,3].thisMap(function(a:Array<Int>, x:Int) { return a.length + x; } );
        assertEquals(4, res[0]);
    }

    public function testArity() {
        assertEquals(0, testArity.arity());
        assertEquals(1, Fxp.id.arity());
        assertEquals(2, Fxp.compose.arity());
    }
}
