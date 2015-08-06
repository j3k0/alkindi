package alkindi;


class PlayerScore {
    public var username : String;
    public var score : Int;

    public function new(name:String, score:Int) {
        this.username = name;
        this.score = score;
    }
}


class Game {
    public var id : String;
    public var date : Date;
    public var players : Array<PlayerScore>;

    public function new(id:String, date:Date, players:Array<PlayerScore>) {
        this.id = id;
        this.date = date;
        this.players = players;
    }
}
