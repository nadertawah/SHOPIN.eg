//
//  MeVM.swift
//  Shopify
//
//  Created by Nader Said on 24/06/2022.
//

import Foundation

class MeViewModel
{
    init(dataProvider : DataProviderProtocol,dataPersistant: DataPersistantProtocol)
    {
        self.dataProvider = dataProvider
        self.dataPersistant = dataPersistant
    }
    
    //MARK: - Var(s)
    var dataProvider : DataProviderProtocol
    var dataPersistant: DataPersistantProtocol

    private(set) var isLoggedIn = Observable<Bool>(UserDefaults.standard.bool(forKey: "isLoggedIn"))
    private(set) var customer = Observable<Customer>(nil)
    private(set) var wishlistProducts = Observable<[ProductCoreData]>([])
    var ordersList = Observable<[Order]>([])


    //MARK: - intent(s)
    func getLoginState()
    {
        isLoggedIn.value = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if isLoggedIn.value == true
        {
            getCustomer(id: Helper.getCustomerID())
        }
    }
    
    func logout()
    {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        isLoggedIn.value = false
        
        UserDefaults.standard.removeObject(forKey: "customerID")
    }
    
    //MARK: - Helper Funcs
    func getCustomer(id:Int64)
    {
        dataProvider.get(urlStr: Constants.customersAPIUrl.replacingOccurrences(of: ".json", with: "/\(id).json"), type: CustomerModel.self)
        { [weak self]
            customerModel in
            guard let customer = customerModel?.customer else { return }
            self?.customer.value = customer
        }
    }
    
    func getWishlistProducts()
    {
        let customerID = Helper.getCustomerID()
        if customerID != 0
        {
            let predicate = NSPredicate(format: "customerID == \(customerID)")
            dataPersistant.get(type: ProductCoreData.self, predicate: predicate)
            {
                [weak self] in
                self?.wishlistProducts.value = $0
            }
        }
    }
    
    func getOrdersHistory()
    {
        let customerID = UserDefaults.standard.string(forKey: "customerID") ?? ""
        dataProvider.get(urlStr: Constants.ordersHistoryURL, type: Orders.self) { result in
            for order in (result?.orders ?? []) {
                if order.customer?.id == Int64(customerID) {
                    self.ordersList.value?.append(order)
                }
            }
        }
    }
}
