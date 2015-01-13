import 'dart:async';
import 'package:unittest/unittest.dart';
import 'package:client/src/services/find_engine/find_engine.dart';
import 'package:typed_mock/typed_mock.dart';

main() {

  test('should include all results that are not unranked', (){
    // Arrange
    final tb = new _TestBed();
    final result1 = new Foo([new Term('one', Term.TYPE_NAME)]);
    final result2 = new Foo([new Term('two', Term.TYPE_NAME)]);
    final result3 = new Foo([new Term('three', Term.TYPE_NAME)]);

    when(tb.matcher.getMatch(anyObject, anyString))
        .thenReturn(new FindEngineMatch(0, 0, 'test'));

    when(tb.fooSource.getStream()).thenReturn(
        new Stream.fromIterable([result1, result2, result3]));

    final findEngine = tb.newFindEngine();

    // Act
    final resultStream = findEngine.streamResults('arbitrary');

    // Assert
    expect(resultStream.toList().then((List<FindResult<Foo>> l) {
          expect(l, hasLength(3));
          final blah = l.every((r) => ['one', 'two', 'three']
              .contains(r.matchedTerm.term));
          expect(l.every((r) => ['one', 'two', 'three']
              .contains(r.matchedTerm.term)), isTrue);
        }), completes);
  });

  // TODO: enable test once resolved:
  // https://code.google.com/p/dart/issues/detail?id=21945&thanks=21945&ts=1419211844
//  test('should not return unranked results', (){
//    // Arrange
//    final tb = new _TestBed();
//
//    final result1 = new Foo([new Term('one', Term.TYPE_NAME)]);
//    final result2 = new Foo([new Term('two', Term.TYPE_NAME)]);
//    final result3 = new Foo([new Term('three', Term.TYPE_NAME)]);
//
//    when(tb.matcher.getMatch(equals(result1), anyString))
//        .thenReturn(new FindEngineMatch.unranked());
//
//    when(tb.matcher.getMatch(equals(result2), anyString))
//        .thenReturn(new FindEngineMatch(1, 1, 'two'));
//
//    when(tb.matcher.getMatch(equals(result3), anyString))
//        .thenReturn(new FindEngineMatch(1, 1, 'three'));
//
//    when(tb.fooSource.getStream()).thenReturn(
//        new Stream.fromIterable([result1, result2, result3]));
//
//    final findEngine = tb.newFindEngine();
//
//    // Act
//    final resultStream = findEngine.streamResults('arbitrary');
//
//    // Assert
//    expect(resultStream.toList().then((List<FindResult<Foo>> l) {
//      expect(l, hasLength(2));
//      expect(l.every((r) => ['two', 'three'].contains(r.matchedTerm.term)),
//          isTrue);
//    }), completes);
//  });


  // TODO: enable test once resolved:
  // https://code.google.com/p/dart/issues/detail?id=21945
//  test('should only return results having specified term type', (){
//    // Arrange
//    final tb = new _TestBed();
//
//    when(tb.matcher.getMatch(anyObject, anyString))
//        .thenReturn(new FindEngineMatch(0, 0, 'on'));
//
//    when(tb.fooSource.getStream()).thenReturn(
//        new Stream.fromIterable([
//            new Foo([new Term('one', Term.TYPE_NAME)]),
//            new Foo([new Term('on', Term.TYPE_NAME)]),
//            new Foo([new Term('one', Term.TYPE_TAG)])]));
//
//    final findEngine = tb.newFindEngine();
//
//    // Act
//    final resultStream = findEngine.streamResults('arbitrary',
//        matchOnTermType: Term.TYPE_NAME);
//
//    // Assert
//    expect(resultStream.toList().then((List<FindResult<Foo>> l) {
//      expect(l, hasLength(2));
//      expect(l.every((r) => ['one', 'on'].contains(r.matchedTerm.term)),
//          isTrue);
//    }), completes);
//  });

  test('should return results having all term types if none is specified', (){
    // Arrange
    final tb = new _TestBed();
    when(tb.matcher.getMatch(anyObject, anyString))
        .thenReturn(new FindEngineMatch(0, 0, 'test'));

    final findEngine = tb.newFindEngine();

    when(tb.fooSource.getStream()).thenReturn(
        new Stream.fromIterable([
            new Foo([new Term('one', Term.TYPE_NAME)]),
            new Foo([new Term('on', Term.TYPE_NAME)]),
            new Foo([new Term('ne', Term.TYPE_TAG)])]));

    // Act
    final resultStream = findEngine.streamResults('arbitrary');

    // Assert
    expect(resultStream.toList().then((List<FindResult<Foo>> l) {
      expect(l, hasLength(3));
      expect(l.every((r) => ['one', 'on', 'ne'].contains(r.matchedTerm.term)),
          isTrue);
    }), completes);
  });
}

class MockFooSource extends TypedMock implements FindableSource<Foo>{}
class MockMatcher extends TypedMock implements FindEngineMatcher{}

class Foo implements Findable {
  final List<Term> _terms;
  List<Term> get terms => _terms;
  Foo(this._terms);
}

class _TestBed {
  final fooSource = new MockFooSource();
  final matcher = new MockMatcher();

  FindEngine<Foo> newFindEngine() =>
      new FindEngine<Foo>(matcher, fooSource);
}