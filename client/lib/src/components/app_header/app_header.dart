library app_header;

import 'package:angular/angular.dart';
import 'package:logging/logging.dart';
import 'package:di/annotations.dart';
import 'package:client/fitlog_models.dart';

@Injectable()
@Component(
    selector: 'app-header',
    templateUrl: 'packages/client/src/components/app_header/app_header.html',
    cssUrl: 'packages/client/src/components/app_header/app_header.css')
class AppHeader {
  static final _logger = new Logger('nobs_app_header');
  final VersionInfo versionInfo;
  AppHeader(VersionInfo this.versionInfo);
}
