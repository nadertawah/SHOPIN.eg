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
    
    var VM : AddAddressVM!
  
    var countryPickerView = UIPickerView()
    var cityPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityTF.isEnabled = false
        
        //set title
        title = "Add Address"
        
        //Set Picker View to Country Textfield
        countryTF.inputView = countryPickerView
        cityTF.inputView = cityPickerView
        
        
        //Confirm Picker View Protocols
        self.countryPickerView.delegate = self
        self.countryPickerView.dataSource = self
        self.cityPickerView.delegate = self
        self.cityPickerView.dataSource = self
        
        //Btn Confirgation
        saveAddressBtn.shopifyBtn(title: "Save Address")
        
        //TextFeilds Configrations
        countryTF.shopifyTF(placeholder: "Chose Countrt")
        cityTF.shopifyTF(placeholder: "Chose City")
        addressTF.shopifyTF(placeholder: "Enter Address")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(VM.checkEditeAddress)
        if VM.checkEditeAddress == true {
            // To set TextFeilds
            countryTF.text = VM.country
            cityTF.text = VM.city
            addressTF.text = VM.address1
        }
    }
    
    @IBAction func addAddressBtnPressed(_ sender: UIButton) {
        
        if VM.checkEditeAddress == false {
            
            VM.adress = self.addressTF.text ?? ""
            VM.addAddress()
            
            VM.BindingParsingclosuresucess = { [weak self] in
                let alert = Alerts.instance.showAlert(title: "Address Added", message: "Address Added Succusfully")
                self?.present(alert, animated: true, completion: nil)
            }
            VM.BindingParsingclosureError = { [weak self] in
                let alert = Alerts.instance.showAlert(title: "Address Added", message: "Address Already Exists")
                self?.present(alert, animated: true, completion: nil)
            }
        } else if VM.checkEditeAddress == true {
            VM.adress = self.addressTF.text ?? ""
            VM.editAddress()
            
            VM.BindingParsingclosuresucess = { [weak self] in
                let alert = Alerts.instance.showAlert(title: "Edit Address", message: "Address Edited Succusfully")
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
// MARK: - Pciker View Methods
extension AddAddressVC : UIPickerViewDelegate , UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPickerView {
            return VM.countriesList.count
        } else {
            return VM.selectedCountry?.provinces?.count ?? 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == countryPickerView {
            return VM.countriesList[row].name
        } else {
            return VM.selectedCountry?.provinces?[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countryPickerView {
            VM.selectedCountry = VM.countriesList[row]
            cityTF.isEnabled = true
            cityTF.text = ""
            countryTF.text = VM.countriesList[row].name
            countryTF.resignFirstResponder()
        } else {
            VM.selectedCity = VM.selectedCountry?.provinces?[row]
            cityTF.text = VM.selectedCountry?.provinces?[row].name
            cityTF.resignFirstResponder()
        }
    }
}

