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

part of fitlog_models;

class ExerciseSet implements Storable {
  final int personId;
  final int exerciseId;
  final num weight;
  final num reps;

  int _dbKey;
  int get dbKey => _dbKey;
  set dbKey(int val) => _dbKey = val;

  // TODO: Get rid of these fields, getters/setters, just store the DateTime
  // see https://github.com/bgourlie/noBS/issues/1
  // These fields are set-once, assume immutable (will be once above is addressed.
  int recordedDateMillis;
  int performedDateMillis;
  DateTime _recordedDate;
  DateTime _performedDate;

  DateTime get recordedDate {
    if (_recordedDate == null) {
      _recordedDate = new DateTime.fromMillisecondsSinceEpoch(
          recordedDateMillis, isUtc: true);
    }
    return _recordedDate;
  }
  set recordedDate(DateTime date) {
    assert(date.isUtc);
    recordedDateMillis = date.millisecondsSinceEpoch;
    _recordedDate = null;
  }

  DateTime get performedDate {
    if (_performedDate == null) {
      _performedDate = new DateTime.fromMillisecondsSinceEpoch(
          performedDateMillis, isUtc: true);
    }
    return _performedDate;
  }

  set performedDate(DateTime date) {
    assert(date.isUtc);
    performedDateMillis = date.millisecondsSinceEpoch;
    _performedDate = null;
  }

  ExerciseSet(this.personId, this.exerciseId, this.weight, this.reps,
      this.recordedDateMillis, this.performedDateMillis);
}
