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

import 'dart:html' as dom;
import 'package:logging/logging.dart';
import 'package:angular/application_factory.dart';
import 'package:client/fitlog_web_client.dart';
import 'package:client/fitlog_models.dart';
import 'package:client/src/services/storage_engine/storage_engine.dart'
    as storage;
import 'package:client/src/services/nobs_storage/nobs_storage.dart';
import 'package:client/app_context.dart';

const VERSION = 'alpha';
const BUILD_NUMBER = '1';
const BRANCH = '';
const COMMIT_ID = '';
const BUILD_TIME = '';

void main() {
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord
      .listen((LogRecord r) => print('[${r.loggerName}] ${r.message}'));
  final logger = new Logger('app_entrypoint');
  const appVersion =
      const AppVersion(VERSION, BUILD_NUMBER, BRANCH, COMMIT_ID, BUILD_TIME);
  final dbConfig = new NobsDbV1Config();
  final bootstrapper = new storage.Bootstrapper(dbConfig, dom.window);
  logger.finest('bootstrapping database...');
  bootstrapper.getDatabase().then((db) {
    logger.finest('got database, running app.');
    final clientModule = new ClientModule(appVersion, db);
    applicationFactory()
        .addModule(clientModule)
        .rootContextType(AppContext)
        .run();
  });

  // Factory reset is implemented in pure (non-angular) dart.
  // We do this because we need to be able to fix issues that
  // may prevent angular from bootstrapping.
  dom.querySelector('#factory-reset').onClick.listen((e) {
    var doDelete = dom.window.confirm(
        'Are you sure you to reset noBS?  All data stored locally will be lost.');
    if (doDelete) {
      dom.window.indexedDB.deleteDatabase('nobs');
      dom.window.location.reload();
    }
  });
}
