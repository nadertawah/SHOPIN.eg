//
//  WishlistVM.swift
//  Shopify
//
//  Created by Nader Said on 28/06/2022.
//

import Foundation

class WishlistVM
{
    // Init
    init(dataProvider: DataProviderProtocol,dataPersistant: DataPersistantProtocol)
    {
        self.dataProvider = dataProvider
        self.dataPersistant = dataPersistant
        getWishlistProducts()
    }
    
    //MARK: - Var(s)
    private(set) var wishlistProducts = Observable<[ProductCoreData]>([])
    private(set) var productID : Int!
    
    //data provider data persitance services
    private(set) var dataProvider: DataProviderProtocol
    private(set) var dataPersistant: DataPersistantProtocol
    
    //MARK: - Helper Funcs
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
}
