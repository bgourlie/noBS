library muscle_man;

import 'package:angular/angular.dart';
import 'package:di/annotations.dart';

@Injectable()
@Component(
    selector: 'muscle-man',
    templateUrl: 'packages/client/src/components/muscle_man/muscle_man.html',
    useShadowDom: false)
class MuscleMan {}
