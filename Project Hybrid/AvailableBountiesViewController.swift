//
//  AvailableBountiesViewController.swift
//  Project Hybrid
//
//  Created by Yura Yasinskyy on 09.09.18.
//  Copyright © 2018 BravoTeam. All rights reserved.
//

import UIKit

class AvailableBountiesViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var availableBountiesTableView: UITableView!
    
    var availableBounties = [BountieModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AvailableBountiesViewController loaded")
        
        availableBountiesTableView.register(UINib(nibName: "BountieTableViewCell", bundle: nil), forCellReuseIdentifier: "BountieCell")
        availableBountiesTableView.delegate = self
        availableBountiesTableView.dataSource = self
        
        loadBounties()
        
    }
    
    @IBAction func reloadBountiesButtonPressed(_ sender: Any) {
        loadBounties()
    }
    
    func loadBounties() { // fake data until back-end is connected
        availableBounties.removeAll()
        
        for _ in 1...15 {
            let fakeBountie = BountieModel()
            fakeBountie.ens = "\(arc4random_uniform(256))." +
                              "\(arc4random_uniform(256))." +
                              "\(arc4random_uniform(256))." +
                              "\(arc4random_uniform(256))"
            fakeBountie.address = "\(String.randomAlphaNumericString(length: 32))"
            fakeBountie.ethAmount = "\(Double(arc4random_uniform(100))/100)"
            fakeBountie.date = "\(Calendar.current.date(byAdding: .day, value: -Int(arc4random_uniform(365)), to: Date())!)"
            
            availableBounties.append(fakeBountie)
        }
        
        availableBountiesTableView.reloadData()
    }
}

extension AvailableBountiesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableBounties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bountieCell = tableView.dequeueReusableCell(withIdentifier: "BountieCell", for: indexPath) as! BountieTableViewCell
        
        bountieCell.ensLabel.text = availableBounties[indexPath.row].ens
        bountieCell.addressLabel.text = availableBounties[indexPath.row].address
        bountieCell.ethAmountLabel.text = availableBounties[indexPath.row].ethAmount
        bountieCell.dateLabel.text = availableBounties[indexPath.row].date
        
        return bountieCell
    }

}
