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

part of storage_engine;

class Bootstrapper {
  final DbConfig _config;
  final Window _window;

  Bootstrapper(this._config, this._window) {
    if (this._config == null) {
      throw new ArgumentError.notNull('_store');
    }

    if (this._window == null) {
      throw new ArgumentError.notNull('_window');
    }
  }

  /// Get a database connection.  Create or upgrade if needed.
  Future<Database> getDatabase() {
    final completer = new Completer<Database>();
    Future upgradeFuture;
    _window.indexedDB
        .open(_config.dbName,
            version: _config.version, onUpgradeNeeded: (VersionChangeEvent e) {
      _logger.finest('db upgrade needed (${e.oldVersion} -> ${e.newVersion})');
      final req = (e.target as Request);
      final db = req.result;
      final tx = req.transaction;
      upgradeFuture = _config.upgrade(db, tx, e.oldVersion);
    }).then((db) {
      if (upgradeFuture != null) {
        upgradeFuture.then((_) {
          _logger.finest('upgrade complete!');
          completer.complete(db);
        });
      } else {
        completer.complete(db);
      }
    }, onError: (e) => completer.completeError(e));
    return completer.future;
  }
}
