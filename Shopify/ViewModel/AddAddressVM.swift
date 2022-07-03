//
//  AddAddressVM.swift
//  Shopify
//
//  Created by Mohamed Azooz on 28/06/2022.
//

import Foundation

class AddAddressVM {
    
    
    var countriesList : [Country] = []
    var selectedCountry : Country?
    var selectedCity : Provinces?
    var adress:String?
    var ErorMessage:String?
    var checkEditeAddress = false
    
    var country = ""
    var city = ""
    var address1 = ""
    var addressID : Int64 = 0
    
    var BindingParsingclosure : () -> Void = {}
    var BindingParsingclosuresucess : () -> () = {}
    var BindingParsingclosureError : () ->() = {}
    
    var dataProvider : DataProviderProtocol!
    
    init(dataProvider : DataProviderProtocol , editeAddress : Bool)
    {
        self.dataProvider = dataProvider
        getCountires()
        checkEditeAddress = editeAddress
    }
    
    init(dataProvider : DataProviderProtocol , editeAddress : Bool , country: String , city: String , address: String , addressID : Int64)
    {
        self.dataProvider = dataProvider
        getCountires()
        checkEditeAddress = editeAddress
        self.country = country
        self.city = city
        self.address1 = address
        self.addressID = addressID
    }
    
    
    func getCountires() {
        dataProvider.get(urlStr: Constants.countryUrl, type: Countries.self) { [weak self] result in
            self?.countriesList = result?.countries ?? []
            self?.BindingParsingclosure()
        }
    }
    
    func addAddress() {
        let customerID =  Int64(UserDefaults.standard.string(forKey: "customerID") ?? "0") ?? 0
        let parameter = ["address":
                            ["address1":"\(adress ?? "")",
                             "city":"\(selectedCity?.name ?? "")",
                             "first_name":"Azooz",
                             "country":"\(selectedCountry?.name ?? "")",
                             "country_name":"\(selectedCountry?.name ?? "")"
                            ]
        ]
        dataProvider.post(urlStr: Constants.AddressUrl.replacingOccurrences(of: "customerID", with: "\(customerID)"), dataType: Address.self, errorType: AddressErrorModel.self, params: parameter) { result, error in
            if result != nil{
                self.BindingParsingclosuresucess()
            }
            else{
                self.BindingParsingclosureError()
            }
        }
    }
    
    func editAddress() {
        let customerID =  Int64(UserDefaults.standard.string(forKey: "customerID") ?? "0") ?? 0
        let url = Constants.editAddressUrl.replacingOccurrences(of: "customerID", with: "\(customerID)")
        let fullUrl = url.replacingOccurrences(of: "addressID", with: "\(addressID)")
        print(fullUrl)
        let parameter = ["address":
                            ["address1":"\(adress ?? "")",
                             "city":"\(selectedCity?.name ?? "")",
                             "first_name":"Azooz",
                             "country":"\(selectedCountry?.name ?? "")",
                             "country_name":"\(selectedCountry?.name ?? "")"
                            ]
        ]
        print(parameter)
        dataProvider.put(urlStr: fullUrl, dataType: Address.self, errorType: AddressErrorModel.self, params: parameter) { result, error in
            if result != nil{
                self.BindingParsingclosuresucess()
            }
            else{
                self.BindingParsingclosureError()
            }
        }
    }
}
