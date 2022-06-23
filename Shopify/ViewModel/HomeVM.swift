//
//  HomeVM.swift
//  Shopify
//
//  Created by Nader Said on 20/06/2022.
//

import Foundation

class HomeViewModel
{
    
    init()
    {
        getBrands()
        brandsList.bind {[weak self] in self?.filtereBrandsList.value = $0?.smart_collections}
    }
    
    //MARK: - Var(s)
    var brandsList: Observable<BrandsModel> = Observable(nil)
    var filtereBrandsList: Observable<[Brand]> = Observable([Brand]())

    //MARK: - intent(s)
    func searchBrands(searchStr:String)
    {
        filtereBrandsList.value = searchStr == "" ?
            brandsList.value?.smart_collections : brandsList.value?.smart_collections.filter{$0.title?.contains(searchStr) ?? false}
    }
    
    
    //MARK: - Helper Funcs
    func getBrands() {
        
        API().get(urlStr: Constants.brandsAPIUrl, type: BrandsModel.self) { result in
            DispatchQueue.main.async {
                self.brandsList.value = result
            }
            
        }
    }
}
