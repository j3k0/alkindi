package alkindi;

import haxe.Int64;
import alkindi.Types;
import alkindi.Archive;
import alkindi.Fxp;

class ArchiveTestCase extends haxe.unit.TestCase {

    public static function getTrue<T>(x:T) return true;

    public function testForPlayer() {
        var archives:Array<PlayerArchive> = [{
            username: "sousou",
            games: []
        }, {
            username: "jeko",
            games: []
        }];
        assertTrue(
            Archive.forPlayer(archives, "jeko")
            .maybe(false, getTrue));
        assertEquals("jeko",
            Archive.forPlayer(archives, "jeko")
            .maybe("", Types.getUsername));
    }

    public function testLastGame() {
        var archives:Array<PlayerArchive> = [{
            username: "sousou",
            games: [{
                outcome: { newLevel: 4 },
                game: null
            }]
        }, {
            username: "jeko",
            games: []
        }];

        assertEquals(1,
            Archive.forPlayer(archives, "sousou")
            .map(Types.getGames)
            .map(Reflect.field.bind(_, "length"))
            .maybe(-1, Fxp.id));

        var x:GameOutcome = {
            game: null,
            outcome: { newLevel: 12 }
        };

        assertEquals(4,
            Archive.lastGame(archives, "sousou")
            .map(Types.getOutcome)
            .map(Types.getNewLevel)
            .maybe(-1, Fxp.id));
    }

}
