//
//  ProductDetailsVM.swift
//  Shopify
//
//  Created by Nader Said on 21/06/2022.
//

import Foundation

class ProductDetailsVM
{
    init(dataProvider : DataProviderProtocol,dataPersistant: DataPersistantProtocol, productID : String)
    {
        self.dataProvider = dataProvider
        self.dataPersistant = dataPersistant
        getProductDetails(productID: productID)
    }
    
    //MARK: - Var(s)
    //data provider data persitance services
    private(set) var dataProvider : DataProviderProtocol
    private(set) var dataPersistant: DataPersistantProtocol
    
    //VM model
    private(set) var product = Observable<Product>(Product())
    private(set) var isAddedToWishlist = Observable<Bool>(false)
    
    //MARK: - intent(s)
    func toggleWishlist()
    {
        let customerID = Int64(UserDefaults.standard.string(forKey: "customerID") ?? "0") ?? 0
        if customerID != 0
        {
            if isAddedToWishlist.value == true
            {
                let predicate = NSPredicate(format: "id == \(product.value?.id ?? 0) && customerID == \(customerID)")
                dataPersistant.deleteObj(type: ProductCoreData.self, predicate: predicate)
                isAddedToWishlist.value = false
            }
            else if isAddedToWishlist.value == false
            {
                let dict = ["id":product.value?.id ?? 0,"image" : product.value?.image?.src ?? "","title":product.value?.title ?? "" ,"price" : product.value?.variants?[0].price ?? "","customerID":customerID] as [String : Any]
                
                dataPersistant.insertObject(entityName: Constants.productCoreDataEntityName, valuesForKeys: dict)
                isAddedToWishlist.value = true
            }
        }
    }
    
    //MARK: - Helper Funcs
    func getProductDetails(productID : String)
    {
        let productDetailsURL = Constants.productsAPIUrl.replacingOccurrences(of: ".json", with: "/\(productID).json")
        dataProvider.get(urlStr: productDetailsURL, type: ProductModel.self)
        {
            [weak self] in
            self?.product.value = $0?.product ?? Product()
            self?.getAddedToWishlistStatus()
        }
    }
    
    func getAddedToWishlistStatus()
    {
        let customerID = Int64(UserDefaults.standard.string(forKey: "customerID") ?? "0") ?? 0
        if customerID != 0
        {
            let predicate = NSPredicate(format: "id == \(product.value?.id ?? 0) && customerID == \(customerID)")
            dataPersistant.get(type: ProductCoreData.self, predicate: predicate)
            { [weak self] in
                self?.isAddedToWishlist.value = !$0.isEmpty
            }
        }
    }
    
}
