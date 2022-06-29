//
//  ProductsCellVM.swift
//  Shopify
//
//  Created by Nader Said on 28/06/2022.
//

import Foundation

class ProductCellVM
{
    //MARK: - Init
    init(dataProvider: DataProviderProtocol,dataPersistant: DataPersistantProtocol,product:Product)
    {
        self.dataProvider = dataProvider
        self.dataPersistant = dataPersistant
        self.product = product
        getAddedToWishlistStatus()
    }
    
    //MARK: - Var(s)
    var dataProvider: DataProviderProtocol
    var dataPersistant: DataPersistantProtocol
    var isAddedToWishlist =  Observable<Bool>(false)
    var product : Product!
    
    //MARK: - intent(s)
    func toggleWishlist()
    {
        if isAddedToWishlist.value == true
        {
            let predicate = NSPredicate(format: "id == \(product.id ?? 0)")
            dataPersistant.deleteObj(type: ProductCoreData.self, predicate: predicate)
            isAddedToWishlist.value = false
        }
        else if isAddedToWishlist.value == false
        {
            let dict = ["id":product.id ?? 0,"image" : product.image?.src ?? "","title":product.title ?? "" ,"price" : product.variants?[0].price ?? ""] as [String : Any]
            
            dataPersistant.insertObject(entityName: Constants.productCoreDataEntityName, valuesForKeys: dict)
            isAddedToWishlist.value = true
        }
    }
    
    
    //MARK: - Helper Funcs
    func getAddedToWishlistStatus()
    {
        let predicate = NSPredicate(format: "id == \(product.id ?? 0)")
        dataPersistant.get(type: ProductCoreData.self, predicate: predicate)
        { [weak self] in
            self?.isAddedToWishlist.value = !$0.isEmpty
        }
    }
    
}
