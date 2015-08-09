package alkindi;

using alkindi.Fxp;

class FxpTestCase extends haxe.unit.TestCase {

    public static function add(a:Int, b:Int) return a + b;
    public static function mul(a:Int, b:Int) return a * b;

    public function testCompose() {
        var add5mul2 = Fxp.compose(mul.bind(2), add.bind(5));
        assertEquals(12, add5mul2(1));
    }

    public function testWhere() {
        assertTrue(Fxp.where(Fxp.equals.bind(4), [1,2,3]).isNothing());
        assertEquals(3, Fxp.where(Fxp.equals.bind(3), [1,2,3]).maybe(-1, Fxp.id));
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

    public function testWaterfall() {
        var x = Fxp.waterfall([1,1,2,2,3,4,5,6,7,0,8,9], function(acc:Int, v:Int):Int {
            return v == 0 ? 0 : (v % 2) == 0 ? acc + 1 : acc;
        }, 0);
        assertEquals(0, x[0]);
        assertEquals(0, x[1]);
        assertEquals(1, x[2]);
        assertEquals(2, x[3]);
        assertEquals(2, x[4]);
        assertEquals(3, x[5]);
        assertEquals(3, x[6]);
        assertEquals(4, x[7]);
        assertEquals(4, x[8]);
        assertEquals(0, x[9]);
        assertEquals(1, x[10]);
        assertEquals(1, x[11]);
    }

    public function testArity() {
        assertEquals(0, testArity.arity());
        assertEquals(1, Fxp.id.arity());
        assertEquals(2, Fxp.compose.arity());
    }
}
