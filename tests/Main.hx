import alkindi.*;

class Main {

  static function main() {

    var r = new haxe.unit.TestRunner();

    r.add(new FxpTestCase());
    r.add(new MaybeTestCase());
    r.add(new ArchivesTestCase());
    r.add(new GamesTestCase());
    r.add(new LevelsTestCase());
    r.add(new AddGameTestCase());
    r.add(new AlkindiTestCase());
    r.add(new SimpleLevelTestCase());
    r.add(new StatsTestCase());
    // add other TestCases here

    // finally, run the tests
    r.run();
  }
}
