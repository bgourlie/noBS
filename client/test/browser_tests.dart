library browser_tests;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:logging/logging.dart';
import 'services/find_engine/find_engine_tests.dart' as find_engine_tests;
import 'services/storage_engine_defaults/levenshtein_distance_tests.dart'
    as distance_tests;
import 'services/storage_engine_defaults/default_matcher_tests.dart'
    as matcher_tests;
import 'services/storage_engine_defaults/default_term_splitter_tests.dart'
    as term_splitter_tests;
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

  group('find engine', find_engine_tests.main);
  group('find engine defaults', (){
    group('damerau-levenshtein algorithm', distance_tests.main);
    group('matcher tests', matcher_tests.main);
    group('term splitter tests', term_splitter_tests.main);
  });

  group('storage engine', (){
    group('storageService', storage_service_tests.main);
    group('integration tests', storage_engine_integration_tests.main);
  });

  group('nobs storage', (){
    group('smoke tests', nobs_storage_smoke_tests.main);
  });
}

