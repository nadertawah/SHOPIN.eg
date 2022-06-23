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
    func get<T:Decodable>(urlStr: String, type: T.Type, completion: @escaping (T?) -> ())
    {
        let headers = HTTPHeaders(Constants.shopifyHeader)
        
        AF.request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate()
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
    func post<T:Codable,E:Codable>(urlStr: String,dataType: T.Type,errorType: E.Type,params:[String: Any]? , completion: @escaping (T?,E?) -> ())
    {
        let headers = HTTPHeaders(Constants.shopifyHeader)
        
        AF.request(urlStr, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().response
        {
            response  in
            do
            {
                switch response.result
                {
                case .success(_) :
                    let result = try JSONDecoder.init().decode(T.self, from: response.data ?? Data())
                    completion(result,nil)
                    break
                
                case .failure(_):
                    let result = try JSONDecoder.init().decode(E.self, from: response.data ?? Data())
                    completion(nil,result)
                    break
                }
            }
            catch let error
            {
                completion(nil,nil)
                debugPrint(error)
            }
        }
    }
}
