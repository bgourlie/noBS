library find_result;

import 'package:di/annotations.dart';
import 'package:angular/angular.dart';
import 'package:client/fitlog_models.dart';
import 'package:client/src/services/find_engine/find_engine.dart' as fe;

@Injectable()
@Component(selector: '[find-result]',
templateUrl: 'packages/client/src/components/find_result/find_result.html',
cssUrl: 'packages/client/src/components/find_result/find_result.css',
map: const {
    'find-result' : '=>!findResult',
})
class FindResult {
  Exercise _exercise;
  List<String> _tags;

  fe.FindResult<Exercise> findResult;

  Exercise get exercise {
    if(_exercise == null){
      _exercise = findResult.item;
    }
    return _exercise;
  }

  List<String> get tags {
    if(_tags == null){
      _tags = exercise.terms
          .where((fe.Term t) => t.termType == fe.Term.TYPE_TAG)
          .map((t) => t.term).toList();
    }

    return _tags;
  }
}
