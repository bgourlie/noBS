library client_test;

import 'package:unittest/unittest.dart';
import 'services/find_engine_tests.dart' as find_engine_tests;
import 'services/damerau_levenshtein_distance_tests.dart' as distance_tests;

main() {
  group('find engine', find_engine_tests.main);
  group('damerau-levenshtein algorithm', distance_tests.main);
}