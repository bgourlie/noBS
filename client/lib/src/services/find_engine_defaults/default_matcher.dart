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

@Injectable()
class DefaultMatcher implements FindEngineMatcher {
  static const int FUZZY_THRESHOLD = 1;
  static const int RANK_NAME_EQUALS = 0;
  static const int RANK_TAG_EQUALS = 1;
  static const int RANK_NAME_STARTS_WITH = 2;
  static const int RANK_TAG_STARTS_WITH = 3;
  static const int RANK_NAME_CONTAINS = 4;
  static const int RANK_TAG_CONTAINS = 5;
  static const int RANK_LIKE = 6;

  final FuzzyAlgorithm _fuzzy;
  final TermSplitter _termSplitter;

  DefaultMatcher(this._fuzzy, this._termSplitter);

  FindEngineMatch getMatch(Term term, String searchTerm) {
    final lowerTerm = term.term.toLowerCase();
    final lowerSearchTerm = searchTerm.toLowerCase();

    final rank = _getRank(lowerTerm, term.termType, lowerSearchTerm);

    if (rank < RANK_LIKE) {
      // The lower the difference in string length, the higher the sub rank.
      int subRank = (term.term.length - searchTerm.length).abs();
      return new FindEngineMatch(rank, subRank, lowerSearchTerm);
    }

    // If we get here, we attempt to do a fuzzy match on the individual words
    // within a term.
    final words = _termSplitter.splitTerm(term).map((word) {
      final searchTermLength = lowerSearchTerm.length;
      final wordLength = word.length;
      // the string we compare against is a substring equal to the length of the
      // search term.
      final fragment = searchTermLength >= word.length
          ? word.toLowerCase()
          : word.substring(0, searchTermLength).toLowerCase();

      return {
        'fragment': fragment,
        'distance': _fuzzy.distance(lowerSearchTerm, fragment, FUZZY_THRESHOLD)
      };
    });

    final closest = q.min(words, (a, b) {
      if (a['distance'] > b['distance']) return 1;
      if (a['distance'] < b['distance']) return -1;
      return 0;
    });

    return closest == null || closest['distance'] > FUZZY_THRESHOLD
        ? new FindEngineMatch.unranked()
        : new FindEngineMatch(rank, closest['distance'], closest['fragment']);
  }

  int _getRank(String term, int termType, String searchTerm) {
    switch (termType) {
      case Term.TYPE_NAME:
        if (term == searchTerm) {
          return RANK_NAME_EQUALS;
        }
        if (term.startsWith(searchTerm)) {
          return RANK_NAME_STARTS_WITH;
        }
        if (term.contains(searchTerm)) {
          return RANK_NAME_CONTAINS;
        }
        return RANK_LIKE;
      case Term.TYPE_TAG:
        if (term == searchTerm) {
          return RANK_TAG_EQUALS;
        }
        if (term.startsWith(searchTerm)) {
          return RANK_TAG_STARTS_WITH;
        }
        if (term.contains(searchTerm)) {
          return RANK_TAG_CONTAINS;
        }
        return RANK_LIKE;
      default:
        assert(false);
    }
    assert(false);
    return -1;
  }
}
