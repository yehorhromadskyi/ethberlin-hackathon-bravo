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

namespace ExecutorTests
{
    public class FactoryTests
    {
        Web3Geth _web3Geth;

        ContractInfo _contractInfo;

        public FactoryTests()
        {
            var contractDirectory = Environment.CurrentDirectory;
            while (!contractDirectory.EndsWith("contract"))
            {
                contractDirectory = Directory.GetParent(contractDirectory).FullName;
            }

            var compiledDirectory = Directory.GetDirectories(contractDirectory).FirstOrDefault(d => d.EndsWith("compiled"));

            var abif = Directory.GetFiles(compiledDirectory).First(f => f.EndsWith("DelayedExecutor.abi"));
            var binf = Directory.GetFiles(compiledDirectory).First(f => f.Contains("DelayedExecutor.bin"));

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
        public async Task Executor_Deploys()
        {
            var inactivePeriod = TimeSpan.FromDays(50).Seconds;
            var bounty = 1000;

            var gas = await _web3Geth.Eth.DeployContract.EstimateGasAsync(
                _contractInfo.Abi, _contractInfo.Bytecode, Credentials.Sender,
                Credentials.Sender, Credentials.BackupAddress, inactivePeriod, bounty);

            var txHash = await _web3Geth.Eth.DeployContract.SendRequestAsync(
                _contractInfo.Abi, _contractInfo.Bytecode, Credentials.Sender, new HexBigInteger(gas.Value),
                Credentials.Sender, Credentials.BackupAddress, inactivePeriod, bounty);

            var mined = await _web3Geth.Miner.Start.SendRequestAsync();

            TransactionReceipt receipt;

            do
            {
                await Task.Delay(1000);
                receipt = await _web3Geth.Eth.Transactions
                    .GetTransactionReceipt.SendRequestAsync(txHash);
            }
            while(receipt == null);

            mined = await _web3Geth.Miner.Stop.SendRequestAsync();

            var contract = _web3Geth.Eth.GetContract(_contractInfo.Abi, receipt.ContractAddress);

            var deadFunction = contract.GetFunction("dead");
            var isDead = await deadFunction.CallAsync<bool>();

            var bountyFunction = contract.GetFunction("bounty");
            var contractBounty = await bountyFunction.CallAsync<int>();

            Assert.False(isDead);
            Assert.Equal(bounty, contractBounty);
        }
    }
}