package alkindi;


typedef LevelUpdate = {
    var newLevel : Int;
}


typedef GameOutcome = {
    var game : Game;
    var outcome : LevelUpdate;
}


typedef PlayerGameOutcome = {
    var username : String;
    var game : GameOutcome;
}


typedef PlayerArchive = {
    var username : String;
    var games : Array<GameOutcome>;
}


typedef PlayerScoreAndLevel = {
    var username : String;
    var score : Int;
    var level : Int;
}


typedef LevelUpdateFunction =
    Array<PlayerScoreAndLevel> -> String -> LevelUpdate;


typedef LevelDecayFunction =
    Date -> Date -> Int -> LevelUpdate;
