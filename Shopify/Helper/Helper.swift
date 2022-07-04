//
//  Helper.swift
//  Shopify
//
//  Created by Nader Said on 20/06/2022.
//

import Foundation

struct Helper
{
    //get customer id if logged in else return 0
    static func getCustomerID() -> Int64
    {
        return Int64(UserDefaults.standard.string(forKey: "customerID") ?? "0") ?? 0
    }
    
    //adjust amount based on chosen currency
    static func adjustAmount(amount: Float) -> String
    {
        let currency = UserDefaults.standard.string(forKey: "Currency") ?? ""
        let rate = Constants.rates[currency]
        let adjustedAmount =  amount * (rate ?? 0)
        return String(format: "%.2f", adjustedAmount) + " " + currency
    }
}
