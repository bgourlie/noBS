library browser_tests;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:logging/logging.dart';
import 'services/storage_engine/bootstrapper_tests.dart' as storage_service_tests;
import 'services/storage_engine/integration_tests.dart' as integration_tests;

void main(){
  useHtmlEnhancedConfiguration();
  unittestConfiguration.timeout = new Duration(seconds: 10);
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord r) => print('[${r.loggerName}] ${r.message}'));
  group('storage engine', (){
    group('storageService', storage_service_tests.main);
    group('integration tests', integration_tests.main);
  });
}

