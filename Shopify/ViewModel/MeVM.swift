//
//  MeVM.swift
//  Shopify
//
//  Created by Nader Said on 24/06/2022.
//

import Foundation

class MeViewModel
{
    init(dataProvider : DataProviderProtocol)
    {
        self.dataProvider = dataProvider
    }
    
    //MARK: - Var(s)
    private var dataProvider : DataProviderProtocol
    private(set) var isLoggedIn = Observable<Bool>(UserDefaults.standard.bool(forKey: "isLoggedIn"))
    private(set) var customer = Observable<Customer>(nil)
    
    //MARK: - intent(s)
    func getLoginState()
    {
        isLoggedIn.value = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if isLoggedIn.value == true
        {
            getCustomer(id: UserDefaults.standard.integer(forKey: "customerID"))
        }
    }
    
    func logout()
    {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        isLoggedIn.value = false
        
        UserDefaults.standard.removeObject(forKey: "customerID")
    }
    
    //MARK: - Helper Funcs
    func getCustomer(id:Int)
    {
        dataProvider.get(urlStr: Constants.customersAPIUrl.replacingOccurrences(of: ".json", with: "/\(id).json"), type: CustomerModel.self)
        { [weak self]
            customerModel in
            guard let customer = customerModel?.customer else { return }
            self?.customer.value = customer
        }
    }
}
