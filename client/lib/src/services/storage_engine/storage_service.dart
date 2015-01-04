part of storage_engine;

class StorageService<T> {
  final Store _store;
  final Window _window;

  StorageService(this._store, this._window) {
    if(this._store == null) {
      throw new ArgumentError.notNull('_store');
    }

    if(this._window == null) {
      throw new ArgumentError.notNull('_window');
    }
  }

  Future<Database> open() {
    return _window.indexedDB.open(_store.dbName, version: _store.version,
        onUpgradeNeeded: (VersionChangeEvent e)  {
          _logger.finest('db upgrade needed (${e.oldVersion} -> ${e.newVersion})');
          _store.upgrade(e.oldVersion);
        });
  }
}

