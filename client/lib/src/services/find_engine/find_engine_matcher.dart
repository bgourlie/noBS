part of find_engine;

/// Responsible for determining the position of the result given the [Term] and
/// a search term.
abstract class FindEngineMatcher {
   FindEngineMatch getMatch(Term term, String searchTerm);
}