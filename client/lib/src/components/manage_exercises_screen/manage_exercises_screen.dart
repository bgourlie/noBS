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

library manage_exercises_screen;

import 'package:angular/angular.dart';
import 'package:di/annotations.dart';
import 'package:logging/logging.dart';
import 'package:client/src/services/nobs_storage/nobs_storage.dart';
import 'package:client/fitlog_models.dart';

@Injectable()
@Component(
    selector: 'manage-exercises-screen',
    templateUrl: 'packages/client/src/components/manage_exercises_screen/manage_exercises_screen.html',
    useShadowDom: false)
class ManageExercisesScreen {
  static final _logger = new Logger('manage-exercises-screen');
  final ExerciseRepository _exerciseRepo;

  NgForm createExerciseForm;
  String name;
  String synonyms;
  String tags;
  bool submitting = false;

  ManageExercisesScreen(this._exerciseRepo);

  void submit() {
    submitting = true;
    final synonymList = synonyms != null ? synonyms.split(',') : [];
    final tagList = tags != null ? tags.split(',') : [];
    final exercise = new Exercise(name, synonymList, tagList);
    _exerciseRepo.put(exercise).then((_) {
      name = '';
      synonyms = '';
      tags = '';
    }).whenComplete(() => submitting = false);
  }
}
