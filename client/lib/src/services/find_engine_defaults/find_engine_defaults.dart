// The contents of this file are subject to the Common Public Attribution
// License Version 1.0. (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// https://raw.githubusercontent.com/bgourlie/noBS/master/LICENSE.
// The License is based on the Mozilla Public License Version 1.1, but Sections
// 14 and 15 have been added to cover use of software over a computer network
// and provide for limited attribution for the Original Developer. In addition,
// Exhibit A has been modified to be consistent with Exhibit B.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
// the specific language governing rights and limitations under the License.
//
// The Original Code is noBS Exercise Logger.
//
// The Original Developer is the Initial Developer.  The Initial Developer of
// the Original Code is W. Brian Gourlie.
//
// All portions of the code written by W. Brian Gourlie are Copyright (c)
// 2014-2015 W. Brian Gourlie. All Rights Reserved.

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
  FindEngineDefaultsModule() {
    bind(FuzzyAlgorithm, toImplementation: DamerauLevenshteinDistance);
    bind(FindEngineMatcher, toImplementation: DefaultMatcher);
    bind(TermSplitter, toImplementation: DefaultTermSplitter);
  }
}
