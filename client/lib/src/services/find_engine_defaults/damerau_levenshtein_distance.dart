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

part of find_engine_defaults;

@Injectable()
class DamerauLevenshteinDistance implements FuzzyAlgorithm {
  int get maxThreshold => 255;

  int distance(String source, String target, int threshold) {
    if (threshold > maxThreshold) {
      threshold = maxThreshold;
    }

    // normalization -- source should always be shorter than/equal in length to
    // target
    if (source.length > target.length) {
      final tmp = target;
      target = source;
      source = tmp;
    }

    final length1 = source.length;
    final length2 = target.length;
    if (length2 - length1 > threshold) {
      return maxThreshold;
    }

    final maxi = length1;
    final maxj = length2;

    var dCurrent = new Uint8ClampedList(maxi + 1);
    var dMinus1 = new Uint8ClampedList(maxi + 1);
    var dMinus2 = new Uint8ClampedList(maxi + 1);
    Uint8ClampedList dSwap;

    for (int i = 0; i < maxi; i++) {
      dCurrent[i] = i;
    }

    int jm1 = 0,
        im1 = 0,
        im2 = -1;
    for (int j = 1; j <= maxj; j++) {
      // rotate
      dSwap = dMinus2;
      dMinus2 = dMinus1;
      dMinus1 = dCurrent;
      dCurrent = dSwap;

      // initialize
      int minDistance = maxThreshold;
      dCurrent[0] = j;
      im1 = 0;
      im2 = -1;

      for (int i = 1; i <= maxi; i++) {
        int cost = source[im1] == target[jm1] ? 0 : 1;
        int del = dCurrent[im1] + 1;
        int ins = dMinus1[i] + 1;
        int sub = dMinus1[im1] + cost;
        int min =
            (del > ins) ? (ins > sub ? sub : ins) : (del > sub ? sub : del);

        if (i > 1 &&
            j > 1 &&
            source[im2] == target[jm1] &&
            source[im1] == target[j - 2]) {
          final possMin = dMinus2[im2] + cost;
          min = min < possMin ? min : possMin;
        }

        dCurrent[i] = min;
        if (min < minDistance) {
          minDistance = min;
        }

        im1++;
        im2++;
      }

      jm1++;
      if (minDistance > threshold) {
        return maxThreshold;
      }
    }

    int result = dCurrent[maxi];
    return (result > threshold) ? maxThreshold : result;
  }
}
