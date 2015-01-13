library default_term_splitter_tests;

import 'package:unittest/unittest.dart';
import 'package:client/src/services/find_engine/find_engine.dart';
import 'package:client/src/services/find_engine_defaults/find_engine_defaults.dart';

main(){
  test('should split terms with type TYPE_NAME using spaces', (){
    final splitter = new DefaultTermSplitter();
    final term = new Term('this is my term', Term.TYPE_NAME);
    final words = splitter.splitTerm(term);

    expect(words, orderedEquals(['this', 'is', 'my', 'term']));
  });

  test('should split terms with type TYPE_TAG using dashes', (){
    final splitter = new DefaultTermSplitter();
    final term = new Term('this-is-my-term', Term.TYPE_TAG);
    final words = splitter.splitTerm(term);

    expect(words, orderedEquals(['this', 'is', 'my', 'term']));
  });
}
