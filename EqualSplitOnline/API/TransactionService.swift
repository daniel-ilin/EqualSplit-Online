//
//  TransactionService.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 16.01.2022.
//

import Alamofire

struct TransactionService {
    
    static func addTransaction(intoSessionId sessionid: String, withAmount amount: Int, description: String, completion: @escaping (AFDataResponse<Data?>)->Void) {
        
        let request: [String: String] = [
            "sessionid": sessionid,
            "amount": String(amount),
            "description": description
        ]
        
        let callurl = "\(API_URL)/transactions"
        
        AF.request(callurl, method: .post, parameters: request, encoder: JSONParameterEncoder.default).response { response in
            if response.response?.statusCode == 200 {
                completion(response)
            } else {
                print("DEBUG - status: \(String(describing: response.error?.localizedDescription))")
            }
        }
    }
    
    static func changeTransaction(id: String, withAmount amount: Int, description: String, completion: @escaping (AFDataResponse<Data?>)->Void) {
        
        let request: [String: String] = [
            "amount": String(amount),
            "description": description,
            "id": id
        ]
        
        let callurl = "\(API_URL)/transactions"
        
        AF.request(callurl, method: .put, parameters: request, encoder: JSONParameterEncoder.default).response { response in
            if response.response?.statusCode == 200 {
                completion(response)
            } else {
                print("DEBUG - status: \(String(describing: response.error?.localizedDescription))")
            }
        }
    }
    
    static func deleteTransaction(withId id: String, inSessionWithId sessionId: String, completion: @escaping (AFDataResponse<Data?>)->Void) {
        
        let request: [String: String] = [
            "id": id,
            "sessionid": sessionId
        ]
        
        let callurl = "\(API_URL)/transactions"
        
        AF.request(callurl, method: .delete, parameters: request, encoder: JSONParameterEncoder.default).response { response in
            if response.response?.statusCode == 200 {
                completion(response)
            } else {
                print("DEBUG - status: \(String(describing: response.error?.localizedDescription))")
            }
        }
    }
    
    
}
