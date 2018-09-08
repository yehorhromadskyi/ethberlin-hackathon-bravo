using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Xunit;

namespace ContractTests
{
    public class DeployTests
    {
        Contract _contract;

        public DeployTests()
        {
            var currentDirectory = Environment.CurrentDirectory;
            while (!currentDirectory.EndsWith("bin"))
            {
                currentDirectory = Directory.GetParent(currentDirectory).FullName;
            }

            var abif = Directory.GetFiles(currentDirectory).First(f => f.EndsWith("DelayedExecutor.abi"));
            var binf = Directory.GetFiles(currentDirectory).First(f => f.Contains("DelayedExecutor.bin"));

            _contract = new Contract
            {
                Abi = File.ReadAllText(abif),
                Bytecode = File.ReadAllText(binf)
            };
        }

        [Fact]
        public void Contract_Compiles_Successfully()
        {
            Assert.NotNull(_contract.Abi);
            Assert.NotNull(_contract.Bytecode);
        }
    }
}
