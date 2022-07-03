//
//  OrdersHistoryVC.swift
//  Shopify
//
//  Created by Moataz Hussein on 03/07/2022.
//

import UIKit

class OrdersHistoryVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // register cell
        self.tableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "orderCell")
        
        // fetch order history
        VM.ordersList.bind
        { [weak self] _ in
            DispatchQueue.main.async
            {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        VM.getOrdersHistory()
    }
    
    var VM: MeViewModel!

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VM.ordersList.value?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as? OrderCell else { return UITableViewCell() }
        
        let order = VM.ordersList.value?[indexPath.row]

        // Configure the cell...
        cell.orderIDLabel.text = "\(order?.id ?? 0)"
        cell.dateLabel.text = order?.closed_at
        cell.totalAmountLabel.text = order?.current_total_price
        
        return cell
    }
    
}
