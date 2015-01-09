part of storage_engine;

abstract class Store {
  String get dbName;
  int get version;

  void upgrade( Database db, int oldVersion);
}
