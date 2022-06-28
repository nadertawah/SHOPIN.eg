//
//  AddressVC.swift
//  Shopify
//
//  Created by Mohamed Azooz on 28/06/2022.
//

import UIKit

class AddressVC: UIViewController {

    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var addAddressBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        //set title
        title = "Address"
//        //Confirm Delegate and DataSource Protocols
//        addressTableView.delegate = self
//        addressTableView.dataSource = self
        
        //Btn Confirgation
        addAddressBtn.shopifyBtn(title: "Add New Address")
    }

    //MARK: - IBOutlet(s)
    @IBAction func addAddressBtnPressed(_ sender: UIButton) {
        let addAddressVC = AddAddressVC()
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
}

// MARK: - AddressVC DataSource & Delegate Methods
//extension AddressVC : UITableViewDelegate , UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
    
//}
