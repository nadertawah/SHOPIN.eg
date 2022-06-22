//
//  LoginRegisterVM.swift
//  Shopify
//
//  Created by Nader Said on 22/06/2022.
//

import Foundation

class LoginRegisterVM
{
    init(dataProvider : DataProviderProtocol)
    {
        self.dataProvider = dataProvider
    }
    
    //MARK: - Var(s)
    //data provider service
    var dataProvider : DataProviderProtocol
    
    //VC binding closure
    var bind : ((Bool) -> ())?
    
    //MARK: - intent(s)
    func login(email:String, password:String)
    {
        
    }
    
    func register(name:String,email:String, password:String)
    {
        
    }
    
    //MARK: - Helper Funcs
    func getProductDetails(productID : String)
    {
        let productDetailsURL = Constants.productsAPIUrl.replacingOccurrences(of: ".json", with: "/\(productID).json")
        dataProvider.get(urlStr: productDetailsURL, type: ProductModel.self)
        {
            [weak self] in
            //self?.product = $0?.product ?? Product()
        }
    }
    
}
