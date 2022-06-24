//
//  HomeVM.swift
//  Shopify
//
//  Created by Nader Said on 20/06/2022.
//

import Foundation

class HomeViewModel {
    
    // Init
    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    //MARK: - Variable(s)
    var brandsList: Observable<SmartCollections> = Observable(nil)
    var dataProvider: DataProviderProtocol
    
    func getBrands() {
        
        dataProvider.get(urlStr: Constants.brandsAPIUrl, type: SmartCollections.self) { result in
            DispatchQueue.main.async {
                self.brandsList.value = result
            }
        }
    }
}
