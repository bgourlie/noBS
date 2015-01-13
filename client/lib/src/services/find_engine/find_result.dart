part of find_engine;

class FindResult<T extends Findable> {

  /// The matched [Findable].
  final T item;

  final FindEngineMatch match;

  /// The [Term] that resulted in the match.
  final Term matchedTerm;

  /// A value only set on special instances of FindResult to indicate that no
  /// terms matched.
  final bool _noMatch;

  FindResult(this.item, this.match, this.matchedTerm) : _noMatch = false;

  FindResult.noMatch()
      : item = null,
        matchedTerm = null,
        match = null,
        _noMatch = true;

  String toString() => _noMatch ? '[No Match]' : matchedTerm.toString();
}
