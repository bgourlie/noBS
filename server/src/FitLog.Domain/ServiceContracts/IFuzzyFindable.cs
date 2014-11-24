using System;

namespace FitLog.Domain.ServiceContracts
{
    public interface IFuzzyFindable
    {
        string Term { get; }
    }
}