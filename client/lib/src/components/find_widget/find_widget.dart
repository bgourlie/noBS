library find_widget;

import 'package:angular/angular.dart';
import 'package:di/annotations.dart';
import 'package:logging/logging.dart';
import 'package:client/fitlog_models.dart';
import 'package:client/src/services/find_engine/find_engine.dart';
import 'package:client/src/services/exercise_find_engine.dart';

@Injectable()
@Component(selector: 'find-widget',
    templateUrl: 'packages/client/src/components/find_widget/find_widget.html',
    cssUrl: 'packages/client/src/components/find_widget/find_widget.css')
class FindWidget {
    static final _logger = new Logger('find_widget');
    final ExerciseFindEngine _findEngine;
    final findResults = new List<FindResult<Exercise>>();
    String searchTerm;

    FindWidget(this._findEngine);

    void onFindRequest(String term, int onTermType){
        this.searchTerm = term;
        if(this.searchTerm.length == 0){
            findResults.clear();
        }else{
            _logger.finest('Handling find request for "$term"');
            findResults.clear();
            _findEngine.streamResults(term).listen((FindResult<Exercise> e){
                findResults.add(e);
            });
        }
    }
}