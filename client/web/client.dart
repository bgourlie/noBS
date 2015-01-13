import 'dart:html' as dom;
import 'package:logging/logging.dart';
import 'package:angular/application_factory.dart';
import 'package:client/fitlog_web_client.dart';
import 'package:client/fitlog_models.dart';
import 'package:client/src/services/storage_engine/storage_engine.dart'
    as storage;
import 'package:client/src/services/nobs_storage/nobs_storage.dart';

const VERSION = 'alpha';
const BUILD_NUMBER = '';
const BRANCH = '';
const COMMIT_ID = '';
const BUILD_TIME = '';

void main() {
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord
      .listen((LogRecord r) => print('[${r.loggerName}] ${r.message}'));
  final logger = new Logger('app_entrypoint');
  const versionInfo =
      const VersionInfo(VERSION, BUILD_NUMBER, BRANCH, COMMIT_ID, BUILD_TIME);
  final dbConfig = new NobsDbV1Config();
  final bootstrapper = new storage.Bootstrapper(dbConfig, dom.window);
  logger.finest('bootstrapping database...');
  bootstrapper.getDatabase().then((db) {
    logger.finest('got database, running app.');
    final clientModule = new ClientModule(versionInfo, db);
    applicationFactory().addModule(clientModule).run();
  });
}
