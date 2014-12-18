library find_engine;

import 'dart:async';
import 'package:di/annotations.dart';
import 'package:di/di.dart';

part 'find_result.dart';
part 'findable.dart';
part 'findable_source.dart';
part 'fuzzy_algorithm.dart';
part 'term.dart';
part 'threshold_out_of_bounds_error.dart';
part 'invalid_term_type_error.dart';
part 'match_ranker.dart';
part 'find_engine_module.dart';

class FindEngine<T extends Findable> {
  final FuzzyAlgorithm _fuzzyAlgorithm;
  final MatchRanker _matchRanker;
  final FindableSource<T> _source;

  FindEngine(this._fuzzyAlgorithm, this._matchRanker, this._source);

  /// The maximum threshold that [streamResults] will accept.
  int get maxThreshold => _fuzzyAlgorithm.maxThreshold;

  /// Returns a [Stream] of [FindResult]s whose values satisfy [searchTerm].
  ///
  /// The [FindResult]'s values, which are [Findable]s, will satisfy
  /// [searchTerm] if the [Findable]'s [Term]s are similar to [searchTerm].
  ///
  /// The [threshold] tunes the similarity tolerance.  A threshold of 0 will
  /// require an exact match, while a higher threshold will allow for more
  /// differences between a [Findable]'s [Term]s and [searchTerm].  If no
  /// [threshold] is specified, it will default to [defaultThreshold].
  ///
  /// [matchOnTermType] determines the type of [Term] that [searchTerm] will
  /// be compared to.  If unspecified, it will compare against all [Term] types.
  Stream<FindResult<T>> streamResults(String searchTerm, int threshold,
      {int matchOnTermType : Term.TYPE_UNSPECIFIED}){

    if(threshold == null || threshold < 0 || threshold > maxThreshold){
      throw new ThresholdNullOrOutOfBoundsError();
    }

    return _source.getStream()
        .map((r) => _fuzzyMatch(r, searchTerm, threshold, matchOnTermType))
        .where((r) => _resultFilter(r, threshold));
  }

  bool _resultFilter(FindResult<T> r, int threshold) {
    final ret = !r._noMatch && (r.matchRank < FindResult.RANK_LAST
        || r.matchScore <= threshold);
    return ret;
  }

  FindResult _fuzzyMatch(Findable findable, String searchTerm, int threshold,
      int matchOnTermType){

    if(![Term.TYPE_UNSPECIFIED, Term.TYPE_NAME, Term.TYPE_TAG]
        .contains(matchOnTermType)){
      throw new InvalidTermTypeError();
    }

    final terms = matchOnTermType == Term.TYPE_UNSPECIFIED ? findable.terms
        : findable.terms.where((t) => t.termType == matchOnTermType);

    final matchedTerms = terms.map((Term t) {
      final lowerTerm = t.term.toLowerCase();
      final lowerSearchTerm = searchTerm.toLowerCase();
      final matchedTerm = {'term' : t, 'distance'
          : _fuzzyAlgorithm.distance(lowerSearchTerm, lowerTerm, threshold),
          'rank' : _matchRanker.getRank(lowerTerm, lowerSearchTerm)};

      return matchedTerm;
    });

    var bestMatch;
    for(var matchedTerm in matchedTerms){
      // rank takes precedence over score.
      if(bestMatch == null || matchedTerm['rank'] < bestMatch['rank']
          || (matchedTerm['rank'] == bestMatch['rank']
          && matchedTerm['distance'] < bestMatch['distance'])){
        bestMatch = matchedTerm;
      }
    }

    return bestMatch == null ? new FindResult.noMatch()
        : new FindResult(findable, bestMatch['rank'], bestMatch['distance'],
        bestMatch['term']);
  }
}