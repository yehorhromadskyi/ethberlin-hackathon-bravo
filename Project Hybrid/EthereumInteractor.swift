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
            self.getCurrentNetworkId { currentNetworkId in
                self.getNumberOfConnectedPeers { numberOfConnectedPeers in
                    completion("\(web3Version)\n"
                        + "\(currentNetworkId)\n"
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
    
    func getCurrentNetworkId(completion: @escaping (String) -> Void) {
        firstly {
            web3.net.version()
            }.done { version in
                completion("Current network ID: \(version)")
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
    
}
