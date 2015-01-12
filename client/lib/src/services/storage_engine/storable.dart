part of storage_engine;

abstract class Storable {
  int get dbKey;
  set dbKey (int val);
}