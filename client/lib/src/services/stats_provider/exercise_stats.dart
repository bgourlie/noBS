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

part of stats_provider;

class ExerciseStats {
  final int exerciseId;
  final int personId;
  final int totalSets;
  final num totalWeightLifted;
  final num totalReps;
  final ExerciseSet bestWeight;
  final ExerciseSet bestReps;
  final ExerciseSet bestCombined;

  ExerciseStats(this.exerciseId, this.personId, this.totalSets,
      this.totalWeightLifted, this.totalReps, this.bestWeight, this.bestReps,
      this.bestCombined);
}
