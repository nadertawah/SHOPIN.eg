//
//  CheckOutVM.swift
//  Shopify
//
//  Created by Mohamed Azooz on 23/06/2022.
//

import Foundation

class CheckOutVM {
    
    var BindingParsingclouser : () -> Void = {}
    var discountList = [PriceRule]()
    var subTotal = ""
    var AddressList = [Address]()
    var country = [String]()
    var city = [String]()
    var addresss = [String]()
    var BindingParsingclosure : () -> Void = {}
    
    var dataProvider : DataProviderProtocol!
    
    init(dataProvider : DataProviderProtocol)
    {
        self.dataProvider = dataProvider
        getAddresses()
    }
    
    init(total : String)
    {
        subTotal = total
    }
    
    func getAddresses() {
        let customerID =  UserDefaults.standard.integer(forKey: "customerID")
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
            print(country[0])
        }
    }
    
    
    func getDiscountCodes() {
        dataProvider.get(urlStr: Constants.discountCodesUrl, type: PriceRules.self) { [weak self] result in
            self?.discountList = result?.price_rules ?? []
            self?.BindingParsingclouser()
        }
    }


    
}


