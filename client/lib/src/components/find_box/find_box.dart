library find_box;

import 'dart:html';
import 'package:di/annotations.dart';
import 'package:angular/angular.dart';
import 'package:logging/logging.dart';
import 'package:rate_limit/rate_limit.dart';
import 'package:client/src/services/exercise_find_engine.dart';

typedef FindRequestHandler(String term, int onTermType);

@Injectable()
@Component(
    selector: 'find-box',
    templateUrl: 'packages/client/src/components/find_box/find_box.html',
    cssUrl: 'packages/client/src/components/find_box/find_box.css',
    map: const {
      'find-request-handler' : '&findRequestHandler'
    })
class FindBox implements ShadowRootAware {
  static final _logger = new Logger('nobs_find_box');
  final ExerciseFindEngine _findEngine;
  String term;
  bool optionsExpanded = false;
  Function findRequestHandler;

  FindBox(this._findEngine);
  void toggleOptions() {
   optionsExpanded = !optionsExpanded;
  }

  void onShadowRoot(ShadowRoot shadowRoot){
    shadowRoot.querySelector('#term').onKeyDown.transform(
        new Debouncer(const Duration(milliseconds: 250))).forEach(
            (KeyboardEvent e) {
              final handler = findRequestHandler();
              if(handler != null){
                handler(term, 0);
              }
    });
  }
}
