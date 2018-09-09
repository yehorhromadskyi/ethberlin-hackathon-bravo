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

namespace ContractTests
{
    public static class Miner
    {
        public static async Task<TransactionReceipt> MineAndGetReceiptAsync(Web3Geth web3, string transactionHash)
        {
            var mined = await web3.Miner.Start.SendRequestAsync();

            TransactionReceipt receipt;

            do
            {
                await Task.Delay(1000);
                receipt = await web3.Eth.Transactions.GetTransactionReceipt.SendRequestAsync(transactionHash);
            }
            while(receipt == null);

            mined = await web3.Miner.Stop.SendRequestAsync();

            return receipt;
        }
    }
}