//
//  API.swift
//  Shopify
//
//  Created by Nader Said on 18/06/2022.
//

import Foundation
import CoreData
import Alamofire

class API
{
    static let shared = API()
    static var isConnectedToInternet:Bool
    {
        return Connectivity.sharedInstance.isReachable
    }
    private init(){}
    
    
    func httpGet<T:Decodable>(urlStr: String,type: T.Type, completion: @escaping (T?) -> ())
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

struct Connectivity
{
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool
    {
        return self.sharedInstance.isReachable
    }
    private init(){}
}


