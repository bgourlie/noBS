library entry_screen;

import 'package:angular/angular.dart';
import 'package:di/annotations.dart';
import 'package:logging/logging.dart';
import 'package:client/fitlog_models.dart';

@Injectable()
@Component(
    selector: 'entry-screen',
    templateUrl: 'packages/client/src/components/entry_screen/entry_screen.html',
    cssUrl: 'packages/client/src/components/entry_screen/entry_screen.css')
class EntryScreen {
  static final _logger = new Logger('nobs_entry_screen');
  Exercise selectedExercise;

  void onExerciseSelected(Exercise e){
    _logger.finest('${e.title} selected');
    selectedExercise = e;
  }

  void cancelRecord(){
    _logger.finest('cancel record called.');
    selectedExercise = null;
  }
}
