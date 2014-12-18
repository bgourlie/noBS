library find_engine_defaults;

import 'dart:typed_data';
import 'package:di/annotations.dart';
import 'package:di/di.dart' as di;
import 'package:quiver/iterables.dart' as q;
import 'package:client/src/services/find_engine/find_engine.dart';

part 'fuzzy_algorithm.dart';
part 'term_splitter.dart';
part 'damerau_levenshtein_distance.dart';
part 'default_matcher.dart';
part 'default_term_splitter.dart';

class FindEngineDefaultsModule extends di.Module {
  FindEngineDefaultsModule(){
    bind(FuzzyAlgorithm, toImplementation: DamerauLevenshteinDistance);
    bind(FindEngineMatcher, toImplementation: DefaultMatcher);
    bind(TermSplitter, toImplementation: DefaultTermSplitter);
  }
}