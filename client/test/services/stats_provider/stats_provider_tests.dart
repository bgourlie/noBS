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

import 'dart:async';
import 'package:unittest/unittest.dart';
import 'package:client/src/services/stats_provider/stats_provider.dart';
import 'package:client/src/services/nobs_storage/nobs_storage.dart';
import 'package:typed_mock/typed_mock.dart';
import 'package:client/fitlog_models.dart';

main() {
  test('should compute correct stats', () {
    final nowMillis = new DateTime.now().toUtc().millisecondsSinceEpoch;
    final setRepo = new MockSetsRepo();
    when(setRepo.getAllByExerciseId(anyInt, anyInt)).thenReturn(
        new Stream.fromIterable([
      new ExerciseSet(1, 1, 225, 6, nowMillis, nowMillis),
      new ExerciseSet(1, 1, 235, 6, nowMillis, nowMillis),
      new ExerciseSet(1, 1, 135, 10, nowMillis, nowMillis)
    ]));

    final statsProvider = new StatsProvider(setRepo);

    expect(statsProvider.getStats(1, 1).then((stats) {
      expect(stats.totalSets, equals(3));
      expect(stats.totalReps, equals(22));
      expect(stats.totalWeightLifted, equals(4110));
      expect(stats.bestReps.reps, equals(10));
      expect(stats.bestWeight.weight, equals(235));
      expect(stats.bestCombined.weight * stats.bestCombined.reps, equals(1410));
    }), completes);
  });
}

class MockSetsRepo extends TypedMock implements ExerciseSetRepository {}
