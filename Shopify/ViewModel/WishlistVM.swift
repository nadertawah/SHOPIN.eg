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
    var dataProvider: DataProviderProtocol
    var dataPersistant: DataPersistantProtocol
    var wishlistProducts = Observable<[ProductCoreData]>([])
    private(set) var productID : Int!

    //MARK: - intent(s)
    
    
    
    //MARK: - Helper Funcs
    func getWishlistProducts()
    {
        let customerID = UserDefaults.standard.integer(forKey: "customerID")
        let predicate = NSPredicate(format: "customerID == \(customerID)")
        dataPersistant.get(type: ProductCoreData.self, predicate: predicate)
        {
            [weak self] in
            self?.wishlistProducts.value = $0
        }
    }
    
   
}
