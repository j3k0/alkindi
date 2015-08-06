package alkindi;


typedef DateValue = {
        var date : Date;
        var value : Float;
    }


typedef PlayerStats = {
        var username : String;
        var victories : Array<DateValue>;
        var defeats : Array<DateValue>;
        var rankings : Array<DateValue>;
        var winningSprees : Array<DateValue>;
    }
