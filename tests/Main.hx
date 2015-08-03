import alkindi.*;

class Main {

  static function main() {

    var r = new haxe.unit.TestRunner();
    r.add(new AlkindiTestCase());
    // add other TestCases here

    // finally, run the tests
    r.run();
  }
}
