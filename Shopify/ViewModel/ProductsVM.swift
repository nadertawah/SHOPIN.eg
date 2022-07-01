//
//  ProductsVM.swift
//  Shopify
//
//  Created by Moataz Hussein on 23/06/2022.
//

import Foundation

class ProductsViewModel
{
    
    init(dataProvider: DataProviderProtocol,dataPersistant: DataPersistantProtocol, brand: String) {
        self.dataProvider = dataProvider
        self.dataPersistant = dataPersistant
        getProducts(from: brand)
        
        productsList.bind {
            [weak self] in
            guard let productsList = $0?.products else {return}
            self?.filteredProductList.value = productsList
            
            self?.maxPriceUSD = productsList.map(
                {Float($0.variants?[0].price ?? "") ?? 0 } ).max() ?? 0
            self?.getMaxPriceWithCurrentCurrency()
        }
    }
    
    init(dataProvider: DataProviderProtocol,dataPersistant: DataPersistantProtocol) {
        self.dataProvider = dataProvider
        self.dataPersistant = dataPersistant
        getProducts()
    }
    
    //MARK: - Variable(s)
    var productsList: Observable<Products> = Observable(Products(products: []))
    var filteredProductList : Observable<[Product]> = Observable([])
    var maxPriceUSD : Float = 0
    var maxPriceWithCurrentCurrency = Observable<Float>(0)
    var dataProvider: DataProviderProtocol
    var dataPersistant: DataPersistantProtocol
    //MARK: - intent(s)
    func filterProducts(price: Float,searchStr:String)
    {
        filteredProductList.value = productsList.value?.products
        
        //filter by search string
        if searchStr != ""
        {
            filteredProductList.value = filteredProductList.value?.filter{$0.title?.uppercased().contains(searchStr.uppercased()) ?? false}
        }
        
        //filter by price
        let currency = UserDefaults.standard.string(forKey: "Currency") ?? ""
        let rate = Constants.rates[currency]
        let actualPrice = price / (rate ?? 0.0)
        if actualPrice > 0
        {
            filteredProductList.value = filteredProductList.value?.filter
            {
                (($0.variants?[0].price ?? "") as NSString).floatValue <= actualPrice
                
            }
        }
        
    }

    var selectedSubCategory = 1
    var selectedMainCategory = 2
    
    //MARK: - Helper Funcs
    func getProducts(from brand: String) {
        
        dataProvider.get(urlStr: Constants.productsAPIUrl, type: Products.self) { result in
            DispatchQueue.main.async {
                self.productsList.value = Products(products: result?.products.filter { $0.vendor == brand } ?? [] )
            }
        }
        
    }
    
    func getProducts(with subCategory: String?, and mainCategoryID: UInt64?) {
        
        var filteredList = Products(products: [])
        dataProvider.get(urlStr: Constants.productsAPIUrl, type: Products.self) { result in
            DispatchQueue.main.async {
                let preFilteredList = Products(products: result?.products.filter { $0.product_type == subCategory } ?? [])
                self.dataProvider.get(urlStr: Constants.collectsAPIUrl, type: Collects.self) { result in
                    let collections = Collects(collects: result?.collects.filter { $0.collection_id == mainCategoryID } ?? [])
                    for collection in collections.collects {
                        for product in preFilteredList.products {
                            if product.id ?? 0 == collection.product_id ?? 0 {
                                filteredList.products.append(product)
                            }
                        }
                    }
                    self.productsList.value = filteredList
                }
            }
        }
        
    }
    
    func getProducts() {
        
        dataProvider.get(urlStr: Constants.productsAPIUrl, type: Products.self) { result in
            DispatchQueue.main.async {
                self.productsList.value = result
            }
        }
        
    }
    
    func getMaxPriceWithCurrentCurrency()
    {
        let rate = Constants.rates[Constants.currency]!
        maxPriceWithCurrentCurrency.value = maxPriceUSD * rate
    }
}
