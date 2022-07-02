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
        let customerID = Int64(UserDefaults.standard.string(forKey: "customerID") ?? "0") ?? 0
        if customerID != 0
        {
            if isAddedToWishlist.value == true
            {
                let predicate = NSPredicate(format: "id == \(product.id ?? 0) && customerID == \(customerID)")
                dataPersistant.deleteObj(type: ProductCoreData.self, predicate: predicate)
                isAddedToWishlist.value = false
            }
            else if isAddedToWishlist.value == false
            {
                let dict = ["id":product.id ?? 0,"image" : product.image?.src ?? "","title":product.title ?? "" ,"price" : product.variants?[0].price ?? "","customerID":customerID] as [String : Any]
                
                dataPersistant.insertObject(entityName: Constants.productCoreDataEntityName, valuesForKeys: dict)
                isAddedToWishlist.value = true
            }
        }
    }
    
    
    //MARK: - Helper Funcs
    func getAddedToWishlistStatus()
    {
        let customerID = Int64(UserDefaults.standard.string(forKey: "customerID") ?? "0") ?? 0
        if customerID != 0
        {
            let predicate = NSPredicate(format: "id == \(product.id ?? 0) && customerID == \(customerID)")
            dataPersistant.get(type: ProductCoreData.self, predicate: predicate)
            { [weak self] in
                self?.isAddedToWishlist.value = !$0.isEmpty
            }
        }
        
    }
    
}
