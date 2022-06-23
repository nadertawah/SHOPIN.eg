//
//  CheckOutVM.swift
//  Shopify
//
//  Created by Mohamed Azooz on 23/06/2022.
//

import Foundation
import Alamofire

class CheckOutVM {
    
    var BindingParsingclouser : () -> Void = {}
    var discountList = [PriceRule]()

//    func getDiscountCodes() {
//
//        API().get(urlStr: Constants.discountCodesUrl, type: PriceRule.self) { result in
//            DispatchQueue.main.async {
////                self.discountList = result
//            }
//        }
//    }


    func getDiscountCodes () {
        print("---------------------")
        AF.request(Constants.discountCodesUrl, method: .get)
            .responseData { response in
                switch response.result {
                case .success(let Value):
                    do {
                        let codes = try JSONDecoder().decode(PriceRules.self, from: Value )
                        self.discountList = codes.price_rules
                        self.BindingParsingclouser()
                    } catch let error {
                        print(error)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
}


