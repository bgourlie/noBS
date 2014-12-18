library fitlog_web_client;

import 'package:angular/angular.dart';
import 'src/components/entry_screen/entry_screen.dart';
import 'src/components/app_header/app_header.dart';
import 'src/components/find_box/find_box.dart';
import 'src/components/find_widget/find_widget.dart';
import 'package:client/fitlog_models.dart';
import 'package:client/src/services/find_engine/find_engine.dart';
import 'package:client/src/services/damerau_levenshtein_distance.dart';
import 'package:client/src/services/exercise_find_engine.dart';
import 'package:client/src/services/exercise_source.dart';


part 'src/routes.dart';

class ClientModule extends Module {
  final VersionInfo versionInfo;

  ClientModule(this.versionInfo){
    install(new FindEngineModule());
    bind(VersionInfo, toValue: this.versionInfo);
    bind(EntryScreen);
    bind(AppHeader);
    bind(FindBox);
    bind(FindWidget);
    bind(ExerciseSource);
    bind(DamerauLevenshteinDistance);
    bind(ExerciseFindEngine);
    bind(RouteInitializerFn, toImplementation: Routes);
  }
}
