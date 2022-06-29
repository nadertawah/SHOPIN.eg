//
//  MockApi.swift
//  ShopifyTests
//
//  Created by Nader Said on 29/06/2022.
//

import Foundation

class MockApi : DataProviderProtocol
{
    func get<T>(urlStr: String, type: T.Type, completion: @escaping (T?) -> ()) where T : Decodable
    {
        
    }
    
    func post<T, E>(urlStr: String, dataType: T.Type, errorType: E.Type, params: [String : Any]?, completion: @escaping (T?, E?) -> ()) where T : Decodable, T : Encodable, E : Decodable, E : Encodable
    {
        
    }
    
    
}
