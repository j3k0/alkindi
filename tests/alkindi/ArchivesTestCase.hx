package alkindi;

import haxe.Int64;
import alkindi.Types;
import alkindi.Archives;
import alkindi.Fxp;

class ArchivesTestCase extends haxe.unit.TestCase {

    public static function getTrue<T>(x:T) return true;

    public static var archivesNoGames:Array<PlayerArchive> = [{
        username: "sousou",
        games: []
    }, {
        username: "jeko",
        games: []
    }];

    public static var archivesSousou1:Array<PlayerArchive> = [{
        username: "sousou",
        games: [{
            outcome: { newLevel: 4 },
            game: null
        }]
    }, {
        username: "jeko",
        games: []
    }];

    public function testForPlayer() {
        assertTrue(
            Archives.forPlayer(archivesNoGames, "jeko")
            .maybe(false, getTrue));
        assertEquals("jeko",
            Archives.forPlayer(archivesNoGames, "jeko")
            .maybe("", Types.getUsername));
    }

    public function testLastGame() {

        assertEquals(1,
            Archives.forPlayer(archivesSousou1, "sousou")
            .map(Types.getGames)
            .maybe(-1, Reflect.field.bind(_, "length")));

        assertEquals(4,
            Archives.lastGame(archivesSousou1, "sousou")
            .map(Types.getOutcome)
            .map(Types.getNewLevel)
            .maybe(-1, Fxp.id));
    }

    public function testLastGameDate() {
        // TODO
    }

    public function testContains() {
        // TODO
    }

    public function testDontContain() {
        // TODO
    }

    public function testGetLevel() {
        // TODO
    }

    public function testGetScoreAndLevel() {
        // TODO
    }
}
