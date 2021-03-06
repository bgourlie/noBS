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

library app_header;

import 'dart:async';
import 'package:angular/angular.dart';
import 'package:di/annotations.dart';
import 'package:logging/logging.dart';
import 'package:client/fitlog_models.dart';

typedef Future<bool> NavigateHandler(String section);

@Injectable()
@Component(
    selector: 'app-header',
    templateUrl: 'packages/client/src/components/app_header/app_header.html',
    useShadowDom: false,
    map: const {
  'default-section': '=>!defaultSection',
  'navigate-handler': '&navigateHandler'
})
class AppHeader {
  static final _logger = new Logger('app-header');
  final AppVersion appVersion;
  Function navigateHandler;
  bool toggled = false;
  String defaultSection;
  String curSection;

  AppHeader(this.appVersion) {
    new Future(() {
      _doNavigate(defaultSection);
    });
  }

  bool toggleMenu() => toggled = !toggled;

  void goManageUsers() => _doNavigate('manage_users');

  void goManageExercises() => _doNavigate('manage_exercises');

  void goRecord() => _doNavigate('record');

  void _doNavigate(String section) {
    if (!['record', 'manage_users', 'manage_exercises'].contains(section)) {
      throw new ArgumentError('Invalid section');
    }

    if (navigateHandler != null) {
      NavigateHandler handler = navigateHandler();
      handler(section).then((doNavigate) {
        if (doNavigate) {
          curSection = section;
          toggled = false;
        } else {
          _logger.warning('navigation to [$section] disallowed.');
        }
      });
    } else {
      curSection = section;
    }
  }
}
