//
//  CheckOutVM.swift
//  Shopify
//
//  Created by Mohamed Azooz on 23/06/2022.
//

import Foundation

class CheckOutVM {
    
    var BindingParsingclouser : () -> Void = {}
    var discountList = [PriceRule]()
    var dataProvider : DataProviderProtocol!
    var subTotal = ""
    
    init(dataProvider : DataProviderProtocol)
    {
        self.dataProvider = dataProvider
    }
    
    init(total : String)
    {
        subTotal = total
    }
    
    func getDiscountCodes() {
        dataProvider.get(urlStr: Constants.discountCodesUrl, type: PriceRules.self) { [weak self] result in
            self?.discountList = result?.price_rules ?? []
            self?.BindingParsingclouser()
        }
    }


//    func getDiscountCodes () {
//        AF.request(Constants.discountCodesUrl, method: .get)
//            .responseData { response in
//                switch response.result {
//                case .success(let Value):
//                    do {
//                        let codes = try JSONDecoder().decode(PriceRules.self, from: Value )
//                        self.discountList = codes.price_rules
//                        self.BindingParsingclouser()
//                    } catch let error {
//                        print(error)
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//    }
    
}


