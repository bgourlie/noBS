library fitlog_web_client;

import 'dart:indexed_db';
import 'package:angular/angular.dart';
import 'package:client/src/components/entry_screen/entry_screen.dart';
import 'package:client/src/components/app_header/app_header.dart';
import 'package:client/src/components/find_widget/find_widget.dart';
import 'package:client/src/components/find_result/find_result.dart';
import 'package:client/src/components/tag/tag.dart';
import 'package:client/src/components/record_widget/record_widget.dart';
import 'package:client/fitlog_models.dart';
import 'package:client/src/services/find_engine_defaults/find_engine_defaults.dart';
import 'package:client/src/services/exercise_find_engine.dart';
import 'package:client/src/services/nobs_storage/nobs_storage.dart';
import 'package:client/src/services/exercise_source.dart';


part 'src/routes.dart';

class ClientModule extends Module {
  final VersionInfo _versionInfo;
  final Database _database;

  ClientModule(this._versionInfo, this._database){
    install(new FindEngineDefaultsModule());
    install(new NobsStorageModule());
    bind(Database, toValue: this._database);
    bind(VersionInfo, toValue: this._versionInfo);
    bind(EntryScreen);
    bind(AppHeader);
    bind(FindWidget);
    bind(FindResult);
    bind(Tag);
    bind(RecordWidget);
    bind(ExerciseSource);
    bind(ExerciseFindEngine);
    bind(RouteInitializerFn, toImplementation: Routes);
  }
}
