//
//  CurrenciesTableView.swift
//  Shopify
//
//  Created by Moataz Hussein on 29/06/2022.
//

import UIKit

class CurrenciesTableView: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        
    }
    
    //MARK: - Variable(s)
    let currencies = ["EGP", "USD", "EUR"]
    let defaults = UserDefaults.standard

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath) as? LabelTableViewCell else { return UITableViewCell() }

        // Configure the cell...
        cell.label.text = currencies[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defaults.set(currencies[indexPath.row], forKey: "Currency")
        navigationController?.popViewController(animated: true)
    }
    
}
