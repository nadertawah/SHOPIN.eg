//
//  CategoryVM.swift
//  Shopify
//
//  Created by Moataz Hussein on 24/06/2022.
//

import Foundation

class CategoryViewModel {
    
    //MARK: - Initializer
    init(dataProvider: DataProviderProtocol) {
        
        self.dataProvider = dataProvider
        getSubCategories()
        getMainCategories()
        
    }

    //MARK: - Variable(s)
    var mainCategoriesList = [String]()
    var subCategoriesList = [String]()
    var dataProvider: DataProviderProtocol
    let productsVM = ProductsViewModel(dataProvider: API())
    
    //MARK: - Helper Funcs
    func getSubCategories() {
        
        productsVM.productsList.bind { [weak self] _ in
            guard let products = self?.productsVM.productsList.value?.products else { return }
            DispatchQueue.main.async {
                for product in products {
                    if !(self?.subCategoriesList.contains(product.product_type ?? "") ?? true) {
                        self?.subCategoriesList.append(product.product_type ?? "")
                    }
                }
            }
        }
        
    }
    
    func getMainCategories() {
        
        dataProvider.get(urlStr: Constants.mainCategoryAPIUrl, type: CustomCollections.self) { result in
            guard let categories = result?.custom_collections else { return }
            DispatchQueue.main.async {
                for category in categories {
                    if !(self.mainCategoriesList.contains(category.title ?? "") ) {
                        self.mainCategoriesList.append(category.title ?? "")
                    }
                }
            }
        }

    }
    
}
