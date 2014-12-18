part of find_engine;

class FindEngineModule extends Module {
  FindEngineModule(){
    bind(MatchRanker);
  }
}