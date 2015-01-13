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

library find_engine;

import 'dart:async';
import 'package:quiver/iterables.dart' as q;
import 'package:logging/logging.dart';

part 'find_result.dart';
part 'findable.dart';
part 'findable_source.dart';
part 'term.dart';
part 'invalid_term_type_error.dart';
part 'find_engine_matcher.dart';
part 'find_engine_match.dart';

class FindEngine<T extends Findable> {
  static final _logger = new Logger('find_engine');
  final FindEngineMatcher _matcher;
  final FindableSource<T> _source;

  FindEngine(this._matcher, this._source);

  /// Returns a [Stream] of [FindResult] whose [Term]s satisfy [searchTerm].
  ///
  /// Whether or not a [Findable] satisfies [searchTerm] is determined by the
  /// injected [FindEngineMatcher].
  ///
  /// [matchOnTermType] determines the type of term that [searchTerm] will
  /// be compared to.  If unspecified, it will compare against all term types.
  Stream<FindResult<T>> streamResults(String searchTerm,
      {int matchOnTermType: Term.TYPE_UNSPECIFIED}) {
    if (![
      Term.TYPE_UNSPECIFIED,
      Term.TYPE_NAME,
      Term.TYPE_TAG
    ].contains(matchOnTermType)) {
      throw new InvalidTermTypeError();
    }

    return _source
        .getStream()
        .map((r) => _match(r, searchTerm, matchOnTermType))
        .where((r) => !r._noMatch);
  }

  FindResult<T> _match(
      Findable findable, String searchTerm, int matchOnTermType) {
    final terms = matchOnTermType == Term.TYPE_UNSPECIFIED
        ? findable.terms
        : findable.terms.where((t) => t.termType == matchOnTermType);

    final matchedTerms = terms.map((Term t) {
      final match = _matcher.getMatch(t, searchTerm);

      return match.rank == FindEngineMatch.UNRANKED
          ? new FindResult.noMatch()
          : new FindResult(findable, match, t);
    });

    // TODO(blocked): write test to verify that we actually return the
    // highest ranked match. See:
    // https://code.google.com/p/dart/issues/detail?id=21945
    final bestMatch = q.max(matchedTerms, (FindResult a, FindResult b) {
      if (!a._noMatch && b._noMatch) return 1;
      if (a._noMatch && !b._noMatch) return -1;
      if (a._noMatch && b._noMatch) return 0;

      // A lower rank is a better match
      if (a.match.rank < b.match.rank) return 1;
      if (a.match.rank > b.match.rank) return -1;

      // if we get here, ranks are safely assumed to be equal
      if (a.match.subRank > b.match.subRank) return -1;
      if (a.match.subRank < b.match.subRank) return 1;

      // rank and subRank are safely assumed to be equal
      return 0;
    });

    return bestMatch;
  }
}
