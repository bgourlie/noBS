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

part of nobs_storage;

class NobsDbV1Config implements DbConfig {
  String get dbName => _DB_NAME;
  int get version => 1;

  Future upgrade(Database db, Transaction tx, int oldVersion) {
    final setsStore =
        db.createObjectStore(_SETS_STORE_NAME, autoIncrement: true);
    final peopleStore =
        db.createObjectStore(_PEOPLE_STORE_NAME, autoIncrement: true);

    peopleStore.createIndex('email', 'email', unique: true);

    final exerciseStore =
        db.createObjectStore(_EXERCISE_STORE_NAME, autoIncrement: true);
    setsStore.createIndex('idx_personId_exerciseId_performedDate', [
      'personId',
      'exerciseId',
      'performedDate'
    ]);
    return _seed(db, tx);
  }

  Future _seed(Database db, Transaction tx) {
    _logger.finest('seeding database...');
    final exerciseRepo = new ExerciseRepository(db, new ExerciseSerializer());
    final exercises = [
      new Exercise('Stiff-legged Deadlift', ['romanian deadlift', 'sldl'], [
        'back',
        'hamstrings'
      ]),
      new Exercise('Deadlift', ['dl'], ['back', 'hamstrings']),
      new Exercise('Benchpress', ['bp'], ['chest', 'pecs']),
      new Exercise('Preacher Curl', [], ['biceps']),
      new Exercise('Hammer Curl', [], ['biceps', 'forearms']),
      new Exercise(
          'Squat', ['Back Squat'], ['legs', 'quads', 'glutes', 'back']),
      new Exercise('Bent-knee Good Morning', ['good morning'], ['glutes']),
      new Exercise('Front Squat', [], ['legs', 'quads']),
      new Exercise(
          'Military Press', ['overhead press'], ['shoulders', 'deltoids']),
      new Exercise('Lunge', [], ['legs']),
      new Exercise('Tricep Extension', ['skull crusher'], ['triceps']),
      new Exercise('Pull-Up', [], ['lats', 'back', 'biceps']),
      new Exercise('Bentover Row', [], ['back', 'lats']),
      new Exercise('Incline Row', [], ['back', 'lats']),
      new Exercise('Lat Pulldown', [], ['back', 'lats']),
      new Exercise('Shrug', [], ['traps']),
      new Exercise('Close-Grip Benchpress', ['cgbp'], ['triceps', 'chest']),
      new Exercise('Pullover', [], ['chest']),
      new Exercise('Decline Benchpress', [], ['chest']),
      new Exercise('Incline Benchpress', [], ['chest']),
      new Exercise('Pushup', [], ['chest']),
      new Exercise('Dip', [], ['chest']),
      new Exercise('Arnold Press', [], ['shoulders']),
      new Exercise('Front raise', [], ['shoulders']),
      new Exercise('Lateral raise', [], ['shoulders']),
      new Exercise('Behind neck press', [], ['shoulders']),
      new Exercise('Rear deltoid raise', [], ['shoulders']),
      new Exercise('Box jumps', [], ['plyometric'])
    ];

    return exerciseRepo.putAll(exercises, tx).then((_) {
      _logger.finest('seeding complet!');
    });
  }
}
