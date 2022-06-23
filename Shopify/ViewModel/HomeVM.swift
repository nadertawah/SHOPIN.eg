//
//  HomeVM.swift
//  Shopify
//
//  Created by Nader Said on 20/06/2022.
//

import Foundation

class HomeViewModel {
    
    var brandsList: Observable<SmartCollections> = Observable(nil)
    
    func getBrands() {
        
        API().get(urlStr: Constants.brandsAPIUrl, type: SmartCollections.self) { result in
            DispatchQueue.main.async {
                self.brandsList.value = result
            }
            
        }
    }
}
