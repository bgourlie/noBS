// The contents of this file are subject to the Common Public Attribution
// License Version 1.0. (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// https://raw.githubusercontent.com/bgourlie/noBS/master/LICENSE.
// The License is based on the Mozilla Public License Version 1.1, but Sections
// 14 and 15 have been added to cover use of software over a computer network
// and provide for limited attribution for the Original Developer. In addition,
// Exhibit A has been modified to be consistent with Exhibit B.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
// the specific language governing rights and limitations under the License.
//
// The Original Code is noBS Exercise Logger.
//
// The Original Developer is the Initial Developer.  The Initial Developer of
// the Original Code is W. Brian Gourlie.
//
// All portions of the code written by W. Brian Gourlie are Copyright (c)
// 2014-2015 W. Brian Gourlie. All Rights Reserved.

library relative_time;

import 'package:angular/angular.dart';
import 'package:di/annotations.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

@Injectable()
@Formatter(name: 'relativeTime')
class RelativeTime {
  static final _logger = new Logger('relative_time_filter');
  static final DateFormat timeOnlyFormat = new DateFormat('h:mm a');
  static final DateFormat pastWeekFormat = new DateFormat('EEE h:mm a');
  static final DateFormat dateOnlyFormat = new DateFormat('M/d/y');

  call(time) {
    if (time is String) {
      _logger.finest('time is string, parsing \'$time\'');
      time = DateTime.parse(time);
    }

    assert(time.isUtc);

    final diff = new DateTime.now().toUtc().difference(time);

    if (diff.inMinutes <= 59) {
      return Intl.plural(diff.inMinutes,
          zero: 'just now',
          one: '1 minute ago',
          other: '${diff.inMinutes} minutes ago');
    }

    if (diff.inHours <= 23) {
      return Intl.plural(diff.inHours,
          one: 'an hour ago', other: '${diff.inHours} hours ago');
    }

    if (diff.inDays == 1) {
      return 'yesterday at ${timeOnlyFormat.format(time.toLocal())}';
    }

    if (diff.inDays < 7) {
      return pastWeekFormat.format(time.toLocal());
    }

    return dateOnlyFormat.format(time.toLocal());
  }
}
