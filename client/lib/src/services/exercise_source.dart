library exercise_source;

import 'dart:async';
import 'package:di/annotations.dart';
import 'package:client/fitlog_models.dart';
import 'package:client/src/services/find_engine/find_engine.dart';
import 'package:client/src/services/nobs_storage/nobs_storage.dart';

@Injectable()
class ExerciseSource implements FindableSource<Exercise> {
  final ExerciseRepository _exerciseRepo;
  ExerciseSource(this._exerciseRepo);

  Stream<Exercise> getStream() => _exerciseRepo.getAll();
}
