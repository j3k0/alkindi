package alkindi;

import alkindi.Types;
import alkindi.Archives;
import haxe.Int64;

class TestData {

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
            outcome: { newLevel: 50 },
            game: {
                date: Int64.ofInt(1981),
                id: "mummy",
                players: []
            }
        }]
    }, {
        username: "jeko",
        games: []
    }];

    public static var dummyGame:Game = {
        id: "dummy",
        date: Int64.ofInt(1991),
        players: [{
            username: "jeko",
            score: 21
        }, {
            username: "sousou",
            score: 20
        }]
    };

    public static function myDecay(d0:Timestamp, d1:Timestamp, l:Level): LevelUpdate
        return { newLevel: l + (Int64.toInt(d0) - Int64.toInt(d1)) }

    public static function myUpdate(players:Array<PlayerScoreAndLevel>, username:Username): LevelUpdate
        return { newLevel: Archives.forPlayerSL(players, username).maybe(Archives.STARTING_LEVEL, Types.getLevel) + 100 }
}
