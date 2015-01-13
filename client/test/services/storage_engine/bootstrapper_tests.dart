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

library storage_service_tests;

import 'dart:html' as dom;
import 'package:unittest/unittest.dart';
import 'package:typed_mock/typed_mock.dart';
import 'package:client/src/services/storage_engine/storage_engine.dart';
import 'db_test_utils.dart';

const String DB_NAME = 'testDb';
class MockConfig extends TypedMock implements DbConfig {}

main() {
  tearDown(() {
    return dom.window.indexedDB.deleteDatabase(DB_NAME);
  });

  test('should throw error when store is null', () {
    expect(() => new Bootstrapper(null, dom.window),
        throwsA(new isInstanceOf<ArgumentError>()));
  });

  test('should throw error when window is null', () {
    final config = new MockConfig();
    expect(() => new Bootstrapper(config, null),
        throwsA(new isInstanceOf<ArgumentError>()));
  });

  test('should return normally with valid arguments', () {
    final config = new MockConfig();
    expect(() => new Bootstrapper(config, dom.window), returnsNormally);
  });

  test('should call upgrade method on store when the database is new', () {
    final config = new MockConfig();
    when(config.dbName).thenReturn(DB_NAME);
    when(config.version).thenReturn(1);
    when(config.upgrade).thenReturn((a, b, c) => print('called!'));
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
    when(config.upgrade).thenReturn((a, b, c) => print('called!'));

    final configV2 = new MockConfig();
    when(configV2.dbName).thenReturn(DB_NAME);
    when(configV2.version).thenReturn(2);
    when(configV2.upgrade).thenReturn((a, b, c) => print('called!'));

    final bootstrapper = new Bootstrapper(config, dom.window);
    expect(bootstrapper.getDatabase().then((db) {
      verify(config.upgrade(db, anyObject, 0)).once();
      expect(closeDb(db).then((_) {
        final bootstrapper2 = new Bootstrapper(configV2, dom.window);
        expect(bootstrapper2.getDatabase().then((db2) {
          verify(configV2.upgrade(db2, anyObject, 1)).once();
          expect(closeDb(db2), completes);
        }), completes);
      }), completes);
    }), completes);
  });
}
