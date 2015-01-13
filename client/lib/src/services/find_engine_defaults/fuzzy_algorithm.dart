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

part of find_engine_defaults;

abstract class FuzzyAlgorithm {
  /// The maximum threshold (distance) that the fuzzy algorithm can accept.
  int get maxThreshold;

  /// Returns the distance (number of differences) between two strings.
  ///
  /// Different algorithms may take different types of differences into account.
  /// For example, the Levenshtien distance algorithm takes into account
  /// insertions, deletions, and substitutions, but not transpositions.
  /// Damerau-Levenshtien distance does take into account transpositions.
  ///
  /// When the number of difference exceeds [threshold], [maxThreshold] should
  /// be returned.
  int distance(String source, String target, int threshold);
}
