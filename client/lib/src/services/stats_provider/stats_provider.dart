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

library stats_provider;

import 'dart:async';
import 'package:di/annotations.dart';
import 'package:client/src/services/nobs_storage/nobs_storage.dart';
import 'package:client/fitlog_models.dart';

part 'exercise_stats.dart';

@Injectable()
class StatsProvider {
  final ExerciseSetRepository _setRepository;

  StatsProvider(this._setRepository);

  Future<ExerciseStats> getStats(int personId, int exerciseId) {
    final completer = new Completer<ExerciseStats>();
    int totalSets = 0;
    int totalWeightLifted = 0;
    num totalReps = 0;
    ExerciseSet bestWeight;
    ExerciseSet bestReps;
    ExerciseSet bestTotal;

    _setRepository.getAllByExerciseId(personId, exerciseId).listen((set) {
      totalSets++;
      totalReps += set.reps;
      totalWeightLifted += set.weight * set.reps;

      if (bestWeight == null || bestWeight.weight < set.weight) {
        bestWeight = set;
      }

      if (bestReps == null || bestReps.reps < set.reps) {
        bestReps = set;
      }

      if (bestTotal == null ||
          bestTotal.reps * bestTotal.weight < set.reps * set.weight) {
        bestTotal = set;
      }
    }).onDone(() => completer.complete(new ExerciseStats(exerciseId, personId,
        totalSets, totalWeightLifted, totalReps, bestWeight, bestReps,
        bestTotal)));

    return completer.future;
  }
}
