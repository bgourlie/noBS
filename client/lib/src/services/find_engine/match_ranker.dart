part of find_engine;

/// Responsible for determining the rank of a match given the string to match
/// against and the search term.
@Injectable()
class MatchRanker {
  int getRank(String term, String searchTerm){
    if(term.startsWith(searchTerm)){
      return FindResult.RANK_STARTS_WITH;
    }else if(term.contains(searchTerm)){
      return FindResult.RANK_CONTAINS;
    }else{
      return FindResult.RANK_LAST;
    }
  }
}