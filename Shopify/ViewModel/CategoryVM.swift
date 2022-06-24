//
//  CategoryVM.swift
//  Shopify
//
//  Created by Moataz Hussein on 24/06/2022.
//

import Foundation

class CategoryViewModel
{
    
    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
        getSubCategories()
    }

    //MARK: - Variable(s)
    let mainCategoriesList = ["WOMEN", "KIDS", "MEN", "SALE"]
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
    
}
