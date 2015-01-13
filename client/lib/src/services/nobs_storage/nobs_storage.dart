library nobs_storage;

import 'dart:async';
import 'dart:indexed_db';
import 'package:di/di.dart';
import 'package:di/annotations.dart';
import 'package:logging/logging.dart';
import 'package:client/fitlog_models.dart';
import 'package:client/src/services/storage_engine/storage_engine.dart';

part 'nobs_db_v1_config.dart';
part 'exercise_repository.dart';

final _logger = new Logger('nobs_storage');

const EXERCISE_STORE_NAME = 'exercises';
const SETS_STORE_NAME = 'sets';

class NobsStorageModule extends Module {
  NobsStorageModule(){
    bind(ExerciseRepository);
  }
}
