//
//  API.swift
//  Shopify
//
//  Created by Nader Said on 18/06/2022.
//

import Foundation
import Alamofire

class API : DataProviderProtocol
{
    func get<T:Decodable>(urlStr: String,type: T.Type, completion: @escaping (T?) -> ())
    {
        AF.request(urlStr)
        
            .responseDecodable(of: T.self, queue: .global(qos: .background))
        {
            resp in
            do
            {
                completion(try resp.result.get())
            }
            catch let error
            {
                completion(nil)
                debugPrint(error)
            }
            
        }
    }
}
