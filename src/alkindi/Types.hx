package alkindi;

typedef Score = Int;

typedef Level = Int;

typedef Username = String;

typedef Timestamp = haxe.Int64;

typedef DateValue = {
    date: Timestamp,
    value: Int
}

typedef PlayerStats = {
    username: Username,
    victories: Array<DateValue>,
    defeats: Array<DateValue>,
    rankings: Array<DateValue>,
    winningSprees: Array<DateValue>
}

typedef LevelUpdate = {
    newLevel: Level
}

typedef GameOutcome = {
    game: Game,
    outcome: LevelUpdate
}

typedef PlayerGameOutcome = {
    username: Username,
    game: GameOutcome
}

typedef PlayerArchive = {
    username: Username,
    games: Array<GameOutcome>
}

typedef PlayerScoreAndLevel = {
    username: Username,
    score: Score,
    level: Level
}

typedef LevelUpdateFunction =
    Array<PlayerScoreAndLevel> -> Username -> LevelUpdate;

typedef LevelDecayFunction =
    Timestamp -> Timestamp -> Level -> LevelUpdate;

typedef PlayerScore = {
    username: Username,
    score: Score
}

typedef PlayerWinner = {
    username: Username,
    winner: Bool
}

typedef Game = {
    id: Username,
    date: Timestamp,
    players: Array<PlayerScore>
}

typedef TDate<T> = { date: T }
typedef TGame<T> = { game: T }
typedef TGames<T> = { games: T }
typedef TNewLevel<T> = { newLevel: T }
typedef TOutcome<T> = { outcome: T }
typedef TPlayers<T> = { players: T }
typedef TScore<T> = { score: T }
typedef TUsername<T> = { username: T }

class Types {
    public static inline function getDate<T>(x:TDate<T>) return x.date;
    public static inline function getGame<T>(x:TGame<T>) return x.game;
    public static inline function getGames<T>(x:TGames<T>) return x.games;
    public static inline function getNewLevel<T>(x:TNewLevel<T>) return x.newLevel;
    public static inline function getOutcome<T>(x:TOutcome<T>) return x.outcome;
    public static inline function getPlayers<T>(x:TPlayers<T>) return x.players;
    public static inline function getScore<T>(x:TScore<T>) return x.score;
    public static inline function getUsername<T>(x:TUsername<T>) return x.username;
}

