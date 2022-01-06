//
//  MyJsonDecoder.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 01.01.2022.
//

import Foundation

struct MyJsonDecoder {
    
    static func decodeJson<T:Decodable>(from data: Data,to resultType: T.Type) -> T? {
        let decoder = JSONDecoder()
        
        do {
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            debugPrint(error)
        }
            return nil
    }
    
}
