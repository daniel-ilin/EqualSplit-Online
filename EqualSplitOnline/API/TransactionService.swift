//
//  TransactionService.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 16.01.2022.
//

import Foundation
import Alamofire

struct TransactionService {
    
    static func addTransaction(intoSessionId sessionid: String, forUser targetid: String, withAmount amount: Int, description: String, completion: @escaping (AFDataResponse<Data?>)->Void) {
        
        guard let accessToken = KeychainService.getAccessToken() else { return }
        
        let headers: HTTPHeaders = [
            "x-auth-token": accessToken
          ]
        
        let request: [String: String] = [
            "sessionid": sessionid,
            "amount": String(amount),
            "description": description,
            "targetid": targetid
        ]
        
        let callurl = API_URL + "/transaction"
        
        AF.request(callurl, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<300).response { response in
            switch response.result {
            case .success:
                completion(response)
            case .failure:
                if response.response?.statusCode == 401 {
                    AuthService.requestAccessToken {
                        addTransaction(intoSessionId: sessionid, forUser: targetid, withAmount: amount, description: description) { response in
                            completion(response)
                        }
                    } errorHandler: { error in
                        print(error)
                    }
                } else {
                    print("Request failed")
                }
            }
        }
    }
    
    static func changeTransaction(id: String, withAmount amount: Int, description: String, completion: @escaping (AFDataResponse<Data?>)->Void) {
        
        guard let accessToken = KeychainService.getAccessToken() else { return }
        
        let headers: HTTPHeaders = [
            "x-auth-token": accessToken
          ]
        
        let request: [String: String] = [
            "amount": String(amount),
            "description": description,
            "id": id
        ]
        
        let callurl = API_URL + "/transaction"
        
        AF.request(callurl, method: .put, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<300).response { response in
            switch response.result {
            case .success:
                completion(response)
            case .failure:
                if response.response?.statusCode == 401 {
                    AuthService.requestAccessToken {
                        changeTransaction(id: id, withAmount: amount, description: description) { response in
                            completion(response)
                        }
                    } errorHandler: { error in
                        print(error)
                    }
                } else {
                    print("Request failed")
                }
            }
        }
    }
    
    static func deleteTransaction(withId id: String, inSessionWithId sessionId: String, completion: @escaping (AFDataResponse<Data?>)->Void) {
        
        guard let accessToken = KeychainService.getAccessToken() else { return }
        
        let headers: HTTPHeaders = [
            "x-auth-token": accessToken
          ]
        
        let request: [String: String] = [
            "id": id,
            "sessionid": sessionId
        ]
        
        let callurl = API_URL + "/transaction"
        
        AF.request(callurl, method: .delete, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<300).response { response in
            switch response.result {
            case .success:
                completion(response)
            case .failure:
                if response.response?.statusCode == 401 {
                    AuthService.requestAccessToken {
                        deleteTransaction(withId: id, inSessionWithId: sessionId) { response in
                            completion(response)
                        }
                    } errorHandler: { error in
                        print(error)
                    }
                } else {
                    print("Request failed")
                }
            }
        }
    }
    
    
}
