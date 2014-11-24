using FitLog.Domain.Model;
using FitLog.Domain.ServiceContracts;
using System.Collections.Generic;

namespace FitLog.Domain.ServiceImplementations
{
    public class FuzzyFinder<T> : IFuzzyFinder<T> where T : IFuzzyFindable
    {
        IEnumerable<FuzzyResult<T>> IFuzzyFinder<T>.Matches(IEnumerable<T> candidates, string input, int threshold)
        {
            foreach(var c in candidates)
            {
                yield return new FuzzyResult<T>(c, DamerauLevenshteinDistance(c.Term, input, threshold));
            }
            ////return from c in candidates
            ////   select new FuzzyResult<T>(c, DamerauLevenshteinDistance(c.Term, input, threshold));
        }

         private static int DamerauLevenshteinDistance(string string1, string string2, int threshold)
         {
            // Return trivial case - where they are equal
            if (string1.Equals(string2)) return 0;

            // Return trivial case - where one is empty
            if (string.IsNullOrEmpty(string1)) return (string2 ?? "").Length;
 
            if (string.IsNullOrEmpty(string2)) return 0;

            // Return trivial case - where string1 is contained within string2
            if (string2.Contains(string1)) return string2.Length - string1.Length;

            // REVERSE CASE: STRING2 IS CONTAINED WITHIN STRING1
            if (string1.Contains(string2)) return 0;

            var length1 = string1.Length;
            var length2 = string2.Length;

            var d = new int[2, length2 + 1];

            // 
            for (var i = 0; i <= d.GetUpperBound(0); i++)
            {
                d[i, 0] = i;
            }

            // But you must initiate the first element of each row with 0:
            for (var i = 0; i <= 2; i++)
            {
                d[i, 0] = 0;
            }

            // This initialization counts insertions. You need it, but for
            // better consistency of code I call the variable j (not i):
            for (var j = 0; j <= d.GetUpperBound(1); j++)
            {
                d[0, j] = j;
            }

            // Now do the job:
            // for (var i = 1; i <= d.GetUpperBound(0); i++)
            for (var i = 1; i <= length1; i++)
            {
                //Here in this for-loop: add "%3" to evey term 
                // that is used as first index of d!
                var im1 = i - 1;
                var im2 = i - 2;
                var minDistance = threshold;
                for (var j = 1; j <= d.GetUpperBound(1); j++)
                {
                    var jm1 = j - 1;
                    var jm2 = j - 2;
                    var cost = string1[im1] == string2[jm1] ? 0 : 1;

                    // DON'T COUNT DELETIONS!  
                    var del = d[im1, j] + 1;
                    var ins = d[i % 3, jm1] + 1;
                    var sub = d[im1 % 3, jm1] + cost;

                    d[i, j] = del <= ins && del <= sub ? del : ins <= sub ? ins : sub;
                    d[i % 3, j] = ins <= sub ? ins : sub;

                    if (i > 1 && j > 1 && string1[im1] == string2[jm2] && string1[im2] == string2[jm1])
                    {
                        var c1 = d[i % 3, j];
                        var c2 = d[im2 % 3, jm2] + cost;
                        // Math.Min not in CoreCLR, use ternary instead.
                        d[i % 3, j] = c1 <= c2 ? c1 : c2;
                    }

                    if (d[i % 3, j] < minDistance)
                    {
                        minDistance = d[i % 3, j];
                    }
                }

                if (minDistance > threshold) return int.MaxValue;
            }

            return d[length1 % 3, d.GetUpperBound(1)] > threshold
                ? int.MaxValue
                : d[length1 % 3, d.GetUpperBound(1)];
        }
    }
}