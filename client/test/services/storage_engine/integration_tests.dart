// The contents of this file are subject to the Common Public Attribution
// License Version 1.0. (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// https://raw.githubusercontent.com/bgourlie/noBS/master/LICENSE.
// The License is based on the Mozilla Public License Version 1.1, but Sections
// 14 and 15 have been added to cover use of software over a computer network
// and provide for limited attribution for the Original Developer. In addition,
// Exhibit A has been modified to be consistent with Exhibit B.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
// the specific language governing rights and limitations under the License.
//
// The Original Code is noBS Exercise Logger.
//
// The Original Developer is the Initial Developer.  The Initial Developer of
// the Original Code is W. Brian Gourlie.
//
// All portions of the code written by W. Brian Gourlie are Copyright (c)
// 2014-2015 W. Brian Gourlie. All Rights Reserved.

library storage_engine_integration_tests;

import 'dart:async';
import 'dart:html' as dom;
import 'dart:indexed_db';
import 'package:quiver/core.dart';
import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:client/src/services/storage_engine/storage_engine.dart';

const String DB_NAME = 'testDb';
const String TEST_STORE_NAME = 'foo';
final _logger = new Logger('storage_engine_integration_tests');

void main() {
  Database db;
  final serializer = new FooSerializer();

  setUp(() {
    final bootstrapper = new Bootstrapper(new TestDbV1Config(), dom.window);
    return dom.window.indexedDB.deleteDatabase(DB_NAME, onBlocked: (e) {
      _logger.finest('delete db blocked, but completing future anyway');
    }).then((_) {
      _logger.finest('db successfully deleted!');
      return bootstrapper.getDatabase().then((_db_) {
        _logger.finest('db opened.');
        db = _db_;
      });
    });
  });

  tearDown(() {
    if (db != null) {
      db.close();
    }
  });

  test('should put item into storage', () {
    final fooRepo = new FooRepository(db, serializer);
    expect(fooRepo.put(new Foo('brian', 31)).then((_) {
      _logger.finest('put foo object!');
    }), completes);
  });

  test('should put and retrieve', () {
    final fooRepo = new FooRepository(db, serializer);
    final foo = new Foo('brian', 31);
    expect(fooRepo.put(foo).then((_) {
      expect(fooRepo.get(foo.dbKey).then((Optional<Foo> foo2) {
        expect(foo2.isPresent, isTrue);
        expect(foo2.value.name, equals(foo.name));
        expect(foo2.value.age, equals(foo.age));
      }), completes);
    }), completes);
  });

  test('should put many and retrieve all', () {
    final fooRepo = new FooRepository(db, serializer);
    final foo1 = new Foo('brian', 31);
    final foo2 = new Foo('jon', 29);
    final foo3 = new Foo('aaron', 39);
    final foo4 = new Foo('jeremy', 38);
    expect(fooRepo.putAll([foo1, foo2, foo3, foo4]).then((_) {
      expect(fooRepo.getAll().toList().then((List<Foo> foos) {
        expect(foos.length, equals(4));
      }), completes);
    }), completes);
  });

  test('should put many and retrieve all with explicit transaction', () {
    final bootstrapper = new Bootstrapper(new TestDbV1Config(), dom.window);
    expect(bootstrapper.getDatabase().then((_db_) {
      final fooRepo = new FooRepository(_db_, serializer);
      final foo1 = new Foo('brian', 31);
      final foo2 = new Foo('jon', 29);
      final foo3 = new Foo('aaron', 39);
      final foo4 = new Foo('jeremy', 38);
      final trans = _db_.transaction(TEST_STORE_NAME, 'readwrite');
      expect(fooRepo.putAll([foo1, foo2, foo3, foo4], trans).then((_) {
        expect(fooRepo.getAll().toList().then((List<Foo> foos) {
          expect(foos.length, equals(4));
        }), completes);
      }), completes);
    }), completes);
  });
}

class TestDbV1Config extends DbConfig {
  String get dbName => DB_NAME;
  int get version => 1;

  Future upgrade(Database db, Transaction tx, int version) {
    _logger.finest('upgrade called.');
    db.createObjectStore('foo', autoIncrement: true);
    return new Future.value();
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
  String get storeName => TEST_STORE_NAME;
  FooRepository(Database db, Serializer<Foo> serializer)
      : super(db, serializer);
}

class FooSerializer extends Serializer<Foo> {
  Foo deserializeImpl(Map value) => new Foo(value['name'], value['age']);
  Map serializeImpl(Foo obj) => {'name': obj.name, 'age': obj.age};
}
