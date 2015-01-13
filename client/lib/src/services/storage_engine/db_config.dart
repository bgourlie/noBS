part of storage_engine;

abstract class DbConfig {
  String get dbName;
  int get version;

 Future upgrade(Database db, Transaction tx, int oldVersion);
}
