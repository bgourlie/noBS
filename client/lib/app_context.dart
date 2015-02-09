library app_context;

import 'dart:async';
import 'package:di/di.dart';
import 'package:logging/logging.dart';
import 'package:client/fitlog_models.dart';
import 'package:client/src/services/nobs_storage/nobs_storage.dart';

@Injectable()
class AppContext {
  static final _logger = new Logger('app_context');
  final String defaultSection = 'record';
  final int STATE_LOADING = 0;
  final int STATE_CREATE_USER = 1;
  final int STATE_ENTRY = 2;

  final PersonRepository _personRepo;

  int state;

  AppContext(this._personRepo);

  Future<bool> navigate(String section) {
    final completer = new Completer<bool>();
    switch (section) {
      case 'manage_users':
        _changeState(STATE_CREATE_USER);
        return new Future(() => true);
      case 'record':
        _personRepo.count().then((int count) {
          if (count == 0) {
            _changeState(STATE_CREATE_USER);
          } else {
            state = STATE_ENTRY;
          }
          completer.complete(count > 0);
        });
        _changeState(STATE_ENTRY);
        break;
      default:
        completer.completeError('unexpected section $section');
    }

    return completer.future;
  }

  void _changeState(int newState) {
    if (state == newState) {
      _logger.finest('requested state change but was already $newState');
      return;
    }

    if (![STATE_LOADING, STATE_ENTRY, STATE_CREATE_USER].contains(newState)) {
      throw new ArgumentError('Invalid state.');
    }

    state = newState;
  }

  void onUserCreated(Person person) {
    _changeState(STATE_ENTRY);
  }
}
