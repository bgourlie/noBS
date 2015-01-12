part of storage_engine;

abstract class Repository<T extends Storable> {
  final Database _db;

  Repository(this._db);

  String get storeName;
  Map<String, Object> serialize(T storable);
  T deserialize(int key, Map value);

  Future<Optional<T>> get(int key){
    final completer = new Completer<Optional<T>>();
    final tx = _db.transaction(storeName, 'readonly');
    final index = tx.objectStore(storeName);
    index.getObject(key).then((Object result){
      if(result == null){
        completer.complete(new Optional.absent());
      } else {
        final ret = deserialize(key, result);
        completer.complete(new Optional.of(ret));
      }
    }, onError: (e) => completer.completeError(e));
    return completer.future;
  }

  Future put(T storable){
    final completer = new Completer();
    final tx = _db.transaction(storeName, 'readwrite');
    final objectStore = tx.objectStore(storeName);
    _logger.finest('adding object to store...');
    objectStore.add(serialize(storable)).then((addedKey) {
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
    final tx = _db.transaction(storeName, 'readonly');
    final objectStore = tx.objectStore(storeName)
        .openCursor(autoAdvance: true).listen((cursor){
      final obj = deserialize(cursor.key, cursor.value);
      controller.add(obj);
    }, onDone: () => controller.close(),
        onError: (e, stacktrace) => controller.addError(e, stacktrace));

    return controller.stream;
  }
}