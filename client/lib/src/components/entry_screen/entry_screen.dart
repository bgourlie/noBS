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

library entry_screen;

import 'dart:async';
import 'package:angular/angular.dart';
import 'package:di/annotations.dart';
import 'package:logging/logging.dart';
import 'package:client/src/services/stats_provider/stats_provider.dart';
import 'package:client/fitlog_models.dart';
import 'package:client/src/services/nobs_storage/nobs_storage.dart';

@Injectable()
@Component(
    selector: 'entry-screen',
    templateUrl: 'packages/client/src/components/entry_screen/entry_screen.html',
    useShadowDom: false)
class EntryScreen {
  static final _logger = new Logger('nobs_entry_screen');
  final ExerciseSetRepository _setRepo;
  final PersonRepository _personRepo;
  final StatsProvider _statsProvider;

  List<Person> users;
  Person selectedUser;
  Exercise selectedExercise;
  List<ExerciseSet> previousSets;
  ExerciseStats exerciseStats;

  bool saving = false;

  EntryScreen(this._setRepo, this._personRepo, this._statsProvider) {
    _personRepo.getAll().toList().then((List<Person> users) {
      this.users = users;
      assert(users.length != 0);
      selectedUser = users[0];
    });
  }

  void onExerciseSelected(Exercise e) {
    _logger.finest('${e.title} selected');
    selectedExercise = e;
    refreshExerciseHistory();
  }

  void onRecord(num weight, num reps) {
    saving = true;
    _logger.finest('record called: weight=$weight reps=$reps');
    assert(selectedExercise != null);
    // eventually we will have widgets to adjust recorded/performed dates.
    final now = new DateTime.now().toUtc().millisecondsSinceEpoch;
    final set = new ExerciseSet(
        selectedUser.dbKey, selectedExercise.dbKey, weight, reps, now, now);
    _setRepo.put(set).then((_) {
      _logger.finest('saved set!');
      previousSets.add(set);
    }).whenComplete(() => saving = false);
  }

  void cancelRecord() {
    _logger.finest('cancel record called.');
    selectedExercise = null;
  }

  void refreshExerciseHistory() {
    _setRepo
        .getLatest(selectedUser.dbKey, selectedExercise.dbKey, 3)
        .toList()
        .then((sets) {
      previousSets = sets;
    });

    _statsProvider.getStats(selectedUser.dbKey, selectedExercise.dbKey).then(
        (ExerciseStats stats) {
      exerciseStats = stats;
    });
  }

  void userChanged() {
    // small hack - run in a future to guarantee model is updated
    // The change event can fire before angular digest loop completes
    // and updates model.
    new Future(() {
      _logger.finest('selected user is ${selectedUser.nick}');
      refreshExerciseHistory();
    });
  }
}
