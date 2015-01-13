library default_matcher_tests;

import 'package:unittest/unittest.dart';
import 'package:typed_mock/typed_mock.dart';
import 'package:client/src/services/find_engine/find_engine.dart';
import 'package:client/src/services/find_engine_defaults/find_engine_defaults.dart';

main(){
  test('should rank exact-name-match above exact-tag-match', (){
    final tb = new _TestBed();
    final matcher = tb.newMatcher();
    final nameTerm = new Term('test', Term.TYPE_NAME);
    final tagTerm = new Term('test', Term.TYPE_TAG);
    final nameResult = matcher.getMatch(nameTerm, 'test');
    final tagResult = matcher.getMatch(tagTerm, 'test');
    expect(nameResult.rank, lessThan(tagResult.rank));
  });

  test('should rank exact-tag-match above start-with-name match', (){
    final tb = new _TestBed();
    final matcher = tb.newMatcher();
    final nameTerm = new Term('testing', Term.TYPE_NAME);
    final tagTerm = new Term('test', Term.TYPE_TAG);
    final nameResult = matcher.getMatch(nameTerm, 'test');
    final tagResult = matcher.getMatch(tagTerm, 'test');
    expect(tagResult.rank, lessThan(nameResult.rank));
  });

  test('should rank starts-with-name match above start-with-tag match', (){
    final tb = new _TestBed();
    final matcher = tb.newMatcher();
    final nameTerm = new Term('testing', Term.TYPE_NAME);
    final tagTerm = new Term('testing', Term.TYPE_TAG);
    final nameResult = matcher.getMatch(nameTerm, 'test');
    final tagResult = matcher.getMatch(tagTerm, 'test');
    expect(nameResult.rank, lessThan(tagResult.rank));
  });

  test('should rank starts-with-tag match above contains-name match', (){
    final tb = new _TestBed();
    final matcher = tb.newMatcher();
    final nameTerm = new Term('some testing', Term.TYPE_NAME);
    final tagTerm = new Term('testing', Term.TYPE_TAG);
    final nameResult = matcher.getMatch(nameTerm, 'test');
    final tagResult = matcher.getMatch(tagTerm, 'test');
    expect(tagResult.rank, lessThan(nameResult.rank));
  });

  test('should rank contains-name match above contains-tag match', (){
    final tb = new _TestBed();
    final matcher = tb.newMatcher();
    final nameTerm = new Term('some testing', Term.TYPE_NAME);
    final tagTerm = new Term('some testing', Term.TYPE_TAG);
    final nameResult = matcher.getMatch(nameTerm, 'test');
    final tagResult = matcher.getMatch(tagTerm, 'test');
    expect(nameResult.rank, lessThan(tagResult.rank));
  });

  test('should rank contains-tag match above name-like match', (){
    final tb = new _TestBed();
    when(tb.fuzzyAlgo.distance(anyString, anyString, anyInt)).thenReturn(1);
    final matcher = tb.newMatcher();
    final nameTerm = new Term('this is a tset', Term.TYPE_NAME);
    final tagTerm = new Term('this is a test', Term.TYPE_TAG);
    final nameResult = matcher.getMatch(nameTerm, 'test');
    final tagResult = matcher.getMatch(tagTerm, 'test');
    expect(tagResult.rank, lessThan(nameResult.rank));
  });

  test('should rank contains-name match on shorter term higher than ' +
      'contains-name match on longer term', (){
    final tb = new _TestBed();
    final matcher = tb.newMatcher();
    final nameTerm = new Term('this is a test', Term.TYPE_NAME);
    final tagTerm = new Term('this is a testability thing', Term.TYPE_NAME);
    final shortResult = matcher.getMatch(nameTerm, 'test');
    final longResult = matcher.getMatch(tagTerm, 'test');
    expect(shortResult.rank, equals(longResult.rank));
    expect(shortResult.subRank, lessThan(longResult.subRank));
  });

  test('should rank contains-tag match on shorter term higher than ' +
  'contains-tag match on longer term', (){
    final tb = new _TestBed();
    final matcher = tb.newMatcher();
    final nameTerm = new Term('this is a test', Term.TYPE_TAG);
    final tagTerm = new Term('this is a testability thing', Term.TYPE_TAG);
    final shortResult = matcher.getMatch(nameTerm, 'test');
    final longResult = matcher.getMatch(tagTerm, 'test');
    expect(shortResult.rank, equals(longResult.rank));
    expect(shortResult.subRank, lessThan(longResult.subRank));
  });

  test('should return unranked match if fuzzy distance exceeds threshold', (){
    final tb = new _TestBed();
    when(tb.fuzzyAlgo.distance(anyString, anyString, anyInt))
        .thenReturn(DefaultMatcher.FUZZY_THRESHOLD + 1);
    final matcher = tb.newMatcher();
    final nameTerm = new Term('this is a tset', Term.TYPE_NAME);
    final result = matcher.getMatch(nameTerm, 'test');
    expect(result.rank, equals(FindEngineMatch.UNRANKED));
  });

  test('should be case insensitive', (){
    final tb = new _TestBed();
    when(tb.fuzzyAlgo.distance(anyString, anyString, anyInt))
        .thenReturn(DefaultMatcher.FUZZY_THRESHOLD + 1);
    final matcher = tb.newMatcher();
    final nameTerm = new Term('THIS IS A TEST', Term.TYPE_NAME);
    final result = matcher.getMatch(nameTerm, 'this is a test');
    expect(result.rank, lessThan(FindEngineMatch.UNRANKED));
  });

  test('should return the expected matchedFragment', (){
    final tb = new _TestBed();
    final matcher = tb.newMatcher();
    final nameTerm = new Term('THIS IS A TEST', Term.TYPE_NAME);
    final result = matcher.getMatch(nameTerm, 'this is a test');
    expect(result.rank, lessThan(FindEngineMatch.UNRANKED));
  });
}

class SpaceTermSplitter implements TermSplitter{
  splitTerm(Term term) => term.term.split(' ');
}

class MockFuzzyAlgo extends TypedMock implements FuzzyAlgorithm{}

class _TestBed{
  final termSplitter = new SpaceTermSplitter();
  final fuzzyAlgo = new MockFuzzyAlgo();

  DefaultMatcher newMatcher() => new DefaultMatcher(fuzzyAlgo, termSplitter);
}
