using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Nethereum.Geth;
using Nethereum.Hex.HexTypes;
using Nethereum.RPC.Eth.DTOs;
using Nethereum.Web3.Accounts.Managed;
using Nethereum.ABI;
using Nethereum.Contracts;

namespace Utils
{
    public static class ExecutorFactory
    {
        public static async Task<Contract> DeployFactoryAsync(Web3Geth web3Geth, ContractInfo contract)
        {
            var gas = await web3Geth.Eth.DeployContract.EstimateGasAsync(
                contract.Abi, contract.Bytecode, Credentials.Sender);

            var txHash = await web3Geth.Eth.DeployContract.SendRequestAsync(
                contract.Abi, contract.Bytecode, Credentials.Sender, new HexBigInteger(gas.Value));

            var receipt = await Miner.MineAndGetReceiptAsync(web3Geth, txHash);

            var deployedContract = web3Geth.Eth.GetContract(contract.Abi, receipt.ContractAddress);

            return deployedContract;
        }
    }
}