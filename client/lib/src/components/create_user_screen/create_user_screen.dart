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

library create_user_screen;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:di/annotations.dart';
import 'package:client/fitlog_models.dart';
import 'package:logging/logging.dart';
import 'package:client/src/services/nobs_storage/nobs_storage.dart';

typedef void UserCreatedHandler(Person person);

@Injectable()
@Component(
    selector: 'create-user-screen',
    templateUrl: 'packages/client/src/components/create_user_screen/create_user_screen.html',
    useShadowDom: false,
    map: const {'user-created-handler': '&userCreatedHandler'})
class CreateUserScreen {
  static final _logger = new Logger('create_user_screen');
  final PersonRepository _personRepo;
  final nickRegexp = r'^[a-zA-Z0-9_]{3,22}$';

  bool loading = true;
  bool submitting = false;

  List<Person> existingUsers;

  Function userCreatedHandler;
  NgForm createUserForm;
  String email;
  String nick;
  String errorMessage;

  CreateUserScreen(this._personRepo) {
    this._personRepo.getAll().toList().then((List<Person> people) {
      existingUsers = people;
    }).whenComplete(() => loading = false);
  }

  void submitUser() {
    errorMessage = null;
    final person = new Person(email, nick);
    submitting = true;
    _personRepo.put(person).then((_) {
      existingUsers.add(person);
      if (userCreatedHandler != null) {
        final UserCreatedHandler handler = userCreatedHandler();
        handler(person);
      }
    }).catchError((Event e) {
      errorMessage = '''An error occurred when attempting to save the user.
      Make sure that another user doesn't already exist with the same e-mail
      address.''';
    }).whenComplete(() => submitting = false);
  }
}
