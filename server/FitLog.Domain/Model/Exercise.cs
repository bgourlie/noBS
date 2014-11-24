using System;
using FitLog.Domain.ServiceContracts;

namespace FitLog.Domain.Model
{
    public class Exercise : IFuzzyFindable
    {
        public string Name { get; set; }

        string IFuzzyFindable.Term
        {
            get
            {
                return Name;
            }
        }
    }
}