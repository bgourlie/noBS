part of storage_engine;

abstract class DbConfig {
  String get dbName;
  int get version;

  void upgrade(Database db, int oldVersion);
}
