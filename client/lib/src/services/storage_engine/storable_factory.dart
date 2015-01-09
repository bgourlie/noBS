part of storage_engine;

abstract class StorableFactory<T extends Storable> {
  String get storeName;
  T fromStorage(int key, Map value);
}