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

@Injectable()
class ExerciseSetRepository extends Repository<ExerciseSet> {
  final Database _db;
  String get storeName => _SETS_STORE_NAME;

  ExerciseSetRepository(Database db, ExerciseSetSerializer serializer)
      : _db = db,
        super(db, serializer);

  Stream<ExerciseSet> getLatest(int exerciseId, int numRecords) {
    final controller = new StreamController<ExerciseSet>();
    final trans = _db.transactionStore(_SETS_STORE_NAME, 'readonly');
    final store = trans.objectStore(_SETS_STORE_NAME);
    final index = store.index('idx_exerciseId_performedDate');
    final uBound = [exerciseId, new DateTime.now().toUtc()];
    final lBound = [exerciseId, new DateTime.utc(1983, 3, 15)];
    final cursor = index.openCursor(
        range: new KeyRange.bound(lBound, uBound),
        direction: 'prev',
        autoAdvance: true);
    cursor.take(numRecords).listen((r) {
      controller.add(r.value);
    },
        onDone: () => controller.close(),
        onError: (e) => controller.addError(e));
    return controller.stream;
  }
}
