package alkindi;

import alkindi.Alkindi;

class AlkindiTestCase extends haxe.unit.TestCase {

    public function testAddGame() {
        assertEquals(0, Alkindi.addGame(null,null,null,null).length);
    }
}
