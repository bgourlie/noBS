part of find_engine;

/// Contains metadata regarding a matched [Term].
///
/// [rank] and [subRank] determines a match's relevance.
/// [rank] must be a value between 0 and 255.  [subRank] is arbitrary, and
/// determines the position of a match within a particular rank.  If you were
/// to order matches by relevance, you would sort by [rank], then by [subRank].
class FindEngineMatch {
  static const UNRANKED = 256;

  final int rank;
  final int subRank;
  final String matchedFragment;

  FindEngineMatch(this.rank, this.subRank, this.matchedFragment);

  FindEngineMatch.unranked()
      : this.rank = UNRANKED,
        this.subRank = UNRANKED,
        this.matchedFragment = '';

  String toString() => '"$matchedFragment" [rank: $rank] [subRank: $subRank]';
}
