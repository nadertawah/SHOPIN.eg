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
}
