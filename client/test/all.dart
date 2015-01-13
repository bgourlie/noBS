library client_test;

import 'package:unittest/unittest.dart';
import 'services/find_engine/find_engine_tests.dart' as find_engine_tests;
import 'services/storage_engine_defaults/levenshtein_distance_tests.dart'
    as distance_tests;
import 'services/storage_engine_defaults/default_matcher_tests.dart'
    as matcher_tests;
import 'services/storage_engine_defaults/default_term_splitter_tests.dart'
    as term_splitter_tests;

main() {
  group('find engine', find_engine_tests.main);
  group('find engine defaults', (){
    group('damerau-levenshtein algorithm', distance_tests.main);
    group('matcher tests', matcher_tests.main);
    group('term splitter tests', term_splitter_tests.main);
  });
}