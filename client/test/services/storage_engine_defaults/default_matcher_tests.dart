// The contents of this file are subject to the Common Public Attribution
// License Version 1.0. (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// https://raw.githubusercontent.com/bgourlie/noBS/master/LICENSE.
// The License is based on the Mozilla Public License Version 1.1, but Sections
// 14 and 15 have been added to cover use of software over a computer network
// and provide for limited attribution for the Original Developer. In addition,
// Exhibit A has been modified to be consistent with Exhibit B.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
// the specific language governing rights and limitations under the License.
//
// The Original Code is noBS Exercise Logger.
//
// The Original Developer is the Initial Developer.  The Initial Developer of
// the Original Code is W. Brian Gourlie.
//
// All portions of the code written by W. Brian Gourlie are Copyright (c)
// 2014-2015 W. Brian Gourlie. All Rights Reserved.

library default_matcher_tests;

import 'package:unittest/unittest.dart';
import 'package:typed_mock/typed_mock.dart';
import 'package:client/src/services/find_engine/find_engine.dart';
import 'package:client/src/services/find_engine_defaults/find_engine_defaults.dart';

main() {
  test('should rank exact-name-match above exact-tag-match', () {
    final tb = new _TestBed();
    final matcher = tb.newMatcher();
    final nameTerm = new Term('test', Term.TYPE_NAME);
    final tagTerm = new Term('test', Term.TYPE_TAG);
    final nameResult = matcher.getMatch(nameTerm, 'test');
    final tagResult = matcher.getMatch(tagTerm, 'test');
    expect(nameResult.rank, lessThan(tagResult.rank));
  });

  test('should rank exact-tag-match above start-with-name match', () {
    final tb = new _TestBed();
    final matcher = tb.newMatcher();
    final nameTerm = new Term('testing', Term.TYPE_NAME);
    final tagTerm = new Term('test', Term.TYPE_TAG);
    final nameResult = matcher.getMatch(nameTerm, 'test');
    final tagResult = matcher.getMatch(tagTerm, 'test');
    expect(tagResult.rank, lessThan(nameResult.rank));
  });

  test('should rank starts-with-name match above start-with-tag match', () {
    final tb = new _TestBed();
    final matcher = tb.newMatcher();
    final nameTerm = new Term('testing', Term.TYPE_NAME);
    final tagTerm = new Term('testing', Term.TYPE_TAG);
    final nameResult = matcher.getMatch(nameTerm, 'test');
    final tagResult = matcher.getMatch(tagTerm, 'test');
    expect(nameResult.rank, lessThan(tagResult.rank));
  });

  test('should rank starts-with-tag match above contains-name match', () {
    final tb = new _TestBed();
    final matcher = tb.newMatcher();
    final nameTerm = new Term('some testing', Term.TYPE_NAME);
    final tagTerm = new Term('testing', Term.TYPE_TAG);
    final nameResult = matcher.getMatch(nameTerm, 'test');
    final tagResult = matcher.getMatch(tagTerm, 'test');
    expect(tagResult.rank, lessThan(nameResult.rank));
  });

  test('should rank contains-name match above contains-tag match', () {
    final tb = new _TestBed();
    final matcher = tb.newMatcher();
    final nameTerm = new Term('some testing', Term.TYPE_NAME);
    final tagTerm = new Term('some testing', Term.TYPE_TAG);
    final nameResult = matcher.getMatch(nameTerm, 'test');
    final tagResult = matcher.getMatch(tagTerm, 'test');
    expect(nameResult.rank, lessThan(tagResult.rank));
  });

  test('should rank contains-tag match above name-like match', () {
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
      'contains-name match on longer term', () {
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
      'contains-tag match on longer term', () {
    final tb = new _TestBed();
    final matcher = tb.newMatcher();
    final nameTerm = new Term('this is a test', Term.TYPE_TAG);
    final tagTerm = new Term('this is a testability thing', Term.TYPE_TAG);
    final shortResult = matcher.getMatch(nameTerm, 'test');
    final longResult = matcher.getMatch(tagTerm, 'test');
    expect(shortResult.rank, equals(longResult.rank));
    expect(shortResult.subRank, lessThan(longResult.subRank));
  });

  test('should return unranked match if fuzzy distance exceeds threshold', () {
    final tb = new _TestBed();
    when(tb.fuzzyAlgo.distance(anyString, anyString, anyInt))
        .thenReturn(DefaultMatcher.FUZZY_THRESHOLD + 1);
    final matcher = tb.newMatcher();
    final nameTerm = new Term('this is a tset', Term.TYPE_NAME);
    final result = matcher.getMatch(nameTerm, 'test');
    expect(result.rank, equals(FindEngineMatch.UNRANKED));
  });

  test('should be case insensitive', () {
    final tb = new _TestBed();
    when(tb.fuzzyAlgo.distance(anyString, anyString, anyInt))
        .thenReturn(DefaultMatcher.FUZZY_THRESHOLD + 1);
    final matcher = tb.newMatcher();
    final nameTerm = new Term('THIS IS A TEST', Term.TYPE_NAME);
    final result = matcher.getMatch(nameTerm, 'this is a test');
    expect(result.rank, lessThan(FindEngineMatch.UNRANKED));
  });

  test('should return the expected matchedFragment', () {
    final tb = new _TestBed();
    final matcher = tb.newMatcher();
    final nameTerm = new Term('THIS IS A TEST', Term.TYPE_NAME);
    final result = matcher.getMatch(nameTerm, 'this is a test');
    expect(result.rank, lessThan(FindEngineMatch.UNRANKED));
  });
}

class SpaceTermSplitter implements TermSplitter {
  splitTerm(Term term) => term.term.split(' ');
}

class MockFuzzyAlgo extends TypedMock implements FuzzyAlgorithm {}

class _TestBed {
  final termSplitter = new SpaceTermSplitter();
  final fuzzyAlgo = new MockFuzzyAlgo();

  DefaultMatcher newMatcher() => new DefaultMatcher(fuzzyAlgo, termSplitter);
}
