package alkindi;

import haxe.Int64;
import alkindi.Types;
import alkindi.Alkindi;
import alkindi.Fxp;

class AlkindiTestCase extends haxe.unit.TestCase {

    public function testAddGame() {
        assertEquals(0, Alkindi.addGame(null,null,null,null).length);
    }
}
