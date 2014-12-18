part of find_engine;

/// Contains a [Findable] and metadata regarding the search that resulted in it.
///
/// The two values that indicate how good a match is are [matchRank] and
/// [matchScore].  [matchRank] will be one of a finite set of well-defined
/// values.  The ranks are as follow (lowest to highest, where lower is better):
///
/// - RANK_STARTS_WITH: The [Term] starts with the search term.
///
/// - RANK_CONTAINS: The [Term] contains the search term.
///
/// - RANK_LAST: The lowest rank, to be used when none of the former rank
///   conditions are met
class FindResult<T extends Findable> {
  static const RANK_STARTS_WITH = 0;
  static const RANK_CONTAINS = 1;
  static const RANK_LAST = 255;

  /// The matched [Findable].
  final T item;

  /// A value indicating what 'rank' the result falls into.  A lower ranking
  /// indicates a better match.
  final int matchRank;

  /// A score indicating how similar the [matchedTerm] is to the search term.
  /// A lower score indicates a better match.
  final int matchScore;

  /// The [Term] that resulted in the match.
  final Term matchedTerm;

  /// A value only set on special instances of FindResult to indicate that no
  /// terms matched.
  final bool _noMatch;

  FindResult(this.item, this.matchRank, this.matchScore, this.matchedTerm)
      : _noMatch = false;

  FindResult.noMatch() : item = null, matchScore = null, matchedTerm = null,
      matchRank = RANK_LAST, _noMatch = true;

  String toString() => _noMatch ? '[No Match]' : matchedTerm.toString();
}