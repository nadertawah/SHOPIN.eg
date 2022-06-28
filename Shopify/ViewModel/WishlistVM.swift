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
    
    //MARK: - intent(s)
    
    
    
    //MARK: - Helper Funcs
    func getWishlistProducts()
    {
        dataPersistant.get(type: ProductCoreData.self, predicate: nil)
        {
            [weak self] in
            self?.wishlistProducts.value = $0
        }
    }
    
   
}
