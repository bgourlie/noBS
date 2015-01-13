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

library levenshtien_distance_tests;

import 'package:unittest/unittest.dart';
import 'package:client/src/services/find_engine_defaults/find_engine_defaults.dart';

main() {
  test('should report correct number of insertions (1)', () {
    final algo = new DamerauLevenshteinDistance();
    final result = algo.distance('bria', 'brian', 255);
    expect(result, equals(1));
  });

  test('should report correct number of insertions (2)', () {
    final algo = new DamerauLevenshteinDistance();
    final result = algo.distance('brians tes', 'brians tests', 255);
    expect(result, equals(2));
  });

  test('should report correct number of substitutions (1)', () {
    final algo = new DamerauLevenshteinDistance();
    final result = algo.distance('brian', 'briam', 255);
    expect(result, equals(1));
  });

  test('should report correct number of substitutions (2)', () {
    final algo = new DamerauLevenshteinDistance();
    final result = algo.distance('brian', 'brimm', 255);
    expect(result, equals(2));
  });

  test('should report correct number of deletions (1)', () {
    final algo = new DamerauLevenshteinDistance();
    final result = algo.distance('brian', 'bria', 255);
    expect(result, equals(1));
  });

  test('should report correct number of deletions (2)', () {
    final algo = new DamerauLevenshteinDistance();
    final result = algo.distance('brians tests', 'brians tes', 255);
    expect(result, equals(2));
  });

  test('should report correct number of transpositions (1)', () {
    final algo = new DamerauLevenshteinDistance();
    final result = algo.distance('brain', 'brian', 255);
    expect(result, equals(1));
  });

  test('should report correct number of transpositions (2)', () {
    final algo = new DamerauLevenshteinDistance();
    final result = algo.distance('brains tests', 'brians tsets', 255);
    expect(result, equals(2));
  });

  test('should be case sensitive', () {
    final algo = new DamerauLevenshteinDistance();
    final result = algo.distance('BRIAN', 'brian', 255);
    expect(result, equals(5));
  });

  test('should return max threshold if minimum threshold is exceeded', () {
    final algo = new DamerauLevenshteinDistance();
    final result = algo.distance('brian', 'nairb', 2);
    expect(result, equals(255));
  });
}
