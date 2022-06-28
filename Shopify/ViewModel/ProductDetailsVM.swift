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
    //data provider service
    var dataProvider : DataProviderProtocol
    var dataPersistant: DataPersistantProtocol

    //VC binding closure
    var bind : (() -> ())?

    //VM model
    private(set) var product = Product() { didSet{bind?()} }
    private(set) var isAddedToWishlist = Observable<Bool>(false)
    
    //MARK: - intent(s)
    func toogleWishlist()
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
    func getProductDetails(productID : String)
    {
        let productDetailsURL = Constants.productsAPIUrl.replacingOccurrences(of: ".json", with: "/\(productID).json")
        dataProvider.get(urlStr: productDetailsURL, type: ProductModel.self)
        {
            [weak self] in
            self?.product = $0?.product ?? Product()
            self?.getAddedToWishlistStatus()
        }
    }
    
    func getAddedToWishlistStatus()
    {
        let predicate = NSPredicate(format: "id == \(product.id ?? 0)")
        dataPersistant.get(type: ProductCoreData.self, predicate: predicate)
        { [weak self] in
            self?.isAddedToWishlist.value = !$0.isEmpty
        }
    }
    
}
