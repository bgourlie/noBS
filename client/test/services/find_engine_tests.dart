import 'dart:async';
import 'package:unittest/unittest.dart';
import 'package:client/src/services/find_engine/find_engine.dart';
import 'package:typed_mock/typed_mock.dart';

main() {

  test('''should always include results regardless of distance if rank is less
      than RANK_LAST''', (){
    // Arrange
    final tb = new _TestBed();
    when(tb.fuzzyAlgo.maxThreshold).thenReturn(255);
    when(tb.fuzzyAlgo.distance(anyString, 'one', anyInt)).thenReturn(15);
    when(tb.fuzzyAlgo.distance(anyString, 'two', anyInt)).thenReturn(16);
    when(tb.fuzzyAlgo.distance(anyString, 'three', anyInt)).thenReturn(17);
    when(tb.matchRanker.getRank(anyString, anyString))
        .thenReturn(FindResult.RANK_CONTAINS);

    when(tb.fooSource.getStream()).thenReturn(
        new Stream.fromIterable([
            new Foo([new Term('one', Term.TYPE_NAME)]),
            new Foo([new Term('two', Term.TYPE_NAME)]),
            new Foo([new Term('three', Term.TYPE_NAME)])]));

    final findEngine = tb.newFindEngine();


    // Act
    final resultStream = findEngine.streamResults('arbitrary', 16);

    // Assert
    expect(resultStream.toList().then((List<FindResult<Foo>> l) {
          expect(l, hasLength(3));
          final blah = l.every((r) => ['one', 'two', 'three']
              .contains(r.matchedTerm.term));
          expect(l.every((r) => ['one', 'two', 'three']
              .contains(r.matchedTerm.term)), isTrue);
        }), completes);
  });

  test('''should only exclude results having distance greater than or equal to
      threshold if rank is LAST_RANK''', (){
    // Arrange
    final tb = new _TestBed();
    when(tb.fuzzyAlgo.maxThreshold).thenReturn(255);
    when(tb.fuzzyAlgo.distance(anyString, 'one', anyInt)).thenReturn(15);
    when(tb.fuzzyAlgo.distance(anyString, 'two', anyInt)).thenReturn(16);
    when(tb.fuzzyAlgo.distance(anyString, 'three', anyInt)).thenReturn(17);
    when(tb.matchRanker.getRank(anyString, anyString))
        .thenReturn(FindResult.RANK_LAST);

    when(tb.fooSource.getStream()).thenReturn(
        new Stream.fromIterable([
            new Foo([new Term('one', Term.TYPE_NAME)]),
            new Foo([new Term('two', Term.TYPE_NAME)]),
            new Foo([new Term('three', Term.TYPE_NAME)])]));

    final findEngine = tb.newFindEngine();

    // Act
    final resultStream = findEngine.streamResults('arbitrary', 16);

    // Assert
    expect(resultStream.toList().then((List<FindResult<Foo>> l) {
      expect(l, hasLength(2));
      expect(l.every((r) => ['one', 'two'].contains(r.matchedTerm.term)),
          isTrue);
    }), completes);
  });

  test('should only return results having specified term type', (){
    // Arrange
    final tb = new _TestBed();
    when(tb.fuzzyAlgo.maxThreshold).thenReturn(255);
    when(tb.fuzzyAlgo.distance(anyString, 'one', anyInt)).thenReturn(0);
    when(tb.fuzzyAlgo.distance(anyString, 'on', anyInt)).thenReturn(1);
    when(tb.fuzzyAlgo.distance(anyString, 'one', anyInt)).thenReturn(0);
    when(tb.matchRanker.getRank(anyString, anyString))
        .thenReturn(FindResult.RANK_LAST);

    when(tb.fooSource.getStream()).thenReturn(
        new Stream.fromIterable([
            new Foo([new Term('one', Term.TYPE_NAME)]),
            new Foo([new Term('on', Term.TYPE_NAME)]),
            new Foo([new Term('one', Term.TYPE_TAG)])]));

    final findEngine = tb.newFindEngine();

    // Act
    final resultStream = findEngine.streamResults('arbitrary', 16,
        matchOnTermType: Term.TYPE_NAME);

    // Assert
    expect(resultStream.toList().then((List<FindResult<Foo>> l) {
      expect(l, hasLength(2));
      expect(l.every((r) => ['one', 'on'].contains(r.matchedTerm.term)),
          isTrue);
    }), completes);
  });

  test('should return results having all term types if none is specified', (){
    // Arrange
    final tb = new _TestBed();
    when(tb.fuzzyAlgo.maxThreshold).thenReturn(255);
    when(tb.fuzzyAlgo.distance(anyString, 'one', anyInt)).thenReturn(0);
    when(tb.fuzzyAlgo.distance(anyString, 'on', anyInt)).thenReturn(1);
    when(tb.fuzzyAlgo.distance(anyString, 'ne', anyInt)).thenReturn(1);
    when(tb.matchRanker.getRank(anyString, anyString))
        .thenReturn(FindResult.RANK_LAST);
    final findEngine = tb.newFindEngine();

    when(tb.fooSource.getStream()).thenReturn(
        new Stream.fromIterable([
            new Foo([new Term('one', Term.TYPE_NAME)]),
            new Foo([new Term('on', Term.TYPE_NAME)]),
            new Foo([new Term('ne', Term.TYPE_TAG)])]));

    // Act
    final resultStream = findEngine.streamResults('arbitrary', 16);

    // Assert
    expect(resultStream.toList().then((List<FindResult<Foo>> l) {
      expect(l, hasLength(3));
      expect(l.every((r) => ['one', 'on', 'ne'].contains(r.matchedTerm.term)),
          isTrue);
    }), completes);
  });

  test('should throw error when threshold is null', (){
    // Arrange
    final tb = new _TestBed();
    when(tb.fuzzyAlgo.maxThreshold).thenReturn(255);
    final findEngine = tb.newFindEngine();

    // Act and Assert
    expect(() => findEngine.streamResults('foo', null), throwsA(new
        isInstanceOf<ThresholdNullOrOutOfBoundsError>()));
  });

  test('should throw error when threshold is less than 0', (){
    // Arrange
    final tb = new _TestBed();
    when(tb.fuzzyAlgo.maxThreshold).thenReturn(255);
    final findEngine = tb.newFindEngine();

    // Act and Assert
    expect(() => findEngine.streamResults('foo', -1), throwsA(new
    isInstanceOf<ThresholdNullOrOutOfBoundsError>()));
  });

  test('should throw error when threshold is greater than maxThreshold', (){
    // Arrange
    final tb = new _TestBed();
    when(tb.fuzzyAlgo.maxThreshold).thenReturn(255);
    final findEngine = tb.newFindEngine();

    // Act and Assert
    expect(() => findEngine.streamResults('foo', 256), throwsA(new
    isInstanceOf<ThresholdNullOrOutOfBoundsError>()));
  });
}

class MockFooSource extends TypedMock implements FindableSource<Foo>{}
class MockFuzzyAlgo extends TypedMock implements FuzzyAlgorithm{}
class MockMatchRanker extends TypedMock implements MatchRanker{}

class Foo implements Findable {
  final List<Term> _terms;
  List<Term> get terms => _terms;
  Foo(this._terms);
}

class _TestBed {
  final fooSource = new MockFooSource();
  final fuzzyAlgo = new MockFuzzyAlgo();
  final matchRanker = new MockMatchRanker();

  FindEngine<Foo> newFindEngine() =>
      new FindEngine<Foo>(fuzzyAlgo, matchRanker, fooSource);
}