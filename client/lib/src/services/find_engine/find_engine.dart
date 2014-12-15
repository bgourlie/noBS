library find_engine;

import 'dart:async';

part 'find_result.dart';
part 'findable.dart';
part 'findable_source.dart';
part 'fuzzy_algorithm.dart';
part 'term.dart';
part 'threshold_out_of_bounds_error.dart';
part 'invalid_term_type_error.dart';

class FindEngine<T extends Findable> {
  final FuzzyAlgorithm _fuzzyAlgorithm;
  final FindableSource<T> _source;

  FindEngine(this._fuzzyAlgorithm, this._source);

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
        .where((r) => !r._noMatch && r.matchScore <= threshold);
  }

  FindResult _fuzzyMatch(Findable findable, String searchTerm, int threshold,
      int matchOnTermType){

    if(![Term.TYPE_UNSPECIFIED, Term.TYPE_NAME, Term.TYPE_TAG]
        .contains(matchOnTermType)){
      throw new InvalidTermTypeError();
    }

    final terms = matchOnTermType == Term.TYPE_UNSPECIFIED ? findable.terms
        : findable.terms.where((t) => t.termType == matchOnTermType);

    final matchedTerms = terms.map((t) => {'term' : t, 'distance' :
        _fuzzyAlgorithm.distance(searchTerm, t.term, threshold)});

    var bestMatch;
    for(var matchedTerm in matchedTerms){
      if(bestMatch == null || matchedTerm['distance'] < bestMatch['distance']){
        bestMatch = matchedTerm;
      }
    }

    return bestMatch == null ? new FindResult.noMatch()
        : new FindResult(findable, bestMatch['distance'], bestMatch['term']);
  }
}