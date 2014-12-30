library fitlog_web_client;

import 'package:angular/angular.dart';
import 'package:client/src/components/entry_screen/entry_screen.dart';
import 'package:client/src/components/app_header/app_header.dart';
import 'package:client/src/components/find_box/find_box.dart';
import 'package:client/src/components/find_widget/find_widget.dart';
import 'package:client/src/components/find_result/find_result.dart';
import 'package:client/src/components/tag/tag.dart';
import 'package:client/fitlog_models.dart';
import 'package:client/src/services/find_engine_defaults/find_engine_defaults.dart';
import 'package:client/src/services/exercise_find_engine.dart';
import 'package:client/src/services/exercise_source.dart';


part 'src/routes.dart';

class ClientModule extends Module {
  final VersionInfo versionInfo;

  ClientModule(this.versionInfo){
    install(new FindEngineDefaultsModule());
    bind(VersionInfo, toValue: this.versionInfo);
    bind(EntryScreen);
    bind(AppHeader);
    bind(FindBox);
    bind(FindWidget);
    bind(FindResult);
    bind(Tag);
    bind(ExerciseSource);
    bind(ExerciseFindEngine);
    bind(RouteInitializerFn, toImplementation: Routes);
  }
}
