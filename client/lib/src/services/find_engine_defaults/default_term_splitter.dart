part of find_engine_defaults;

@Injectable()
class DefaultTermSplitter implements TermSplitter {
  List<String> splitTerm(Term term){
    assert([Term.TYPE_NAME, Term.TYPE_TAG].contains(term.termType));
    String splitChars;
    if(term.termType == Term.TYPE_NAME){
      splitChars = ' ';
    }else if(term.termType == Term.TYPE_TAG){
      splitChars = '-';
    }

    return term.term.split(splitChars);
  }
}