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
    private(set) var dataProvider: DataProviderProtocol
    private(set) var dataPersistant: DataPersistantProtocol
    private(set) var isAddedToWishlist =  Observable<Bool>(false)
    private(set) var product : Product!
    
    //MARK: - intent(s)
    func toggleWishlist()
    {
        let customerID = Helper.getCustomerID()
        if customerID != 0
        {
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
    }
    
    
    //MARK: - Helper Funcs
    func getAddedToWishlistStatus()
    {
        let customerID = Helper.getCustomerID()
        if customerID != 0
        {
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
    
}
