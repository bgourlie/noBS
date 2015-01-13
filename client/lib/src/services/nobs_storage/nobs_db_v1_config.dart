part of nobs_storage;

class NobsDbV1Config implements DbConfig {
  String get dbName => 'nobs';
  int get version => 1;

  Future upgrade(Database db, Transaction tx, int version){
    db.createObjectStore(SETS_STORE_NAME, autoIncrement: true);
    db.createObjectStore(EXERCISE_STORE_NAME, autoIncrement: true);
    return _seed(db, tx);
  }

  Future _seed(Database db, Transaction tx)  {
    _logger.finest('seeding database...');
    final exerciseRepo = new ExerciseRepository(db);
    final exercises = [
        new Exercise('Stiff-legged Deadlift',
            ['romanian deadlift', 'sldl'], ['back', 'hamstrings']),
        new Exercise('Deadlift', ['dl'], ['back', 'hamstrings']),
        new Exercise('Benchpress', ['bp'], ['chest', 'pecs']),
        new Exercise('Preacher Curl', [], ['biceps']),
        new Exercise('Hammer Curl', [], ['biceps', 'forearms']),
        new Exercise('Squat', ['Back Squat'],
            ['legs', 'quads', 'glutes', 'back']),
        new Exercise('Bent-knee Good Morning', ['good morning'],
            ['glutes']),
        new Exercise('Front Squat', [], ['legs', 'quads']),
        new Exercise('Military Press', ['overhead press'],
            ['shoulders', 'deltoids']),
        new Exercise('Lunge', [], ['legs']),
        new Exercise('Tricep Extension', ['skull crusher'],
            ['triceps']),
        new Exercise('Pull-Up', [], ['lats', 'back', 'biceps']),
        new Exercise('Bentover Row', [], ['back', 'lats']),
        new Exercise('Incline Row', [], ['back', 'lats']),
        new Exercise('Lat Pulldown', [], ['back', 'lats']),
        new Exercise('Shrug', [], ['traps']),
        new Exercise('Close-Grip Benchpress', ['cgbp'],
            ['triceps', 'chest']),
        new Exercise('Pullover', [], ['chest']),
        new Exercise('Decline Benchpress', [], ['chest']),
        new Exercise('Incline Benchpress', [], ['chest']),
        new Exercise('Pushup', [], ['chest']),
        new Exercise('Dip', [], ['chest']),
        new Exercise('Arnold Press', [], ['shoulders']),
        new Exercise('Front raise', [], ['shoulders']),
        new Exercise('Lateral raise', [], ['shoulders']),
        new Exercise('Behind neck press', [], ['shoulders']),
        new Exercise('Rear deltoid raise', [], ['shoulders']),
        new Exercise('Box jumps', [], ['plyometric'])
    ];

    return exerciseRepo.putAll(exercises, tx).then((_){
      _logger.finest('seeding complet!');
    });
  }
}
