import 'package:grinder/grinder.dart';
import 'dart:io';

void main([List<String> args]) {
  task('init', init);
  task('analyze', analyze, ['init']);
  task('tests', tests, ['analyze']);

  startGrinder(args);
}

void init(GrinderContext context) {
  Pub.get(context);
}

void analyze(GrinderContext context) {
  Analyzer.analyzePaths(context,
      ['web/client.dart']);
}

void tests(GrinderContext context) {
  Tests.runCliTests(context);
}
