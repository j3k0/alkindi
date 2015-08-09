package alkindi;

typedef Score = Int;
typedef Level = Int;
typedef Username = String;
typedef Timestamp = Float;
typedef GameId = String;

typedef TDate = { date: Timestamp }
typedef TGame<T> = { game: T }
typedef TGames<T> = { games: T }
typedef TNewLevel = { newLevel: Level }
typedef TOutcome<T> = { outcome: T }
typedef TPlayers<T> = { players: T }
typedef TScore = { score: Score }
typedef TUsername = { username: Username }
typedef TLevel = { level: Level }
typedef TGameId = { id: GameId }

class Types {
    public static inline function getDate(x:TDate) return x.date;
    public static inline function getGame<T>(x:TGame<T>) return x.game;
    public static inline function getGames<T>(x:TGames<T>) return x.games;
    public static inline function getNewLevel(x:TNewLevel) return x.newLevel;
    public static inline function getOutcome<T>(x:TOutcome<T>) return x.outcome;
    public static inline function getPlayers<T>(x:TPlayers<T>) return x.players;
    public static inline function getScore(x:TScore) return x.score;
    public static inline function getLevel(x:TLevel) return x.level;
    public static inline function getUsername(x:TUsername) return x.username;
}

typedef DateValue = {
    > TDate,
    value: Int
}

typedef PlayerStats = {
    > TUsername,
    victories: Array<DateValue>,
    defeats: Array<DateValue>,
    rankings: Array<DateValue>,
    winningSprees: Array<DateValue>
}

typedef LevelUpdate = TNewLevel;

typedef Game = {
    > TDate,
    > TGameId,
    players: Array<PlayerScore>
}

typedef GameOutcome = {
    > TGame<Game>,
    > TOutcome<LevelUpdate>,
}

typedef PlayerGameOutcome = {
    > TUsername,
    > TGame<GameOutcome>,
}

typedef PlayerArchive = {
    > TUsername,
    > TGames<Array<GameOutcome>>,
}

typedef PlayerScore = {
    > TUsername,
    > TScore,
}

typedef PlayerScoreAndLevel = {
    > PlayerScore,
    > TLevel,
}

typedef PlayerWinner = {
    > TUsername,
    winner: Bool
}

// Define how Level updates while playing
typedef LevelUpdateFunction =
    Array<PlayerScoreAndLevel> -> Username -> LevelUpdate;

// Define how Level decays while not playing
// Player's level will decay from start date to end date,
// from given Level to the returned LevelUpdate.
typedef LevelDecayFunction =
    Timestamp -> Timestamp -> Level -> LevelUpdate;
