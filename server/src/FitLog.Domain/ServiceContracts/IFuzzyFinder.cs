using FitLog.Domain.Model;
using System.Collections.Generic;

namespace FitLog.Domain.ServiceContracts
{
    public interface IFuzzyFinder<T> where T : IFuzzyFindable
    {
        IEnumerable<FuzzyResult<T>> Matches(IEnumerable<T> candidates, string input, int minThreshold);
    }
}