library browser_tests;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'services/storage_service_tests.dart' as storage_service_tests;

void main(){
  useHtmlEnhancedConfiguration();
  group('storageService', storage_service_tests.main);
}

