library entry_screen;

import 'package:angular/angular.dart';
import 'package:di/annotations.dart';

@Injectable()
@Component(
    selector: 'entry-screen',
    templateUrl: 'packages/client/src/components/entry_screen/entry_screen.html',
    cssUrl: 'packages/client/src/components/entry_screen/entry_screen.css')
class EntryScreen {
    static final _logger = new Logger('nobs_entry_screen');

    String test = 'Hello from no bullshit exercise log!';
}
