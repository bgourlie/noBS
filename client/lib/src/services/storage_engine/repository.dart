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

abstract class Repository<T extends Storable> {
  final Database _db;
  final Serializer<T> _serializer;

  Repository(this._db, this._serializer);

  String get storeName;

  Future<Optional<T>> get(int key) {
    final completer = new Completer<Optional<T>>();
    final tx = _db.transaction(storeName, 'readonly');
    final index = tx.objectStore(storeName);
    index.getObject(key).then((Object result) {
      if (result == null) {
        completer.complete(new Optional.absent());
      } else {
        final ret = _serializer.deserialize(key, result);
        completer.complete(new Optional.of(ret));
      }
    }, onError: (e) => completer.completeError(e));
    return completer.future;
  }

  Future put(T storable) {
    final completer = new Completer();
    final tx = _db.transaction(storeName, 'readwrite');
    final objectStore = tx.objectStore(storeName);
    _logger.finest('adding object to store...');
    objectStore.add(_serializer.serialize(storable)).then((addedKey) {
      _logger.finest('object added to store with key=$addedKey');
      storable.dbKey = addedKey;
    }, onError: (e) => completer.completeError(e));

    tx.completed.then((_) {
      _logger.finest('transaction complete.');
      completer.complete();
    });
    return completer.future;
  }

  Future putAll(List<T> storables, [Transaction tx]) {
    if (tx == null) {
      tx = _db.transaction(storeName, 'readwrite');
    }

    final objectStore = tx.objectStore(storeName);

    storables.forEach((Storable s) =>
        objectStore.add(_serializer.serialize(s)).then((key) => s.dbKey = key));

    return tx.completed.then((_) {
      _logger.finest('putMany transaction completed.');
    });
  }

  Stream<T> getAll() {
    final controller = new StreamController<T>();
    final tx = _db.transaction(storeName, 'readonly');
    final objectStore = tx
        .objectStore(storeName)
        .openCursor(autoAdvance: true)
        .listen((cursor) {
      final obj = _serializer.deserialize(cursor.key, cursor.value);
      controller.add(obj);
    },
        onDone: () => controller.close(),
        onError: (e, stacktrace) => controller.addError(e, stacktrace));

    return controller.stream;
  }
}
