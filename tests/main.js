var alkindi = require("../index");

var archives = [{
    username: "sousou",
    games: [{
        outcome: { "newLevel": 50 },
        game: {
            date: 1981,
            id: "mummy",
            players: [{
                username: "sousou",
                score: 20
            }, {
                username: "oreo",
                score: 35
            }]
        }
    }]
}, {
    username: "jeko",
    games: []
}];

var game = {
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

var outcomes = alkindi.addGame(
    alkindi.simpleLevelUpdate,
    alkindi.simpleLevelDecay,
    archives, game);

console.log(JSON.stringify(outcomes));
