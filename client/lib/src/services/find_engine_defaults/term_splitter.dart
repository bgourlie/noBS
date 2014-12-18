part of find_engine_defaults;

abstract class TermSplitter {
  /// Splits a [Term] into individual words.
  ///
  /// It's common for a [Term] to consist of multiple words that we want to
  /// match on independently.  Consider the following examples:
  /// - A typical phrase, "close grip bench press"
  /// - A stackoverflow style tag, "entity-framework"
  /// - A camelcase property name, "findPeopleByName"
  ///
  /// This method is responsible for splitting the phrase into
  /// individual words.
  List<String> splitTerm(Term term);
}