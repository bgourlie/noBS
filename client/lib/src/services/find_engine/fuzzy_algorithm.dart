part of find_engine;

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
