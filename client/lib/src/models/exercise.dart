part of fitlog_models;

class Exercise implements Findable {
  final String title;
  final List<Term> _terms;

  List<Term> get terms => _terms;

  Exercise._internal(this.title, this._terms);

  factory Exercise(String title, List<String> synonyms, List<String> tags){
    final names = new List<String>()
        ..add(title)
        ..addAll(synonyms);

    final terms = names.map((e) => new Term(e, Term.TYPE_NAME)).toList()
        ..addAll(synonyms.map((e) => new Term(e, Term.TYPE_TAG)));

    return new Exercise._internal(title, terms);
  }
}