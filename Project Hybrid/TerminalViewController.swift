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
    @IBOutlet weak var privateKeyTextField: UITextField!
    @IBOutlet weak var recieverAddressTextField: UITextField!
    @IBOutlet weak var amountOfEthereumTextField: UITextField!
    @IBOutlet weak var gasPriceTextField: UITextField!
    @IBOutlet weak var gasAmountTextField: UITextField!
    @IBOutlet weak var blockNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TerminalViewController loaded")
        
        getNetworkStatus()
    }
    
    // MARK: - IBActions
    
    @IBAction func getStatusButtonPressed(_ sender: Any) {
        getNetworkStatus()
    }
    
    @IBAction func getBlockTransactionCountButtonPressed(_ sender: Any) {
        getBlockTransactionCount()
    }
    
    @IBAction func executeTransactionButtonPressed(_ sender: Any) {
        executeTransaction()
    }
    
    @IBAction func clearTerminalButtonPressed(_ sender: Any) {
        teminalTextView.text = ""
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
    
    func executeTransaction() {        
        EthereumInteractor.shared.executeTransaction(privateKey: privateKeyTextField.text!,
                                                     gasPrice: BigUInt(gasPriceTextField.text ?? "") ?? 0,
                                                     gasAmount: BigUInt(gasAmountTextField.text ?? "") ?? 0,
                                                     recieverAddress: recieverAddressTextField.text!,
                                                     amountOfEthereum: Double(amountOfEthereumTextField.text!) ?? 0,
                                                     completion: { transactionExecutionResult in
                                                        print(transactionExecutionResult)
                                                        DispatchQueue.main.async {
                                                            self.teminalTextView.text.append("\n" + transactionExecutionResult)
                                                        }
                                        
        })
    }
}
