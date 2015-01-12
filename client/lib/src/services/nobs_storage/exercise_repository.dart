part of nobs_storage;

@Injectable()
class ExerciseRepository extends Repository<Exercise> {
  String get storeName => EXERCISE_STORE_NAME;

  ExerciseRepository(Database db) : super(db);

  Exercise deserialize(int key, Map obj) {
    final e = new Exercise(obj['title'], obj['synonyms'], obj['tags']);
    e.dbKey = key;
    return e;
  }

  Map serialize(Exercise obj) {
    return {'title' : obj.title, 'synonyms' : obj.synonyms, 'tags' : obj.tags };
  }
}