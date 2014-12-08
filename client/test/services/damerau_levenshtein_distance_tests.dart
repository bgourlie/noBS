import 'package:unittest/unittest.dart';
import 'package:client/src/services/damerau_levenshtein_distance.dart';

main(){
  group('damerau-levenshtein distance', (){
    test('should report correct number of insertions (1)', () {
      final algo = new DamerauLevenshteinDistance();
      final result = algo.distance('bria', 'brian', 255);
      expect(result, equals(1));
    });

    test('should report correct number of insertions (2)', () {
      final algo = new DamerauLevenshteinDistance();
      final result = algo.distance('brians tes', 'brians tests', 255);
      expect(result, equals(2));
    });

    test('should report correct number of substitutions (1)', () {
      final algo = new DamerauLevenshteinDistance();
      final result = algo.distance('brian', 'briam', 255);
      expect(result, equals(1));
    });

    test('should report correct number of substitutions (2)', () {
      final algo = new DamerauLevenshteinDistance();
      final result = algo.distance('brian', 'brimm', 255);
      expect(result, equals(2));
    });

    test('should report correct number of deletions (1)', () {
      final algo = new DamerauLevenshteinDistance();
      final result = algo.distance('brian', 'bria', 255);
      expect(result, equals(1));
    });

    test('should report correct number of deletions (2)', () {
      final algo = new DamerauLevenshteinDistance();
      final result = algo.distance('brians tests', 'brians tes', 255);
      expect(result, equals(2));
    });

    test('should report correct number of transpositions (1)', () {
      final algo = new DamerauLevenshteinDistance();
      final result = algo.distance('brain', 'brian', 255);
      expect(result, equals(1));
    });

    test('should report correct number of transpositions (2)', () {
      final algo = new DamerauLevenshteinDistance();
      final result = algo.distance('brains tests', 'brians tsets', 255);
      expect(result, equals(2));
    });

    test('should be case insensitive', () {
      final algo = new DamerauLevenshteinDistance();
      final result = algo.distance('BRIAN', 'brian', 255);
      expect(result, equals(0));
    });

    test('should return max threshold if minimum threshold is exceeded', () {
      final algo = new DamerauLevenshteinDistance();
      final result = algo.distance('brian', 'nairb', 2);
      expect(result, equals(255));
    });
  });
}