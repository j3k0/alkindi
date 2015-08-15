package alkindi;

import alkindi.Types;
import alkindi.Archives;

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
                date: 1981,
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
        date: 1991,
        players: [{
            username: "jeko",
            score: 21
        }, {
            username: "sousou",
            score: 20
        }]
    };

    public static var complexArchive:PlayerArchive = {
        username: "sousou",
        games: [{
            outcome: { newLevel: 30 },
            game: {
                date: 1981,
                id: "mummy1",
                players: [{ username:"jeko", score:20 }, { username:"sousou", score:20 }]
            }
        }, {
            outcome: { newLevel: 37 },
            game: {
                date: 1990,
                id: "mummy2",
                players: [{ username:"jeko", score:51 }, { username:"sousou", score:20 }]
            }
        }, {
            outcome: { newLevel: 67 },
            game: {
                date: 2004,
                id: "mummy3",
                players: [{ username:"jeko", score:11 }, { username:"sousou", score:20 }]
            }
        }]
    };

    public static function myDecay(d0:Timestamp, d1:Timestamp, l:Level): LevelUpdate
        return { newLevel: l + Std.int(d0 - d1) }

    public static function myUpdate(players:Array<PlayerScoreAndLevel>, archives:Array<PlayerArchive>, username:Username): LevelUpdate
        return { newLevel: Archives.forPlayerSL(players, username).maybe(Archives.STARTING_LEVEL, Types.getLevel) + 100 }
}
