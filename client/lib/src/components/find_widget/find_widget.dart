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

library find_widget;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:di/annotations.dart';
import 'package:logging/logging.dart';
import 'package:rate_limit/rate_limit.dart';
import 'package:client/fitlog_models.dart';
import 'package:client/src/services/find_engine/find_engine.dart';
import 'package:client/src/services/exercise_find_engine.dart';

typedef SelectedHandler(Exercise exercise);

@Injectable()
@Component(
    selector: 'find-widget',
    templateUrl: 'packages/client/src/components/find_widget/find_widget.html',
    cssUrl: 'packages/client/src/components/find_widget/find_widget.css',
    map: const {'selected-handler': '&selectedHandler'})
class FindWidget implements ShadowRootAware {
  static final _logger = new Logger('find_widget');
  final ExerciseFindEngine _findEngine;
  List<FindResult<Exercise>> findResults;
  Function selectedHandler;
  String searchTerm; // The searchTerm, updated as it's being typed
  String searchedTerm; // The term actually being searched

  FindWidget(this._findEngine);

  void onShadowRoot(ShadowRoot shadowRoot) {
    shadowRoot.querySelector('#term').onKeyDown
        .transform(new Debouncer(const Duration(milliseconds: 250)))
        .forEach((e) => doSearch());
  }

  void doSearch() {
    if (this.searchTerm.length == 0) {
      findResults.clear();
    } else {
      _logger.finest('Handling find request for "$searchTerm"');
      _findEngine
          .streamResults(searchTerm)
          .toList()
          .then((results) => findResults = results);
    }
    searchedTerm = searchTerm;
  }

  void handleSelect(Exercise e) {
    if (selectedHandler != null) {
      SelectedHandler handler = selectedHandler();
      handler(e);
    }

    findResults.clear();
    searchTerm = null;
  }
}
