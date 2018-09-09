//
//  EthereumInteractor.swift
//  Project Hybrid
//
//  Created by Yura Yasinskyy on 08.09.18.
//  Copyright © 2018 BravoTeam. All rights reserved.
//

import Foundation
import Web3

class EthereumInteractor {
    
    /// EthereumInteractor singletone
    static let shared = EthereumInteractor()
    
    // MARK: - Properties
    
    let rickenbyTestNetURL = "https://rinkeby.infura.io/"
    let web3: Web3
    
    // MARK: - Init
    
    private init() {
        web3 = Web3(rpcURL: rickenbyTestNetURL)
        print("EthereumInteractor connected to \(rickenbyTestNetURL)")
    }
    
    // MARK: - Network status
    
    func getNetworkStatus(completion: @escaping (String) -> Void) {
        getWeb3Version { web3Version in
            self.getCurrentChainId { currentChainId in
                self.getNumberOfConnectedPeers { numberOfConnectedPeers in
                    completion("\(web3Version)\n"
                        + "\(currentChainId)\n"
                        + "\(numberOfConnectedPeers)")
                }
            }
        }
    }
    
    func getWeb3Version(completion: @escaping (String) -> Void) {
        firstly() {
            web3.clientVersion()
        }.done { version in
            completion("Current client Web3 version: \(version)")
        }.catch { error in
            completion(error.getDescription())
        }
    }
    
    func getNumberOfConnectedPeers(completion: @escaping (String) -> Void) {
        firstly {
            web3.net.peerCount()
            }.done { ethereumQuantity in
                completion("Number of connected peers: \(ethereumQuantity.quantity)")
            }.catch { error in
                completion(error.getDescription())
        }
    }
    
    func getCurrentChainId(completion: @escaping (String) -> Void) {
        firstly {
            web3.net.version()
            }.done { version in
                completion("Current chain ID: \(version)")
            }.catch { error in
                completion(error.getDescription())
        }
    }
    
    // MARK: - Exploring Ethereum
    
    func getBlockTransactionCount(blockNumber: BigUInt, completion: @escaping (String) -> Void) {
        firstly {
            web3.eth.getBlockTransactionCountByNumber(block: .block(blockNumber))
            }.done { count in
                completion("Number of transactions in block \(blockNumber): \(String(count.quantity))")
            }.catch { error in
                completion(error.getDescription())
        }
    }
    
    func executeTransaction(privateKey: String,
                            gasPrice: BigUInt,
                            gasAmount: BigUInt,
                            recieverAddress: String,
                            amountOfEthereum: Double,
                            completion: @escaping (String) -> Void) {
        var transactionExecutionResult = "----------\nExecuting new transaction\n----------"
        
        let privateKey = try! EthereumPrivateKey(hexPrivateKey: privateKey)
        firstly {
            web3.eth.getTransactionCount(address: privateKey.address, block: .latest)
            }
            .then { nonce -> Promise<EthereumSignedTransaction> in
                transactionExecutionResult.append("\n" + "Transaction count of the sender (nonce): \(nonce.quantity)")
                transactionExecutionResult.append("\n" + "Gas price: \(gasPrice)")
                transactionExecutionResult.append("\n" + "Gas amount: \(gasAmount)")
                transactionExecutionResult.append("\n" + "Reciever address: \(recieverAddress)")
                transactionExecutionResult.append("\n" + "Amount of Ethereum: \(amountOfEthereum)")
                
                let transaction = try EthereumTransaction(
                    nonce: nonce,
                    gasPrice: EthereumQuantity(quantity: gasPrice.gwei),
                    gas: EthereumQuantity(quantity: gasAmount),
                    to: EthereumAddress(hex: recieverAddress, eip55: true),
                    value: EthereumQuantity(quantity: BigUInt(amountOfEthereum).eth)
                )
                
                transactionExecutionResult.append("\n" + "Signing transaction")
                return try transaction.sign(with: privateKey, chainId: 4).promise
            }.then { pendingTransaction -> Promise<EthereumData> in
                transactionExecutionResult.append("\n" + "Sending transaction")
                return self.web3.eth.sendRawTransaction(transaction: pendingTransaction)
            }.done { transactionData in
                transactionExecutionResult.append("\n" + "Transaction executed successfully with hash: \(transactionData.hex())")
                transactionExecutionResult.append("\n----------")
                completion(transactionExecutionResult)
            }.catch { error in
                transactionExecutionResult.append("\n" + "\(error.getDescription())")
                transactionExecutionResult.append("\n----------")
                completion(transactionExecutionResult)
        }
    }
    
}
