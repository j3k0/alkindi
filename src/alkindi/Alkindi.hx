package alkindi;


// games //
typedef GameId = String;

typedef UserName = String;

typedef Level = Int;

typedef Score = Int;

typedef PlayerScore = {
    var username : String;
    var score : Score;
}

typedef Game = {
    var id : GameId;
    var date : Date;
    var players : Array<PlayerScore>;
}


// player level //
typedef LevelUpdate = {
    var newLevel : Level;
}

typedef GameOutcome = {
    var game : Game;
    var outcome : LevelUpdate;
}

typedef PlayerGameOutcome = {
    var username : UserName;
    var game : GameOutcome;
}

typedef PlayerArchive = {
    var username : UserName;
    var games : Array<GameOutcome>;
}

typedef PlayerScoreAndLevel = {
    var username : UserName;
    var score : Score;
    var level : Level;
}

typedef LevelUpdateFunction =
    Array<PlayerScoreAndLevel> -> UserName -> LevelUpdate;

typedef LevelDecayFunction =
    Date -> Date -> Level -> LevelUpdate;


// player stats //
typedef DateValue = {
        var date : Date;
        var value : Float;
    }

typedef PlayerStats = {
        var username : UserName;
        var victories : Array<DateValue>;
        var defeats : Array<DateValue>;
        var rankings : Array<DateValue>;
        var winningSprees : Array<DateValue>;
    }


@:expose
class Alkindi {
    static function emptyLevelUpdate(){ return {newLevel: 0}; }

    static function emptyPlayerStats(){
        return { username: ""
               , victories: []
               , defeats: []
               , rankings: []
               , winningSprees: []
               };
    };

    public static function addGame( update : LevelUpdateFunction,
                                    decay : LevelDecayFunction,
                                    players : Array<PlayerArchive>,
                                    game : Game
                                  ) : Array<PlayerGameOutcome> {
        return [];
    }

    public static function simpleLevelUpdate( scores : Array<PlayerScoreAndLevel>,
                                              username: UserName
                                            ) : LevelUpdate {
        return emptyLevelUpdate();
    }

    public static function simpleLevelDecay( then : Date,
                                             now : Date,
                                             level : Level
                                            ) : LevelUpdate {
        return emptyLevelUpdate();
    }

    public static function getPlayerStats(archive:PlayerArchive):PlayerStats {
        return emptyPlayerStats();
    }
}
