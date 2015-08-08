package alkindi;

import alkindi.Fxp;
import alkindi.Maybe;

class MaybeTestCase extends haxe.unit.TestCase {

    public function testOf() {
        assertTrue(Maybe.of() != null);
        assertTrue(Maybe.of(1) != null);
    }

    public function testIsNothing() {
        assertTrue(Maybe.of().isNothing());
        assertTrue(!Maybe.of(false).isNothing());
    }

    public function testMaybe() {
        assertEquals(1, Maybe.of().maybe(1, Fxp.id));
        assertEquals(2, Maybe.of(2).maybe(1, Fxp.id));
    }

    public function testMap() {
        var add3 = function(x:Int) return x + 3;
        assertTrue(!Maybe.of(5).map(add3).isNothing());
        assertTrue(Maybe.of(5).map(toNull).isNothing());
        assertEquals(8, Maybe.of(5).map(add3).maybe(0, Fxp.id));
    }

    public function testChain() {
        var add3 = function(x:Int)
            return x == 1 ? Maybe.of() : Maybe.of(x + 3);
        assertTrue(Maybe.of(1).chain(add3).isNothing());
        assertTrue(!Maybe.of(2).chain(add3).isNothing());
        assertEquals(8, Maybe.of(5).chain(add3).maybe(0, Fxp.id));
    }

    static function toNull<T>(x:T) return null;
}
