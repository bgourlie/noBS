part of storage_engine;

class Repository<T extends Storable> {
  final Database _db;
  final StorableFactory<T> _storableFactory;

  Repository(this._db, this._storableFactory);

  Future<Optional<T>> get(int key){
    final completer = new Completer<Optional<T>>();
    final tx = _db.transaction(_storableFactory.storeName, 'readonly');
    final index = tx.objectStore(_storableFactory.storeName);
    index.getObject(key).then((Object result){
      if(result == null){
        completer.complete(new Optional.absent());
      } else {
        final ret = _storableFactory.fromStorage(key, result);
        completer.complete(new Optional.of(ret));
      }
    }, onError: (e) => completer.completeError(e));
    return completer.future;
  }

  Future put(T storable){
    final completer = new Completer();
    final tx = _db.transaction(_storableFactory.storeName, 'readwrite');
    final objectStore = tx.objectStore(_storableFactory.storeName);
    _logger.finest('adding object to store...');
    objectStore.add(storable.toStorage()).then((addedKey) {
      _logger.finest('object added to store with key=$addedKey');
      storable.dbKey = addedKey;
    }, onError: (e) => completer.completeError(e));

    tx.completed.then((_) {
      _logger.finest('transaction complete.');
      completer.complete();
    });
    return completer.future;
  }

  Stream<T> getAll(){
    final controller = new StreamController<T>();
    final tx = _db.transaction(_storableFactory.storeName, 'readonly');
    final objectStore = tx.objectStore(_storableFactory.storeName)
        .openCursor(autoAdvance: true).listen((cursor){
      final obj = _storableFactory.fromStorage(cursor.key, cursor.value);
      controller.add(obj);
    }, onDone: () => controller.close(),
        onError: (e, stacktrace) => controller.addError(e, stacktrace));

    return controller.stream;
  }
}