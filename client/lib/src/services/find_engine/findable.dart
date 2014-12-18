part of find_engine;

abstract class Findable {
  /// The terms which, when searched against, may result in the [Findable] being
  /// returned.
  List<Term> get terms;
}