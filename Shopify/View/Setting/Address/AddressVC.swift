//
//  AddressVC.swift
//  Shopify
//
//  Created by Mohamed Azooz on 28/06/2022.
//

import UIKit

class AddressVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI ()

    }

    //MARK: - IBOutlet(s)
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var addAddressBtn: UIButton!
    
    //MARK: - Vars(s)
    let VM = AddressVM(dataProvider: API())
    
    //MARK: - IBOutlet(s)
    @IBAction func addAddressBtnPressed(_ sender: UIButton) {
        let addAddressVC = AddAddressVC()
        addAddressVC.VM = AddAddressVM(dataProvider: API(), editeAddress: false)
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }

    
    //MARK: - Helper functions
    func updateUI () {
        
        VM.BindingParsingclosure = { [weak self] in
            DispatchQueue.main.async {
                self?.addressTableView.reloadData()
            }
        }
        
        //set title
        title = "Address"
        
        //Confirm Delegate and DataSource Protocols
        addressTableView.delegate = self
        addressTableView.dataSource = self
        
        //Registration of Cart Cell
        addressTableView.register(UINib(nibName: "addressCell", bundle: nil), forCellReuseIdentifier: "addressCell")
        
        //Btn Confirgation
        addAddressBtn.shopifyBtn(title: "Add New Address")
        
        addressTableView.reloadData()
    }
}
  

// MARK: - AddressVC DataSource & Delegate Methods
extension AddressVC : UITableViewDelegate , UITableViewDataSource {
    //Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VM.AddressList.count
    }
    //cell for Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addressTableView.dequeueReusableCell(withIdentifier: "addressCell") as! addressCell
        
        cell.countryLabel.text = VM.country[indexPath.row]
        cell.cityLabel.text = VM.city[indexPath.row]
        cell.addressLabel.text = VM.addresss[indexPath.row]
        
        return cell
    }
    //Did Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addAddressVC = AddAddressVC()
        addAddressVC.VM = AddAddressVM(dataProvider: API(), editeAddress: true, country:VM.country[indexPath.row], city: VM.city[indexPath.row], address: VM.addresss[indexPath.row], addressID: VM.AddressList[indexPath.row].id ?? 0)
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
    
    //Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // Delete Row Method
        internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                print("Delete")
                VM.deleteAddress(addressID: Int(VM.AddressList[indexPath.row].id ?? 0))
                VM.AddressList.remove(at: indexPath.row)
                self.addressTableView.deleteRows(at: [indexPath], with: .right)
                self.addressTableView.reloadData()
            }
            
        }
}

