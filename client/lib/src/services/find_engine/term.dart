part of find_engine;

class Term {
  static const TYPE_UNSPECIFIED = 0;
  static const TYPE_NAME = 1;
  static const TYPE_TAG = 2;

  final String term;
  final int termType;

  Term(this.term, this.termType){
    assert([TYPE_NAME, TYPE_TAG].contains(termType));
  }

  String toString() => '$term';
}