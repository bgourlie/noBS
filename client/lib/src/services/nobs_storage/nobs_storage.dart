// The contents of this file are subject to the Common Public Attribution
// License Version 1.0. (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// https://raw.githubusercontent.com/bgourlie/noBS/master/LICENSE.
// The License is based on the Mozilla Public License Version 1.1, but Sections
// 14 and 15 have been added to cover use of software over a computer network
// and provide for limited attribution for the Original Developer. In addition,
// Exhibit A has been modified to be consistent with Exhibit B.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
// the specific language governing rights and limitations under the License.
//
// The Original Code is noBS Exercise Logger.
//
// The Original Developer is the Initial Developer.  The Initial Developer of
// the Original Code is W. Brian Gourlie.
//
// All portions of the code written by W. Brian Gourlie are Copyright (c)
// 2014-2015 W. Brian Gourlie. All Rights Reserved.

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
  NobsStorageModule() {
    bind(ExerciseRepository);
  }
}
