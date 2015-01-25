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

library nobs_storage_smoke_tests;

import 'dart:html' as dom;
import 'dart:indexed_db';
import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:client/fitlog_models.dart';
import 'package:client/src/services/storage_engine/storage_engine.dart';
import 'package:client/src/services/nobs_storage/nobs_storage.dart';

const String DB_NAME = 'testDb';
const String TEST_STORE_NAME = 'foo';
final _logger = new Logger('integration_tests');

void main() {
  final config = new NobsDbV1Config();
  Database db;
  final exerciseSerializer = new ExerciseSerializer();
  final exerciseSetSerializer = new ExerciseSetSerializer();

  setUp(() {
    final bootstrapper = new Bootstrapper(config, dom.window);
    return dom.window.indexedDB.deleteDatabase(config.dbName, onBlocked: (e) {
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

  test('should add and retrieve an exercise, exercise set', () {
    final exerciseRepo = new ExerciseRepository(db, exerciseSerializer);
    final exercise =
        new Exercise('benchpress', ['barbell benchpress'], ['chest']);
    expect(exerciseRepo.put(exercise).then((_) {
      expect(exerciseRepo.get(exercise.dbKey).then((benchpress) {
        expect(benchpress.isPresent, isTrue);
        expect(benchpress.value.dbKey, equals(exercise.dbKey));

        final setRepo = new ExerciseSetRepository(db, exerciseSetSerializer);
        final set = new ExerciseSet(benchpress.value.dbKey, 225, 8,
            new DateTime.now().toUtc().millisecondsSinceEpoch,
            new DateTime.now().toUtc().millisecondsSinceEpoch);
        final set2 = new ExerciseSet(benchpress.value.dbKey, 225, 8,
            new DateTime.now().toUtc().millisecondsSinceEpoch,
            new DateTime.now().toUtc().millisecondsSinceEpoch);

        expect(setRepo.putAll([set, set2]).then((__) {
          expect(setRepo.get(set.dbKey).then((dbSet) {
            expect(dbSet.isPresent, isTrue);
            expect(dbSet.value.dbKey, equals(set.dbKey));
            expect(dbSet.value.exerciseId, equals(benchpress.value.dbKey));
            expect(setRepo
                .getLatest(benchpress.value.dbKey, 3)
                .toList()
                .then((sets) {
              expect(sets.length, equals(2));
            }), completes);
          }), completes);
        }), completes);
      }), completes);
    }), completes);
  });
}
