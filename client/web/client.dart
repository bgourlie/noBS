import 'package:logging/logging.dart';
import 'package:angular/application_factory.dart';
import 'package:client/fitlog_web_client.dart';
import 'package:client/fitlog_models.dart';

const VERSION = 'alpha';
const BUILD_NUMBER = '';
const BRANCH = '';
const COMMIT_ID = '';
const BUILD_TIME = '';

void main() {
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord r) => print('[${r.loggerName}] ${r.message}'));
  final buildTime = DateTime.parse(BUILD_TIME);
  const versionInfo = const VersionInfo(VERSION, BUILD_NUMBER, BRANCH, COMMIT_ID, BUILD_TIME);
  final clientModule = new ClientModule(versionInfo);
  applicationFactory().addModule(clientModule).run();
}
