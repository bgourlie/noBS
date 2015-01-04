library storage_service_tests;

import 'dart:html' as dom;
import 'dart:async';
import 'package:unittest/unittest.dart';
import 'package:typed_mock/typed_mock.dart';
import 'package:client/src/services/storage_engine/storage_engine.dart';

const String DB_NAME = 'dbName';
class MockStore extends TypedMock implements Store{}

main() {

  Future closeDb(db) {
    final completer = new Completer();
    db.close();
    new Timer(new Duration(milliseconds: 1), () {
      completer.complete();
    });
    return completer.future;
  };

  tearDown(() {
    return dom.window.indexedDB.deleteDatabase(DB_NAME);
  });

  test('should throw error when store is null', (){
    expect(() => new StorageService(null, dom.window),
    throwsA(new isInstanceOf<ArgumentError>()));
  });

  test('should throw error when window is null', (){
    final store = new MockStore();
    expect(() => new StorageService(store, null),
    throwsA(new isInstanceOf<ArgumentError>()));
  });

  test('should return normally with valid arguments', (){
    final store = new MockStore();
    expect(() => new StorageService(store, dom.window), returnsNormally);
  });

  test('should call upgrade method on store when the database is new', (){
    final store = new MockStore();
    when(store.dbName).thenReturn(DB_NAME);
    when(store.version).thenReturn(1);
    when(store.upgrade).thenReturn((oldVersion, newVersion) => print('upgrade called!'));
    final storageService = new StorageService(store, dom.window);
    expect(storageService.open().then((db) {
      verify(store.upgrade(0)).once();
      expect(closeDb(db), completes);
    }), completes);
  });

  test('should call upgrade method on store when there is a new version', () {
    final store = new MockStore();
    when(store.dbName).thenReturn(DB_NAME);
    when(store.version).thenReturn(1);
    when(store.upgrade).thenReturn((oldVersion)
        => print('upgrade called!'));

    final storeV2 = new MockStore();
    when(storeV2.dbName).thenReturn(DB_NAME);
    when(storeV2.version).thenReturn(2);
    when(storeV2.upgrade).thenReturn((oldVersion)
        => print('upgrade called!'));

    final storageService = new StorageService(store, dom.window);
    expect(storageService.open().then((db) {
      verify(store.upgrade(0)).once();
      expect(closeDb(db).then((_) {
        final storageService2 = new StorageService(storeV2, dom.window);
        expect(storageService2.open().then((db2){
          verify(storeV2.upgrade(1)).once();
          expect(closeDb(db2), completes);
        }), completes);
      }), completes);
    }), completes);
  });
}

