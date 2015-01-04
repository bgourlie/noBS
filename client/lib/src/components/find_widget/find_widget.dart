library find_widget;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:di/annotations.dart';
import 'package:logging/logging.dart';
import 'package:rate_limit/rate_limit.dart';
import 'package:client/fitlog_models.dart';
import 'package:client/src/services/find_engine/find_engine.dart';
import 'package:client/src/services/exercise_find_engine.dart';

typedef SelectedHandler(Exercise exercise);

@Injectable()
@Component(selector: 'find-widget',
    templateUrl: 'packages/client/src/components/find_widget/find_widget.html',
    cssUrl: 'packages/client/src/components/find_widget/find_widget.css',
    map: const {
      'selected-handler' : '&selectedHandler'
    })
class FindWidget implements ShadowRootAware {
  static final _logger = new Logger('find_widget');
  final ExerciseFindEngine _findEngine;
  final findResults = new List<FindResult<Exercise>>();
  Function selectedHandler;
  String searchTerm;  // The searchTerm, updated as it's being typed
  String searchedTerm; // The term actually being searched

  FindWidget(this._findEngine);

  void onShadowRoot(ShadowRoot shadowRoot){
    shadowRoot.querySelector('#term').onKeyDown.transform(
        new Debouncer(const Duration(milliseconds: 250))).forEach(
            (e) => doSearch());
  }

  void doSearch(){
    if(this.searchTerm.length == 0){
      findResults.clear();
    }else{
      _logger.finest('Handling find request for "$searchTerm"');
      findResults.clear();
      _findEngine.streamResults(searchTerm)
          .listen((FindResult<Exercise> e){
            findResults.add(e);
          });
      }
    searchedTerm = searchTerm;
  }

  void handleSelect(Exercise e){
    if(selectedHandler != null){
      SelectedHandler handler = selectedHandler();
      handler(e);
    }

    findResults.clear();
    searchTerm = null;
  }
}