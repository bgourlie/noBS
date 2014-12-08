import 'dart:async';
import 'package:unittest/unittest.dart';
import 'package:client/src/services/find_engine/find_engine.dart';
import 'package:typed_mock/typed_mock.dart';

main() {
  test('should only return results having distance <= to threshold', (){
    // Arrange
    final mockSource = new MockFooSource();
    final mockFuzzyAlgo = new MockFuzzyAlgo();
    when(mockFuzzyAlgo.maxThreshold).thenReturn(255);
    when(mockFuzzyAlgo.distance(anyString, 'one', anyInt)).thenReturn(15);
    when(mockFuzzyAlgo.distance(anyString, 'two', anyInt)).thenReturn(16);
    when(mockFuzzyAlgo.distance(anyString, 'three', anyInt)).thenReturn(17);
    final findEngine = new FindEngine<Foo>(mockFuzzyAlgo, mockSource);

    when(mockSource.getStream()).thenReturn(
        new Stream.fromIterable([
          new Foo([new Term('one', Term.TYPE_NAME)]),
          new Foo([new Term('two', Term.TYPE_NAME)]),
          new Foo([new Term('three', Term.TYPE_NAME)])]));

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
    final mockSource = new MockFooSource();
    final mockFuzzyAlgo = new MockFuzzyAlgo();
    when(mockFuzzyAlgo.maxThreshold).thenReturn(255);
    when(mockFuzzyAlgo.distance(anyString, 'one', anyInt)).thenReturn(0);
    when(mockFuzzyAlgo.distance(anyString, 'on', anyInt)).thenReturn(1);
    when(mockFuzzyAlgo.distance(anyString, 'one', anyInt)).thenReturn(0);
    final findEngine = new FindEngine<Foo>(mockFuzzyAlgo, mockSource);

    when(mockSource.getStream()).thenReturn(
        new Stream.fromIterable([
            new Foo([new Term('one', Term.TYPE_NAME)]),
            new Foo([new Term('on', Term.TYPE_NAME)]),
            new Foo([new Term('one', Term.TYPE_TAG)])]));

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
    final mockSource = new MockFooSource();
    final mockFuzzyAlgo = new MockFuzzyAlgo();
    when(mockFuzzyAlgo.maxThreshold).thenReturn(255);
    when(mockFuzzyAlgo.distance(anyString, 'one', anyInt)).thenReturn(0);
    when(mockFuzzyAlgo.distance(anyString, 'on', anyInt)).thenReturn(1);
    when(mockFuzzyAlgo.distance(anyString, 'ne', anyInt)).thenReturn(1);
    final findEngine = new FindEngine<Foo>(mockFuzzyAlgo, mockSource);

    when(mockSource.getStream()).thenReturn(
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
    final mockSource = new MockFooSource();
    final mockFuzzyAlgo = new MockFuzzyAlgo();
    final findEngine = new FindEngine<Foo>(mockFuzzyAlgo, mockSource);

    // Act and Assert
    expect(() => findEngine.streamResults('foo', null), throwsA(new
        isInstanceOf<ThresholdNullOrOutOfBoundsError>()));
  });

  test('should throw error when threshold is less than 0', (){
    // Arrange
    final mockSource = new MockFooSource();
    final mockFuzzyAlgo = new MockFuzzyAlgo();
    final findEngine = new FindEngine<Foo>(mockFuzzyAlgo, mockSource);

    // Act and Assert
    expect(() => findEngine.streamResults('foo', -1), throwsA(new
    isInstanceOf<ThresholdNullOrOutOfBoundsError>()));
  });

  test('should throw error when threshold is greater than maxThreshold', (){
    // Arrange
    final mockSource = new MockFooSource();
    final mockFuzzyAlgo = new MockFuzzyAlgo();
    when(mockFuzzyAlgo.maxThreshold).thenReturn(255);
    final findEngine = new FindEngine<Foo>(mockFuzzyAlgo, mockSource);

    // Act and Assert
    expect(() => findEngine.streamResults('foo', 256), throwsA(new
    isInstanceOf<ThresholdNullOrOutOfBoundsError>()));
  });
}

class MockFooSource extends TypedMock implements FindableSource<Foo>{}
class MockFuzzyAlgo extends TypedMock implements FuzzyAlgorithm{}

class Foo implements Findable {
  final List<Term> _terms;
  List<Term> get terms => _terms;
  Foo(this._terms);
}