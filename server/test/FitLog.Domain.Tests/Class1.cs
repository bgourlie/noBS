using FitLog.Domain.Model;
using FitLog.Domain.ServiceImplementations;
using Xunit;

namespace FitLog.Domain.Tests
{
    public class Class1
    {
        public Class1()
        {
        }

        [Fact]
        public void True_is_true()
        {
            // Arrange
            var fuzzyFinder = new FuzzyFinder<Exercise>();
            Assert.True(true);
        }
    }
}
