part of find_engine;

class FindResult<T extends Findable> {
  final T result;
  final int matchScore;
  final Term matchedTerm;
  final bool _noMatch;

  FindResult(this.result, this.matchScore, this.matchedTerm) :_noMatch = false;

  FindResult.noMatch() : result = null, matchScore = null, matchedTerm = null,
      _noMatch = true;

  String toString() => _noMatch ? '[No Match]' : matchedTerm.toString();
}