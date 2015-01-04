library storage_engine;

import 'dart:html';
import 'dart:async';
import 'dart:indexed_db';
import 'package:logging/logging.dart';

part 'storage_service.dart';
part 'store.dart';

final _logger = new Logger('storage_engine');
