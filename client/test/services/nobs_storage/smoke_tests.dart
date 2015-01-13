library nobs_storage_smoke_tests;

import 'dart:async';
import 'dart:html' as dom;
import 'dart:indexed_db';
import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:client/src/services/storage_engine/storage_engine.dart';
import 'package:client/src/services/nobs_storage/nobs_storage.dart';

const String DB_NAME = 'testDb';
const String TEST_STORE_NAME = 'foo';
final _logger = new Logger('integration_tests');

void main(){
  final config = new NobsDbV1Config();
  Database db;

  setUp((){
    final bootstrapper = new Bootstrapper(config, dom.window);
    return dom.window.indexedDB.deleteDatabase(config.dbName, onBlocked: (e) {
      _logger.finest('delete db blocked, but completing future anyway');
    }).then((_) {
      _logger.finest('db successfully deleted!');
      return bootstrapper.getDatabase().then((_db_) {
        _logger.finest('db opened.');
        db = _db_;
      });
    });
  });

  tearDown(() {
    if(db != null){
      db.close();
    }
  });

  test('should complete normally', (){

  });
}