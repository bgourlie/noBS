library storage_service_tests;

import 'dart:html' as dom;
import 'package:unittest/unittest.dart';
import 'package:typed_mock/typed_mock.dart';
import 'package:client/src/services/storage_engine/storage_engine.dart';
import 'db_test_utils.dart';

const String DB_NAME = 'testDb';
class MockConfig extends TypedMock implements DbConfig{}

main() {
  tearDown(() {
    return dom.window.indexedDB.deleteDatabase(DB_NAME);
  });

  test('should throw error when store is null', (){
    expect(() => new Bootstrapper(null, dom.window),
    throwsA(new isInstanceOf<ArgumentError>()));
  });

  test('should throw error when window is null', (){
    final config = new MockConfig();
    expect(() => new Bootstrapper(config, null),
    throwsA(new isInstanceOf<ArgumentError>()));
  });

  test('should return normally with valid arguments', (){
    final config = new MockConfig();
    expect(() => new Bootstrapper(config, dom.window), returnsNormally);
  });

  test('should call upgrade method on store when the database is new', (){
    final config = new MockConfig();
    when(config.dbName).thenReturn(DB_NAME);
    when(config.version).thenReturn(1);
    when(config.upgrade).thenReturn((a,b,c) => print('called!'));
    final storageService = new Bootstrapper(config, dom.window);
    expect(storageService.getDatabase().then((db) {
      verify(config.upgrade(db, anyObject, 0)).once();
      expect(closeDb(db), completes);
    }), completes);
  });

  test('should call upgrade method on store when there is a new version', () {
    final config = new MockConfig();
    when(config.dbName).thenReturn(DB_NAME);
    when(config.version).thenReturn(1);
    when(config.upgrade).thenReturn((a,b,c) => print('called!'));

    final configV2 = new MockConfig();
    when(configV2.dbName).thenReturn(DB_NAME);
    when(configV2.version).thenReturn(2);
    when(configV2.upgrade).thenReturn((a,b,c) => print('called!'));

    final bootstrapper = new Bootstrapper(config, dom.window);
    expect(bootstrapper.getDatabase().then((db) {
      verify(config.upgrade(db, anyObject, 0)).once();
      expect(closeDb(db).then((_) {
        final bootstrapper2 = new Bootstrapper(configV2, dom.window);
        expect(bootstrapper2.getDatabase().then((db2){
          verify(configV2.upgrade(db2, anyObject, 1)).once();
          expect(closeDb(db2), completes);
        }), completes);
      }), completes);
    }), completes);
  });
}

