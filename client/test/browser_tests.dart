library browser_tests;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:logging/logging.dart';
import 'services/storage_engine/bootstrapper_tests.dart'
    as storage_service_tests;
import 'services/storage_engine/integration_tests.dart'
    as storage_engine_integration_tests;
import 'services/nobs_storage/smoke_tests.dart' as nobs_storage_smoke_tests;

void main(){
  useHtmlEnhancedConfiguration();
  unittestConfiguration.timeout = new Duration(seconds: 10);
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord r) =>
      print('[${r.loggerName}] ${r.message}'));
  group('storage engine', (){
    group('storageService', storage_service_tests.main);
    group('integration tests', storage_engine_integration_tests.main);
  });

  group('nobs storage', (){
    group('smoke tests', nobs_storage_smoke_tests.main);
  });
}

