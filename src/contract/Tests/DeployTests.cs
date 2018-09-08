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

namespace ContractTests
{
    public class DeployTests
    {
        const string Password = "password";

        const string Sender = "0x12890d2cce102216644c59dae5baed380d84830c";
        const string BackupAddress = "0xd147520dba4367a8d243b7feb69f5161c0177de4";

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

        [Fact]
        public async Task Contract_Deploys_Successfully()
        {
            int bounty = 1000;
            var expirationDate = DateTimeOffset.UtcNow.ToUnixTimeSeconds();

            var web3Geth = new Web3Geth(new ManagedAccount(Sender, Password));

            var txHash = await web3Geth.Eth.DeployContract.SendRequestAsync(
                _contract.Abi, _contract.Bytecode, Sender, new HexBigInteger(290000), BackupAddress, expirationDate, bounty);

             var mined = await web3Geth.Miner.Start.SendRequestAsync();
             Assert.False(mined);

             TransactionReceipt receipt = null;

            do
            {
                await Task.Delay(5000);
                receipt = await web3Geth.Eth.Transactions.GetTransactionReceipt.SendRequestAsync(txHash);
            } while (receipt == null);

            mined = await web3Geth.Miner.Stop.SendRequestAsync();
            Assert.True(mined);

            var contractAddress = receipt.ContractAddress;
            _contract.Address = contractAddress;

            var contract = web3Geth.Eth.GetContract(_contract.Abi, contractAddress);

            var bountyFunction = contract.GetFunction("bounty");
            var contractBounty = await bountyFunction.CallAsync<int>();

            var backupAddressFunction = contract.GetFunction("backupAddress");
            var contractBackupAddress = await backupAddressFunction.CallAsync<string>();

            var expirationDateFunction = contract.GetFunction("expirationDate");
            var contractExpirationDate = await expirationDateFunction.CallAsync<int>();

            Assert.True(contract != null);
            Assert.Equal(bounty, contractBounty);
            Assert.Equal(BackupAddress, contractBackupAddress);
            Assert.Equal(expirationDate, contractExpirationDate);
        }
    }
}
