library exercise_find_engine;

import 'package:di/annotations.dart';
import 'package:client/fitlog_models.dart';
import 'package:client/src/services/find_engine/find_engine.dart';
import 'package:client/src/services/damerau_levenshtein_distance.dart';
import 'package:client/src/services/exercise_source.dart';

// TODO: track https://github.com/angular/di.dart/issues/129
// once fixed we may be able to inject the generic type directly
@Injectable()
class ExerciseFindEngine extends FindEngine<Exercise>{
    ExerciseFindEngine(DamerauLevenshteinDistance levenshtien, ExerciseSource source)
        : super(levenshtien, source);
}

