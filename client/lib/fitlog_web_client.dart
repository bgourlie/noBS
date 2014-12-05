library fitlog_web_client;

import 'package:angular/angular.dart';
import 'src/components/entry_screen/entry_screen.dart';

part 'src/routes.dart';

class ClientModule extends Module {
  ClientModule(){
    bind(EntryScreen);
    bind(RouteInitializerFn, toImplementation: Routes);
  }
}
