library record_widget;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:di/annotations.dart';
import 'package:logging/logging.dart';

@Injectable()
@Component(selector: 'record-widget',
templateUrl: 'packages/client/src/components/record_widget/record_widget.html',
cssUrl: 'packages/client/src/components/record_widget/record_widget.css',
map: const {'on-back': '&goBackHandler'})
class RecordWidget implements ShadowRootAware {
  static final _logger = new Logger('record_widget');
  Function goBackHandler;
  num weight;
  num reps;

  void onShadowRoot(ShadowRoot root) {
    root.querySelector('#go-back').onClick.listen((e){
      if(goBackHandler != null){
        goBackHandler();
      }
    });
  }
}

