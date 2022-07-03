//
//  AddressVC.swift
//  Shopify
//
//  Created by Mohamed Azooz on 28/06/2022.
//

import UIKit

class AddressVC: UIViewController {

    //OutLets
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var addAddressBtn: UIButton!
    
    //MARK: - Vars(s)
    let VM = AddressVM(dataProvider: API())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI ()

    }
    
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
    override func viewWillAppear(_ animated: Bool) {
        
    }
    

    //MARK: - IBOutlet(s)
    @IBAction func addAddressBtnPressed(_ sender: UIButton) {
        let addAddressVC = AddAddressVC()
        addAddressVC.VM = AddAddressVM(dataProvider: API(), editeAddress: false)
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
}

// MARK: - AddressVC DataSource & Delegate Methods
extension AddressVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VM.AddressList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addressTableView.dequeueReusableCell(withIdentifier: "addressCell") as! addressCell
        
        cell.countryLabel.text = VM.country[indexPath.row]
        cell.cityLabel.text = VM.city[indexPath.row]
        cell.addressLabel.text = VM.addresss[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addAddressVC = AddAddressVC()
        addAddressVC.VM = AddAddressVM(dataProvider: API(), editeAddress: true)
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
    
    
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

