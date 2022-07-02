//
//  AddressVM.swift
//  Shopify
//
//  Created by Mohamed Azooz on 28/06/2022.
//

import Foundation

class AddressVM {
    
    var AddressList = [Address]()
    var country = [String]()
    var city = [String]()
    var addresss = [String]()
    
    var BindingParsingclosure : () -> Void = {}
    var BindingParsingclosuresucess : () -> () = {}
    var BindingParsingclosureError : () ->() = {}
    
//    var selectedCountry : Country?
//    var selectedCity : Provinces?
//    var adress:String?
    
    var dataProvider : DataProviderProtocol!
    
    init(dataProvider : DataProviderProtocol)
    {
        self.dataProvider = dataProvider
        getAddresses()
    }
    
    func getAddresses() {
        let customerID =  Int64(UserDefaults.standard.string(forKey: "customerID") ?? "0") ?? 0
        dataProvider.get(urlStr: Constants.AddressUrl.replacingOccurrences(of: "customerID", with: "\(customerID)") , type: Addresses.self) { [weak self] result in
            self?.AddressList = result?.addresses ?? []
            self?.get()
            self?.BindingParsingclosure()
        }
    }
    
    func get() {
        for address in self.AddressList {
            country.append(address.country ?? "")
            city.append(address.city ?? "")
            addresss.append(address.address1 ?? "")
        }
    }
    
    func deleteAddress(addressID : Int) {
        let customerID =  Int64(UserDefaults.standard.string(forKey: "customerID") ?? "0") ?? 0
        let url = Constants.deletAddressUrl.replacingOccurrences(of: "customerID", with: "\(customerID)")
        let fullUrl = url.replacingOccurrences(of: "addressID", with: "\(addressID)")
        print(fullUrl)
        
        dataProvider.delete(urlStr: fullUrl, dataType: Address.self, errorType: AddressErrorModel.self) { result, error in
            if result != nil{
                self.BindingParsingclosuresucess()
            }
            else{
                self.BindingParsingclosureError()
            }
        }
    }
}
