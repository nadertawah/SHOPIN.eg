//
//  LoginRegisterVM.swift
//  Shopify
//
//  Created by Nader Said on 22/06/2022.
//

import Foundation

class LoginRegisterVM
{
    init(dataProvider : DataProviderProtocol,dataPersistant: DataPersistantProtocol)
    {
        self.dataProvider = dataProvider
        self.dataPersistant = dataPersistant
    }
    
    //MARK: - Var(s)
    //data provider service
    var dataProvider : DataProviderProtocol
    var dataPersistant: DataPersistantProtocol
    
    //MARK: - intent(s)
    func login(email:String, password:String,completionHandler : @escaping (String,Bool)->())
    {
        dataProvider.get(urlStr: Constants.customersAPIUrl, type: CustomersModel.self)
        { 
            customersModel in
            guard let customers = customersModel?.customers else { return }
            var isLoggedIn = false
            var customerID : Int64 = 0
            for customer in customers
            {
                if customer.email == email && customer.multipass_identifier == password
                {
                    isLoggedIn = true
                    customerID = customer.id ?? 0
                    completionHandler("Welcome, \(customer.first_name ?? "")",true)
                    break
                }
            }
            
            if isLoggedIn
            {
                UserDefaults.standard.set("\(customerID)", forKey: "customerID")
            }
            else
            {
                completionHandler("Wrong credintials!",false)
            }
        }
    }
    
    func register(name:String,email:String, password:String,phone:String, completionHandler : @escaping (String)->())
    {
        let fullName = name.split(separator: " ")
        let parameter: [String: Any] = [
            "customer":[
                "first_name": fullName[0],
                "last_name": fullName[fullName.count - 1] ,
                  "email": email,
                  "verified_email":true,
                "multipass_identifier": password,
                "phone": phone,
                  "addresses":[]
               ]
        ]
        
        dataProvider.post(urlStr: Constants.customersAPIUrl, dataType: CustomerModel.self, errorType: CustomerErrorModel.self, params: parameter)
        {
            if $0 != nil
            {
                completionHandler("Done!")
            }
            else if let errors = $1?.errors
            {
                var message = ""
                if let emailError = errors.email
                {
                    message += "Email : \(emailError[0])\n"
                }
                else if let phoneError = errors.phone
                {
                    message += "Phone: \(phoneError[0])"
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
