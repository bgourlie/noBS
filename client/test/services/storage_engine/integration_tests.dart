library integration_tests;

import 'dart:async';
import 'dart:html' as dom;
import 'dart:indexed_db';
import 'package:quiver/core.dart';
import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:client/src/services/storage_engine/storage_engine.dart';

const String DB_NAME = 'testDb';

final _logger = new Logger('integration_tests');

void main(){
  Database db;

  setUp((){
    final bootstrapper = new Bootstrapper(new TestDbV1Config(), dom.window);
    return dom.window.indexedDB.deleteDatabase(DB_NAME, onBlocked: (e) {
      print('delete db blocked, but completing future anyway');
    }).then((_) {
      print('db successfully deleted!');
      return bootstrapper.getDatabase().then((_db_) {
        print('db opened.');
        db = _db_;
      });
    });
  });

  tearDown(() {
    if(db != null){
      db.close();
    }
  });

  test('should put item into storage', (){
    final fooRepo = new FooRepository(db);
    expect(fooRepo.put(new Foo('brian', 31)).then((_){
      _logger.finest('put foo object!');
    }), completes);
  });

  test('should put and retrieve', (){
    final fooRepo = new FooRepository(db);
    final foo = new Foo('brian', 31);
    expect(fooRepo.put(foo).then((_){
      expect(fooRepo.get(foo.dbKey).then((Optional<Foo> foo2){
        expect(foo2.isPresent, isTrue);
        expect(foo2.value.name, equals(foo.name));
        expect(foo2.value.age, equals(foo.age));
      }), completes);
    }), completes);
  });

  test('should put many and retrieve all', (){
    final fooRepo = new FooRepository(db);
    final foo1 = new Foo('brian', 31);
    final foo2 = new Foo('jon', 29);
    final foo3 = new Foo('aaron', 39);
    final foo4 = new Foo('jeremy', 38);
    expect(Future.wait([fooRepo.put(foo1), fooRepo.put(foo2), fooRepo.put(foo3),
        fooRepo.put(foo4)]).then((_){
      expect(fooRepo.getAll().toList().then((List<Foo> foos){
        expect(foos.length, equals(4));
      }), completes);
    }), completes);
  });
}

class TestDbV1Config extends DbConfig {
  String get dbName => DB_NAME;
  int get version => 1;

  void upgrade(Database db, int version){
    _logger.finest('upgrade called.');
    db.createObjectStore('foo', autoIncrement: true);
  }
}

class Foo extends Storable {
  int _dbKey;
  int get dbKey => _dbKey;
  set dbKey(int val) => _dbKey = val;

  final String name;
  final int age;

  Foo(this.name, this.age);
}

class FooRepository extends Repository<Foo> {
  String get storeName => 'foo';

  FooRepository(Database db) : super(db);

  Foo deserialize(int key, Map value) =>
      new Foo(value['name'], value['age']);

  Map serialize(Foo obj) => { 'name' : obj.name, 'age' : obj.age };
}