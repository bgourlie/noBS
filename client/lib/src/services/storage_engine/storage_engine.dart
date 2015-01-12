library storage_engine;

import 'dart:html';
import 'dart:async';
import 'dart:indexed_db';
import 'package:logging/logging.dart';
import 'package:quiver/core.dart';

part 'bootstrapper.dart';
part 'storable.dart';
part 'db_config.dart';
part 'repository.dart';

final _logger = new Logger('storage_engine');
