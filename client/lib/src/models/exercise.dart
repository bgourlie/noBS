part of fitlog_models;

class Exercise implements Findable, Storable {
  final String title;
  final List<String> synonyms;
  final List<String> tags;

  List<Term> _terms;
  int _dbKey;

  int get dbKey => _dbKey;
  set dbKey(int val) => _dbKey = val;

  List<Term> get terms {
    if(_terms == null){
      final names = new List<String>()
        ..add(title)
        ..addAll(synonyms);

      _terms = names.map((e) => new Term(e, Term.TYPE_NAME)).toList()
        ..addAll(tags.map((e) => new Term(e, Term.TYPE_TAG)));
    }
    return _terms;
  }

  Exercise(this.title, this.synonyms, this.tags);
}