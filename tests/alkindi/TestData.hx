package alkindi;

import alkindi.Types;
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
            outcome: { newLevel: 4 },
            game: {
                date: Int64.ofInt(1981),
                id: "dummy",
                players: []
            }
        }]
    }, {
        username: "jeko",
        games: []
    }];

    public static var dummyGame:Game = {
        id: "dummy",
        date: Int64.ofInt(0),
        players: [{
            username: "jeko",
            score: 21
        }, {
            username: "sousou",
            score: 20
        }]
    };
}
