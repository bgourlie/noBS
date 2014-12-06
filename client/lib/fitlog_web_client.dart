library fitlog_web_client;

import 'package:angular/angular.dart';
import 'src/components/entry_screen/entry_screen.dart';
import 'src/components/version_widget/version_widget.dart';
import 'fitlog_models.dart';

part 'src/routes.dart';

class ClientModule extends Module {
  final VersionInfo versionInfo;

  ClientModule(this.versionInfo){
    bind(VersionInfo, toValue: this.versionInfo);
    bind(EntryScreen);
    bind(VersionWidget);
    bind(RouteInitializerFn, toImplementation: Routes);
  }
}
