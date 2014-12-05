import 'dart:html';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:angular/application_factory.dart';
import 'package:client/fitlog_web_client.dart';

const VERSION = 'alpha';
const BUILD_NUMBER = '';
const BRANCH = '';
const COMMIT_ID = '';
const BUILD_TIME = '';

void main() {
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord r) => print('[${r.loggerName}] ${r.message}'));
  final buildTime = DateTime.parse(BUILD_TIME);
  final formatter = new DateFormat.yMd().add_Hm();
  final clientModule = new ClientModule();
  applicationFactory().addModule(clientModule).run();
}
