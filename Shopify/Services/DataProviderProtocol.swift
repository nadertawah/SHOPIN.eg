//
//  DataProviderProtocol.swift
//  Shopify
//
//  Created by Nader Said on 20/06/2022.
//

import Foundation

protocol DataProviderProtocol
{
    func get<T:Decodable>(urlStr: String,type: T.Type, completion: @escaping (T?) -> ())
    func post<T:Codable,E:Codable>(urlStr: String,dataType: T.Type,errorType: E.Type,params:[String: Any]? , completion: @escaping (T?,E?) -> ())
    func delete<T:Codable,E:Codable>(urlStr: String,dataType: T.Type,errorType: E.Type , completion: @escaping (T?,E?) -> ())
    func put<T:Codable,E:Codable>(urlStr: String,dataType: T.Type,errorType: E.Type,params:[String: Any]? , completion: @escaping (T?,E?) -> ())
    
}
