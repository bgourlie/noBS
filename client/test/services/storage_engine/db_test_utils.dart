library db_test_utils;

import 'dart:async';
import 'dart:indexed_db';
import 'package:logging/logging.dart';

final _logger = new Logger('db_test_utils');

Future closeDb(Database db) {
  final completer = new Completer();
  db.close();
  new Timer(new Duration(milliseconds: 1), () {
    completer.complete();
  });
  return completer.future;
}
