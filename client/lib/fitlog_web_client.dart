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

library fitlog_web_client;

import 'dart:indexed_db';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular/core_dom/module_internal.dart';
import 'package:client/fitlog_models.dart';
import 'package:client/src/components/app_main/app_main.dart';
import 'package:client/src/components/entry_screen/entry_screen.dart';
import 'package:client/src/components/version_info/version_info.dart';
import 'package:client/src/components/find_widget/find_widget.dart';
import 'package:client/src/components/exercise/exercise.dart';
import 'package:client/src/components/tag/tag.dart';
import 'package:client/src/components/record_widget/record_widget.dart';
import 'package:client/src/components/muscle_man/muscle_man.dart';
import 'package:client/src/components/create_user_screen/create_user_screen.dart';
import 'package:client/src/filters/relative_time.dart';
import 'package:client/src/services/find_engine_defaults/find_engine_defaults.dart';
import 'package:client/src/services/exercise_find_engine.dart';
import 'package:client/src/services/nobs_storage/nobs_storage.dart';
import 'package:client/src/services/exercise_source.dart';

class ClientModule extends Module {
  final AppVersion _appVersion;
  final Database _database;

  ClientModule(this._appVersion, this._database) {
    install(new FindEngineDefaultsModule());
    install(new NobsStorageModule());
    bind(Database, toValue: this._database);
    bind(AppVersion, toValue: this._appVersion);

    bind(AppMain);
    bind(CreateUserScreen);
    bind(EntryScreen);
    bind(VersionInfo);
    bind(FindWidget);
    bind(FindResult);
    bind(RelativeTime);
    bind(Tag);
    bind(RecordWidget);
    bind(ExerciseSource);
    bind(ExerciseFindEngine);
    bind(MuscleMan);

    // disable CSS shim
    bind(PlatformJsBasedShim, toImplementation: PlatformJsBasedNoShim);
    bind(DefaultPlatformShim, toImplementation: DefaultPlatformNoShim);
  }
}

/// Class to effectively disable CSS shim
@Injectable()
class DefaultPlatformNoShim implements DefaultPlatformShim {
  bool get shimRequired => true;
  String shimCss(String css, {String selector, String cssUrl}) => css;
  void shimShadowDom(Element root, String selector) {}
}

/// Class to effectively disable CSS shim
@Injectable()
class PlatformJsBasedNoShim implements PlatformJsBasedShim {
  bool get shimRequired => true;
  String shimCss(String css, {String selector, String cssUrl}) => css;
  void shimShadowDom(Element root, String selector) {}
}
