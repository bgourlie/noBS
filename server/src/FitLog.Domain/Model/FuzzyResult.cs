using FitLog.Domain.ServiceContracts;

namespace FitLog.Domain.Model
{
    public class FuzzyResult<T> where T : IFuzzyFindable
    {
        public readonly T Result;
        public readonly int Confidence;

        public FuzzyResult(T result, int confidence)
        {
            this.Result = result;
            this.Confidence = confidence;
        }
    }
}