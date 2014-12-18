part of find_engine_defaults;


@Injectable()
class  DamerauLevenshteinDistance implements FuzzyAlgorithm {
  int get maxThreshold => 255;


  int distance(String source, String target, int threshold){

    if(threshold > maxThreshold){
      threshold = maxThreshold;
    }

    // normalization -- source should always be shorter than/equal in length to
    // target
    if(source.length > target.length){
      final tmp = target;
      target = source;
      source = tmp;
    }

    final length1 = source.length;
    final length2 = target.length;
    if(length2 - length1 > threshold){
      return maxThreshold;
    }

    final maxi = length1;
    final maxj = length2;

    var dCurrent = new Uint8ClampedList(maxi + 1);
    var dMinus1 = new Uint8ClampedList(maxi + 1);
    var dMinus2 = new Uint8ClampedList(maxi + 1);
    Uint8ClampedList dSwap;

    for(int i = 0; i < maxi; i++){
      dCurrent[i] = i;
    }

    int jm1 = 0, im1 = 0, im2 = -1;
    for(int j = 1; j <= maxj; j++){
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

      for(int i = 1; i <= maxi; i++){
        int cost = source[im1] == target[jm1] ? 0 : 1;
        int del = dCurrent[im1] + 1;
        int ins = dMinus1[i] + 1;
        int sub = dMinus1[im1] + cost;
        int min = (del > ins) ? (ins > sub ? sub : ins)
            : (del > sub ? sub : del);

        if(i > 1 && j > 1 && source[im2] == target[jm1]
            && source[im1] == target[j - 2]){
          final possMin = dMinus2[im2] + cost;
          min = min < possMin ? min : possMin;
        }

        dCurrent[i] = min;
        if(min < minDistance){
          minDistance = min;
        }

        im1++;
        im2++;
      }

      jm1++;
      if(minDistance > threshold){
        return maxThreshold;
      }
    }

    int result = dCurrent[maxi];
    return (result > threshold) ? maxThreshold : result;
  }
}