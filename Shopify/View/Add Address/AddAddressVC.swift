//
//  AddressVC.swift
//  Shopify
//
//  Created by Mohamed Azooz on 28/06/2022.
//

import UIKit

class AddAddressVC: UIViewController {

    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var saveAddressBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        //set title
        title = "Add Address"
        
        //Btn Confirgation
        saveAddressBtn.shopifyBtn(title: "Save Address")
    }
}
