using System;

namespace FitLog.Domain.ServiceContracts
{
    public interface IFuzzyFinder<T> where T : IFuzzyFindable
    {
    }
}