part of storage_engine;

class Bootstrapper {
  final DbConfig _config;
  final Window _window;

  Bootstrapper(this._config, this._window) {
    if(this._config == null) {
      throw new ArgumentError.notNull('_store');
    }

    if(this._window == null) {
      throw new ArgumentError.notNull('_window');
    }
  }

  /// Get a database connection.  Create or upgrade if needed.
  Future<Database> getDatabase() {
    final completer = new Completer<Database>();
    _window.indexedDB.open(_config.dbName, version: _config.version,
        onUpgradeNeeded: (VersionChangeEvent e)  {
          _logger.finest('db upgrade needed (${e.oldVersion} -> ${e.newVersion})');
          final req = (e.target as Request);
          final db = req.result;
          final tx = req.transaction;
          _config.upgrade(db, tx, e.oldVersion);
        }).then((db) {
          _logger.finest('returning new connection.');
          completer.complete(db);
    }, onError: (e) => completer.completeError(e));
    return completer.future;
  }
}
