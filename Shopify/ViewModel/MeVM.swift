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

    private(set) var isLoggedIn = Observable<Bool>(Helper.getCustomerID() != 0)
    private(set) var customer = Observable<Customer>(nil)
    private(set) var wishlistProducts = Observable<[ProductCoreData]>([])
    private(set) var ordersList = Observable<[Order]>([])


    //MARK: - intent(s)
    func getLoginState()
    {
        let customerID = Helper.getCustomerID()
        if customerID != 0
        {
            isLoggedIn.value = true
            getCustomer(id: customerID)
        }
    }
    
    func logout()
    {
        isLoggedIn.value = false
        
        UserDefaults.standard.set("0", forKey: "customerID")
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
        let customerID = Helper.getCustomerID()
        dataProvider.get(urlStr: Constants.ordersHistoryURL, type: Orders.self) { result in
            for order in (result?.orders ?? []) {
                if order.customer?.id == customerID {
                    self.ordersList.value?.append(order)
                }
            }
        }
    }
}
