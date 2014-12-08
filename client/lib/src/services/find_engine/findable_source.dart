part of find_engine;

abstract class FindableSource<T extends Findable> {
  Stream<T> getStream();
}