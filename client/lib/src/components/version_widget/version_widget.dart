library version_widget;

import 'package:angular/angular.dart';
import 'package:logging/logging.dart';
import 'package:di/annotations.dart';
import 'package:client/fitlog_models.dart';

@Injectable()
@Component(
    selector: 'version-widget',
    templateUrl: 'packages/client/src/components/version_widget/version_widget.html',
    cssUrl: 'packages/client/src/components/version_widget/version_widget.css')
class VersionWidget {
  static final _logger = new Logger('nobs_version_widget');
  final VersionInfo versionInfo;
  VersionWidget(VersionInfo this.versionInfo);
}
