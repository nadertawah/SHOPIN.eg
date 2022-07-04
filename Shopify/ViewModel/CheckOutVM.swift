//
//  CheckOutVM.swift
//  Shopify
//
//  Created by Mohamed Azooz on 23/06/2022.
//

import Foundation

class CheckOutVM {
    
    //MARK: - Var(s)
    var BindingParsingclouser : () -> Void = {}
    var discountList = [PriceRule]()
    var subTotal = ""
    var AddressList = [Address]()
    var country = [String]()
    var city = [String]()
    var addresss = [String]()
    var customerEMail = ""
    var productList = Observable<[CartProducts]>([])
    var BindingParsingclosure : () -> Void = {}
    var dataProvider : DataProviderProtocol
    var dataPersistant : DataPersistantProtocol

    
    //MARK: - Init
    init(dataProvider: DataProviderProtocol, dataPersistant: DataPersistantProtocol, total: String, products: Observable<[CartProducts]>)
    {
        productList.value = products.value
        self.dataProvider = dataProvider
        self.dataPersistant = dataPersistant
        getAddresses()
        subTotal = total
    }
    
    
    //MARK: - Helper Funcs
    func getAddresses() {
        let customerID =  Helper.getCustomerID()
        if customerID != 0
        {
            dataProvider.get(urlStr: Constants.AddressUrl.replacingOccurrences(of: "customerID", with: "\(customerID)") , type: Addresses.self) { [weak self] result in
                self?.AddressList = result?.addresses ?? []
                self?.get()
                self?.BindingParsingclosure()
            }
        }
        
    }
    
    func get() {
        for address in self.AddressList {
            country.append(address.country ?? "")
            city.append(address.city ?? "")
            addresss.append(address.address1 ?? "")
            print(country[0])
        }
    }
    
    // empty cart
    func emptyCart()
    {
        for i in (0..<(productList.value?.count ?? 0)).reversed()
        {
            if let product = productList.value?[i]
            {
                debugPrint(product)
                dataPersistant.deleteObj(obj: product)
                productList.value?.remove(at: i)
            }
        }
    }
    
    
    func getDiscountCodes() {
        dataProvider.get(urlStr: Constants.discountCodesUrl, type: PriceRules.self) { [weak self] result in
            self?.discountList = result?.price_rules ?? []
            self?.BindingParsingclouser()
        }
    }
    
    func postOrder(completionHandler : @escaping (String)->())
    {
        let customerID = Helper.getCustomerID()
        let currency = UserDefaults.standard.string(forKey: "Currency") ?? ""
        var lineItems = [[String: Any]]()
        dataProvider.get(urlStr: Constants.customersAPIUrl.replacingOccurrences(of: ".json", with: "/\(customerID).json"), type: CustomerModel.self) { [weak self] result in
            self?.customerEMail = result?.customer?.email ?? ""
            
            for product in (self?.productList.value ?? [])
            {
                let item = ["variant_id": product.variantID, "quantity": product.qty]
                lineItems.append(item)
            }
            let parameter = ["order":
                                ["currency":currency,
                                 "email":self?.customerEMail ?? "",
                                 "fulfillment_status":"fulfilled",
                                 "line_items":lineItems
                                ]
            ]
            
            self?.dataProvider.post(urlStr: Constants.ordersURL, dataType: Order.self, errorType: OrderErrorModel.self, params: parameter)
            {
                if $0 != nil
                {
                    completionHandler("Order Placed Successfully!")
                }
                else if let errors = $1?.errors
                {
                    var message = ""
                    if let emailError = errors.email
                    {
                        message += "Email: \(emailError)\n"
                    }
                    else
                    {
                        message = "Error"
                    }
                    completionHandler(message)
                }
            }
        }
    }
    
}


