using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Xunit;
using Nethereum.Geth;
using Nethereum.Hex.HexTypes;
using Nethereum.RPC.Eth.DTOs;
using Nethereum.Web3.Accounts.Managed;
using Nethereum.ABI;
using System.Threading;
using Nethereum.Web3;
using Utils;

namespace FactoryTests
{
    public class ExecutorFactoryTests
    {
        Web3Geth _web3Geth;

        ContractInfo _contractInfo;

        public ExecutorFactoryTests()
        {
            var contractDirectory = Environment.CurrentDirectory;
            while (!contractDirectory.EndsWith("contract"))
            {
                contractDirectory = Directory.GetParent(contractDirectory).FullName;
            }

            var compiledDirectory = Directory.GetDirectories(contractDirectory).FirstOrDefault(d => d.EndsWith("compiled"));
            var abif = Directory.GetFiles(compiledDirectory).First(f => f.EndsWith("DelayedExecutorFactory.abi"));
            var binf = Directory.GetFiles(compiledDirectory).First(f => f.Contains("DelayedExecutorFactory.bin"));

            _contractInfo = new ContractInfo
            {
                Abi = File.ReadAllText(abif),
                Bytecode = File.ReadAllText(binf)
            };

            _web3Geth = new Web3Geth(new ManagedAccount(Credentials.Sender, Credentials.Password));
        }

        [Fact]
        public void Contract_Compiles_Successfully()
        {
            Assert.NotNull(_contractInfo.Abi);
            Assert.NotNull(_contractInfo.Bytecode);
        }

        [Fact]
        public async Task Executor_Factory_Deploys_Child_Contract()
        {
            var inactivePeriod = TimeSpan.FromDays(50).Seconds;
            var bounty = 1000;

            var contract = await ExecutorFactory.DeployFactoryAsync(_web3Geth, _contractInfo);

            var createExecutorFunction = contract.GetFunction("createExecutor");

            var gas = await createExecutorFunction.EstimateGasAsync(
                Credentials.Sender, Credentials.BackupAddress, inactivePeriod, bounty);

            var txHash = await createExecutorFunction.SendTransactionAsync(
                Credentials.Sender, new HexBigInteger(gas.Value), new HexBigInteger(0),
                Credentials.Sender, Credentials.BackupAddress, inactivePeriod, bounty);

            var receipt = await Miner.MineAndGetReceiptAsync(_web3Geth, txHash);

            var countFunction = contract.GetFunction("getExecutorsCount");
            var exesCount = await countFunction.CallAsync<int>();

            Assert.Equal(1, exesCount);
        }
    }
}
