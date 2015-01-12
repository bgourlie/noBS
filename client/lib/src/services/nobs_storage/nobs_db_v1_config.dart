part of nobs_storage;

class NobsDbV1Config implements DbConfig {
  String get dbName => 'nobs';
  int get version => 1;

  void upgrade(Database db, Transaction tx, int version){
    db.createObjectStore('sets', autoIncrement: true);
    db.createObjectStore(EXERCISE_STORE_NAME, autoIncrement: true);
    _seed(db);
  }

  void _seed(Database db)  {
    _logger.finest('seeding database');
    final exerciseRepo = new ExerciseRepository(db);
    exerciseRepo.put(new Exercise('Stiff-legged Deadlift',
        ['romanian deadlift', 'sldl'], ['back', 'hamstrings']));
    exerciseRepo.put(new Exercise('Deadlift', ['dl'], ['back', 'hamstrings']));
    exerciseRepo.put(new Exercise('Benchpress', ['bp'], ['chest', 'pecs']));
    exerciseRepo.put(new Exercise('Preacher Curl', [], ['biceps']));
    exerciseRepo.put(new Exercise('Hammer Curl', [], ['biceps', 'forearms']));
    exerciseRepo.put(new Exercise('Squat', ['Back Squat'],
        ['legs', 'quads', 'glutes', 'back']));
    exerciseRepo.put(new Exercise('Bent-knee Good Morning', ['good morning'],
        ['glutes']));
    exerciseRepo.put(new Exercise('Front Squat', [], ['legs', 'quads']));
    exerciseRepo.put(new Exercise('Military Press', ['overhead press'],
        ['shoulders', 'deltoids']));
    exerciseRepo.put(new Exercise('Lunge', [], ['legs']));
    exerciseRepo.put(new Exercise('Tricep Extension', ['skull crusher'],
        ['triceps']));
    exerciseRepo.put(new Exercise('Pull-Up', [], ['lats', 'back', 'biceps']));
    exerciseRepo.put(new Exercise('Bentover Row', [], ['back', 'lats']));
    exerciseRepo.put(new Exercise('Incline Row', [], ['back', 'lats']));
    exerciseRepo.put(new Exercise('Lat Pulldown', [], ['back', 'lats']));
    exerciseRepo.put(new Exercise('Shrug', [], ['traps']));
    exerciseRepo.put(new Exercise('Close-Grip Benchpress', ['cgbp'],
        ['triceps', 'chest']));
    exerciseRepo.put(new Exercise('Pullover', [], ['chest']));
    exerciseRepo.put(new Exercise('Decline Benchpress', [], ['chest']));
    exerciseRepo.put(new Exercise('Incline Benchpress', [], ['chest']));
    exerciseRepo.put(new Exercise('Pushup', [], ['chest']));
    exerciseRepo.put(new Exercise('Dip', [], ['chest']));
    exerciseRepo.put(new Exercise('Arnold Press', [], ['shoulders']));
    exerciseRepo.put(new Exercise('Front raise', [], ['shoulders']));
    exerciseRepo.put(new Exercise('Lateral raise', [], ['shoulders']));
    exerciseRepo.put(new Exercise('Behind neck press', [], ['shoulders']));
    exerciseRepo.put(new Exercise('Rear deltoid raise', [], ['shoulders']));
    exerciseRepo.put(new Exercise('Box jumps', [], ['plyometric']));
  }
}
