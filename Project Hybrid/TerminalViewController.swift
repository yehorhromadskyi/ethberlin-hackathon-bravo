//
//  TerminalViewController.swift
//  Project Hybrid
//
//  Created by Yura Yasinskyy on 08.09.18.
//  Copyright © 2018 BravoTeam. All rights reserved.
//

import UIKit
import Web3

class TerminalViewController: UIViewController {

    @IBOutlet weak var teminalTextView: UITextView!
    @IBOutlet weak var blockNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNetworkStatus()
    }
    
    // MARK: - IBActions
    
    @IBAction func getStatusButtonPressed(_ sender: Any) {
        getNetworkStatus()
    }
    
    @IBAction func getBlockTransactionCountButtonPressed(_ sender: Any) {
        getBlockTransactionCount()
    }
    
    
    
    // MARK: - EthereumInteractor actions
    
    func getNetworkStatus() {
        EthereumInteractor.shared.getNetworkStatus { networkStatus in
            print(networkStatus)
            DispatchQueue.main.async {
                self.teminalTextView.text.append("\n" + networkStatus)
            }
        }
    }
    
    func getBlockTransactionCount() {
        EthereumInteractor.shared.getBlockTransactionCount(blockNumber: BigUInt(blockNumberTextField.text ?? "") ?? 0,
                                                           completion: { transactionCount in
            print(transactionCount)
            DispatchQueue.main.async {
                self.teminalTextView.text.append("\n" + transactionCount)
            }
        })
    }
    
}
