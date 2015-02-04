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

library app_main;

import 'package:angular/angular.dart';
import 'package:di/annotations.dart';
import 'package:logging/logging.dart';
import 'package:client/fitlog_models.dart';
import 'package:client/src/services/nobs_storage/nobs_storage.dart';

@Injectable()
@Component(
    selector: 'app-main',
    templateUrl: 'packages/client/src/components/app_main/app_main.html',
    useShadowDom: false)
class AppMain {
  static final _logger = new Logger('app-main');
  final int STATE_LOADING = 0;
  final int STATE_CREATE_USER = 1;
  final int STATE_ENTRY = 2;

  final PersonRepository _personRepo;
  int state = 0;

  AppMain(this._personRepo) {
    changeState(STATE_ENTRY);
  }

  void changeState(int newState){
    if(state == newState){
      return;
    }

    if(![STATE_LOADING, STATE_ENTRY, STATE_CREATE_USER].contains(newState)){
      throw new ArgumentError('Invalid state.');
    }

    // Verify that at least one user exists before allowing this state.
    if(newState == STATE_ENTRY){
      _personRepo.count().then((int count) {
        if (count == 0) {
          _logger.finest(
              'no users have been created, displaying create user screen.');
          changeState(STATE_CREATE_USER);
        } else {
          state = STATE_ENTRY;
        }
      });
    } else {
      state = newState;
    }
  }

  void onUserCreated(Person person) {
    changeState(STATE_ENTRY);
  }
}
