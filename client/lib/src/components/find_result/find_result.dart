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

library find_result;

import 'package:di/annotations.dart';
import 'package:angular/angular.dart';
import 'package:client/fitlog_models.dart';
import 'package:client/src/services/find_engine/find_engine.dart' as fe;

@Injectable()
@Component(
    selector: '[find-result]',
    templateUrl: 'packages/client/src/components/find_result/find_result.html',
    cssUrl: 'packages/client/src/components/find_result/find_result.css',
    map: const {'find-result': '=>!findResult',})
class FindResult {
  Exercise _exercise;
  List<String> _tags;
  List<String> _synonyms;

  fe.FindResult<Exercise> findResult;

  Exercise get exercise {
    if (_exercise == null) {
      _exercise = findResult.item;
    }
    return _exercise;
  }

  List<String> get tags {
    if (_tags == null) {
      _tags = exercise.terms
          .where((fe.Term t) => t.termType == fe.Term.TYPE_TAG)
          .map((t) => t.term)
          .toList();
    }
    return _tags;
  }

  List<String> get synonyms {
    if (_synonyms == null) {
      _synonyms = exercise.terms
          .where((fe.Term t) => t.termType == fe.Term.TYPE_NAME)
          .skip(1)
          .map((fe.Term t) => t.term)
          .toList();
    }
    return _synonyms;
  }
}
